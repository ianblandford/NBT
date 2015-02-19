function [SignalInfo] = nbt_readlocs(SignalInfo, ReadLocFilename)
SignalInfo.interface.EEG.chanlocs = readlocs(ReadLocFilename);
end