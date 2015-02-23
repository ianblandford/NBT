% nbt_plotColorbar - this function plots the colorbar for the topoplots in
% nbt_Print and other NBT visualization tools
%
% Usage:
%   nbt_plotColorbar(subplotIndex, cmin, cmax, maxTicks, units, maxColumns)
%
% Inputs:
%   subPlotIndex,
%   cmin,
%   cmax,
%   maxTicks,
%   units,
%   maxColumns
%
% Outputs:
%
% Example:
%   nbt_plotColorbar(1, min(biomarkerValues), max(biomarkerValues), 6, units, 5)
%
% References:
%
% See also:
%  nbt_Print, nbt_plot_2conditions_topoAll

%------------------------------------------------------------------------------------
% Originally created by ..., Edited by Simon J. Houtman (2015)
%------------------------------------------------------------------------------------
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

function nbt_plotColorbar(subplotIndex, cmin, cmax, maxTicks, units, maxColumns)
    if ~exist('maxTicks')
        disp('Maximum number of ticks was not specified, using default of 6 ticks.');
        maxTicks = 6;
    end
    
    %%% Plot the colorbar on the righthand side of the topoplot
    cbar = colorbar('location','west');
    posish = get(cbar,'position');
    set(cbar,'position',[0.14 + mod(subplotIndex-1, maxColumns)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',10);               
    
    %%% Set the title to be empty
    set(get(cbar,'title'),'String','');
    
    %%% Set caxis
    caxis([cmin,cmax]);
    
    %%% Round the ticks to 2 decimals
    if((abs(cmax) - abs(cmin))/maxTicks<=1)
        cmin = round(cmin/0.01)*0.01;
        cmax = round(cmax/0.01)*0.01;
    else
        cmin = round(cmin);
        cmax = round(cmax);
    end
    
    %%% Set the colorbar ticks
    cticks = linspace(cmin,cmax,maxTicks);
    
    %%% Increase the colobar limits by a very small number, otherwise the
    %%% first or the last tick might fall off (Fix for Matlab bug)
    %%% Note: if you decrease this number further, ticks will fall off
    caxis([min(cticks)-0.00000000001 max(cticks)+0.00000000001]);
    set(cbar,'YTick',cticks);

    if((abs(cmax) - abs(cmin))/maxTicks<=1)
        cticks = round(cticks/0.01)*0.01;
    else
        cticks = round(cticks);
    end
    
    
%     %%% Make sure that the number of decimals is the same for all labels
%     tickStringOriginal = num2str(cticks');
%     
%     %%% Get the length of the longest tick label
%     maxLength = 0;
%     for k = 1 : length(tickStringOriginal)
%         if numel(tickStringOriginal(k,:)) > maxLength
%             maxLength = numel(tickStringOriginal(k,:));
%         end
%     end
%     
%     %%% Initialize a new char array of size (0,maxLength)
%     tickString = char.empty(0,maxLength);
%     
%     %%% Iterate along the original ticks-string and add a '0' at the end of
%     %%% the string if it is missing
%     for k = 1 : length(cticks)
%         [head, tail] = strtok(tickStringOriginal(k,:),'.');
%         
%         %%% Add 1 zero at the end
%         if numel(tail) == 2
%             %%% Remove the space at the beginning
%             head = head(2:end);
% 
%             %%% And add the zero at the end
%             tickString(k,:) = [head tail '0'];
%         elseif numel(tail) == 1
%             %%% Not possible
%         elseif numel(tail) == 0
%             %%% Add a dot and two zeros
%             tickString(k,:) = [head tail];
%         else
%             tickString(k,:) = [head tail];
%         end
%     end
%     
    set(cbar,'YTickLabel',cticks);
        
    %%% Put the unit on the colorbar
    if ~isempty(units(subplotIndex))
        cbarTitle = title(cbar, units(subplotIndex));
        set(cbarTitle, 'fontsize', 8);
    end
end