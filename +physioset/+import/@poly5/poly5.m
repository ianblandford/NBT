classdef poly5 < physioset.import.abstract_physioset_import
    
    methods (Access = private, Static)
       sens = labels2sensors(labels); 
    end
    
    % Needed by import() method of parent class
    methods
        ev = read_events(obj, fileName, pObj, verb, verbLabl);
        [sens, sr, hdr, ev, startDate, startTime] = ...
            read_file(obj, fileName, psetFileName, verb, verbLabl);
    end
    
    % Constructor
    methods
        function obj = poly5(varargin)
            obj = obj@physioset.import.abstract_physioset_import(varargin{:});
        end 
    end
    
end