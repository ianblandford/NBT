% nbt_ampDist - Creates a Amplitude Distance biomarker object 
%
% Usage:
%   BiomarkerObject = nbt_ampDist
%   or
%   BiomarkerObject = nbt_ampDist(NumChannels)
%
% Inputs:
%   NumChannels
%
% Outputs:
%   ampDist BiomarkerObject    
%
% Example:
%   
% References:
% 
% See also: 
%  
  
%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2009), see NBT website (http://www.nbtwiki.net) for current email address
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

classdef nbt_ampDist < nbt_SignalBiomarker
    %% Copyright (c) 2009,  Simon-Shlomo Poil (Center for Neurogenomics and Cognitive Research (CNCR), VU University Amsterdam)
    %% ChangeLog - remember to set NBTversion property
    %$ Version 0 - 
    
    properties
        Kurtosis
        Skewness
        Iqr
        Median
        Range
        Cov
    end
    properties (Constant)
        biomarkerType = {'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker', 'nbt_SignalBiomarker','nbt_SignalBiomarker','nbt_SignalBiomarker'};
    end
    methods
        function BiomarkerObject = nbt_ampDist(NumChannels)
            if nargin == 0
                NumChannels = 1;
            end
            
            BiomarkerObject.Kurtosis = nan(NumChannels, 1);
            BiomarkerObject.Skewness = nan(NumChannels, 1);
            BiomarkerObject.Iqr = nan(NumChannels, 1);
            BiomarkerObject.Median = nan(NumChannels, 1);
            BiomarkerObject.Range = nan(NumChannels, 1);
            BiomarkerObject.Cov = nan(NumChannels, 1);
            
            BiomarkerObject.primaryBiomarker = 'Range';
            BiomarkerObject.biomarkers = {'Kurtosis','Skewness','Iqr', 'Median','Range','Cov'};
        end
    end
end