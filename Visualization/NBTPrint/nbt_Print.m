function nbt_Print(NBTstudy,groups)
    %%% Todo
    % * Can't handle difference group yet, look up how this is stored
    % CHECK * Can't handle GUI yet, command line only
    % CHECK * Fix labels on rows
    % CHECK * Fix check input arguments
    % NO * Fix variable name chanValuesGroup
    % * Create subfunctions, 1 function of 500 lines of code is not
    % feasible to edit later on in life =)
    % NO * Do we want a separate NBT Print config file?

    %%% Check whether the input is valid
    checkInput();
    
    %% Display the NBT Print visualization window
    %% NBT Print visualization options
    dataType = '';
    VIZ_LAYOUT = '';
    VIZ_SIG = '';
    waitfor(VizQuerry);
%     if ~isempty(G(group_ind).group_difference)
%         prompt = {'Alpha sig. threshold:'}; dlg_title = 'Alpha'; num_lines = 1; def = {'0.05'};
%         alpha = str2double(inputdlg(prompt,dlg_title,num_lines,def));
%     end
    switch dataType
        case 'raw'
            disp('Getting raw values');
            if size(groups,2) == 1          
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups};
                
                %%% Generate fixed biomarker list
                StatObj = nbt_generateBiomarkerList(NBTstudy,groups);
                
                %%% Get the data
                Data = getData(Group1,StatObj);
                
                %%% Number of biomarkers
                nBioms = Data.numBiomarkers;
                
                %% Get subject number from the command line
                subjectNumber = input('Please specify the number of the subject');
                    
                plotValues = zeros(1,129);
                for biomID = 1 : nBioms
                    %% Get raw biomarker data, compute means and store them
                    chanValuesGroup1 = Data{biomID,1};                   
                    plotValues(biomID,:) = chanValuesGroup1(:,subjectNumber);
                end
                biomarkerIndex = StatObj.group{groups}.biomarkerIndex;
            elseif size(groups,2) == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Generate fixed biomarker list
                StatObjGroup1 = nbt_generateBiomarkerList(NBTstudy,groups(1));
                StatObjGroup2 = nbt_generateBiomarkerList(NBTstudy,groups(2));
                
                %%% Get the data
                DataGroup1 = getData(Group1,StatObjGroup1);
                DataGroup2 = getData(Group2,StatObjGroup2);
                
                %%% Number of biomarkers
                nBioms = DataGroup1.numBiomarkers;
                
                plotValues = zeros(1,129);
                for biomID = 1 : nBioms
                    %% Get biomarker data, compute means and store them
                    chanValuesGroup1 = DataGroup1{biomID,1};
                    chanValuesGroup2 = DataGroup2{biomID,1};
                    meanGroup1 = mean(chanValuesGroup1');
                    meanGroup2 = mean(chanValuesGroup2');
                    plotValues(biomID,:) = meanGroup2 - meanGroup1;
                end
                biomarkerIndex = StatObjGroup1.group{1}.biomarkerIndex;
            else
                error('nbt_Print can not handle more than two groups');
            end            
        case 'mean'
            disp('Computing means');
            if size(groups,2) == 1          
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups};
                
                %%% Generate fixed biomarker list
                StatObj = nbt_generateBiomarkerList(NBTstudy,groups);
                
                %%% Get the data
                Data = getData(Group1,StatObj);
                
                %%% Number of biomarkers
                nBioms = Data.numBiomarkers;
                
                plotValues = zeros(nBioms,129);
                for biomID = 1 : nBioms
                    %% Get raw biomarker data, compute means and store them
                    chanValuesGroup1 = Data{biomID,1};
                    meanGroup1 = mean(chanValuesGroup1');   

                    plotValues(biomID,:) = meanGroup1;
                end
                biomarkerIndex = StatObj.group{groups}.biomarkerIndex;
            elseif size(groups,2) == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Generate fixed biomarker list
                StatObjGroup1 = nbt_generateBiomarkerList(NBTstudy,groups(1));
                StatObjGroup2 = nbt_generateBiomarkerList(NBTstudy,groups(2));
                
                %%% Get the data
                DataGroup1 = getData(Group1,StatObjGroup1);
                DataGroup2 = getData(Group2,StatObjGroup2);
                
                %%% Number of biomarkers
                nBioms = DataGroup1.numBiomarkers;
                
                plotValues = zeros(1,129);
                for biomID = 1 : nBioms
                    %% Get biomarker data, compute means and store them
                    chanValuesGroup1 = DataGroup1{biomID,1};
                    chanValuesGroup2 = DataGroup2{biomID,1};
                    meanGroup1 = mean(chanValuesGroup1');
                    meanGroup2 = mean(chanValuesGroup2');
                    plotValues(biomID,:) = meanGroup2 - meanGroup1;
                end
                biomarkerIndex = StatObjGroup1.group{1}.biomarkerIndex;
            else
                error('nbt_Print can not handle more than two groups');
            end
    end
    switch VIZ_LAYOUT
        case 'dflt'
             omega=50;%max amount of defined biomarkers UPDATE from nbt_PrintSort
        case 'cstm'
    end

    %%% Get the channel locations from one of the two groups
    chanLocs = Group1.chanLocs;

    % Set custom names for frequency bands?
    declareFreqBands();
    
    perPage = 25;
    nPages=ceil(nBioms/25);
    fgh=[];
    for page = 1 : nPages
        %% Generates a new figure for each page defined by iotta
        switch dataType
            case {'mean' 'raw'}
                if nGroups > 1 % there are two groups
                    fgh(page)=figure('name',['Mean of  ', char(Group2.groupName), '-', char(Group1.groupName)],'NumberTitle','off');
                else
                    fgh(page)=figure('name',['Mean of  ',char(Group1.groupName)],'NumberTitle','off');
                end
        end      
        
        xSize =27; ySize = 19.;
        xLeft = (30-xSize)/2; yTop = (21-ySize)/2;
        set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        set(gcf,'Position',[0 0 xSize*50 ySize*50]);
        
        for i = page * perPage - perPage + 1 : (page * perPage)
            % Loads p-vals when there is a group difference
%             if ~isempty(G(group_ind).group_difference) && ~isempty(char(biom(i)))
%                 sig_biom=find(stat_results(1,pzindex(i)).p<alpha);
%             else
%                 sig_biom=[];
%             end
            
            %% LOADS DATA TO BE VISUALIZED IN SUBPLOT  
            if biomarkerIndex(i) ~= 0
                if nGroups > 1 % 2 groups
                   biomholder = plotValues(biomarkerIndex(i),:);
                else
                   biomholder = plotValues(biomarkerIndex(i),:);
                end
            else
                biomholder = 0;
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
            
            if size(biomholder,2) == length(chanLocs)
                subaxis(6,5,6+mod(i-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)
                
                if nGroups == 1
                    Red_cbrewer5colors = load('Red_cbrewer5colors','Red_cbrewer5colors');
                    Red_cbrewer5colors = Red_cbrewer5colors.Red_cbrewer5colors;
                    colormap(Red_cbrewer5colors);
                else
                    RedBlue_cbrewer10colors = load('RedBlue_cbrewer10colors','RedBlue_cbrewer10colors');
                    RedBlue_cbrewer10colors = RedBlue_cbrewer10colors.RedBlue_cbrewer10colors;
                    colormap(RedBlue_cbrewer10colors);
                end
                
                figure(fgh(end));
                sig_biom = [];
                modplot(biomholder,chanLocs,'headrad','rim','emarker2',{sig_biom,'o','w',6,2},'maplimits',[-3 3],'style','map');
                set(gca, 'LooseInset', get(gca,'TightInset'));
                
                switch dataType
                    case {'mean' 'raw'}
                        plot_colorbar();
                end
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
            case 'mean'
                if nGroups > 1 % there are two groups
                    group1 = strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2 = strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.5,0.9,['Average difference between ', group1 ,' and ', group2, ', with ref. electrode ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                else
%                     if ~isempty(G(group_ind).group_difference)
%                      text(0.85,0.9,['Average of ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                  else
                     text(0.5,0.9,['Average of ',int2str(Group1.fileList),' subjects with ref. electrode ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
%                     end
                end
            case 'raw'
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
                if page==1
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
                elseif page==2;
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

    function plot_colorbar()
        %%% Plot the colorbar on the lefthand side of the topoplot
       cbar=colorbar('location','west');
        posish=get(cbar,'position');
        set(cbar,'position',[0.14+mod(i-1,5)*.205,posish(2),0.01,posish(4)+.2*posish(4)],'fontsize',7);                        

        cmin = min(biomholder); 
        cmax = max(biomholder);

        caxis([cmin,cmax]);
        set(cbar,'FontSize', 10);
       % ticks = get(cbar,'YTick');
       % if length(ticks)>4 ... force no more than 4?
       % set(cbar,'YTick',round([min_cbar:(max_cbar-min_cbar)/3:max_cbar]/0.01)*0.01); 

        %%% Round the YTick to 2 decimals
        if((abs(cmax) - abs(cmin))/(size(colormap,1)+1)<=1)
            cmin = round(cmin/0.01)*0.01;
            cmax = round(cmax/0.01)*0.01;
        else
            cmin = round(cmin);
            cmax = round(cmax);
        end

        cticks = linspace(cmin,cmax,size(colormap,1)+1);
        %cticks = cticks(1:2:end); % make ticks more sparse
        caxis([min(cticks) max(cticks)]);
        set(cbar,'YTick',cticks);
        if((abs(cmax) - abs(cmin))/(size(colormap,1)+1)<=1)
            set(cbar,'YTickLabel',round(cticks/0.01)*0.01);
        else
            set(cbar,'YTickLabel',round(cticks));
        end
    end
end