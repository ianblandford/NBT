function [SE, SP,LP,MM,gSE,gSP,gLP,gMM]=nbt_glmnetfit(NBTelementBase,DiffMapIn, GroupElement)

load(NBTelementBase)
%Experimental genetic search
Groups = [2 3];

%First find ECR2 members in DiffMapCondition
MapIndex = [];
DiffMap = DiffMapIn.Map;
for i=1:length(DiffMap)
    [Type Token] = strtok(DiffMap{i,1},':');
    [NBTelementName Token] = strtok(Token, ':');
    [Frequency Token] = strtok(Token, ':');
    [ConditionID Token] = strtok(Token, ':');
    [Groupp Token] = strtok(Token, ':');
    Groupp = nbt_str2double(Groupp);
    if(strcmp(ConditionID,'ECR2'))
        if((Groupp(1) ~= Groups(1) || Groupp(2) ~= Groups(2)))
            continue
        end
        MapIndex = [ MapIndex i];
    end
end

%exclude biomarkers:
%MapIndex = nbt_negSearchVector(MapIndex,[1:157 159:401 403:638 2142:2150]);
MapIndex = sort([2040
         402
        1599
        1607
        1914
        2041
        1575
         706
        1574
        1915
        2079
        2134
         650
         705
        1577
        1584
        1594
        1850
        2135
        1606
        1609
        1851
        1588
        1598
        1608
        1583
        1593
        1601
        1602
        1604
        1852
        1853
        1585
        1595
        1581
        1591
        1906
         649
         673
        1582
        1587
        1592
        1597
        1603
        1605
        1576
        1816
        1600
        1580
        1590
         158
        1579
        1586
        1589
        1596
         704
        1578
        1817
        2078
        1950]);
 MapIndex = nbt_negSearchVector(MapIndex,[1:157 159:401 403:638 2142:2150]);   
  



NBTelementList = nbt_ExtractObject('nbt_NBTelement');


% Define groups
eval(['Group = ' GroupElement ';' ])
GroupS = unique(Group.Data);
NumGroups = length(GroupS);
GroupCell = cell(NumGroups,1);
for GId = 1:NumGroups
    eval(['dataString = ''find(NBTelement.Data ==' int2str(GroupS(GId)) ')'';']);
    [GroupCell{GId,1}, Pool, PoolKey] = nbt_GetData(Subject, {Group, dataString}) ;
end

GlobalSubjList = Subject.Data;

w = nan(length(GlobalSubjList),length(MapIndex));

