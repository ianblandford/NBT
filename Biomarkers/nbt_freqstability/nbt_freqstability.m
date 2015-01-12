classdef nbt_freqstability < nbt_SignalBiomarker
    %NBT_FREQSTABILITY Summary of this class goes here
    %   Detailed explanation goes here

    properties
        PhaseIQR
        PhaseStd
        PhaseA
        PhasePIQR
        PhaseP
        PhasePStd
        TFiqr
        TFstd
        TFindx
        CentralFrqIQR
        CentralFrqStd
        CentralFrq
    end
    properties (Constant)
        biomarkerType ={'nbt_SignalBiomarker', 'nbt_SignalBiomarker', 'nbt_SignalBiomarker', 'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker',...
                'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker'};
    end

    methods
        function biomarkerObject=nbt_freqstability(NumChannels)
            biomarkerObject.CentralFrqIQR = nan(NumChannels,1);
            biomarkerObject.CentralFrqStd = nan(NumChannels,1);
            biomarkerObject.CentralFrq =nan(NumChannels,1);
            biomarkerObject.PhaseIQR =nan(NumChannels,1);
            biomarkerObject.PhaseStd =nan(NumChannels,1);
            biomarkerObject.PhaseA =nan(NumChannels,1);
            biomarkerObject.TFiqr=nan(NumChannels,1);
            biomarkerObject.TFstd=nan(NumChannels,1);
            biomarkerObject.TFindx= nan(NumChannels,1);
            biomarkerObject.PhasePIQR = nan(NumChannels,1);
            biomarkerObject.PhaseP = nan(NumChannels,1);
            biomarkerObject.PhasePStd=nan(NumChannels,1);
            
          biomarkerObject.PrimaryBiomarker = 'CentralFrqIQR';
            biomarkerObject.Biomarkers ={'PhaseIQR', 'PhaseStd', 'PhaseA', 'PhasePIQR','PhaseP','PhasePStd','TFiqr','TFstd',...
                'TFindx','CentralFrqIQR','CentralFrqStd','CentralFrq'};
        end
    end
end
