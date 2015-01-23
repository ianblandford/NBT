classdef nbt_ClassificationStat < nbt_Stat
   
    properties
        classificationType 
        subSampleType = 'holdout'
        subSampleLimit = 0.3
        subSampleStratification = 'stratified'
        removeFeaturesType = 'ttest2'
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