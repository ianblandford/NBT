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
        
        
        modelVars = cell(1, NCrossVals);
        if(~ClassificationStatObj.statOptions.UseParallel)
            parfor i=1:NCrossVals
                disp(i)
                [FP(i), TP(i), FN(i), TN(i), SE(i), SP(i), PP(i), NN(i), LP(i), LN(i), MM(i), AUC(i), H(i), ACC(i), modelVars{1,i}] = runClassification(DataMatrix,Outcome,ClassificationStatObj);
            end
        else
            for i=1:NCrossVals % also potential parametere!
                disp(i)
                tic
                [FP(i), TP(i), FN(i), TN(i), SE(i), SP(i), PP(i), NN(i), LP(i), LN(i), MM(i), AUC(i), H(i), ACC(i), modelVars{1,i}] = runClassification(DataMatrix,Outcome,ClassificationStatObj);
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
        [ClassificationStatObj] = nbt_TrainClassifier(TrainMatrix,TrainOutcome, ClassificationStatObj);
        
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
        [pp, ClassificationStatObj] = nbt_UseClassifier(TestMatrix, ClassificationStatObj);
        %eval outcome
        [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H_measure] = nbt_evalOutcome(pp, TestOutcome);
        toc
    case 'train'
        % Type Train
        ClassificationStatObj = nbt_TrainClassifier(DataMatrix, Outcome, ClassificationStatObj);
    case 'use'
        % Type Use
        [pp, ClassificationStatObj] = nbt_UseClassifier(DataMatrix, ClassificationStatObj);
        %eval outcome
        [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM] = nbt_evalOutcome(pp, TestOutcome);
    otherwise
        error('The specified Type is not known - Please use either CrossValidate, Validate, Train, or Use')
end

%update s
ClassificationStatObj.outcomeEval.FalsePositive =  FP;
ClassificationStatObj.outcomeEval.TruePositive =  TP;
ClassificationStatObj.outcomeEval.FalseNegative =  FN;
ClassificationStatObj.outcomeEval.TrueNegative =  TN;
ClassificationStatObj.outcomeEval.Sensitivity =  SE;
ClassificationStatObj.outcomeEval.Specificity =  SP;
ClassificationStatObj.outcomeEval.PositivePredictiveValue  =  PP;
ClassificationStatObj.outcomeEval.NegativePredictiveValue =  NN;
ClassificationStatObj.outcomeEval.LikelihoodRatioPos =  LP;
ClassificationStatObj.outcomeEval.LikelihoodRatioNeg  =  LN;
ClassificationStatObj.outcomeEval.MatthewCorr =  MM;
ClassificationStatObj.outcomeEval.AUC=AUC;
ClassificationStatObj.modelVarsStore = modelVars;

%save s s

%                 s.BaselineSE=BaselineSE;
%                 s.BaselineSP=BaselineSP;
%                 s.BaselineAUC=BaselineAUC;
%                 s.ESE=ESE;
%                 s.ESP=ESP;
%                 s.EAUC=EAUC;
%                 s.HAE=HAE;
%                 s.HE=HE;



end

function  [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H, ACC, modelVars] = runClassification(DataMatrix,Outcome,ClassificationStatObj)
[ TrainMatrix,  TestMatrix, TrainOutcome, TestOutcome] = nbt_RandomSubsampler(DataMatrix, Outcome,ClassificationStatObj.subSampleType,ClassificationStatObj.subSampleLimit,ClassificationStatObj.subSampleStratification);
%if ~isstruct(ClassificationStatObj.channels) && length(ClassificationStatObj.channels)>1 % using channels, not regions
[TrainMatrix, BiomsToUse] = nbt_RemoveFeatures(TrainMatrix, TrainOutcome,ClassificationStatObj.removeFeaturesType{1,1}, ClassificationStatObj.channels, ClassificationStatObj.uniqueBiomarkers);

NewTestMatrix = nan(size(TestMatrix,1),size(TrainMatrix,2));
for ii=1:size(TrainMatrix,2)
    NewTestMatrix(:,ii) = nanmedian(TestMatrix(:,BiomsToUse{1,ii}),2);
end
TestMatrix = NewTestMatrix;
clear NewTestMatrix;

if(~isempty(ClassificationStatObj.removeFeaturesType{1,2}))
    [TrainMatrix, BiomsToUse] = nbt_RemoveFeatures(TrainMatrix, TrainOutcome,ClassificationStatObj.removeFeaturesType{1,2}, ClassificationStatObj.channels, ClassificationStatObj.uniqueBiomarkers);
    
    NewTestMatrix = nan(size(TestMatrix,1),size(TrainMatrix,2));
    for ii=1:size(TrainMatrix,2)
        NewTestMatrix(:,ii) = nanmedian(TestMatrix(:,BiomsToUse{1,ii}),2);
    end
    TestMatrix = NewTestMatrix;
    clear NewTestMatrix;
end

%clear NaNs
if(sum(sum(isnan(TrainMatrix))))
    idxNotNaN = find(0==sum(isnan(TrainMatrix)));
    TrainMatrix = TrainMatrix(:,idxNotNaN);
    TestMatrix = TestMatrix(:,idxNotNaN);
end
if(sum(sum(isnan(TestMatrix))))
    idxNotNaN = find(0==sum(isnan(TestMatrix)));
    TrainMatrix = TrainMatrix(:,idxNotNaN);
    TestMatrix = TestMatrix(:,idxNotNaN);
end

%end
if(ClassificationStatObj.balanceClasses)
    [TrainMatrix, TrainOutcome] = nbt_balanceClasses(TrainMatrix, TrainOutcome,0);
end

[ClassificationStatObj] = nbt_TrainClassifier(TrainMatrix,TrainOutcome, ClassificationStatObj);
[pp, ClassificationStatObj ] = nbt_UseClassifier(TestMatrix, ClassificationStatObj);
[FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, AUC, H, ACC] = nbt_evalOutcome(pp, TestOutcome);
modelVars = ClassificationStatObj.modelVars;
end
