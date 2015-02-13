classdef nbt_zscore < nbt_PairedStat
    properties
    end
    
    methods
        function obj = nbt_zscore(obj)
            % ?
            obj.testOptions.tail = 'both';
            obj.testName = 'Z-score';
            obj.groupStatHandle = @nanmean;
            obj.testOptions.vartype = 'equal';
            % ?
        end
        
        function obj = calculate(obj, StudyObj)
            nGroups = 1;
            if nGroups == 1
                Data1 = StudyObj.groups{1}.getData();
                for bID=1:size(Data1.dataStore,2)
                    [obj.statStruct{bID,1}] = zscore(Data1{bID,1});
                end
            elseif nGroups == 2
                % Get data
                Data1 = StudyObj.groups{1}.getData();
                Data2 = StudyObj.groups{2}.getData();
                
                for bID=1:size(Data1.dataStore,1)
                    % Do zscore for two groups
                end
            else
                error('nbt_Print can not handle more than two groups');
            end
        end
    end
end

