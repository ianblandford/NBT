classdef nbt_elasticLogit < nbt_PairedStat
    properties
    end
    
    methods
        function obj = nbt_elasticLogit(obj)
        end
        
        function obj = calculate(obj, StudyObj)
            %Get data
            n_groups = length(obj.groups);
            for j=1:n_groups
                Data_groups{j} = StudyObj.groups{obj.groups(j)}.getData(obj,j);
            end
            
        end
    end
end