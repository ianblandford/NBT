% nbt_generateBiomarkerList - this function creates an analysis object,
% iterates along all biomarkers which have a fixed order in NBT Print and
% checks whether the biomarker is present for the current group and stores
% it in the analysis object
%
% Usage:
%   obj = nbt_generateBiomarkerList(NBTstudy,groupNumber);
%
% Inputs:
%   NBTstudy,
%   groupNumber
%
% Outputs:
%  Analysis object containing the biomarkers present in the data for a
%  specific group, in the fixed NBT Print biomarker order
%
% Example:
%   obj = nbt_generateBiomarkerList(NBTstudy,1);
%
% References:
%
% See also:
%  nbt_Print, nbt_getData

%------------------------------------------------------------------------------------
% Originally created by Simon J. Houtman (2015)
%------------------------------------------------------------------------------------
%
% Copyright (C) <year>  <Main Author>  (Neuronal Oscillations and Cognition group,
% Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research,
% Neuroscience Campus Amsterdam, VU University Amsterdam)
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
% ---------------------------------------------------------------------------------------

function obj = nbt_generateBiomarkerList(NBTstudy,grpNumber)
    % Create a new analysis object
    obj = nbt_Analysis;
    
    % Get the biomarkerlist from NBTstudy
    Group = NBTstudy.groups{grpNumber};
    biomarkerList = Group.biomarkerList;
    
    % Specify the fixed order for the NBT Print plots
    biomarkersFixedOrder = {'NBTe_nbt_PeakFit', 'NBTe_nbt_PeakFit', 'NBTe_nbt_DFA', 'NBTe_nbt_PeakFit', 'NBTe_nbt_OscB', 'NBTe_nbt_PeakFit', 'NBTe_nbt_PeakFit', 'NBTe_nbt_AmpCorr', 'NBTe_nbt_Coherence', 'NBTe_nbt_Phaselock'};
    subBiomarkersFixedOrder = {'relativePower', 'absolutePower', 'markerValues', 'centralFreq', 'cumulativeLifetime', 'bandwidth', 'spectralEdge', 'markerValues', 'coherence', 'PLV'};
    freqBandsFixedOrder = {'1  4', '4  7', '8  13', '13  30', '30  45'};
    
    % Iteate along all fixed biomarkers and then check whether a present
    % biomarker corresponds to the fixed biomarker and store it in the
    % analysis object. This will make sure that the biomarkers are stored
    % in the fixed NBT Print order.
    obj.group{grpNumber}.biomarkerIndex = zeros(1,length(biomarkerList));
    i = 1;
    for biomarker = 1 : length(biomarkersFixedOrder)
        for freqBand = 1 : 5
            for presentBiomarker = 1 : length(biomarkerList)
                currentBiom = biomarkerList{presentBiomarker};
                if strfind(currentBiom,biomarkersFixedOrder{biomarker}) & strfind(currentBiom,subBiomarkersFixedOrder{biomarker}) & strfind(currentBiom,freqBandsFixedOrder{freqBand})
                    obj.group{grpNumber}.biomarkers{i} = biomarkersFixedOrder{biomarker};
                    obj.group{grpNumber}.subBiomarkers{i} = subBiomarkersFixedOrder{biomarker};
                    obj.group{grpNumber}.biomarkerIdentifiers{i} = {'frequencyRange' freqBandsFixedOrder{freqBand}};
                    obj.group{grpNumber}.classes{i} = {'SignalBiomarker'};
                    i = i + 1;
                end
            end
        end
    end
end