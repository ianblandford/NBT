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
        case 'raw'
        case 'mean'
            disp('Computing means');
            if size(groups,2) == 1          
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{1};
                
                %%% Generate fixed biomarker list
                obj = nbt_generateBiomarkerList(NBTstudy,Group1.grpNumber);
                
                %%% Get the data
                DataGroup1 = getData(Group1,obj);       
                                
                %%% Group mean
                nBioms = DataGroup1.numBiomarkers;
                plotValues = zeros(nBioms,129);
                
                for biomID = 1 : nBioms
                    %%% Get raw biomarker data, compute mean and store
                    chanValuesGroup1 = DataGroup1{biomID,1};
                    meanGroup1 = mean(chanValuesGroup1');   
                    
                    plotValues(biomID,:) = meanGroup1;
                end                    
            elseif size(groups,2) == 2
                %%% Has to be changed with new version of getData!
                StatObj = NBTstudy.statAnalysis{end};
                
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{1};
                Group2 = NBTstudy.groups{2};
                DataGroup1 = getData(Group1);
                DataGroup2 = getData(Group2);

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
             omega=50;%max amount of defined biomarkers UPDATE from nbt_PrintSort
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
    %sortedBiomarkers = nbt_PrintSort(biomarkerList);
 
    % 6. Print the topoplots
%     if size(sortedBiomarkers,2) > 25
%         nPlotsPerPage = 25;
%     else
%         nPlotsPerPage = size(sortedBiomarkers,2);
%     end
            nPlotsPerPage = 25;

    nPages = ceil(length(nBioms)/nPlotsPerPage);

    %load nbt_colormapContourWhiteRed
    %colormap(nbt_colormapContourWhiteRed)

    fgh = [];
    lowerPlotBound = 1;
    
allindex = 1;
zindex = 1:nBioms;
    
for dingus=1:numel(allindex);
    index=allindex(dingus);%cycles through the subjects & selects right one
    pages=ceil(length(zindex)/25);
    fgh=[];
    for iotta=0:pages-1
        if length(zindex)-iotta*25>25
            perpage=25;
        elseif length(zindex)-iotta*25<=25
            perpage=length(zindex)-iotta*25;
        end
        %% Generates a new figure for each page defined by iotta
        switch dataType
%             case {'zscore','raw'}
%                 fgh(end+1)=figure('name',['NBT print of ',char(Group1.groupName)],'NumberTitle','on');
            case 'mean'
                if nGroups > 1 % there are two groups
                    fgh(end+1)=figure('name',['Mean of  ', char(Group2.groupName), '-', char(Group1.groupName)],'NumberTitle','off');
                else
                    fgh(end+1)=figure('name',['Mean of  ',char(Group1.groupName)],'NumberTitle','off');
                end
        end
       
        
        xSize =27; ySize = 19.;
        xLeft = (30-xSize)/2; yTop = (21-ySize)/2;
        set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        set(gcf,'Position',[0 0 xSize*50 ySize*50]);
        
        disp(iotta)
        disp(perpage)
        disp((1+(iotta)*25)+perpage-1)
        for i=(1+(iotta)*25):1:(1+(iotta)*25)+perpage-1
            i
            % Loads p-vals when there is a group difference
%             if ~isempty(G(group_ind).group_difference) && ~isempty(char(biom(i)))
%                 sig_biom=find(stat_results(1,pzindex(i)).p<alpha);
%             else
%                 sig_biom=[];
%             end
            
            %% LOADS DATA TO BE VISUALIZED IN SUBPLOT
            switch dataType     
                case 'zscore'
                case 'mean'
                    if ~isempty(char(biomarkerList{i}))
                        if nGroups > 1 % 2 groups
                           biomholder = plotValues(i,:);
                        else
                           biomholder = plotValues(i,:);
                        end
                    elseif isempty(char(biomarkerList{i}))
                        biomholder=zeros(size(chanLocs)).';
                    end
                case 'raw'% In the future, replace this with proper data loading
%                     if ~isempty(char(biom(i)))
%                     %    if (size(stat_results(1,1).group_name,1)>1) % 2 groups
%                     %        biomholder=(stat_results(1,zindex(i)).vals1(:,index).*stat_results(1,zindex(i)).sigma)+stat_results(1,zindex(i)).mu;
%                     %    else
%                             biomholder = plotValues;
%                     %    end
%                     elseif isempty(char(biom(i)))
%                         biomholder = zeros(size(chanLocs)).';
%                     end
            end
            switch VIZ_SIG
%                 case 'sig'
%                     if ~isempty(sig_biom)
%                         biomholder(setdiff(1:numel(biomholder),sig_biom))=NaN;
%                         sig_biom=[];
%                     else
%                         biomholder=zeros(size(chanLocs)).';
%                     end
            end
            %Check if all biomarker vals are NaN, which often happens for
            % alpha and beta peak frequencies
            if any(~isnan(biomholder))==0
                sig_biom = [];
                biomholder = zeros(size(chanLocs)).';
            end
            
%             subaxis(1+ceil(perpage/5),5,6+mod(i-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)
            subaxis(6,5,6+mod(i-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)
            if size(biomholder,2) == length(chanLocs)
%                 coolWarm = load('nbt_CoolWarm.mat','coolWarm');
             %   coolWarm =load('nbt_GoldenBrown.mat','cdata');
                %                 coolWarm = load('nbt_CoolWarmWhite.mat');
              %  coolWarm=coolWarm.cdata;
               % if ~isempty(G(group_ind).group_difference) && ~strcmp(dataType,'zscore')
                %    coolWarm=flipud(coolWarm);
                %end
               % colormap(coolWarm);
%                 load nbt_zscorecolormap
%                 colormap(flipud(nbt_zscorecolormap))
% colormap('cool')
colormap('HSV')
% colormap('Jet')
% load nbt_BlueWhiteRed
% colormap(nbt_BlueWhiteRed)
% load nbt_colormapContourBlueRed
% colormap(nbt_colormapContourBlueRed)
% load nbt_colormapContourWhiteRed
% colormap(nbt_colormapContourWhiteRed)
% load nbt_colormapP
% colormap(nbt_colormapP)
% load nbt_colortmapP
% colormap(nbt_colortmapP)
% load nbt_colortmap2
% colormap(nbt_colortmap2)
% load nbt_CoolWarm
% colormap(coolWarm)
% load nbt_CoolWarmBlack
% colormap(coolWarmBlack)
% load nbt_CoolWarmWhite
% colormap(coolWarmWhite)
% load nbt_DarkBlueWhiteDarkRed
% colormap(nbt_DarkBlueWhiteDarkRed)
% load nbt_DarkBlueWhiteDarkRedSharp
% colormap(nbt_DarkBlueWhiteDarkRedSharp)
% load nbt_GoldenBrown
% colormap(cdata)
% load nbt_InvCoolWarm
% colormap(nbt_InvCoolWarm)
% load nbt_redwhite
% colormap(nbt_redwhite)
% load nbt_zscorecolormap
% colormap(nbt_zscorecolormap)

                figure(fgh(end));
                sig_biom = [];
                modplot(biomholder,chanLocs,'headrad','rim','emarker2',{sig_biom,'o','w',6,2},'maplimits',[-3 3],'style','map');
                set(gca, 'LooseInset', get(gca,'TightInset'));
                
                switch dataType
                    case 'mean'
                        if  any(biomholder~=0)
                        cbarc=colorbar('location','west');
                        posish=get(cbarc,'position');
                        set(cbarc,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);
                         %caxis([min(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu))),max(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu)))]);
