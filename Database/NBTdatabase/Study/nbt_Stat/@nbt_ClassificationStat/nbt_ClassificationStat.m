classdef nbt_ClassificationStat < nbt_Stat
   
    properties
        classificationType 
        subSampleType = 'holdout'
        nCrossVals
        subSampleLimit = 0.3
        subSampleStratification = 'stratified'
        removeFeaturesType 
        usedFeatures
        balanceClasses = false;
        realOutcome
        predictedOutcome
        outcomeEval
        modelVars
        modelVarsStore %to store multiple modelVars from multiple runs
    end
    
    methods
        function obj = nbt_ClassificationStat()
            obj.removeFeaturesType{1,1} = 'ttest2';
            obj.removeFeaturesType{1,2} = '';
        end
        
        obj = nbt_plot(obj)
    end
    
end