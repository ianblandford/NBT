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
    
    %%% Number of groups
    nGroups = size(groups,2);
       
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
            if nGroups == 1          
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups};
                
                %%% Number of channels
                nChannels = size(NBTstudy.groups{groups}.chanLocs,2);
                
                %%% Check whether the group is a difference group
                if ~isempty(Group1.groupType)
                    
                else
                    %%% Generate fixed biomarker list
                    AnalysisObj = nbt_generateBiomarkerList(NBTstudy,groups);

                    %%% Get the data
                    Data = getData(Group1,AnalysisObj);

                    %%% Number of biomarkers
                    nBioms = Data.numBiomarkers;
                    
                    %%% Get subject number from the command line
                    subjectNumber = input('Specify the number of the subject');

                    signalBiomarkers = zeros(nBioms,nChannels);
                    crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                    for biomID = 1 : nBioms
                        biomDataGroup1 = Data.dataStore{biomID};
                        if size(biomDataGroup1{1},2) == nChannels
                            %% chan * chan biomarker
                            crossChannelBiomarkers(:,:,biomID) = biomDataGroup1{subjectNumber};
                        else
                            %% Get raw biomarker data, compute means and store them
                            signalBiomarkers(biomID,:) = Data{biomID,1};
                        end
                    end
                    biomarkerIndex = AnalysisObj.group{1}.biomarkerIndex;
%                     units = AnalysisObj.group{groups}.units;
                end
            elseif nGroups == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Number of channels
                nChannels = size(NBTstudy.groups{groups(1)}.chanLocs,2);
                
                %%% Generate fixed biomarker list
                AnalysisObjGrp1 = nbt_generateBiomarkerList(NBTstudy,groups(1));
                AnalysisObjGrp2 = nbt_generateBiomarkerList(NBTstudy,groups(2));
                
                %%% Get the data
                DataGroup1 = getData(Group1,AnalysisObjGrp1);
                DataGroup2 = getData(Group2,AnalysisObjGrp2);
                
                %%% Number of biomarkers
                nBioms = DataGroup1.numBiomarkers;
                
                %%% Get subject number from the command line
                subjectNumber = input('Specify the number of the subject');
 
                signalBiomarkers = zeros(nBioms,nChannels);
                crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                for biomID = 1 : nBioms
                    biomDataGroup1 = DataGroup1.dataStore{biomID};
                    biomDataGroup2 = DataGroup2.dataStore{biomID};
                    
                    %% Check whether the biomarker is a cross channel biomarker
                    if size(biomDataGroup1{1},2) == nChannels
                        %% chan * chan biomarker
                        crossChannelBiomarkers(:,:,biomID) = biomDataGroup2{subjectNumber} - biomDataGroup1{subjectNumber};
                    else
                        %% Get raw biomarker data, and store them
                        signalBiomarkers(biomID,:) = DataGroup2{biomID,1} - DataGroup1{biomID,1};
                    end
                end
                biomarkerIndex = AnalysisObjGrp1.group{1}.biomarkerIndex;
