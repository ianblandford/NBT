% Copyright (C) 2010  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
%

% ChangeLog - see version control log for details
% <date> - Version <#> - <text>

classdef nbt_amplitude < nbt_SignalBiomarker
    properties
        Channels
%         SubRegions
        Normalized       
    end
      properties (Constant)
         biomarkerType = {'nbt_SignalBiomarker'};
         units = {'\mu V^2'};
     end
    methods
        function BiomarkerObject = nbt_amplitude(NumChannels,Channels,SubRegions,Normalized, Unit)
            if nargin == 0
                NumChannels = 1;
                Channels=NaN;
                Normalized=NaN;
            else
                BiomarkerObject.Normalized=Normalized;
                BiomarkerObject.Channels =Channels;
                BiomarkerObject.NumChannels=NumChannels;
%                 BiomarkerObject.SubRegions=SubRegions;
                BiomarkerObject.biomarkers ={'Channels'};
                BiomarkerObject.BiomarkerUnits = Unit;
                BiomarkerObject = setUniqueIdentifiers(BiomarkerObject);
            end
        end
        
        function BiomarkerObject = setUniqueIdentifiers(BiomarkerObject)
            BiomarkerObject.uniqueIdentifiers = {'frequencyRange','Normalized'};
        end
    end
end
