% nbt_definegroups - this function is part of the statistics GUI, it allows
% to select groups for statistics and records the groups into a struct
% variable. this function calls nbt_definegroup function, a graphic
% interface for defining the group of interest
%
% Usage:
%   G = nbt_definegroups;
%
% Inputs:
%
% Outputs:
%  G is the struct variable containing informations on the selected groups
%      i.e.:  G(1).fileslist contains information on the files of Group 1
%
% Example:
%   G = nbt_definegroups
%
% References:
%
% See also:
%  nbt_definegroup

%------------------------------------------------------------------------------------
% Originally created by Giuseppina Schiavone (2012), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
% Modified to new statistics GUI format : Simon-Shlomo Poil: December 2012
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

function nbt_definegroups(~,~)
global NBTstudy
global hh2
[ScreenWidth, ScreenHeight] = nbt_getScreenSize();
hh2 = figure('Units','pixels', 'name','Select Group(s)' ,'numbertitle','off','Position',[ScreenWidth/4  ScreenHeight/2  160  100],...
    'MenuBar','none','NextPlot','new','Resize','off');
uicontrol(hh2,'Style','pushbutton','String','Load Existing Group(s)','Position',[5 50 150 30],'fontsize',10,'callback',@loadGroups);
uicontrol(hh2,'Style','pushbutton','String','Define New Group(s)','Position',[5 10 150 30],'fontsize',10,'callback',@defGroups);

% fit figure to screen, adapt to screen resolution
hh2=nbt_movegui(hh2);
uiwait(hh2)

%% nested functions part
    function loadGroups(d1,d2)
        try
        [FileName,PathName,FilterIndex] = uigetfile;
        Loaded = (load([PathName filesep FileName ]));
        NBTstudy = Loaded.NBTstudy;
        close(hh2)
        catch
        end
    end

    
end


function defGroups(d1,d2)
    global NBTstudy 
    global hh2
        %--- indicate how many groups you want to create
        n_group = str2double(cell2mat(inputdlg('How many groups do you want to define?: ' )));
        
        %--- run the nbt_definegroup interface
        if isempty(NBTstudy.groups)
            start = 1;
        else
            start = length(NBTstudy.groups)+1;
        end

        for i=start:start+n_group-1
            disp(['Define group ' num2str(i)])
            NBTstudy.groups{i} = nbt_Group.defineGroup([]);
            NBTstudy.groups{i}.grpNumber = i;
        end
        close(hh2)
    end