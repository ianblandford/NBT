function obj = topo_egi256_hcgsn1(varargin)
% TOPO_EGI256_HCGSN1 - EOG correction for EGI's HCGSN1 net using topograhies

import misc.process_arguments;
import misc.split_arguments;
import misc.split_arguments;
import pset.selector.sensor_class;
import pset.selector.good_data;
import pset.selector.cascade;

%% Process input arguments
opt.MinCard         = 2;
opt.MaxCard         = @(d) ceil(0.25*length(d));
opt.Max             = {10 10 @(feat) prctile(feat, 70)};
opt.RetainedVar     = 99.75;
opt.MaxPCs          = 40;
opt.MinPCs          = @(lambda) max(3, ceil(0.1*numel(lambda)));
opt.BSS             = spt.bss.efica;

[thisArgs, varargin] = split_arguments(opt, varargin);

[~, opt] = process_arguments(opt, thisArgs);

%% Default criterion
myFeat1 = spt.feature.psd_ratio.eog;
myFeat2 = spt.feature.bp_var;
myFeat3 =  spt.feature.topo_ratio.eog_egi256_hcgsn1;
myCrit = spt.criterion.threshold('Feature', {myFeat1, myFeat2, myFeat3}, ...
    'Max',      opt.Max, ...
    'MinCard',  opt.MinCard, ...
    'MaxCard',  opt.MaxCard);


%% PCA
myFilter = @(sr) filter.lpfilt('fc', 13/(sr/2));
myPCA = spt.pca(...
    'RetainedVar',              opt.RetainedVar, ...
    'MaxCard',                  opt.MaxPCs, ...
    'MinCard',                  opt.MinPCs, ...
    'MinSamplesPerParamRatio',  15, ...
    'LearningFilter',           myFilter);

%% Build the bss node
dataSel = cascade(sensor_class('Class', {'EEG', 'MEG'}), good_data);
obj = meegpipe.node.bss.new(...
    'DataSelector', dataSel, ...
    'Criterion',    myCrit, ...
    'PCA',          myPCA, ...
    'BSS',          opt.BSS, ...
    'Filter',       filter.lasip.eog, ...
    'RegrFilter',   filter.mlag_regr('Order', 5), ...
    'Name',         'bss.eog', ...
    varargin{:});


end