function [Signal, SignalInfo] = nbt_CSD(Signal,SignalInfo,Save_dir)
    %%% Get the channel information
    chanLocs = SignalInfo.interface.EEG.chanlocs;
    
    %%% Get the channel labels in the CSD toolbox format
    nChannels = size(chanLocs,2);
    chanInfo.lab = cell(nChannels,1);
    chanInfo.theta = zeros(nChannels,1);
    chanInfo.phi = zeros(nChannels,1);
    for chan = 1 : nChannels
        chanInfo.lab{chan} = chanLocs(chan).labels;
        chanInfo.theta(chan) = chanLocs(chan).sph_theta;
        chanInfo.phi(chan) = chanLocs(chan).sph_phi;
    end
    
    tic
    %%% Compute G and H using CSD toolbox 'GetGH.m'
    [G,H] = GetGH(chanInfo);
    
    %%% Define CSDSignal
    nTimePoints = size(Signal,1);
    CSDSignal = zeros(nTimePoints,size(Signal,2));

    %%% Compute CSD using CSD toolbox 'CSD.m'
    text = ['Computing scalp current density for ', num2str(nTimePoints), ' time points'];
    disp(text);
    for timePoint = 1 : size(Signal,1)
        if mod((timePoint / nTimePoints * 100),1) == 0
            disp([num2str(timePoint / nTimePoints * 100), '%']);
        end
        CSDSignal(timePoint,:) = computeCSD(Signal(timePoint,:)',G,H);
    end
    toc
    
    %%% Set the Signal and SignalInfo
    Signal = CSDSignal;
    
    %%% Set the SignalInfo
    SignalInfo.signalName = 'CSDSignal';
    SignalInfo.signalType = 'CSDSignal';
end