classdef nbt_elasticLogit < nbt_ClassificationStat
    properties
    end
    
    methods
        function obj = nbt_elasticLogit(obj)
        end
        
        function obj = calculate(obj, StudyObj)
            obj = nbt_Classify(obj, StudyObj); 
        end
    end
end