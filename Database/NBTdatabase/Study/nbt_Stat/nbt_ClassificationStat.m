classdef nbt_ClassificationStat < nbt_Stat
   
    properties
        classificationType 
        subsampleType
        subsampleLimit
        subsampleStratification 
        removeFeaturesType
        nCrossVals
        realOutcome
        predictedOutcome
        outcomeEval
        modelVars
    end
    
    methods
        function obj = nbt_ClassificationStat()
        end
    end
    
end