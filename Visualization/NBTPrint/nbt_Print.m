    function nbt_Print(NBTstudy,groups)
    %%% Check whether the input is valid
    checkInput();
    
    %%% Number of groups
    nGroups = size(groups,2);
    
    %%% Select Signal
    signal = input('For which signal do you want to plot the biomarkers? (Example: Signal, ICASignal, CSDSignal) ','s');
    
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
                
                %%% Check whether the group is a difference group
                if ~isempty(Group1.groupType)
                    
                else
                    %%% Generate fixed biomarker list
                    AnalysisObj = nbt_generateBiomarkerList(NBTstudy,signal,groups);
                    
                    %%% Get the data
                    DataObj = getData(Group1,AnalysisObj);

                    %%% Number of channels
                    nChannels = size(DataObj{1,1},1);
                
                    %%% Number of subjects
                    nSubjects = size(DataObj{1,1},2);
                    
                    %%% Number of biomarkers
                    nBioms = DataObj.numBiomarkers;
                    
                    %%% Get subject number from the command line
                    subjectNumber = input('Specify the number of the subject');

                    signalBiomarkers = zeros(nBioms,nChannels);
                    crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                    for biomID = 1 : nBioms
                        biomDataGroup1 = DataObj.dataStore{biomID};
                        if size(biomDataGroup1{1},2) == nChannels
                            %% chan * chan biomarker
                            crossChannelBiomarkers(:,:,biomID) = biomDataGroup1{subjectNumber};
                        else
                            %% Get raw biomarker data, compute means and store them
                            signalBiomarkers(biomID,:) = DataObj{biomID,1};
                        end
                    end
                    biomarkerIndex = AnalysisObj.group{1}.biomarkerIndex;
                    units = AnalysisObj.group{1}.units;
                end
            elseif nGroups == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Generate fixed biomarker list
                AnalysisObjGrp1 = nbt_generateBiomarkerList(NBTstudy,signal,groups(1));
                AnalysisObjGrp2 = nbt_generateBiomarkerList(NBTstudy,signal,groups(2));
                
                %%% Get the data
                DataObjGrp1 = getData(Group1,AnalysisObjGrp1);
                DataObjGrp2 = getData(Group2,AnalysisObjGrp2);
                
                %%% Number of channels
                nChannels = size(DataObjGrp1{1,1},1);
                
                %%% Number of subjects
                nSubjects = size(DataObjGrp1{1,1},2);
                    
                %%% Number of biomarkers
                nBioms = DataObjGrp1.numBiomarkers;
                
                %%% Get subject number from the command line
                subjectNumber = input('Specify the number of the subject');
 
                signalBiomarkers = zeros(nBioms,nChannels);
                crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                for biomID = 1 : nBioms
                    biomDataGroup1 = DataObjGrp1.dataStore{biomID};
                    biomDataGroup2 = DataObjGrp2.dataStore{biomID};
                    
                    %% Check whether the biomarker is a cross channel biomarker
                    if size(biomDataGroup1{1},2) == nChannels
                        %% chan * chan biomarker
                        crossChannelBiomarkers(:,:,biomID) = biomDataGroup2{subjectNumber} - biomDataGroup1{subjectNumber};
                    else
                        %% Get raw biomarker data, and store them
                        signalBiomarkers(biomID,:) = DataObjGrp2{biomID,1} - DataObjGrp1{biomID,1};
                    end
                end
                biomarkerIndex = AnalysisObjGrp1.group{1}.biomarkerIndex;
                units = AnalysisObjGrp1.group{groups(1)}.units;
            else
                error('nbt_Print can not handle more than two groups');
            end            
        case 'mean'
            disp('Computing means');
            if nGroups == 1    
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups};
                
                %%% Check whether the group is a difference group
                if ~isempty(Group1.groupType)
                    
                else
                    %%% Generate fixed biomarker list
                    AnalysisObj = nbt_generateBiomarkerList(NBTstudy,signal,groups);

                    %%% Get the data
                    DataObj = getData(Group1,AnalysisObj);
                    
                    %%% Number of channels
                    nChannels = size(DataObj{1,1},1);
                
                    %%% Number of subjects
                    nSubjects = size(DataObj{1,1},2);
                    
                    %%% Number of biomarkers
                    nBioms = DataObj.numBiomarkers;

                    signalBiomarkers = zeros(nBioms,nChannels);
                    crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                    for biomID = 1 : nBioms
                        biomID
                        biomDataGroup1 = DataObj.dataStore{biomID};
                        if size(biomDataGroup1{1},2) == nChannels
                            chanValues = zeros(nChannels,nChannels);
                            for subject = 1 : size(biomDataGroup1,1)
                                chanValues = chanValues + biomDataGroup1{subject};
                            end
                            
                            %% chan * chan biomarker
                            crossChannelBiomarkers(:,:,biomID) = chanValues / size(biomDataGroup1,1);
                        else
                            %% Get raw biomarker data, compute means and store them
                            chanValuesGroup1 = DataObj{biomID,1};

                            meanGroup1 = nanmean(chanValuesGroup1',1);
                            signalBiomarkers(biomID,:) = meanGroup1;
                        end
                    end
                    biomarkerIndex = AnalysisObj.group{1}.biomarkerIndex;
                    units = AnalysisObj.group{1}.units;
                end
            elseif nGroups == 2
                %%% Get groups NBTstudy
                Group1 = NBTstudy.groups{groups(1)};
                Group2 = NBTstudy.groups{groups(2)};
                
                %%% Generate fixed biomarker list
                AnalysisObjGrp1 = nbt_generateBiomarkerList(NBTstudy,signal,groups(1));
                AnalysisObjGrp2 = nbt_generateBiomarkerList(NBTstudy,signal,groups(2));
                
                %%% Get the data
                DataObjGrp1 = getData(Group1,AnalysisObjGrp1);
                DataObjGrp2 = getData(Group2,AnalysisObjGrp2);
                
                %%% Number of channels
                nChannels = size(DataObjGrp1{1,1},1);
                
                %%% Number of subjects
                nSubjects = size(DataObjGrp1{1,1},2);
                
                %%% Number of biomarkers
                nBioms = DataObjGrp1.numBiomarkers;
 
                signalBiomarkers = zeros(nBioms,nChannels);
                crossChannelBiomarkers = zeros(nChannels,nChannels,nBioms);
                for biomID = 1 : nBioms
                    biomDataGroup1 = DataObjGrp1.dataStore{biomID};
                    biomDataGroup2 = DataObjGrp2.dataStore{biomID};
                    
                    %% Check whether the biomarker is a cross channel biomarker
                    if size(biomDataGroup1{1},2) == nChannels
                        chanValuesGroup1 = zeros(nChannels,nChannels);
                        chanValuesGroup2 = zeros(nChannels,nChannels);

                        %%% nSubjects is minimum of subjects for which the
                        %%% biomarker is computed
                        if size(biomDataGroup1,1) ~= size(biomDataGroup2,1)
                            biomName = AnalysisObjGrp1.group{1}.biomarkers(biomID);
                            subBiomName = AnalysisObjGrp1.group{1}.subBiomarkers(biomID);
                            error(['The number of subjects differs between the groups for biomarker: ', biomName{1}, '.', subBiomName{1}]);
                            %disp('Warning');
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
                        chanValuesGroup1 = DataObjGrp1{biomID,1};
                        chanValuesGroup2 = DataObjGrp2{biomID,1};
                        
                        signalBiomarkers(biomID,:) = nanmean(chanValuesGroup2',1) - nanmean(chanValuesGroup1',1);
                    end
                end
                biomarkerIndex = AnalysisObjGrp1.group{1}.biomarkerIndex;
                units = AnalysisObjGrp1.group{groups(1)}.units;
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
            
            %%% No statistics, no significance mask or threshold
            significanceMask = cell(nBioms,nChannels);
            sigThresh = 0;
        case 'sig'
            %%% We only run statistics if the user wants to show
            %%% significant channels
            
            %%% Run statistics?
            disp('You chose to show significant channels only');
            runStats = input('Run statistics (1) or use statistics from NBTstudy object (2)?');

            if runStats == 1
%                 %%% Run the statistics, will be stored in:
%                 %%% NBTstudy.statAnalysis{end}
                statTestList = NBTstudy.getStatisticsTests(0);
                for mm=1:size(statTestList,2)
                    disp([int2str(mm) ':' statTestList{1,mm}])
                end
                statTestIdx = input('Please select test above ');
                S = NBTstudy.getStatisticsTests(statTestIdx);
                                
                S.groups = groups;

%                 disp('Biomarkers')
                bioms_name = AnalysisObjGrp1.group{1}.originalBiomNames;
%                 ll=0;
%                 for mm=1:length(bioms_name)
%                     disp([int2str(mm) ':' bioms_name{1,mm} ])
%                     ll=ll+1;
%                     if(ll ==20)
%                         input('More (press enter)');
%                         ll = 0;
%                     end
%                 end
%                 bioms_ind = input('Please select biomarkers above ');
                %%% Compute the statistics for all biomarkers
                bioms_ind = 1:nBioms;
                
                for gp = 1:length(S.groups)
                    for i = 1:length(bioms_ind)
                        [S.group{gp}.biomarkers{i}, S.group{gp}.biomarkerIdentifiers{i}, S.group{gp}.subBiomarkers{i}, S.group{gp}.classes{i}, S.group{gp}.units{i}] = nbt_parseBiomarkerIdentifiers(bioms_name{bioms_ind(i)});
                    end
                end
                
%                 S.data{1} = DataObjGrp1;
%                 S.data{2} = DataObjGrp2;

                
                %%% As soon as the statistics function can differentiate
                %%% between the different types of biomarkers the code
                %%% below can be uncommented
%                 S.group{1} = AnalysisObjGrp1.group{1};
%                 S.group{2} = AnalysisObjGrp2.group{2};
                

%                 S.group{1}.biomarkers = AnalysisObjGrp1.group{1}.biomarkers;
%                 S.group{1}.biomarkerIdentifiers = AnalysisObjGrp1.group{1}.biomarkerIdentifiers;
%                 S.group{1}.subBiomarkers = AnalysisObjGrp1.group{1}.subBiomarkers;
%                 S.group{1}.units = AnalysisObjGrp1.group{1}.units;
%                 S.group{1}.classes = AnalysisObjGrp1.group{1}.classes;
%                 
%                 S.group{2}.biomarkers = AnalysisObjGrp2.group{1}.biomarkers;
%                 S.group{2}.biomarkerIdentifiers = AnalysisObjGrp2.group{1}.biomarkerIdentifiers;
%                 S.group{2}.subBiomarkers = AnalysisObjGrp2.group{1}.subBiomarkers;
%                 S.group{2}.units = AnalysisObjGrp2.group{1}.units;
%                 S.group{2}.classes = AnalysisObjGrp2.group{1}.classes;

                S = S.calculate(NBTstudy);

                NBTstudy.statAnalysis{length(NBTstudy.statAnalysis)+1} = S;
                
                %%% Get the pValues
                pValues = NBTstudy.statAnalysis{end}.pValues;
                
                %%% Multiple comparisons
                multiComp = input('Correct for multiple comparisons? (no / fdr / bonfi / holm) ','s');
                
                if strcmp(multiComp,'fdr')
                    q = input('Specify the desired false discovery rate: (default = 0.05) ');
                end
                
                for biomID = 1 : nBioms
                    if ismember(biomID,bioms_ind)
                        biomIndex = find(ismember(bioms_ind,biomID));
                        if strcmp(multiComp,'fdr')
                            [significanceMask{biomID}, ~] = nbt_MCcorrect(pValues{biomID},multiComp,q);
                        else
                            [significanceMask{biomID}, ~] = nbt_MCcorrect(pValues{biomID},multiComp);
                        end
                    end
                end
                
                %%% Change the string for fdr
                if strcmp(multiComp,'fdr')
                    multiComp = ['fdr(', num2str(q), ')'];
                end
                
                %%% Adjust the string for fdr for plotting
%                 if strcomp(multiComp,'fdr')
%                     multiComp = [multiComp '(' 
                
                disp('Statistics done.')
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
    
    disp('Specify plot quality:');
    plotQual = input('1: low (fast / analysis), 2: high (slow / print), 3: very high (very slow / final print) ');

    chanChanThreshold = input('Specify chan x chan threshold: ');
        
    %%% Get the channel locations from one of the two groups
    chanLocs = Group1.chanLocs;
    chanLocs = verifyChanLocs(chanLocs);
    
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
            %% SECTION TITLE
            % DESCRIPTIVE TEXT
            
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
                cbType = '';
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
                        cbType = 'diff';
                    end
                end
                
                figure(fgh(end));
                %%% Plot topoplotConnect for CrossChannelBiomarkers
                if i > 35 & i < 51 | ismember(i,crossChans)
                    nbt_topoplotConnect(NBTstudy,biomarkerValues,chanChanThreshold)
                    nbt_plotColorbar(i, chanChanThreshold, 1, 6, units, maxColumns, 'normal');
                else
                    %%% Biomarker is not a CrossChannelBiomarker
                    %%% Plot the topoplot for the biomarker
                    nbt_topoplot(biomarkerValues,chanLocs,'headrad','rim','emarker2',{find(significanceMask{biomarkerIndex(i)}==1),'o','g',4,1},'maplimits',[-3 3],'style','map','numcontour',0,'electrodes','on','circgrid',circgrid,'gridscale',gridscale,'shading','flat');
                    set(gca, 'LooseInset', get(gca,'TightInset'));
                    nbt_plotColorbar(i, cmin, cmax, 6, units, maxColumns, cbType);
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
                if nGroups == 2 % there are two groups
                    group1 = strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2 = strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.5,0.93,['Average difference between ', group1 ,' and ', group2, ' ({\itn} = ', num2str(nSubjects),'), reference electrode: ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                    try
                        text(0.5,0.90,['Multiple comparisons: ', multiComp],'horizontalalignment','center','FontSize',12,'Interpreter','tex');
                    catch
                    end
                else
                    text(0.5,0.93,['Average of ',int2str(Group1.fileList),' subjects ({\itn} = ', num2str(nSubjects) ,'), reference electrode: ',chanLocs(1).ref],'horizontalalignment','center','FontSize',14,'Interpreter','tex');
                end
        end
        switch dataType
            case {'mean' 'raw'}
                if nGroups>1 % there are two groups
                    group1=strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                    group2=strtrim(regexprep(Group2.groupName,'Group \d : ',''));
                    text(0.5, 0.99,strcat('NBT print for groups ',{' '}, group1 ,' and ',{' '}, group2),'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',22,'Interpreter','tex');
                else
                    group_name=strtrim(regexprep(Group1.groupName,'Group \d : ',''));
                text(0.5, 0.99,strcat('NBT print for group ',{' '},group_name),'HorizontalAlignment','center','VerticalAlignment', 'top','FontSize',22,'Interpreter','tex');
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
                    LIFETIME= text(0.02,1/12, 'Phase Lag Index','horizontalalignment', 'center', 'fontweight','demi');
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

    function chanLocs = verifyChanLocs(chanLocs)
        if isempty(chanLocs(1).ref)
            disp('No reference electrode is specified, assuming average');
            for channel = 1 : size(chanLocs,2)
                chanLocs(channel).ref = 'average';
            end
        end
    end
end