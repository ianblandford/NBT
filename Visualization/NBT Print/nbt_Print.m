function nbt_Print(NBTstudy,groups)
    %%% Todo
    % * Can't handle difference group yet, look up how this is stored
    % * Can't handle GUI yet, command line only
    % CHECK * Fix labels on rows
    % CHECK * Fix check input arguments
    % * Fix variable name chanValuesGroup
    % * Create subfunctions, 1 function of 500 lines of code is not
    % feasible to edit later on in life =)
    % * Do we want a separate NBT Print config file?

    % 1. Display the NBT Print visualization window
    
    % 1. Run the statistics
    % 2. Get the statistics object
    % 3. Check whether the user wants to plot one group or two groups
    % 4. Get the data for the group(s)
    % 5. Sort the data to the hard coded order
    % 6. Create the topoplots
    
    %%% Check whether the input is valid
    checkInput();
    
    % Get the biomarker list from the (first) group
    biomarkerList = NBTstudy.groups{1}.biomarkerList;
    
    dataType = '';
    VIZ_LAYOUT = '';
    VIZ_SIG = '';   
    %%% 1. Display the NBT Print visualization window
    %% nbt Print visualization OPTIONS
    waitfor(VizQuerry);
%     if ~isempty(G(group_ind).group_difference)
%         prompt = {'Alpha sig. threshold:'}; dlg_title = 'Alpha'; num_lines = 1; def = {'0.05'};
%         alpha = str2double(inputdlg(prompt,dlg_title,num_lines,def));
%     end
    switch dataType
        case {'zscore'}
            disp('Running zscore statistics');
            if nGroups == 1
                S = NBTstudy.getStatisticsTests(24);
                S.groups = groups;
                
                for gp = 1:length(S.groups)
                    for i = 1:size(biomarkerList,1)
                        [S.group{gp}.biomarkers{i}, S.group{gp}.biomarkerIdentifiers{i}, S.group{gp}.subBiomarkers{i}, S.group{gp}.classes{i}] = nbt_parseBiomarkerIdentifiers(biomarkerList{1});
                    end
                end

                StatObj = S.calculate(NBTstudy);
            else        
                StatObj = calculate(nbt_zscore,NBTstudy,2);
            end
            disp('Statistics done.')
        case 'raw'
        case 'mean'
            disp('Computing means');
            if size(groups,2) == 1
                %%% Has to be changed with new version of getData!
                StatObj = NBTstudy.statAnalysis{end};
                
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{1};
                DataGroup1 = getData(Group1,StatObj);
                
                %%% Group mean
                nBioms = DataGroup1.numBiomarkers;
                for biomID = 1 : nBioms
                    %%% Get raw biomarker data, compute mean and store
                    chanValuesGroup1 = DataGroup1{biomID,1};
                    meanGroup1 = StatObj.groupStatHandle(chanValuesGroup1');

                    plotValues(biomID,:) = meanGroup1;
                end                    
            elseif size(groups,2) == 2
                %%% Has to be changed with new version of getData!
                StatObj = NBTstudy.statAnalysis{end};
                
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{1};
                Group2 = NBTstudy.groups{2};
                DataGroup1 = getData(Group1,StatObj);
                DataGroup2 = getData(Group2,StatObj);

                nBioms = DataGroup1.numBiomarkers;
                for biomID = 1 : nBioms
                    %%% Get raw biomarker data
                    chanValuesGroup1 = DataGroup1{biomID,1};
                    chanValuesGroup2 = DataGroup2{biomID,1};

                    %%% Get the group means
                    meanGroup1 = StatObj.groupStatHandle(chanValuesGroup1');
                    meanGroup2 = StatObj.groupStatHandle(chanValuesGroup2');
                    
                    %%% Compute the difference and store them
                    plotValues(biomID,:) = meanGroup2 - meanGroup1;
                end
            else
                error('nbt_Print can not handle more than two groups');
            end
    end
    switch VIZ_LAYOUT
        case 'dflt'
%             omega=50;%max amount of defined biomarkers UPDATE from nbt_PrintSort
%             missing=setdiff([1:omega],namind);
%             namind=[namind,missing];
%             biom=[biom;cell(length(missing),1)];
% 
%             [B,I]=sort(namind);
%             zindex=[zindex,missing];
%             zindex=zindex(I);
% 
%             if isempty(G(group_ind).group_difference) && isempty(pzindex)
%                 pzindex = [];
%             else
%                 pzindex=[pzindex,missing];
%                 pzindex=pzindex(I);
%             end
% 
%             biom=cellstr(char(biom{I}));
        case 'cstm'
%             missing=[];
%             [B,I]=sort(namind);
%             zindex=zindex(I);
%             if isempty(G(group_ind).group_difference) && isempty(pzindex)
%                 pzindex = [];
%             else
%                 pzindex=pzindex(I);
%             end
%             biom=cellstr(char(biom{I}));
    end
%     if ~isempty(G(group_ind).group_difference) && isempty(pzindex)
%         error('T-test need to be computed to visualize a group difference.')
%     end

    %%% Get the channel locations from one of the two groups
    chanLocs = Group1.chanLocs;

    % Set custom names for frequency bands?
    declareFreqBands();

    % 5. Sort the data
    sortedBiomarkers = nbt_PrintSort(DataGroup1.biomarkers);

    % 6. Print the topoplots
    if size(sortedBiomarkers,2) > 25
        nPlotsPerPage = 25;
    else
        nPlotsPerPage = size(sortedBiomarkers,2);
    end
    
    nPages = ceil(length(sortedBiomarkers)/nPlotsPerPage);

    %load nbt_colormapContourWhiteRed
    %colormap(nbt_colormapContourWhiteRed)

    fgh = [];
    lowerPlotBound = 1;
    for pageNumber = 1 : nPages
        %%% Set figure
        switch dataType
            case {'zscore','raw'}
                %fgh(end+1) = figure('name',['NBT print of ',char(G(group_ind).fileslist(index).name)],'NumberTitle','on');
            case 'mean'
                if size(groups,2) == 1
                    % There is one group
                    fgh(end+1) = figure('name',['Mean of  ',Group1.groupName],'NumberTitle','off');
                elseif size(groups,2) == 2
                    % There are two groups
                    fgh(end+1) = figure('name',['Mean of  ', Group2.groupName, '-', Group1.groupName],'NumberTitle','off');
                else
                    error('NBT Print can not handle more than two groups');
                end
        end
        
        xSize = 27;
        ySize = 19.;
        xLeft = (30-xSize)/2;
        yTop = (21-ySize)/2;

        set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        set(gcf,'Position',[0 0 xSize*50 ySize*50]);

        %Plot all the topoplots
        for biomID = lowerPlotBound : lowerPlotBound + nPlotsPerPage - 1
            %biomNumber = sortedBiomarkers(biomID);
            %biomName = biomarkerList(topoplotNumber);

            % subaxis(1+ceil(perpage/5),5,6+mod(i-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)
            subaxis(6,5,6+mod(biomID-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)

            f1=figure(fgh(end));
            set(f1,'renderer','painters');

            sig_biom = [];
            
            
            topoplot(plotValues(biomID,:),chanLocs,'headrad','rim','emarker2',{sig_biom,'o','w',6,2},'maplimits',[-3,3],'style','map');
            set(gca, 'LooseInset', get(gca,'TightInset'));

            if  any(plotValues~=0)
                cbar=colorbar('location','west');
                posish=get(cbar,'position');
                set(cbar,'position',[0.14+mod(biomID-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);                        

                min_cbar = min(plotValues); 
                max_cbar = max(plotValues);

                caxis([min_cbar,max_cbar]);
                set(cbar,'FontSize', 10);
            end
            
            

            %% PLOTTING FREQUENCY BANDS ABOVE THE TOP ROW
            if ismember(pageNumber,[0,1,2]) && biomID <= 70
                    if mod(biomID,25)==1
                        title ('Delta','FontSize',13,'interpreter','tex','fontweight','bold');
                    elseif mod(topoplotNumber,25)==2
                        title ('Theta','FontSize',13,'interpreter','tex','fontweight','bold');
                    elseif mod(topoplotNumber,25)==3
                        title ('Alpha','FontSize',13,'interpreter','tex','fontweight','bold');
                    elseif mod(topoplotNumber,25)==4
                        title ('Beta','FontSize',13,'interpreter','tex','fontweight','bold');
                    elseif mod(topoplotNumber,25)==5
                        title ('Gamma','FontSize',13,'interpreter','tex','fontweight','bold');
                    end
            else
                % non-default bioms
                    title(biom_name,'FontSize',11,'interpreter','none')
            end
        end

        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

        %%% Plot the NBT print title
        text(0.5, 0.99,'NBT Print','HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',22,'Interpreter','tex'); %NBT Print
        
        
        switch dataType
            case 'zscore'
%                 if length(stat_results(1,1).group_ind)>1 % there are two groups
%                     group2=strtrim(regexprep(stat_results(1,1).group_name{2,1},'Group \d : ',''));
%                     text(0.85,0.9,['Relative Z-SCORES based on ',int2str(length(G(group_ind).fileslist)/2),' subject pairs from ', group2 ,', with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                 else
%                     if ~isempty(G(group_ind).group_difference)
%                         text(0.85,0.9,['Z-SCORE based on ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                     else
%                         text(0.85,0.9,['Z-SCORE based on ',int2str(length(G(group_ind).fileslist)),' subjects with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                     end
%                 end
            case 'mean'
                %%% Display text for one group
                if nGroups == 1
                    %%% Either 'normal' group
                    %%% Or difference group
                    
                    %if ~isempty(G(group_ind).group_difference)
                        %text(0.85,0.9,['Average of ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
                    %else
                        text(0.5,0.92,['Average of subjects with ref. electrode ',Group1.chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                    %end
                else
                    %%% Or for two groups
                    text(0.5,0.92,['Average difference between ', Group1.groupName ,' and ', Group2.groupName, ', with ref. electrode ',Group1.chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                end
            case 'raw'
%                 text(0.85,0.9,['Raw data with  ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
        end

        switch VIZ_LAYOUT
            case 'dflt'
                if pageNumber==1
                    get(gcf,'CurrentAxes');
                    ABSAMP = text(0.02,9/12, 'Relative','horizontalalignment', 'center');
                    set(ABSAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    RELAMP= text(0.02,7/12, 'Absolute','horizontalalignment', 'center');
                    set(RELAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    DFA= text(0.02,5/12, 'DFA','horizontalalignment', 'center');
                    set(DFA,'rotation',90);
                    get(gcf,'CurrentAxes');
                    CENTRAL= text(0.02,3/12, 'Central Freq.','horizontalalignment', 'center');
                    set(CENTRAL,'rotation',90);
                    get(gcf,'CurrentAxes');
                    LIFETIME= text(0.02,1/12, 'Lifetime','horizontalalignment', 'center');
                    set(LIFETIME,'rotation',90);
                elseif pageNumber==2;
                    get(gcf,'CurrentAxes');
                    ABSAMP = text(0.02,9/12, 'Bandwidth','horizontalalignment', 'center');
                    set(ABSAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    RELAMP= text(0.02,7/12, 'Spectral edge','horizontalalignment', 'center');
                    set(RELAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    DFA= text(0.02,5/12, 'Amplitude Correlations','horizontalalignment', 'center');
                    set(DFA,'rotation',90);
                    get(gcf,'CurrentAxes');
                    CENTRAL= text(0.02,3/12, 'Coherence','horizontalalignment', 'center');
                    set(CENTRAL,'rotation',90);
                    get(gcf,'CurrentAxes');
                    LIFETIME= text(0.02,1/12, 'PhaseLock PLV','horizontalalignment', 'center');
                    set(LIFETIME,'rotation',90);
                end
            case 'cstm'
        end

        lowerPlotBound = lowerPlotBound + nPlotsPerPage;
    end
    
% Nested functions part
    function checkInput()
        if ~isa(NBTstudy,'nbt_Study')
            error('No valid NBTstudy object was detected');
        end

        if ~isnumeric(groups)
            error('No valid group number(s) was/were detected');
        else
            % Get the number of groups
            nGroups = size(groups,2);
            if nGroups < 1
                error('Number of groups is smaller than 1');
            elseif nGroups > 2
                error('NBT Print can not handle more than two groups');
            end
        end
    end

    function declareFreqBands()
        disp('Default frequency bands:');
        disp('Delta = [1,4];')
        disp('Theta = [4,8];')
        disp('Alpha = [8,13];')
        disp('Beta = [13,30];')
        disp('Gamma = [30,45];')

        temp=input('Declare own frequency bands?[y/n]: ','s');
        if strcmp(temp,'y')
            Delta = (input('Specify Delta [lowF highF]: '));
            Theta = (input('Specify Theta [lowF highF]: '));
            Alpha = (input('Specify Alpha [lowF highF]: '));
            Beta = (input('Specify Beta [lowF highF]: '));
            Gamma = (input('Specify Gamma [lowF highF]: '));
        else
            Delta = [1,4];
            Theta = [4,8];
            Alpha = [8,13];
            Beta = [13,30];
            Gamma = [30,45];
        end
    end
end