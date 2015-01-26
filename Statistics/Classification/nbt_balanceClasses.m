function [DataMatrix, Outcome] = nbt_balanceClasses(DataMatrix, Outcome, TargetClass)
TargetNum = floor(2*length(find(Outcome == TargetClass )));
[Outcome, sortIndex]= sort(Outcome);
DataMatrix = DataMatrix(sortIndex,:);
DataMatrix = DataMatrix(1:TargetNum,:);
Outcome = Outcome(1:TargetNum);
end