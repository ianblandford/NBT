% nbt_CSD(Signal,SignalInfo,SaveDir) calculates the scalp current source
% density for a given signal based on the spherical spline surface
% Laplacian as suggested by Perrin et al. (1989, 1990). Wrapper around
% computeCSD.m of which the contents are the same as CSD.m from the CSD
% Toolbox (Copyright (C) 2003 by J�rgen Kayser)
%
% Usage:
%   nbt_CSD(Signal,SignalInfo,SaveDir)
%
% Inputs:
%   Signal = A raw EEG signal imported in NBT format
%   SignalInfo = The SignalInfo corresponding to the given Signal
%   SaveDir = The folder where the Signal and SignalInfo files are saved

% Outputs:
%   CSDSignal = Current Source Density (CSD) transformed EEG data
%   CSDSignalInfo = The CSD SignalInfo corresponding to the CSDSignal
%
% Example:
%   nbt_CSD(Signal,SignalInfo,SaveDir)
%   
%
% References:
%
% See also:
%   computeCSD.m

%------------------------------------------------------------------------------------
% Originally created by Simon J. Houtman (2015), see NBT website for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
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

function [CSDSignal, CSDSignalInfo] = nbt_CSD(Signal,SignalInfo,SaveDir)
    %%% Get the channel information
    chanLocs = SignalInfo.interface.EEG.chanlocs;
    
    %%% Get the channel labels in the CSD toolbox format
    nChannels = size(chanLocs,2);
    chanInfo.lab = cell(nChannels,1);
    chanInfo.theta = zeros(nChannels,1);
    chanInfo.phi = zeros(nChannels,1);
    for chan = 1 : nChannels
        chanInfo.lab{chan} = chanLocs(chan).labels;
        chanInfo.theta(chan) = chanLocs(chan).sph_theta;
        chanInfo.phi(chan) = chanLocs(chan).sph_phi;
    end
    
    %%% Spline flexibility
    splineFlexibility = 4;
    
    tic
    %%% Compute G and H using CSD toolbox 'GetGH.m'
    [G,H] = GetGH(chanInfo,splineFlexibility);
    
    %%% Define CSDSignal
    nTimePoints = size(Signal,1);
    CSDSignal = zeros(nTimePoints,size(Signal,2));

    %%% Compute CSD using CSD toolbox 'CSD.m'
    disp(['Computing scalp current source density for ', num2str(nTimePoints), ' time points']);
    for timePoint = 1 : size(Signal,1)
        CSDSignal(timePoint,:) = computeCSD(Signal(timePoint,:)',G,H);
    end
    toc
    
    %%% Set the SignalInfo
    CSDSignalInfo = SignalInfo;
    CSDSignalInfo.signalName = 'CSDSignal';
    CSDSignalInfo.signalType = 'CSDSignal';
    CSDSignalInfo.filterSettings = struct('splineFlexibility',splineFlexibility);
    
    %%% Save the Signal and SignalInfo
    disp('Appending to existing signal file.');
    save(strcat([SaveDir '\' SignalInfo.subjectInfo '.mat']),'CSDSignal','-append');
    save(strcat([SaveDir '\' SignalInfo.subjectInfo '_info.mat']),'CSDSignalInfo','-append');
end