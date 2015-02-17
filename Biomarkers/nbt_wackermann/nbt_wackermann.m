classdef nbt_wackermann < nbt_SignalBiomarker
    
    properties
        sigma
        phi
        omega
    end
    properties (Constant)
       biomarkerType = {'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker'}; 
       units = {' ',' ',' '};
    end
    
    methods
        function BiomarkerObject=nbt_wackermann(NumChannels)
            BiomarkerObject.sigma = nan(NumChannels,1);
            BiomarkerObject.phi = nan(NumChannels,1);
            BiomarkerObject.omega = nan(NumChannels,1);
            BiomarkerObject.primaryBiomarker = 'sigma';
            BiomarkerObject.biomarkers = {'sigma','phi','omega'};
        end
    end
end
