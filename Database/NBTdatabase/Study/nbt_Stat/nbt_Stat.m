classdef (Abstract) nbt_Stat < nbt_Analysis
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        testOptions
        pValues
        statValues
        statStruct
        statOptions = statset('UseParallel',true);
    end
    
    methods
        function StatObj = nbt_Stat()
            %empty
        end
        
        % plot()
        % createReport();
        function obj = calculate(obj)
        end
        % checkPreCondition();
        
        function biomarkerNames = getBiomarkerNames(StatObj)
            for m=1:length(StatObj.group{1}.biomarkers)
                prefixIdx = strfind(StatObj.group{1}.biomarkers{m},'_');
                prefixIdx = prefixIdx(end);
                identFlag = true;
                for identLoop = 1:size(StatObj.group{1}.biomarkerIdentifiers{m},1)
                    if(strcmp(StatObj.group{1}.biomarkerIdentifiers{m}{identLoop},'frequencyRange'))
                        biomarkerNames{m} = [StatObj.group{1}.biomarkers{m}(prefixIdx+1:end) '.' StatObj.group{1}.subBiomarkers{m} ' : ' StatObj.group{1}.biomarkerIdentifiers{m}{identLoop,2}];
                        identFlag = false;
                    end
                end
                if(identFlag)
                    biomarkerNames{m} = [StatObj.group{1}.biomarkers{m}(prefixIdx+1:end) '.' StatObj.group{1}.subBiomarkers{m}];
                end
                biomarkerNames{m} = strrep(biomarkerNames{m},'_','.');
            end
            
        end
        
    end
    
end