Mii = 0;
for Mi = 1:length(MapIndex)
   % disp(Mi)
    DiffMap = DiffMapIn.Map{MapIndex(Mi),1};
    Pvalues = DiffMapIn.Map{MapIndex(Mi),2};
    %% decode DiffMap
    % C:NBTelementName:Frequency:Condition:Group1 Group2:Pool %
    
    [Type Token] = strtok(DiffMap,':');
    if(strcmp(Type,'C'))
        [NBTelementName Token] = strtok(Token, ':');
        [Frequency Token] = strtok(Token, ':');
        [ConditionID Token] = strtok(Token, ':');
        [Groupp Token] = strtok(Token, ':');
        Groupp = nbt_str2double(Groupp);
        
    
            Mii = Mii + 1;
            MiiIndex(Mii) = MapIndex(Mi);
     
        
        Token = strtok(Token, ':');
        
        eval(['biomarker =' NBTelementName ';']);
        
        
        %Get data matrix
        if (biomarker.Uplink == 1)
            [Data, Pool, PoolKey]  = nbt_GetData(biomarker, {Subject,[]});
        elseif (biomarker.Uplink ==2)
            [Data, Pool,PoolKey] = nbt_GetData(biomarker, {Condition, ConditionID; Subject, []});
        else
            frqID = nbt_searchvector(FrequencyBand.Data, {Frequency});
            [Data, Pool,PoolKey] = nbt_GetData(biomarker, {FrequencyBand,FrequencyBand.Data{1,frqID};Condition, ConditionID; Subject, []});
        end
        SubjList = nbt_returnData(Subject,Pool,PoolKey);
        
        %Match subject list to Groups
        GId1 = find(GroupS == Groupp(1));
        GId2 = find(GroupS == Groupp(2));
        %GId3 = find(GroupS == CrossValGroup);
        SubjIndex1 = nbt_searchvector(SubjList, GroupCell{GId1,1});
        SubjIndex3 = find(SubjList);
        SubjIndex2 = nbt_searchvector(SubjList, GroupCell{GId2,1});
        SubjIndex3 = nbt_negSearchVector(SubjIndex3, SubjIndex2);
        %SubjIndex3 = nbt_searchvector(SubjList, GroupCell{GId3,1});
      
        %index to GlobalSubject list
       TransferIndex = nbt_searchvector(GlobalSubjList, SubjList);
       tSubjIndex1 = TransferIndex(SubjIndex1);
       tSubjIndex2 = TransferIndex(SubjIndex2);
       tSubjIndex3 = TransferIndex(SubjIndex3);
        
        %decode BiomarkerPool
        
        [A Token] = strtok(Token, '/');
        if(isempty(Token))
            BiomarkerName = [NBTelementName(5:end)];
            
        else
            [B, Token] = strtok(Token, '/');
            A=str2double(A);
            B=str2double(B);
            
            if(isnan(B))
                for SubID = 1:size(Data,2)
                    tmp(:,SubID) = Data{A,SubID};
                end
                try
                    BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{A,1}];
                catch
                    BiomarkerName = [NBTelementName(5:end)];
                end
            else
                C = strtok(Token, '/');
                C=str2double(C);
                if(isnan(C))
                    for SubID=1:size(Data,2)
                        DD = Data{B,SubID};
                        try
                            tmp(:,SubID) = DD{A,1};
                        catch
                            try
                            tmp(:,SubID) = nan(size(tmp,1),1);
                            catch
                                tmp(:,SubID) = nan(1,1);
                            end
                        end
                    end
                    try
                        BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{B,1}];
                    catch
                        BiomarkerName = [NBTelementName(5:end)];
                    end
                else
                    for SubID=1:size(Data,2)
                        DD = Data{C,SubID};
                        DD = DD{B,1};
                        try
                            tmp(:,SubID) = DD{A,1};
                        catch
                            try
                            tmp(:,SubID) = nan(size(tmp,1),1);
                            catch
                                tmp(:,SubID) = nan(1,1);
                            end
                        end
                    end
                    try
                        BiomarkerName = [NBTelementName(5:end) '  ' biomarker.Biomarkers{C,1}];
                    catch
                        BiomarkerName = [NBTelementName(5:end)];
                    end
                end
            end
            Data = tmp;
            clear tmp
        end
    end
    
    if(isempty(Pvalues))
        Pvalues = ones(size(Data,1),1);
        SigIndex = 1:size(Data,1);
    else
        SigIndex = find(Pvalues < 0.05);
    end
    if(length(SigIndex) > 1)
       w([tSubjIndex1 tSubjIndex2],Mii) = nanmedian(Data(SigIndex,[SubjIndex1 SubjIndex2]))';
       wcv(tSubjIndex3,Mii) = nanmedian(Data(SigIndex,SubjIndex3))';
    else
        w([tSubjIndex1 tSubjIndex2],Mii) = (Data(SigIndex,[SubjIndex1 SubjIndex2]))';
        wcv(tSubjIndex3,Mii) = Data(SigIndex,SubjIndex3)';
    end
end


%global index
gSubjIndex3 = find(GlobalSubjList);
        gSubjIndex1 = nbt_searchvector(GlobalSubjList, GroupCell{GId1,1});
        gSubjIndex2 = nbt_searchvector(GlobalSubjList, GroupCell{GId2,1});
       gSubjIndex3 = nbt_negSearchVector(gSubjIndex3, SubjIndex2);
       % gSubjIndex3 = nbt_searchvector(GlobalSubjList, GroupCell{GId3,1});
        
        %% limited training
        
        

