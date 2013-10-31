function [status, MEh] = test1()
% TEST1 - Tests demo functionality

import sensors.*;
import test.simple.*;

MEh     = [];

initialize(7);

%% Default constructors
try
    
    name = 'default constructors';
    
    physiology;
    mixed;
    meg;
    eeg;
    coils;
    dummy;
    
    ok(true, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end

%% Sensor array templates
try
    
    name = 'sensor array templates';
    
    obj = eeg.from_template('hydrocelgsn25610x2e0');
    
    ok(nb_sensors(obj) == 257, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end

%% Empty arrays
try
    
    name = 'empty arrays';
    
    obj1 = meg.empty(50);
    obj2 = eeg.empty(50);
    obj3 = eeg.empty(50);
    
    ok(nb_sensors(obj1) == 50 && nb_sensors(obj2) == 50 && ...
        nb_sensors(obj3) == 50, name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end

%% Conversion of EEG sensors to Ftrip and EEGLAB
try
    
    name = 'conversion of EEG sensors to ftrip and EEGLAB';
    
    obj = eeg.from_template('hydrocelgsn25610x2e0');
    
    eStr = eeglab(obj);
    fStr = fieldtrip(obj);
    
    ok(numel(eStr) == 257 && size(fStr.elecpos, 1) == 257, name);
    
    catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end

%% Conversion of MEG sensors to Ftrip and EEGLAB
try
    
    name = 'conversion of MEG sensors to ftrip and EEGLAB';
    
    obj = meg.empty(256);
    
    eStr = eeglab(obj);
    fStr = fieldtrip(obj);
    
    ok(numel(eStr) == 256 && size(fStr.chanpos, 1) == 256, name);
    
    catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end

%% Construction of EEG sensors from EEGLAB
try
    
    name = 'construction of EEG sensors from EEGLAB';
    
    obj = eeg.from_template('hydrocelgsn25610x2e0');
    
    eStr = eeglab(obj);
    
    warning('off', 'sensors:MissingPhysDim');
    warning('off', 'sensors:InvalidLabel');
    obj2 = eeg.from_eeglab(eStr);
    warning('on', 'sensors:InvalidLabel');
    warning('on', 'sensors:MissingPhysDim');
    
    ok(isempty(setdiff(orig_labels(obj), orig_labels(obj2))) && ...
        max(abs(obj.Cartesian(:)-obj2.Cartesian(:))) < 1e-3, name);
    
    catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end


%% Construction of EEG sensors from Fieldtrip
try
    
    name = 'construction of EEG sensors from Fieldtrip';
    
    obj = eeg.from_template('hydrocelgsn25610x2e0');
    
    fStr = fieldtrip(obj);
    
    warning('off', 'sensors:MissingPhysDim');
    warning('off', 'sensors:InvalidLabel');
    obj2 = eeg.from_fieldtrip(fStr);
    warning('on', 'sensors:InvalidLabel');
    warning('on', 'sensors:MissingPhysDim');
    
    ok(isempty(setdiff(orig_labels(obj), orig_labels(obj2))) && ...
        max(abs(obj.Cartesian(:)-obj2.Cartesian(:))) < 1e-3, name);
    
    catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
end



%% Testing summary
status = finalize();