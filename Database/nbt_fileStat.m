% This function print statistics about the files in a folder
% 
% Usage nbt_fileStat(infoPath)
%
% Input parameters:
%  infoPath: path of the info files.

%--------------------------------------------------------------------------
% Copyright (C) 2014 Simon-Shlomo Poil
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
%-------------------------------------------------------------------------

function nbt_fileStat(infoPath)

fileTree = nbt_ExtractTree(infoPath,'mat','info');

disp('File statistics for:')
disp(infoPath)
disp(['Number of info files: ' num2str(length(fileTree))])
[projectID, fileTree] = strtok(fileTree,'.'); 
projectID = unique(projectID);
disp(['Number of projects: ' num2str(length(projectID))])
[subjectID,fileTree] = strtok(fileTree,'.');
subjectID = unique(subjectID);
disp(['Number of subjects: ' num2str(length(subjectID))])
[dummy, fileTree] = strtok(fileTree,'.');
[conditionID, fileTree] = strtok(fileTree,'.');
[conditionID] = strtok(conditionID,'_');
uniqueConditionID = unique(conditionID);
disp(['Number of unique conditions: ' num2str(length(uniqueConditionID))])
for m=1:length(uniqueConditionID)
   disp(['Number of files in ' uniqueConditionID{1,m} ': ' num2str(length(nbt_searchvector(conditionID,uniqueConditionID(1,m))))]) 
end



end