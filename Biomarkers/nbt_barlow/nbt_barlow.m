% nbt_barlow  - 
%
% Usage:
%   BiomarkerObject=nbt_barlow(NumChannels)
%
% Inputs:
%   NumChannels
%
% Outputs:
%       
%
% Example:
%   
% References:
% 
% See also: 
%  
  
%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2010), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2010  <Main Author>  (Neuronal Oscillations and Cognition group, 
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

classdef nbt_barlow < nbt_SignalBiomarker
   properties
       amplitude
       frequency
       spi
   end

   properties (Constant)
        biomarkerType ={'nbt_SignalBiomarker', 'nbt_SignalBiomarker', 'nbt_SignalBiomarker'};
   end
   methods
       function BiomarkerObject=nbt_barlow(NumChannels)
           BiomarkerObject.amplitude = nan(NumChannels,1);
           BiomarkerObject.frequency = nan(NumChannels,1);
           BiomarkerObject.spi = nan(NumChannels,1);
           BiomarkerObject.primaryBiomarker =  'amplitude';
           BiomarkerObject.biomarkers ={'amplitude', 'frequency', 'spi'};
       end
       
   end
end 
