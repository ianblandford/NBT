% nbt_CoreBiomarker  - Creates a core NBT biomarker object - this is the
% basic NBT biomarker object
%
% Usage:
%   >>  CoreBiomarker = nbt_CoreBiomarker;
%

%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2014), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2014 Simon-Shlomo Poil  (Neuronal Oscillations and Cognition group,
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
% -


classdef nbt_CoreBiomarker
    properties
        lastUpdate %last date this biomarker was updated
        primaryBiomarker % the primary biomarker to use in scripts
        biomarkers % list of all biomarkers in the object
        biomarkerUnits %list of biomarker units
        researcherID % ID of the Reseacher or script that made the last update
        subjectInfo
        nbtVersion
        uniqueIdentifiers %list of biomarker properties that uniquely identify this biomarker
    end
    
    properties (Hidden = true) %to provide backward compatibility
        MarkerValues % the biomarker values
        NumChannels % number of channels
        Fs % The sampling frequency
        DateLastUpdate %last date this biomarker was updated
        PrimaryBiomarker % the primary biomarker to use in scripts
        Biomarkers % list of all biomarkers in the object
        BiomarkerUnits %list of biomarker units
        ReseacherID % ID of the Reseacher or script that made the last update
        ProjectID % The ID of the project which the biomarker belongs to
        SubjectID % The ID of the subject
        FrequencyRange %Frequency range of processed signal [] means broadband.
        Condition % The condition ID
        SignalName % Name of the signal used to compute the biomaker
        NBTDID %NBTDID of the signal used to compute the biomakrer
        NBTversion
    end
    
    methods
        function BiomarkerObject = nbt_CoreBiomarker()
            BiomarkerObject.nbtVersion = nbt_getVersion;
            BiomarkerObject = setUniqueIdentifiers(BiomarkerObject);
        end



    end
end