%                 units = AnalysisObjGrp1.group{groups(1)}.units;
            else
                error('nbt_Print can not handle more than two groups');
            end            
        case 'mean'
            disp('Computing means');
            if nGroups == 1    
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups};
                
                %%% Number of channels
                nChannels = size(NBTstudy.groups{groups}.chanLocs,2);
                
                %%% Check whether the group is a difference group
                if ~isempty(Group1.groupType)
                    
                else
                    %%% Generate fixed biomarker list
                    AnalysisObj = nbt_generateBiomarkerList(NBTstudy,groups);

                    %%% Get the data
                    Data = getData(Group1,AnalysisObj);

                    %%% Number of biomarkers
                    nBioms = Data.numBiomarkers;

                    signalBiomarkers = zeros(nBioms,nChannels);
                    crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                    for biomID = 1 : nBioms
                        biomDataGroup1 = Data.dataStore{biomID};
                        if size(biomDataGroup1{1},2) == nChannels
                            chanValues = zeros(nChannels,nChannels);
                            for subject = 1 : size(biomDataGroup1,1)
                                chanValues = chanValues + biomDataGroup1{subject};
                            end
                            
                            %% chan * chan biomarker
                            crossChannelBiomarkers(:,:,biomID) = chanValues / size(biomDataGroup1,1);
                        else
                            %% Get raw biomarker data, compute means and store them
                            chanValuesGroup1 = Data{biomID,1};

                            meanGroup1 = nanmean(chanValuesGroup1',1);
                            signalBiomarkers(biomID,:) = meanGroup1;
                        end
                    end
                    biomarkerIndex = AnalysisObj.group{1}.biomarkerIndex;
%                     units = AnalysisObj.group{groups}.units;
                end
            elseif nGroups == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Number of channels
                nChannels = size(NBTstudy.groups{groups(1)}.chanLocs,2);
                
                %%% Generate fixed biomarker list
                AnalysisObjGrp1 = nbt_generateBiomarkerList(NBTstudy,groups(1));
                AnalysisObjGrp2 = nbt_generateBiomarkerList(NBTstudy,groups(2));
                
                %%% Get the data
                DataGroup1 = getData(Group1,AnalysisObjGrp1);
                DataGroup2 = getData(Group2,AnalysisObjGrp2);
                
                %%% Number of biomarkers
                nBioms = DataGroup1.numBiomarkers;
 
                signalBiomarkers = zeros(nBioms,nChannels);
                crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                for biomID = 1 : nBioms
                    biomDataGroup1 = DataGroup1.dataStore{biomID};
                    biomDataGroup2 = DataGroup2.dataStore{biomID};
                    
                    %% Check whether the biomarker is a cross channel biomarker
                    if size(biomDataGroup1{1},2) == nChannels
                        chanValuesGroup1 = zeros(nChannels,nChannels);
                        chanValuesGroup2 = zeros(nChannels,nChannels);

                        %%% nSubjects is minimum of subjects for which the
                        %%% biomarker is computed
                        if size(biomDataGroup1,1) ~= size(biomDataGroup2,1)
                            biomName = AnalysisObjGrp1.group{1}.biomarkers(biomID);
                            subBiomName = AnalysisObjGrp1.group{1}.subBiomarkers(biomID);
                            %error(['The number of subjects differs between the groups for biomarker: ', biomName{1}, '.', subBiomName{1}]);
                            disp('Warning');
                            nSubjects = min(size(biomDataGroup1,1),size(biomDataGroup2,1));
                        else
                            nSubjects = size(biomDataGroup1,1);
                        end
                        
                        %% chan * chan biomarker
                        for subject = 1 : nSubjects
                            chanValuesGroup1 = chanValuesGroup1 + biomDataGroup1{subject};
                            chanValuesGroup2 = chanValuesGroup2 + biomDataGroup2{subject};
                        end
                        
                        crossChannelBiomarkers(:,:,biomID) = (chanValuesGroup2/nSubjects) - (chanValuesGroup1/nSubjects);
                    else
                        %% Get raw biomarker data, compute means and store them
                        chanValuesGroup1 = DataGroup1{biomID,1};
                        chanValuesGroup2 = DataGroup2{biomID,1};
                        
                        signalBiomarkers(biomID,:) = nanmean(chanValuesGroup2',1) - nanmean(chanValuesGroup1',1);
                    end
                end
                biomarkerIndex = AnalysisObjGrp1.group{1}.biomarkerIndex;
%                 units = AnalysisObjGrp1.group{groups(1)}.units;
            else
                error('nbt_Print can not handle more than two groups');
            end
    end
    switch VIZ_LAYOUT
        case 'dflt'
             omega=50;%max amount of defined biomarkers UPDATE from nbt_PrintSort
        case 'cstm'
    end
    switch VIZ_SIG
        case 'all'
            %%% Show all channels
            disp('You chose to show all channels, not running statistics');
            
            significanceMask = zeros(nBioms,nChannels);
        case 'sig'
            %%% We only run statistics if the user wants to show
            %%% significant channels
            
            %%% Run statistics?
            disp('You chose to show significant channels only');
            runStats = input('Run statistics (1) or use statistics from NBTstudy object (2)?');

            if runStats == 1
%                 %%% Run the statistics, will be stored in:
%                 %%% NBTstudy.statAnalysis{end}
% 
                
                statTestList = NBTstudy.getStatisticsTests(0);
                for mm=1:size(statTestList,2)
                    disp([int2str(mm) ':' statTestList{1,mm}])
                end
                statTestIdx = input('Please select test above ');
                S = NBTstudy.getStatisticsTests(statTestIdx);
                                
                S.groups = groups;

                disp('Biomarkers')
                bioms_name = AnalysisObjGrp1.group{1}.originalBiomNames;
                ll=0;
                for mm=1:length(bioms_name)
                    disp([int2str(mm) ':' bioms_name{1,mm} ])
                    ll=ll+1;
                    if(ll ==20)
                        input('More (press enter)');
                        ll = 0;
                    end
                end
                bioms_ind = input('Please select biomarkers above ');
                
                for gp = 1:length(S.groups)
                    for i = 1:length(bioms_ind)
                        [S.group{gp}.biomarkers{i}, S.group{gp}.biomarkerIdentifiers{i}, S.group{gp}.subBiomarkers{i}, S.group{gp}.classes{i}, S.group{gp}.units{i}] = nbt_parseBiomarkerIdentifiers(bioms_name{bioms_ind(i)});
                    end
                end

                if strcmp(class(S),'nbt_lssvm')
                    %cv_type = input('Cross validation: 10-fold or random subsampler? (F/RS)');
                    S.nCrossVals = input('Input the desired number of cross-validations (e.g. 100) ');
                    dimRed = input('Would you like to perform dimensionality reduction first? Y/N ','s');
                    if strcmp(dimRed,'Y')
                        S.dimensionReduction = input('Which kind of dimensionality reduction? PCA/PLS/ICA? ','s');
                    end    
                end

                S = S.calculate(NBTstudy);

                NBTstudy.statAnalysis{length(NBTstudy.statAnalysis)+1} = S;
                disp('Statistics done.')

                
                %%% Get the pValues
                pValues = NBTstudy.statAnalysis{end}.pValues;

                %%% Statistics threshold
                sigThresh = input('Significance threshold? (0.05)');
                
                significanceMask = zeros(nBioms,nChannels);
                %significantChannels = zeros(nBioms,nChannels);
                for biomID = 1 : nBioms
                    if ismember(biomID,bioms_ind)
                        biomIndex = find(ismember(bioms_ind,biomID));
                        if find(pValues(:,biomIndex)' <= sigThresh)
                            significanceMask(biomID,:) = pValues(:,biomIndex)' <= sigThresh;
                        end
                    end
                end
                disp('test')
                
            elseif runStats == 2
%                 %%% Use previously computed statistics
%                 disp('Which statistics object do you want to choose from NBTstudy.statAnalysis?');
%                 selectStats = input('Statistics object: ');
%                 
%                 %%% Get the pValues
%                 pValues = NBTstudy.statAnalysis{selectStats}.pValues;
%                 
%                 %%% Statistics threshold
%                 sigThresh = input('Significance threshold? (0.05)');
% 
%                 %%% Set the significant channels
%                 significanceMask = zeros(nBioms,nChannels);
%                 for biomID = 1 : nBioms
%                     biomIndex = find(ismember(bioms_ind,biomID));
%                     if find(pValues(:,biomIndex)' <= sigThresh)
%                         significanceMask(biomID,:) = pValues(:,biomIndex)' <= sigThresh;
%                     end
%                 end
            end
    end
    
    units = 0;
    
    disp('Specify plot quality:');
    plotQual = input('1: low (fast / analysis), 2: high (slow / print), 3: very high (very slow / final print) ');

    chanChanThreshold = input('Specify chan x chan threshold: ');
        
    %%% Get the channel locations from one of the two groups
    chanLocs = Group1.chanLocs;

    % Set custom names for frequency bands?
    declareFreqBands();
    
    if nBioms < 25
        perPage = nBioms;
    else
        perPage = 25;
    end
    
    %%% Temp nBioms = 50
    nBioms = 50;
    
    %%% Set maximum number of columns on the topoplot, fixed (5) for
    %%% nbt_Print and other NBT visualization tools
    maxColumns = 5;
    nPages=ceil(nBioms/25);
    fgh=[];
    for page = 1 : 1%nPages
        %% Generates a new figure for each page defined by iotta
        switch dataType
            case {'mean' 'raw'}
                if nGroups > 1 % there are two groups
                    fgh(page)=figure('name',['Mean of  ', char(Group2.groupName), '-', char(Group1.groupName)],'NumberTitle','off');
                else
                    fgh(page)=figure('name',['Mean of  ',char(Group1.groupName)],'NumberTitle','off');
                end
        end      
        
        xSize = 27;
        ySize = 19.;
        xLeft = (30-xSize)/2; yTop = (21-ySize)/2;
        set(gcf,'PaperPosition',[xLeft yTop xSize ySize]);
        set(gcf,'Position',[0 0 xSize*50 ySize*50]);
        set(gcf, 'PaperOrientation', 'landscape');
        
        if plotQual == 2
            set(gcf,'Renderer','painters');
            circgrid = 300;
            gridscale = 100;
        elseif plotQual == 3
            set(gcf,'Renderer','painters');
            circgrid = 1000;
            gridscale = 300;
        else
            circgrid = 100;
            gridscale = 32;           
        end
        
        upperBound = page * perPage;
        if upperBound > nBioms
            upperBound = nBioms;
        end
        
        crossChans = [21:25];
        for i = page * perPage - perPage + 1 : upperBound    
            subaxis(6, maxColumns, 6+mod(i-1,25), 'Spacing', 0.03, 'Padding', 0, 'Margin', 0)
            axis off;
            if biomarkerIndex(i) ~= 0
                if i > 35 & i < 51 | ismember(i,crossChans)
                    biomarkerValues = nanmean(crossChannelBiomarkers(:,:,biomarkerIndex(i)),3);
                else
                    biomarkerValues = signalBiomarkers(biomarkerIndex(i),:);
                end
                
                if nGroups == 1
                    Red_cbrewer5colors = load('Red_cbrewer5colors','Red_cbrewer5colors');
                    Red_cbrewer5colors = Red_cbrewer5colors.Red_cbrewer5colors;
                    colormap(Red_cbrewer5colors);

                    cmin = min(biomarkerValues);
                    cmax = max(biomarkerValues);
                else
                    climit = max(abs(biomarkerValues)); %colorbar limit
                    if(length(find(biomarkerValues>=0)) == length(biomarkerValues(~isnan(biomarkerValues))))  % only positive values
                        Red_cbrewer5colors = load('Red_cbrewer5colors','Red_cbrewer5colors');
                        Red_cbrewer5colors = Red_cbrewer5colors.Red_cbrewer5colors;
                        colormap(Red_cbrewer5colors);

                        cmin = 0;
                        cmax = climit;
                    elseif(length(find(biomarkerValues<=0)) == length(biomarkerValues(~isnan(biomarkerValues)))) % only negative values
                        Blue_cbrewer5colors = load('Blue_cbrewer5colors','Blue_cbrewer5colors');
                        Blue_cbrewer5colors = Blue_cbrewer5colors.Blue_cbrewer5colors;
                        colormap(Blue_cbrewer5colors);

                        cmin = -1*climit;
                        cmax = 0;
                    else
                        RedBlue_cbrewer10colors = load('RedBlue_cbrewer10colors','RedBlue_cbrewer10colors');
                        RedBlue_cbrewer10colors = RedBlue_cbrewer10colors.RedBlue_cbrewer10colors;
                        
                        RedBlue_cbrewercolors = [RedBlue_cbrewer10colors(1:3,:); [1 1 1]; RedBlue_cbrewer10colors(8:10,:)];
                                            
                        cmin = -1*climit;
                        cmax = climit;
                        colormap(RedBlue_cbrewercolors);
                    end
                end
                
                figure(fgh(end));
                %%% Plot topoplotConnect for CrossChannelBiomarkers
                if i > 35 & i < 51 | ismember(i,crossChans)
                    nbt_topoplotConnect(NBTstudy,biomarkerValues,chanChanThreshold)
                    nbt_plotColorbar(i, chanChanThreshold, 1, 6, units, maxColumns);
                else
                    %%% Biomarker is not a CrossChannelBiomarker
                    %%% Plot the topoplot for the biomarker
                    nbt_topoplot(biomarkerValues,chanLocs,'headrad','rim','emarker2',{find(significanceMask(biomarkerIndex(i),:)==1),'o','g',4,1},'maplimits',[-3 3],'style','map','numcontour',0,'electrodes','on','circgrid',circgrid,'gridscale',gridscale,'shading','flat');
                    set(gca, 'LooseInset', get(gca,'TightInset'));
                    nbt_plotColorbar(i, cmin, cmax, 6, units, maxColumns);
                end
                
           end
            
            %% PLOTTING FREQUENCY BANDS ABOVE THE TOP ROW
            % omega is the # index of the last pre-defined biomarker
            switch VIZ_LAYOUT
                case 'dflt'
                    if mod(i,25)==1 && i <= omega;
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
                        title (biom{i},'FontSize',10,'interpreter','tex');
                    end
                case 'cstm'
                    title (biom{i},'FontSize',10,'interpreter','tex')
            end
        end
        
        ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        switch dataType
            case 'zscore'
            case {'mean' 'raw'}
                if nGroups > 1 % there are two groups
                    group1 = strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2 = strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.5,0.9,['Average difference between ', group1 ,' and ', group2, ', with reference electrode: ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                else
%                     if ~isempty(G(group_ind).group_difference)
%                      text(0.85,0.9,['Average of ',int2str(length(G(group_ind).fileslist)/2),' subject pairs with ref. electrode ',G(1,1).chansregs.chanloc(1,1).ref],'horizontalalignment','right','FontSize',14,'Interpreter','tex');
%                  else
                     text(0.5,0.9,['Average of ',int2str(Group1.fileList),' subjects with reference electrode: ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
%                     end
                end
        end
        switch dataType
            case {'mean' 'raw'}
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
                    ABSAMP = text(0.02,9/12, 'Absolute Power','horizontalalignment', 'center', 'fontweight','demi');
                    set(ABSAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    RELAMP= text(0.02,7/12, 'Relative Power','horizontalalignment', 'center', 'fontweight','demi');
                    set(RELAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    DFA= text(0.02,5/12, 'Central Frequency','horizontalalignment', 'center', 'fontweight','demi');
                    set(DFA,'rotation',90);
                    get(gcf,'CurrentAxes');
                    CENTRAL= text(0.02,3/12, 'DFA','horizontalalignment', 'center', 'fontweight','demi');
                    set(CENTRAL,'rotation',90);
                    get(gcf,'CurrentAxes');
                    LIFETIME= text(0.02,1/12, 'Phase Locking Index','horizontalalignment', 'center', 'fontweight','demi');
                    set(LIFETIME,'rotation',90);
                elseif page==2;
                    get(gcf,'CurrentAxes');
                    ABSAMP = text(0.02,9/12, 'Bandwidth','horizontalalignment', 'center', 'fontweight','demi');
                    set(ABSAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    RELAMP= text(0.02,7/12, 'Spectral edge','horizontalalignment', 'center', 'fontweight','demi');
                    set(RELAMP,'rotation',90);
                    get(gcf,'CurrentAxes');
                    DFA= text(0.02,5/12, 'Amplitude Correlations','horizontalalignment', 'center', 'fontweight','demi');
                    set(DFA,'rotation',90);
                    get(gcf,'CurrentAxes');
                    CENTRAL= text(0.02,3/12, 'Coherence','horizontalalignment', 'center', 'fontweight','demi');
                    set(CENTRAL,'rotation',90);
                    get(gcf,'CurrentAxes');
                    LIFETIME= text(0.02,1/12, 'Phase Locking Value','horizontalalignment', 'center', 'fontweight','demi');
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

    function runStatsNBTPrint()
        %global NBTstudy;
        
        statTestList = NBTstudy.getStatisticsTests(0);
        for mm=1:size(statTestList,2)
            disp([int2str(mm) ':' statTestList{1,mm}])
        end
        statTestIdx = input('Please select test above ');
        S = NBTstudy.getStatisticsTests(statTestIdx);
        
        S.groups = groups;

        disp('Biomarkers')
        biomarkerList = NBTstudy.groups{1}.biomarkerList(biomarkerIndex ~= 0);

        for group = 1 : length(S.groups)
            for i = 1 : length(biomarkerList)
                i
                [S.group{group}.biomarkers{i}, S.group{group}.biomarkerIdentifiers{i}, S.group{group}.subBiomarkers{i}, S.group{group}.classes{i}, S.group{group}.units{i}] = nbt_parseBiomarkerIdentifiers(biomarkerList{i});
            end
        end
        
        S = S.calculate(S);

        NBTstudy.statAnalysis{length(NBTstudy2.statAnalysis)+1} = S;
        disp('Statistics done.')
    end
end