outcome = [zeros(length(gSubjIndex1),1);ones(length(gSubjIndex2),1)];

w = w([gSubjIndex1 gSubjIndex2],:);

% exp replace nan
%  for t = 1: size(w,2)
%     if(any(isnan(w(:,t))))
%         nanSize = sum(isnan(w(:,t)));
%         w(isnan(w(:,t)),t) = nanmedian(w(:,t)) + nanstd(w(:,t))*randn(nanSize,1);
%     end
%  end

% remove Nan
% for t = 1:size(w,2)
%     if(any(isnan(w(:,t))))
%         outcome = outcome(~isnan(w(:,t)));
%         w = w(~isnan(w(:,t)),:) ;
%     end
% end


% % % exp zscore
%    for t=1:size(w,2)
%     w(~isnan(w(:,t)),t) = zscore(w(~isnan(w(:,t)),t));
%    end
% 
%  
% %% Exp bootstrap
% wt = w;
% outcomet = outcome;
% 
% for mm=1:50
%     indx = randperm(size(wt,1));
%     w(mm,:) = randn(1,1) + wt(indx(1),:);
%     outcome(mm) = outcomet(indx(1));
% end




% 
% [c, wt, l] = princomp(w);
% 
% clear w
% for iu =1:1
%     w(:,iu) = wt(:,iu);
% end

disp('break')
%% glm
% remove nans
ii =1;
RemovedSubjects=[];
for i=1:size(w,1)
   if(~isnan(nanmedian(w(i,:))))
      outcome2(ii) = outcome(i);
      w2(ii,:) = w(i,:);
      ii= ii+1;
   else
       RemovedSubjects = [RemovedSubjects i];
   end
end
SubList = [gSubjIndex1 gSubjIndex2];
RemovedSubjects = SubList(RemovedSubjects);
ii=1;
for i=1:size(w2,2)
   if(~isnan(sum(w2(:,i))))
      w3(:,ii) = w2(:,i);
      MapIndex2(ii) = MapIndex(i);
      ii = ii+1;
   end
end
%w3(:,end+1) = w2(:,54); including Tau
w2 = w3;
clear w3;

 %MapIndex2 = [MapIndex2 54];


%testing SVM
[pp,alpha,b,gam,sig2,model] = lssvm(w2,outcome2','c');
% [gam, sig2] = bay_initlssvm({w2,outcome2','c',gam,sig2,'RBF_kernel'})
% [model, gam] = bay_optimize({w2,outcome2','c',gam,sig2,'RBF_kernel'},2)
% [cost, sig2] = bay_optimize({w2,outcome2','c',gam,sig2,'RBF_kernel'},3)
% model = trainlssvm({w2,outcome2','c',gam,sig2}); 
[pp, SE, SP, PP, LP, MM, SEa, SPa, PPa, LPa, MMa,w1,outcome1,wt,outcomet]=nbt_UseLSSVMDiffMap(NBTelementBase,GroupElement,DiffMapIn, MapIndex2, model, Groups,'ECR1', RemovedSubjects);
%svm crossvalidate
disp('break')

% CV - 5 fold prediction with optimization on ECR1
%CVerr=cvglmnet(w2,outcome2',5,[],'response','binomial',glmnetSet,1);

gg= glmnetSet;


   outcome2 = outcome2+1;
    gg.alpha = 0.8;
    topfit = glmnet(w2,outcome2','binomial',gg);

    pp = glmnetPredict(topfit,'response', w1);
    
    [FP, TP, FN, TN, gSE, gSP, gPP, NN, gLP, LN, gMM]=nbt_evalOutcome(pp(:,80), outcome1);



  
disp('break');
%issues:
%- remove biomarker if just one nan value?
% 

end