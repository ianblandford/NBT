function nbt_plot(ClassificationStatObj)

%% plotting
%first calculate pp for the full matrix
ClassificationStatObj.modelVars = ClassificationStatObj.modelVarsStore{1,1};
[pp] = nbt_UseClassifier(DataMatrix, ClassificationStatObj);
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