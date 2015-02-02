function [ClassificationStatObj]=nbt_Classify(ClassificationStatObj, StudyObj)
%Get data
n_groups = length(ClassificationStatObj.groups);
DataMatrix = [];
Outcome = [];
for j=1:n_groups
    Data_groups{j} = StudyObj.groups{ClassificationStatObj.groups(j)}.getData(ClassificationStatObj);
    DataMatrix = [DataMatrix; Data_groups{j}()];
    Outcome = [Outcome; (j-1).*ones(length(Data_groups{j}.subjectList{1,1}),1)];
end

%following should be removed in later versions and be set before the call
%of nbt_Classify
ClassificationStatObj.nCrossVals = 100;
NCrossVals = ClassificationStatObj.nCrossVals;
ClassificationStatObj.channels = 1:size(Data_groups{1}{1,1},1);
warning('Now just using all channels - .channels should be set properly')
ClassificationStatObj.classificationType = 'crossValidate';
Type = 'crossValidate';
ClassificationStatObj.uniqueBiomarkers = size(Data_groups{1}.biomarkers,2);


% n_group1=size(BCell{1},2); % no of subjects in the first group
% n_group2=size(BCell{2},2); % no of subjects in the second group

% Outcome = [zeros(1,n_group1) ones(1,n_group2)]'; % n x 1

%% Set up parameters && remove NaN biomarkers
% It's possible to treat the NaN's in another way; interpolate them with EM
% algorithms, set them to 0, etc. Now, we remove ...
% the entire biomarker if it contains any missing data.
%[~,Y]=find(isnan(DataMatrix)==1);
%Y=unique(Y);
%DataMatrix=DataMatrix(:,setdiff(1:size(DataMatrix,2),Y));
%DataMatrix(1:92,:) = DataMatrix(1:92,:)-DataMatrix(93:end,:);
%DataMatrix(93:end,:) = -1.*DataMatrix(1:92,:);
%DataMatrix = sign(DataMatrix).*log10(abs(DataMatrix));


% [c, Sample, l] = princomp(DataMatrix);
% tmp=cumsum(l);
% nr = find(tmp/tmp(end)>0.999,1)
% DataMatrix = Sample(:,1:nr);
% ChannelsToUse =[];

