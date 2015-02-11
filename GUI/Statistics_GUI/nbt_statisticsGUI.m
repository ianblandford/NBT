% nbt_statisticsGUI - this function builds the core NBT statistics GUI
%

%------------------------------------------------------------------------------------
% Originally created by Giuseppina Schiavone (2012), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
% Resturcture of GUI layout : Simon-Shlomo Poil, 2012-2013
%
% Copyright (C) 2012  Giuseppina Schiavone  (Neuronal Oscillations and Cognition group,
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


function nbt_statisticsGUI
global NBTstudy
try
    NBTstudy = evalin('base','NBTstudy');
catch
   evalin('base','global NBTstudy');
   evalin('base','NBTstudy = nbt_Study;');
end
if (isempty(NBTstudy.groups))
    nbt_definegroups;
end

%----------------------
% First we build the Interface
%----------------------
try %close existing windows
    hh = findobj('Tag','NBTStatMain');
    close(hh)
catch
end

StatSelection = figure('Units','pixels', 'name','NBT: Select Statistics' ,'numbertitle','off','Position',[200  200  610  750.000],...
    'MenuBar','none','NextPlot','new','Resize','off','Tag', 'NBTStatMain');
% fit figure to screen, adapt to screen resolution
StatSelection=nbt_movegui(StatSelection);

% This loads the statistical tests- these needs to be set in nbt_Study.getStatisticsTests.
statList = nbt_Study.getStatisticsTests(0);

hp3 = uipanel(StatSelection,'Title','SELECT TEST','FontSize',10,'Units','pixels','Position',[10 520 360 200],'BackgroundColor','w','fontweight','bold');
ListStat = uicontrol(hp3,'Units', 'pixels','style','listbox','Max',1,'Units', 'pixels','Position',[5 5 350 180],'fontsize',10,'String',statList,'BackgroundColor','w','Tag','ListStat');
% biomarkers
hp2 = uipanel(StatSelection,'Title','SELECT BIOMARKER(S)','FontSize',10,'Units','pixels','Position',[10 300 360 200],'BackgroundColor','w','fontweight','bold');

ListBiom = uicontrol(hp2,'Units', 'pixels','style','listbox','Max',length(NBTstudy.groups{1}.biomarkerList),'Units', 'pixels','Position',[5 5 350 180],'fontsize',10,'String',NBTstudy.groups{1}.biomarkerList,'BackgroundColor','w','Tag','ListBiomarker');

% regions or channels
reglist{1} = 'Channels';
reglist{2} = 'Regions';
reglist{3} = 'Match channels';

hp = uipanel(StatSelection,'Title','SELECT CHANNELS OR REGIONS','FontSize',10,'Units','pixels','Position',[10 220 360 70],'BackgroundColor','w','fontweight','bold');
ListRegion = uicontrol(hp,'Units', 'pixels','style','listbox','Min',0,'Max',2,'Units', 'pixels','Position',[5 5 350 50],'fontsize',10,'String',reglist,'BackgroundColor','w','Tag','ListRegion');

% channel selection button
ChannelsButton = uicontrol(StatSelection,'Style','pushbutton','String','Select Channels and Regions','Position',[400 240 200 30],'fontsize',12);%,'callback',@ChannelsButton_Callback);
set(ChannelsButton,'callback','nbt_selectchansregs;');

% select Group

for i = 1:length(NBTstudy.groups)
    groupList{i} = ['Group ' num2str(i) ' : ' NBTstudy.groups{i}.groupName];
end

hp4 = uipanel(StatSelection,'Title','SELECT GROUP(S)','FontSize',10,'Units','pixels','Position',[10 110 360 100],'BackgroundColor','w','fontweight','bold');
ListGroup = uicontrol(hp4,'Units', 'pixels','style','listbox','Max',length(groupList),'Units', 'pixels','Position',[5 5 350 80],'fontsize',10,'String',groupList,'BackgroundColor','w','Tag','ListGroup');
% run test
RunButton = uicontrol(StatSelection,'Style','pushbutton','String','Run Test','Position',[500 5 100 50],'fontsize',10,'callback', 'nbt_runStatistics(1)', 'Tag', 'NBTstatRunButton');
% join button
joinButton = uicontrol(StatSelection,'Style','pushbutton','String','Join Groups','Position',[5 70 70 30],'fontsize',8,'callback',@join_groups);
% create difference group button
groupdiffButton = uicontrol(StatSelection,'Style','pushbutton','String','Difference Group','Position',[280 70 100 30],'fontsize',8,'callback',@diff_group);
% create difference group button
definegroupButton = uicontrol(StatSelection,'Style','pushbutton','String','Define New Group(s)','Position',[400 140 150 30],'fontsize',12,'callback',@nbt_definegroups);
% create difference group button
addgroupButton = uicontrol(StatSelection,'Style','pushbutton','String','Update Groups List','Position',[130 40 110 30],'fontsize',8,'callback',@add_new_groups);
% remove group(s)
removeGroupButton = uicontrol(StatSelection,'Style','pushbutton','String','Remove Group(s)','Position',[80 70 100 30],'fontsize',8,'callback',@remove_groups);
% save group(s)
saveGroupButton = uicontrol(StatSelection,'Style','pushbutton','String','Save Group(s)','Position',[185 70 90 30],'fontsize',8,'callback',@save_groups);
% export bioms
ExportBio = uicontrol(StatSelection,'Style','pushbutton','String','Export Biomarker(s) to .txt','Position',[5 10 150 30],'fontsize',8,'callback',@export_bioms);

% move up
upButton = uicontrol(StatSelection,'Style','pushbutton','String','/\','Position',[370 165 25 25],'fontsize',8,'callback',@up_group);
% move down
downButton = uicontrol(StatSelection,'Style','pushbutton','String','\/','Position',[370 140 25 25],'fontsize',8,'callback',@down_group);
end