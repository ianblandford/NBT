%------------------------------------------------------------------------------------
% Originally created by Simon-Shlomo Poil (2012), see NBT website for current email address
%------------------------------------------------------------------------------------
%
% ChangeLog - see version control log at NBT website for details.
%
% Copyright (C) 2012  Simon-Shlomo Poil 
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

function [pp, s ]=nbt_UseClassifier(DataMatrix, s)

%Create test matrix and outcome vector (or if only one group> classify
%without outcome)

% Select method
switch class(s)
   case {'nbt_elasticLogit','logit'}
               pp = glmval(s.modelVars,DataMatrix,'logit','constant','on');
    case 'aenet'
        % Logistic regression
        pp = glmval(s.modelVars,DataMatrix,'logit','constant','on');
   case {'lssvm','lssvmbay'}
        % LSSVM - Least-square support vector machine
         pp = simlssvm(s.modelVars,DataMatrix);
    case 'neuralnet'
        net = s.modelVars;
        pp = net(DataMatrix')';
end



% Insure pp is nan if DataMatrix contains nan for a subject. The
% classification is otherwise not well defined.
pp(isnan(mean(DataMatrix,2))) = nan;
end