classdef sleep_scores_generator < physioset.event.generator & ...
        goo.abstract_setget
    % SLEEP_SCORES_GENERATOR - Generate sleep-scores events
    
    methods (Static, Access = private)
        function fh = default_template()
            fh = @(sampl, idx, score, scoreLabel, scorer, frameL, data) ...
                physioset.event.std.sleep_score(sampl, ...
                'Value', idx, 'Type', scoreLabel, 'Scorer', scorer, ...
                'Score', score, 'Duration', round(frameL*data.SamplingRate));
        end
        
        function sleepScoresFile = find_sleep_scores_file(data)
            import mperl.file.spec.catfile;
            
            sleepScoresFile = '';
            procHist = get_processing_history(data);
            for i = 1:numel(procHist)
                if ischar(procHist{i}) && exist(procHist{i}, 'file'),
                    [path, name] = fileparts(procHist{i});
                    sleepScoresFile = catfile(path, [name '.mat']);
                    if ~exist(sleepScoresFile, 'file'),
                        sleepScoresFile = catfile(path, ...
                            [strrep(name, '_eeg_', '_eeg_scores_') '.mat']);
                    end
                    if exist(sleepScoresFile, 'file'),
                        % Found the associated sleep scores
                        break;
                    else
                        sleepScoresFile = '';
                    end
                end
            end
            
        end
        
    end
    
    properties
        Template = physioset.event.sleep_scores_generator.default_template;
    end
    
    methods       
        
        function obj = set.Template(obj, value)
            
            import exceptions.InvalidPropValue;
            import physioset.event.periodic_generator;
            
            if isempty(value),
                obj.Template = periodic_generator.default_template;
                return;
            end
            
            if ~isa(value, 'function_handle'),
                throw(InvalidPropValue('Template', ...
                    'Must be a function_handle'));
            end
            
            try
                toy = value(10, 1, 1, 'Wakefulness', 'German', 30, physioset.physioset);
                if ~isa(toy, 'physioset.event.event'),
                    throw(InvalidPropValue('Template', ...
                        'Template must evaluate to an event object'));
                end
            catch ME
                if ismember(ME.identifier, ...
                        {'MATLAB:TooManyInputs', 'MATLAB:minrhs'})                       
                    throw(InvalidPropValue('Template', ...
                        'Template must take seven arguments'));
                else
                    rethrow(ME);
                end
            end
            
            obj.Template = value;
            
        end
        
        % physioset.event.generator interface
        
        function evArray = generate(obj, data, varargin)
            
            import physioset.event.std.sleep_score;
            import physioset.event.sleep_scores_generator;
            
            sleepScoresFile = ...
                sleep_scores_generator.find_sleep_scores_file(data);
            
            if isempty(sleepScoresFile),
                warning('sleep_scores_generator:MissingScores', ...
                    'Could not find sleep scores file for %s', ...
                    get_name(data));
                evArray = [];
                return;
            end           
            
            sr = data.SamplingRate;
            
            scoreFile = load(sleepScoresFile);
            info      = scoreFile.info;
            
            if iscell(info.score),
                % New version of Gio's scoring toolbox
                scorer = info.score{2};
                frameLength = info.score{3};
                scores = info.score{1};
                scoreLabels = cell(1, numel(scores));
                scoreLabels(scores == 0) = {'Wakefulness'};
                scoreLabels(scores == 1) = {'NREM 1'};
                scoreLabels(scores == 2) = {'NREM 2'};
                scoreLabels(scores == 3) = {'NREM 3'};
                scoreLabels(scores == 5) = {'REM'};
            else
                scorer = info.score.rater;
                frameLength = info.score.wndw;
                scoreLabels = info.score.stage;
                % Hard-coded mapping from labels to numbers
                scores = nan(1, numel(scoreLabels));
                scores(ismember(scoreLabels, 'Wakefulness')) = 0;
                scores(ismember(scoreLabels, 'NREM 1')) = 1;
                scores(ismember(scoreLabels, 'NREM 2')) = 2;
                scores(ismember(scoreLabels, 'NREM 3')) = 3;
                scores(ismember(scoreLabels, 'REM')) = 5;
            end
            sampl = 1;
            evArray = repmat(sleep_score, 1, numel(scores));
            for i = 1:numel(scores)                
                evArray(i) = obj.Template(sampl, i, scores(i), ...
                    scoreLabels{i}, scorer, frameLength, data);
                sampl = sampl + round(frameLength*sr);
            end
            
        end
        
        % Constructor
        
        function obj = sleep_scores_generator(varargin)
            
            import misc.process_arguments;
            import physioset.event.sleep_scores_generator;            
            
            opt.Template  = sleep_scores_generator.default_template;
           
            [~, opt] = process_arguments(opt, varargin);            
           
            obj.Template  = opt.Template;
           
        end
        
    end
    
    
end