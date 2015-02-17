classdef nbt_tdp < nbt_SignalBiomarker
%NBT_TDP Summary of this class goes here
%   Detailed explanation goes here

   properties
       f
       g
   end
    properties (Constant)
        biomarkerType = {'nbt_SignalBiomarker','nbt_SignalBiomarker'};
        units = {' ', ' '};
    end
   methods
       function biomarkerObject = nbt_tdp(NumChannels)
           biomarkerObject.f = nan(NumChannels,1);
           biomarkerObject.g = nan(NumChannels,1);
           biomarkerObject.biomarkers = {'f', 'g'};
       end
   end
end 