%                         if isfield(stat_results(1,zindex(i)),'unit')&& ~isempty( stat_results(1,zindex(i)).unit)
%                             set(get(cbar,'title'),'String', stat_results(1,zindex(i)).unit);
%                         end
                        else
%                             cbar=colorbar('location','west');
%                             posish=get(cbar,'position');
%                             set(cbar,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);
%                            if ~isempty( stat_results(1,zindex(i)).unit)
%                                 set(get(cbar,'title'),'String', stat_results(1,zindex(i)).unit);
%                            end
                        end 
                    case 'raw'
%                         if  any(biomholder~=0)
%                             cbar=colorbar('location','west');
%                             posish=get(cbar,'position');
%                             set(cbar,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);
%                              caxis([min(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu))),max(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu)))]);
%                             if isfield(stat_results(1,zindex(i)),'unit')&& ~isempty( stat_results(1,zindex(i)).unit)
%                                 set(get(cbar,'title'),'String', stat_results(1,zindex(i)).unit);
%                             end
%                         else
%                             %                             cbar=colorbar('location','west');
%                             %                             posish=get(cbar,'position');
%                             %                             set(cbar,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);
% %                            if ~isempty( stat_results(1,zindex(i)).unit)
%                                 %                                 set(get(cbar,'title'),'String', stat_results(1,zindex(i)).unit);
% %                            end
%                         end
                end
