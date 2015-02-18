%------------------------------------------------------------------------------------
% Originally created by Espen A. F. Ihlen (espenale@svt.ntnu.no), 2009
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2009 Espen A. F. Ihlen 
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

classdef nbt_MFDFA < nbt_SignalBiomarker
    properties
        s       % s:            scale
        q       % q:            q-order
        Hq      % Hq:            q-generalized Hurst exponent
        Fq      % Fq:           q-generalized scaling function Fq(s,q)
        alpha   % alpha:        hoelder exponent (see equation (13) and (15) in Kantelhardt et al.(2002))
        f_alpha % f_alpha:      Multifractal spectrum (see equation (13) and (15) Kantelhardt et al.(2002))
        alphaRange
        HqRange
    end
    properties (Constant)
       biomarkerType = {'nbt_SignalBiomarker', 'nbt_SignalBiomarker'}; 
       units =  {' ',' '};
    end

    methods
        function biomarkerObject = nbt_MFDFA(NumChannels)
            biomarkerObject.s = cell(NumChannels,1);
            biomarkerObject.q = cell(NumChannels,1);
            biomarkerObject.Hq = cell(NumChannels,1);
            biomarkerObject.Fq = cell(NumChannels,1);
            biomarkerObject.alpha = cell(NumChannels,1);
            biomarkerObject.f_alpha = cell(NumChannels,1);
            
            biomarkerObject.primaryBiomarker = 'alphaRange';
            biomarkerObject.biomarkers = {'alphaRange', 'HqRange'};
        end
    end
end
