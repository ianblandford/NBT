classdef nbt_ClassificationStat < nbt_Stat
   
    properties
        classificationType 
        subSampleType = 'holdout'
        subSampleLimit = 0.3
        subSampleStratification = 'stratified'
        removeFeaturesType = 'ttest2-MCP'
        nCrossVals
        realOutcome
        predictedOutcome
        outcomeEval
        modelVars
        modelVarsStore %to store multiple modelVars from multiple runs
    end
    
    methods
        function obj = nbt_ClassificationStat()
        end
    end
    
end