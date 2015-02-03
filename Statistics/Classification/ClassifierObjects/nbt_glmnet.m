%Elastic net regression using glmnet implementation
classdef nbt_glmnet < nbt_ClassificationStat
    properties
        alpha = 0.5
    end
    
    methods
        function obj = nbt_glmnet(obj)
        end
        
        function obj = calculate(obj, StudyObj)
            obj = nbt_Classify(obj, StudyObj); 
        end
    end
end