%             elseif size(biomholder,1) == length(chanLocs)^2
%             ThisLineIsLong=reshape(biomholder,length(chanLocs),length(chanLocs));
%              %   bh=imagesc(ThisLineIsLong,[-3,3]);
%              load nbt_CoolWarmBlack
%              colormap(coolWarmBlack)
% %              ds.chanPairs =[];
% %            %  ds.connectStrength = [];
% %              plotconnect = 0;
% %              for m1=1:size(ThisLineIsLong,1)
% %                 for m2=m1:size(ThisLineIsLong,2)
% %                     if(abs(ThisLineIsLong(m1,m2)) > 5)
% %                         ds.chanPairs = [ds.chanPairs; m1 m2];
% %                        % ds.connectStrength = [ds.connectStrength; ThisLineIsLong(m1,m2)];
% %                         plotconnect = 1;
% %                     end
% %                 end
% %              end 
% %              if(plotconnect)
% %                 topoplot_connect(ds, G(1).chansregs.chanloc);
% %                 set(gca, 'LooseInset', get(gca,'TightInset'));
% %              end
% %                 colorbar('off')
%             %    coolWarm = load('nbt_CoolWarm.mat','coolWarm');
%             %    coolWarm = coolWarm.coolWarm;
%              %   colormap([1,1,1;coolWarm]);
%                 load nbt_zscorecolormap
%                 colormap(flipud(nbt_zscorecolormap))
%                % axis off tight square;
%                 set(gca, 'LooseInset', get(gca,'TightInset'));
%                 switch dataType
%                     case {'mean','raw'}
%                         cbar=colorbar('location','west');
%                         posish=get(cbar,'position');
%                         set(cbar,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.35*posish(4)],'fontsize',7);
% %                         caxis([min(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu))),max(stat_results(1,zindex(i)).mu(~isnan(stat_results(1,zindex(i)).mu)))]);
% %                         if isfield(stat_results(1,zindex(i)),'unit')&& ~isempty( stat_results(1,zindex(i)).unit)
% %                             set(get(cbar,'title'),'String', stat_results(1,zindex(i)).unit,'interpreter','tex');
% %                         end
%                 end
            end
            switch dataType
%                 case {'mean','raw'}
%                     if (min(biomholder)>0)
%                         cbar_limit=get(cbarc,'ylim');
%                         set(cbarc,'ylim',[0,cbar_limit(2)]);
%                     elseif (max(biomholder)<0)
%                         cbar_limit=get(cbarc,'ylim');
%                         set(cbarc,'ylim',[cbar_limit(1),0]);
%                     end
            end
            %% PLOTTING FREQUENCY BANDS ABOVE THE TOP ROW
            % omega is the # index of the last pre-defined biomarker
            switch VIZ_LAYOUT
                case 'dflt'
                    if mod(i,25)==1 && i<= omega;
                        title ('Delta','FontSize',10,'interpreter','tex','fontweight','demi');
                    elseif mod(i,25)==2 && i<= omega;
                        title ('Theta','FontSize',10,'interpreter','tex','fontweight','demi');
                    elseif mod(i,25)==3 && i<= omega;
                        title ('Alpha','FontSize',10,'interpreter','tex','fontweight','demi');
                    elseif mod(i,25)==4 && i<= omega;
                        title ('Beta','FontSize',10,'interpreter','tex','fontweight','demi');
                    elseif mod(i,25)==5 && i<= omega;
                        title ('Gamma','FontSize',10,'interpreter','tex','fontweight','demi');
                    elseif i>omega
                        title (biom{i},'FontSize',9,'interpreter','tex');
                    end
                case 'cstm'
                    title (biom{i},'FontSize',9,'interpreter','tex')
            end
        end
        % Colorbar right alignment
        switch dataType
