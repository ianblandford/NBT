%Syncronization likelihood
classdef nbt_SL < nbt_SignalBiomarker  
    properties
        m
        lag
        p_ref
        w1
        w2
        SLm
        medianSLm
        meanSLm
        HITm
        RECm
        D
        E
    end
    properties (Constant)
        biomarkerType = {'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker'};
    end
    methods        
        function BiomarkerObject = nbt_SL(NumChannels)
            BiomarkerObject.m = nan; 
            BiomarkerObject.lag = nan;
            BiomarkerObject.p_ref = ones(1,2);
            BiomarkerObject.w1 = nan;
            BiomarkerObject.w2 = nan;
            BiomarkerObject.SLm = cell(NumChannels);
            BiomarkerObject.medianSLm = nan(NumChannels,NumChannels);
            BiomarkerObject.meanSLm = nan(NumChannels,NumChannels);
            BiomarkerObject.Biomarkers ={'SLm', 'medianSLm', 'meanSLm'};
        end
    end

end

