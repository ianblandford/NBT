function myNode = abp_beat_detect(varargin)

import meegpipe.node.*;

myNode = ev_gen.new(...
    'EventGenerator',   abp_beat_detect.ev_generator, ...
    'Name',             'abp_beat_detect', ...
    'DataSelector',     pset.selector.sensor_label('BP'), ...
    varargin{:});


end