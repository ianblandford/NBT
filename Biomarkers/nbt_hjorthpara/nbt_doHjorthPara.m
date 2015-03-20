%  nbt_HJORTH calculates ACTIVITY, MOBILITY, COMPLEXITY
%           
%  nbt_hjorthpart = nbt_hjorth(...)
%  
%  [...] = hjorth(S,0)
%       calculates stationary Hjorth parameter 
%  [...] = hjorth(S,UC) with 0<UC<1,
%       calculates time-varying Hjorth parameter using 
%       exponential window 
%  [...] = hjorth(S,N) with N>1,
%       calculates time-varying Hjorth parameter using 
%       rectangulare window of length N
%  [...] = hjorth(S,B,A) with B>=1 oder length(B)>1,
%       calulates time-varying Hjorth parameters using 
%       transfer function B(z)/A(z) for windowing 
%
%       S       data (each channel is a column)
%       UC      update coefficient 
%       B,A     filter coefficients (window function) 
%              
%
% Outputs:
% 
% Activity: a measure of the squared standard deviation of the amplitude, sometimes referred to as the variance or mean power
% Mobility: a measure of the standard deviation of the slope with reference to the standard deviation of the amplitude; 
%            expressed as a ratio per time unit and may be conceived also as a mean frequency
% Complexity: a measure of excessive details with reference to the "softest" possible curve shape, the sine wave; 
%              expressed as the number of standard slopes actually generated during the average time required for 
%              generation of one standard amplitude as given by the mobility


% REFERENCE(S):
% [1] B. Hjorth, 
%   EEG analysis based on time domain properties
%   Electroencephalography and Clinical Neurophysiology, vol. 29, no. 3, pp. 306???310, September 1970.
% [2] B. Hjorth, 
%   Time Domain Descriptors and their Relation to particulare Model for Generation of EEG activity. 
%   in G. Dolce, H. Kunkel: CEAN Computerized EEG Analysis, Gustav Fischer 1975, S.3-8. 

%	This file is a modified version of hjort.m ; Copyright (C) 2004,2008,2009 by Alois Schloegl <a.schloegl@ieee.org>
%    	Hjort.m is part of the BIOSIG-toolbox http://biosig.sf.net/

%modified version Copyright (C) 2010  Neuronal Oscillations and Cognition group, Department of Integrative Neurophysiology, Center for Neurogenomics and Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
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
%

% ChangeLog - see version control log for details
% <date> - Version <#> - <text>

function hjorthpara = nbt_doHjorthPara(Signal, SignalInfo,UC,A)


hjorthpara = nbt_hjorthpara(size(Signal,2));
Signal = nbt_RemoveIntervals(Signal,SignalInfo);



K = size(Signal,2); 	% number of electrodes K

%m0 = mean(sumsq(S,2));
d0 = Signal(:,:);
%m1 = mean(sumsq(diff(S,[],1),2));
d1 = diff([zeros(1,K);Signal(:,:) ],[],1);
d2 = diff([zeros(1,K);d1],[],1);

FLAG_ReplaceNaN = 0;

if nargin<4, 
        UC = 0; 
end
if nargin<5;
        if UC==0,
                                
        elseif UC>=1,
                B = ones(1,UC);
                A = UC;
        elseif UC<1,
                FLAG_ReplaceNaN = 1;
                B = UC; 
                A = [1, UC-1];
        end
else
        B = UC;    
end

if ~UC,
        m0 = mean(d0.^2);
        m1 = mean(d1.^2);
        m2 = mean(d2.^2);
else
        if FLAG_ReplaceNaN;
                d0(isnan(d0)) = 0;
                d1(isnan(d1)) = 0;
                d2(isnan(d2)) = 0;
        end
        m0 = filter(B,A,d0.^2)./filter(B,A,double(~isnan(d0)));
        m1 = filter(B,A,d1.^2)./filter(B,A,double(~isnan(d1)));
        m2 = filter(B,A,d2.^2)./filter(B,A,double(~isnan(d2)));
end

hjorthpara.activity = m0;
hjorthpara.mobility   = sqrt(m1./m0); 
hjorthpara.complexity = sqrt(m2./m1)./hjorthpara.mobility; 

hjorthpara = nbt_UpdateBiomarkerInfo(hjorthpara, SignalInfo);
end