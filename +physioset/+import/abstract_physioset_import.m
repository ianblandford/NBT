classdef abstract_physioset_import < ...
        physioset.import.physioset_import & ...
        goo.abstract_setget & ...
        goo.verbose
    % abstract_physioset_import - Ancestor for physioset importer classes
    %
    % See: <a href="matlab:misc.md_help('physioset.import.abstract_physioset_import')">physioset.import.abstract_physioset_import(''physioset.import.abstract_physioset_import'')</a>
    
    
    
    %% Private stuff
    properties (SetAccess = private, GetAccess = private)
        
        StartTime_;
        
    end
    
    
    %% PROTECTED INTERFACE ................................................
    
    methods (Access = protected)
        
        function args = construction_args_pset(obj)
            
            args = {...
                'Precision', obj.Precision, ...
                'Writable',  obj.Writable, ...
                'Temporary', obj.Temporary, ...
                'FileName',  obj.FileName, ...
                'StartTime', obj.StartTime_ ...
                };
            
        end
        
        % Might be overloaded by children classes
        function args = construction_args_physioset(~)
            
            args = {};
            
        end
        
        
    end
    
    
    %% PUBLIC INTERFACE ...................................................
    properties
        
        Precision    = pset.globals.get.Precision;
        Writable     = pset.globals.get.Writable;
        Temporary    = pset.globals.get.Temporary;
        ChunkSize    = pset.globals.get.ChunkSize;
        ReadEvents   = true;
        FileName     = '';
        FileNaming   = 'inherit';
        Sensors      = [];
        EventMapping = mjava.hash({'TREV', 'tr', 'TR\s.+', 'tr'})
        
    end
    
    properties (Dependent)
        StartTime;
    end
    
    methods
        
        function val = get.StartTime(obj)
            
            dateFmt = pset.globals.get.DateFormat;
            timeFmt = pset.globals.get.TimeFormat;
            val = datestr(obj.StartTime_, [dateFmt ' ' timeFmt] );
            
        end
        
    end
    
    % Set methods / consistency checks
    methods
        
        function obj = set.Precision(obj, value)
            
            import exceptions.*;
            
            if ~ischar(value),
                throw(InvalidPropValue('Precision', ...
                    'Must be a string'));
            end
            
            if ~any(strcmpi(value, {'double', 'single'})),
                throw(InvalidPropValue('Precision', ...
                    sprintf('Invalid precision ''%s''', value)));
            end
            
            obj.Precision = value;
            
        end
        
        function obj = set.Writable(obj, value)
            
            import exceptions.*;
            if numel(value) > 1 || ~islogical(value),
                throw(InvalidPropValue('Writable', ...
                    'Must be a logical scalar'));
            end
            obj.Writable = value;
            
        end
        
        function obj = set.Temporary(obj, value)
            
            import exceptions.*;
            if numel(value) > 1 || ~islogical(value),
                throw(InvalidPropValue('Temporary', ...
                    'Must be a logical scalar'));
            end
            
            obj.Temporary = value;
            
        end
        
        function obj = set.ChunkSize(obj, value)
            
            import exceptions.*;
            import misc.isinteger;
            if numel(value) > 1 || ~isinteger(value) || value < 0,
                throw(InvalidPropValue('ChunkSize', ...
                    'The ChunkSize property must be a natural number'));
            end
            obj.ChunkSize = value;
        end
        
        function obj = set.ReadEvents(obj, value)
            
            import exceptions.*;
            if isempty(value) || numel(value) > 1 || ~islogical(value),
                throw(InvalidPropValue('ReadEvents', ...
                    'Must be a logical scalar'));
            end
            
            obj.ReadEvents = value;
            
        end
        
        
        function obj = set.Sensors(obj, value)
            
            import exceptions.*;
            import goo.pkgisa;
            
            if isempty(value),
                obj.Sensors = [];
                return;
            end
            
            if ~isa(value, 'sensors.sensors'),
                
                throw(InvalidPropValue('Sensors', ...
                    'Must be a sensors.object'));
                
            end
            
            obj.Sensors = value;
            
        end
        
        function obj = set.FileName(obj, value)
            
            import exceptions.*;
            import pset.globals;
            
            if ~ischar(value),
                throw(InvalidPropValue('FileName', ...
                    'Must be a valid file name (a string)'));
            end
            
            [pathName, fileName, ext] = fileparts(value);
            
            if isempty(fileName),
                obj.FileName = '';
                return;
            end
            
            if isempty(pathName), pathName = pwd; end
            
            psetExt = globals.get.DataFileExt;
            
            if ~isempty(ext) && ~strcmp(ext, psetExt),
                warning('abstract_physioset_import:InvalidExtension', ...
                    'Replaced file extension %s -> %s', ext, psetExt);
            end
            
            value = [pathName, filesep, fileName, psetExt];
            
            obj.FileName = value;
            
        end
        
        function obj = set.EventMapping(obj, value)
            
            import exceptions.*;
            
            if isempty(value),
                obj.EventMapping = [];
                return;
            end
            
            if numel(value) ~= 1 || ~isa(value, 'mjava.hash'),
                throw(InvalidPropValue('EventMapping', ...
                    'Must be a mjava.hash object'));
            end
            obj.EventMapping = value;
            
        end
        
        
    end
    
    methods (Abstract)
        
        varargout = import(obj, filename, varargin)
        
    end
    
    % Other methods
    methods
        
        function [fileName, obj] = resolve_link(obj, fileName)
            
            
            import safefid.safefid;
            import pset.globals;
            
            if ~exist(fileName, 'file'),
                ME = MException(...
                    'abstract_physioset_import:FileDoesNotExist', ...
                    'File %s does not exist', fileName);
                throw(ME);
            end
            
            fid = safefid.fopen(fileName, 'r');
            if ~fid.Valid, return; end
            tline = fid.fgetl;
            
            if ~isempty(tline) && fid.feof && exist(tline, 'file'),
                
                dataFileExt = globals.get.DataFileExt;
                [path, name] = fileparts(fileName);
                obj.FileName = [path name dataFileExt];
                fileName = tline;
                
            end
            
            
        end
        
    end
    
    % Constructor
    methods
        
        function obj = abstract_physioset_import(varargin)
            import misc.split_arguments;
            import misc.process_arguments;
            
            if nargin < 1, return; end
            
            [args1, args2] = split_arguments('StartTime', varargin);
            
            opt.StartTime = [];
            [~, opt] = process_arguments(opt, args1);
            obj.StartTime_ = opt.StartTime;
            
            % Set public properties
            obj = set(obj, args2{:});
            
        end
        
    end
    
end