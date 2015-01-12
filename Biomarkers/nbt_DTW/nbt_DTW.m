
classdef nbt_DTW < nbt_SignalBiomarker  
    properties
        d
        window
    end
    properties (Constant)
        biomarkerType = {'nbt_SignalBiomarker'};
    end
    methods
        % Now follows the definition of the function that makes a biomarker
        % of the type "nbt_Biomarker_template". The name of this function should alway be
        % the same as the name of the new biomarker object, in this example nbt_Biomarker_template
        
        function BiomarkerObject = nbt_DTW(NumChannels)
           
            % assign values for this biomarker object:
            BiomarkerObject.d = nan(NumChannels,NumChannels); 
            BiomarkerObject.window = nan(1,1);
            BiomarkerObject.Biomarkers ={'d'};
        end
    end

end

