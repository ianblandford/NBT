
% nbt_evalOutcome - Returns outcome measures of a classification
%
% Usage:
%   [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM] = nbt_evalOutcome( pp, outcome );
%
% Inputs:
%   pp          - a vector of estimated class probability
%   outcome     - a vector of the known class 
%    
% Outputs:
%   FP     - Number of False Positive
%   TP     - Number of True Positive
%   FN     - Number of False Negative
%   TN     - Number of True Negative
%   SE     - Sensitivity (Also called Recall rate)
%   SP     - Specificity
%   PP     - Positive predictive value (Also called Precision)
%   NN     - Negative Predictive value
%   LP     - Likelihood ratio positive
%   LN     - Likelihood ratio negative
%   MM     - Matthew correlation
%
%
%
% References:
% See e.g.;
% http://en.wikipedia.org/wiki/Accuracy_and_precision#In_binary_classification

  
%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2011), see NBT website (http://www.nbtwiki.net) for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) <year>  <Main Author>  (Neuronal Oscillations and Cognition group, 
% Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, 
% Neuroscience Campus Amsterdam, VU University Amsterdam)
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
% ---------------------------------------------------------------------------------------

function [FP, TP, FN, TN, SE, SP, PP, NN, LP, LN, MM, ACC, AUC, H]=nbt_evalOutcome(pp, outcome, Threshold)
error(nargchk(2, 3, nargin))
if(~exist('Threshold','var'))
    Threshold = 0.5;
end
GrpID = unique(outcome);
if(length(GrpID) <= 2)
        FP = length(find(pp(outcome==0)>=Threshold));
        TP = length(find(pp(outcome==1)>=Threshold));
        FN = length(find(pp(outcome==1)<Threshold));
        TN = length(find(pp(outcome==0)<Threshold));
        ACC = (TP+TN)/(TP+TN+FP+FN);
        SE = TP/(TP+FN);
        SP = TN/(TN+FP);
        PP = TP /(TP + FP);
        NN = TN /(FN + TN);
        LP = SE/(1-SP);
        LN = (1 - SE)/SP;
        MM = (TP*TN - FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN +FN));
        [FPR,TPR,T,AUC,TOP] = perfcurve(outcome,pp,1);
       % [results,~,~,~,~] = hmeasure(outcome,pp);
        H=NaN;%results.H;
        ACC  = (TP+TN)./(TN+TP+FN+FP);
else
        % means pp gives group belonging not probability
        % here we define a cell with GrpID x 1
        GrpID = unique(outcome);
        for m = 1:length(GrpID)
            FP{m,1} = length(find(pp(outcome ~= GrpID(m)) == GrpID(m)));
            TP{m,1} = length(find(pp(outcome == GrpID(m)) == GrpID(m)));
            FN{m,1} = length(find(pp(outcome == GrpID(m)) ~= GrpID(m)));
            TN{m,1} = length(find(pp(outcome ~= GrpID(m)) ~= GrpID(m)));
            SE{m,1} = TP{m,1}/(TP{m,1}+FN{m,1});
            SP{m,1} = TN{m,1}/(TN{m,1}+FP{m,1});
            PP{m,1} = TP{m,1}/(TP{m,1} + FP{m,1});
            NN{m,1} = TN{m,1}/(FN{m,1} + TN{m,1});
            LP{m,1} = SE{m,1}/(1-SP{m,1});
            LN{m,1} = (1 - SE{m,1})/SP{m,1};
            MM{m,1} = (TP{m,1}*TN{m,1} - FP{m,1}*FN{m,1})/sqrt((TP{m,1}+FP{m,1})*(TP{m,1}+FN{m,1})*(TN{m,1}+FP{m,1})*(TN{m,1} +FN{m,1}));   
            AUC=[];% Area Under the Curve as implemented in Matlab doesn't support multiclass classifiers.
        end 
end
end