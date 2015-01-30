classdef nbt_lssvm < nbt_ClassificationStat
    properties
    end
    
    methods
        function obj = nbt_lssvm(obj)
        end
        
        function obj = calculate(obj, StudyObj)
            obj = nbt_Classify(obj, StudyObj); 
        end
    end
end