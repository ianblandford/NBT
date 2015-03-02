% nbt_runPhaseLocking_gui(Signal, SignalInfo, SaveDir) - GUI support function for
% running PLV
%
% Usage:
% nbt_runPhaseLocking_gui(Signal, SignalInfo, SaveDir)
%
% Inputs:
%   Signal
%   SignalInfo
%   SaveDir
%
% Outputs:
%
% Example:    
%
% References:
% 
% See also: 
%  
  
%------------------------------------------------------------------------------------
% Originally created by Giuseppina Schiavone (2012), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
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
% -------------------------------------------------------------------------

function nbt_runPhaseLocking_gui(Signal, SignalInfo, SaveDir)
    % Get the settings
    settingsPLV = evalin('base','SettingsPLV');

    % Get the signal duration
    signalDuration = floor(size(Signal,1)/SignalInfo.convertedSamplingFrequency);
    display(['Signal duration: ' num2str(signalDuration) ' sec' ])

    if isempty(settingsPLV)
        freqRange = input('Specify frequency range in Hz [lowF highF] (i.e. [8 13]): ');
        timeRange = input('Specify time interval in sec (i.e. [0 5] or all): ','s');

        if strcmp(timeRange,'all')
            timeRange = [0 length(Signal)/SignalInfo.convertedSamplingFrequency];
        else
            timeRange = str2num(timeRange);
        end

        filterOrder = 2/freqRange(1);
        windowLength = [];
        overlap = [];
        indexPhase = [1 1];
        settingsPLV.freqRange = freqRange;
        settingsPLV.timeRange = timeRange;
        settingsPLV.windowLength = windowLength;
        settingsPLV.filterOrder = filterOrder;
        settingsPLV.overlap = overlap;
        settingsPLV.indexPhase = indexPhase;
        assignin('base','SettingsPLV',settingsPLV);
    else
        freqRange = settingsPLV.freqRange;
        timeRange = settingsPLV.timeRange;
        windowLength = settingsPLV.windowLength;
        filterOrder = settingsPLV.filterOrder;
        overlap = settingsPLV.overlap;
        indexPhase = settingsPLV.indexPhase;
    end

    biomarkerName = genvarname(['PhaseLocking' num2str(freqRange(1)) '_' num2str(freqRange(2)) 'Hz' num2str(timeRange(1)) '_' num2str(timeRange(2)) 'sec']); 
    % compute biomarker
    eval([biomarkerName '= nbt_doPhaseLocking(Signal,SignalInfo,freqRange,timeRange,filterOrder,windowLength,overlap,indexPhase)']);
    % save biomarker
    nbt_SaveClearObject(biomarkerName,SignalInfo,SaveDir);
    eval(['evalin(''caller'',''clear ' biomarkerName ''');']);
end