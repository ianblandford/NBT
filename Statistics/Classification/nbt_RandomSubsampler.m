function [ TrainMatrix,  TestMatrix, TrainOutcome, TestOutcome, idxTrain, idxTest] = nbt_RandomSubsampler( DataMatrix,Outcome,PartitionType,PLimit,SamplingType )
switch lower(SamplingType)
    case 'simple'
        switch lower(PartitionType)
            case 'holdout'
                try
                    c = cvpartition(length(Outcome),'Holdout',PLimit);
                    idxTrain = find(c.training);
                    idxTest  = find(c.test);
                    TrainMatrix = DataMatrix(idxTrain,:);
                    TestMatrix  = DataMatrix(idxTest,:);
                    TrainOutcome = Outcome(idxTrain,:);
                    TestOutcome  = Outcome(idxTest,:);
                catch
                    RandSubj = randperm(length(Outcome)); %we make a random permutation of our subjects.
                    TrainMatrix = DataMatrix(RandSubj(PLimit+1:end),:);
                    TestMatrix =  DataMatrix(RandSubj(1:PLimit),:);
                    TrainOutcome = Outcome(RandSubj(PLimit+1:end));
                    TestOutcome = Outcome(RandSubj(1:PLimit));
                    return;
                end
            case 'kfold'
                c = cvpartition(length(Outcome),'KFold',PLimit);
                %we only output idxTrain and idxTest
                for m=1:PLimit
                    idxTrain{m,1} = find(c.training(m));
                    idxTest{m,1}  = find(c.test(m));
                end
                TrainMatrix  = [];
                TestMatrix   = [];
                TrainOutcome = [];
                TestOutcome  = [];
        end
        
    case 'stratified' %preserves class balance in training and test sets
        % For more details see Witten, Frank & Hall "Data Mining" page 152
        switch lower(PartitionType)
            case 'holdout'
                try
                    c = cvpartition(Outcome,'Holdout',PLimit);
                    idxTrain = find(c.training);
                    idxTest  = find(c.test);
                    TrainMatrix = DataMatrix(idxTrain,:);
                    TestMatrix  = DataMatrix(idxTest,:);
                    TrainOutcome = Outcome(idxTrain,:);
                    TestOutcome  = Outcome(idxTest,:);
                catch
                    TestMatrix=[];
                    TestOutcome=[];
                    TrainMatrix=[];
                    TrainOutcome=[];
                    ClassIds=unique(Outcome);
                    for iotta=1:numel(ClassIds)
                        ClassIndexes{iotta}=find(Outcome==ClassIds(iotta));
                        ClassIndexes{iotta}=ClassIndexes{iotta}(randperm(length(ClassIndexes{iotta})));
                        ClassFreq(iotta)=sum(Outcome==ClassIds(iotta))/numel(Outcome);
                        TrainMatrix=[TrainMatrix;DataMatrix(ClassIndexes{iotta}(floor(PLimit*ClassFreq(iotta))+1:end),:)];
                        TrainOutcome=[TrainOutcome;Outcome(ClassIndexes{iotta}(floor(PLimit*ClassFreq(iotta))+1:end))];
                        TestMatrix=[TestMatrix;DataMatrix(ClassIndexes{iotta}(1:floor(PLimit*ClassFreq(iotta))),:)];
                        TestOutcome=[TestOutcome;Outcome(ClassIndexes{iotta}(1:floor(PLimit*ClassFreq(iotta))))];
                    end
                end
            case 'kfold'
                c = cvpartition(Outcome,'KFold',PLimit);
                %we only output idxTrain and idxTest
                for m=1:PLimit
                    idxTrain{m,1} = find(c.training(m));
                    idxTest{m,1}  = find(c.test(m));
                end
                TrainMatrix  = [];
                TestMatrix   = [];
                TrainOutcome = [];
                TestOutcome  = [];
        end
end

