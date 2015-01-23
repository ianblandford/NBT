classdef nbt_elasticLogit < nbt_ClassificationStat
    properties
        alpha = 0.5
        relTol = 1e-6
        cV = 3
        numLambda = 100
        standardize = 1
    end
    
    methods
        function obj = nbt_elasticLogit(obj)
        end
        
        function obj = calculate(obj, StudyObj)
            obj = nbt_Classify(obj, StudyObj); 
        end
    end
end