ClassificationStatObj.realOutcome = Outcome;
%save DataMatrix DataMatrix %sorry Sonja :(
%save Outcome Outcome  %also not saving s further down


Bioms=NaN(size(DataMatrix,2),NCrossVals);
ClassificationStatObj.modelVars=cell(NCrossVals,1);
%% Divide into Train and test set
switch lower(Type)
    case 'crossvalidate'
        % Type CrossValidate
        disp('Cross validation needs work')
        %   DataMatrix = abs(DataMatrix);
        %   DataMatrix = zscore(DataMatrix);

        
      
     if(ClassificationStatObj.statOptions.UseParallel)
        parfor i=1:NCrossVals
            disp(i)
            [FP(i), TP(i), FN(i), TN(i), SE(i), SP(i), PP(i), NN(i), LP(i), LN(i), MM(i), AUC(i), H(i), ACC(i)] = runClassification(DataMatrix,Outcome,ClassificationStatObj);
        end
     else 
        for i=1:NCrossVals % also potential parametere!
            disp(i)
            tic
            [FP(i), TP(i), FN(i), TN(i), SE(i), SP(i), PP(i), NN(i), LP(i), LN(i), MM(i), AUC(i), H(i), ACC(i)] = runClassification(DataMatrix,Outcome,ClassificationStatObj);
            toc
        end
     end
        disp('CrossValidate:done')
        toc
    case 'validate'
        tic
        % Type Validate
        TestLimit = floor(size(DataMatrix,1)*1/3); %a potential parameter!
        [ TrainMatrix,  TestMatrix, TrainOutcome, TestOutcome] = ...
            nbt_RandomSubsampler( DataMatrix,Outcome,TestLimit,'stratified');
        %We use a stratified sample to preserve the class balance.
        %% Feature selction - we first prune the biomarkers given to the classsification algorithm
        % [TrainMatrix, BiomsToUse] = nbt_RemoveFeatures( TrainMatrix,TrainOutcome,'ttest2',ChannelsToUse, size(BCell{1},3));
        
        
        % call nbt_TrainClassifier
        [s] = nbt_TrainClassifier(TrainMatrix,TrainOutcome, s);
        
        if(size(BiomsToUse,2) ==1 && size(BCell{1},3) ~= 1)
            TestMatrix = TestMatrix(:,BiomsToUse{1,1});
        else
            NewTestMatrix = nan(size(TestMatrix,1),size(BCell{1},3));
            for ii=1:size(BCell{1},3)
                NewTestMatrix(:,ii) = nanmedian(TestMatrix(:,BiomsToUse{1,ii}),2);
            end
            TestMatrix = NewTestMatrix;
            clear NewTestMatrix;
        end
        % call nbt_TestClassifier
        [pp, s] = nbt_UseClassifier(TestMatrix, s);
        %eval outcome
        [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H_measure] = nbt_evalOutcome(pp, TestOutcome);
        toc
    case 'train'
        % Type Train
        s = nbt_TrainClassifier(DataMatrix, Outcome, s);
    case 'use'
        % Type Use
        [pp, s] = nbt_UseClassifier(DataMatrix, s);
        %eval outcome
        [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM] = nbt_evalOutcome(pp, TestOutcome);
    otherwise
        error('The specified Type is not known - Please use either CrossValidate, Validate, Train, or Use')
end

%update s
s.outcomeEval.FalsePositive =  FP;
s.outcomeEval.TruePositive =  TP;
s.outcomeEval.FalseNegative =  FN;
s.outcomeEval.TrueNegative =  TN;
s.outcomeEval.Sensitivity =  SE;
s.outcomeEval.Specificity =  SP;
s.outcomeEval.PositivePredictiveValue  =  PP;
s.outcomeEval.NegativePredictiveValue =  NN;
s.outcomeEval.LikelihoodRatioPos =  LP;
s.outcomeEval.LikelihoodRatioNeg  =  LN;
s.outcomeEval.MatthewCorr =  MM;
s.outcomeEval.AUC=AUC;


%save s s

%                 s.BaselineSE=BaselineSE;
%                 s.BaselineSP=BaselineSP;
%                 s.BaselineAUC=BaselineAUC;
%                 s.ESE=ESE;
%                 s.ESP=ESP;
%                 s.EAUC=EAUC;
%                 s.HAE=HAE;
%                 s.HE=HE;

%% plotting
%first calculate pp for the full matrix
[pp] = nbt_UseClassifier(DataMatrix, s);
% make pp values for each group
pp1 = pp(Outcome == 0);
pp2 = pp(Outcome == 1);
% DataMatrix = zscore(DataMatrix)';
DataMatrix = DataMatrix';
DataReal1 = DataMatrix(:, Outcome == 0);
DataReal2 = DataMatrix(:, Outcome == 1);
DataPred1 = DataMatrix(:, pp < 0.5);
DataPred2 = DataMatrix(:, pp >= 0.5);

figure('Name','Classification performance')

% plot dot plot of pp values for the full Data matrix
nbt_DotPlot(subplot(2,4,1),0.1,0.025,0,@median,{'Group 1';'Group 2'; 'Probability'},'',pp1',1:length(pp1),1,pp2',1:length(pp2),1);
set(gca,'YLim',[0 1])
% plot dot plot of Data values - real and classified
%first real
nbt_DotPlot(subplot(2,4,2),0.1,0.025,0,@median,{'Group 1';'Group 2'; 'Biomarker values'},'',DataReal1,1:size(DataReal1,2),1:size(DataReal1,1),DataReal2,1:size(DataReal2,2),1:size(DataReal2,1));
% then predicted
nbt_DotPlot(subplot(2,4,3),0.1,0.025,0,@median,{'Group 1';'Group 2'; 'Predicted groups: Biomarker values'},'',DataPred1,1:size(DataPred1,2),1:size(DataPred1,1),DataPred2,1:size(DataPred2,2),1:size(DataPred2,1));
% Plot ROC
subplot(2,4,4)
[FPR,TPR] = perfcurve(Outcome,pp,1);
plot(FPR,TPR)
xlabel('False positive rate'); ylabel('True positive rate')
title('ROC')

subplot(2,4,5)
boxplot(accuracy/100)
set(gca,'YLim',[0.5 1])
title('Accuracy')

subplot(2,4,6)
boxplot(SE)
set(gca,'YLim',[0.5 1])
title('Sensitivity (SE)')

subplot(2,4,7)
boxplot(SP)
set(gca,'YLim',[0.5 1])
title('Specificity (SP)')

subplot(2,4,8)
boxplot(PP)
set(gca,'YLim',[0.5 1])
title('Precision (PP)')




end

function  [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H, ACC] = runClassification(DataMatrix,Outcome,ClassificationStatObj)
[ TrainMatrix,  TestMatrix, TrainOutcome, TestOutcome] = nbt_RandomSubsampler(DataMatrix, Outcome,ClassificationStatObj.subSampleType,ClassificationStatObj.subSampleLimit,ClassificationStatObj.subSampleStratification);
%if ~isstruct(ClassificationStatObj.channels) && length(ClassificationStatObj.channels)>1 % using channels, not regions
    [TrainMatrix, BiomsToUse] = nbt_RemoveFeatures(TrainMatrix, TrainOutcome,ClassificationStatObj.removeFeaturesType, ClassificationStatObj.channels, ClassificationStatObj.uniqueBiomarkers);

        NewTestMatrix = nan(size(TestMatrix,1),size(TrainMatrix,2));
        for ii=1:size(TrainMatrix,2)
            NewTestMatrix(:,ii) = nanmedian(TestMatrix(:,BiomsToUse{1,ii}),2);
        end
        TestMatrix = NewTestMatrix;
        clear NewTestMatrix;
  
%end

[TrainMatrix, TrainOutcome] = nbt_balanceClasses(TrainMatrix, TrainOutcome,0);


[ClassificationStatObj] = nbt_TrainClassifier(TrainMatrix,TrainOutcome, ClassificationStatObj);
[pp, ClassificationStatObj ] = nbt_UseClassifier(TestMatrix, ClassificationStatObj);
[FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H, ACC] = nbt_evalOutcome(pp, TestOutcome);
end