%             case 'zscore'
%                 caxis([-3,3])
%                 cb = colorbar('location','WestOutside','position',[1-0.02,0.41,0.007,1/6]);
%                 set(get(cb,'title'),'String','Z','interpreter','tex');
        end
        set(gca,'fontsize',8)
        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        switch dataType
            case 'zscore'
%                 if length(stat_results(1,1).group_ind)>1 % there are two groups
%                     group2=strtrim(regexprep(stat_results(1,1).group_name{2,1},'Group \d : ',''));
%                     text(0.85,0.9,['Relative Z-SCORES based on ',int2str(length(G(group_ind).fileslist)/2),' subject pairs from ', group2 ,', with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                 else
%                     if ~isempty(G(group_ind).group_difference)
%                     text(0.85,0.9,['Z-SCORE based on ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                 else
%                     text(0.85,0.9,['Z-SCORE based on ',int2str(length(G(group_ind).fileslist)),' subjects with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                     end
%                 end
            case 'mean'
                if nGroups > 1 % there are two groups
                    group1 = strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2 = strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.85,0.9,['Average difference between ', group1 ,' and ', group2, ', with ref. electrode ',chanLocs(1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
                else
%                     if ~isempty(G(group_ind).group_difference)
%                      text(0.85,0.9,['Average of ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                  else
                     text(0.85,0.9,['Average of ',int2str(Group1.fileList),' subjects with ref. electrode ',chanLocs(1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                     end
                end
            case 'raw'
%                 text(0.85,0.9,['Raw data with  ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
        end
        switch dataType
            case 'mean'
                if nGroups>1 % there are two groups
                    group1=strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2=strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.5, 0.99,strcat('NBT print for groups ',{' '}, group1 ,' and ',{' '}, group2),'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',18,'Interpreter','tex');
                else
                    group_name=strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                text(0.5, 0.99,strcat('NBT print for group ',{' '},group_name),'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',18,'Interpreter','tex');
                end
%              otherwise
%                 text(0.5, 0.99,['NBT print for ',regexprep(G(group_ind).fileslist(index).name,'_analysis.mat',' ')],'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',18,'Interpreter','tex');
        end
        switch VIZ_LAYOUT
            case 'dflt'
                if iotta==0
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
                elseif iotta==1;
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
        %         switch printoptions
        %             case 'pdf'
%                         set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
%                         set(gcf,'PaperOrientation','landscape');
%                         genericname=['NBTprint_',regexprep(regexprep(G(group_ind).fileslist(index).name,'_analysis.mat',' '),'\.','_'),'_page',num2str(iotta+1),'.pdf'];
%                         print(gcf, '-dpdf','-r300', genericname);
        %
        %             case 'eps'
        %                 genericname=['NBTprint_',regexprep(regexprep(G(group_ind).fileslist(index).name,'_analysis.mat',' '),'\.','_'),'_page',num2str(iotta+1),'.eps'];
        %                 saveas(h,genericname,'eps')
        %             case 'jpg'
        %                 set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        %                 set(gcf,'PaperOrientation','landscape');
        %                 genericname=['NBTprint_',regexprep(regexprep(G(group_ind).fileslist(index).name,'_analysis.mat',' '),'\.','_'),'_page',num2str(iotta+1),'.jpg'];
        %                 print(gcf, '-djpeg','-r600', genericname);
        %             otherwise
        %                 printdlg();  %#ok<MCPRD>
        %         end
        %         close(gcf);
    end
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


    
