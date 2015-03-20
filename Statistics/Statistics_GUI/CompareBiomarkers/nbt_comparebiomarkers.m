% nbt_comparebiomarkers - this function is part of the statistics GUI, it allows
% to compare two or more biomarkers
%
% Usage:
%  G = nbt_comparebiomarkers(G);
%
% Inputs:
%   %   G is the struct variable containing informations on the selected groups
%      i.e.:  G(1).fileslist contains information on the files of Group 1
%           G(1).biomarkerslist list of selected biomarkers for the
%           statistics
%           G(1).chansregs list of the channels and the regions relected
% Outputs:
%
%
% Example:
%
%
% References:
%
% See also:
%  nbt_selectrunstatistics

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
% --------------

function G = nbt_comparebiomarkers(G)

%create panel


global rsq

for i = 1:length(G(1).biomarkerslist)
    b(i) = strcmp(G(1).biomarkerslist{i},'rsq.Answers');
end

if nnz(b(i)) > 0
    %load rsq
    rs = load([G(1).fileslist(1).path '/' G(1).fileslist(1).name],'rsq');
    rsq = rs.rsq;
end


nbt_compareBiomarkersPanel;

%Other Functions
%nbt_compareBiomarkersGetSettings
%nbt_compareBiomakersPlotTopos



    
   
end