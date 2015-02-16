function obj = nbt_generateBiomarkerList()
    obj = nbt_Analysis;
    
    biomarkersFixedOrder = {'Peakfit', 'Peakfit', 'DFA', 'Peakfit', 'OscB', 'Peakfit', 'Peakfit', 'AmpCorr', 'Coherence', 'Phaselock'};
    subBiomarkersFixedOrder = {'RelativePower', 'AbsolutePower', 'MarkerValues', 'CentralFreq', 'CumulativeLifetime', 'Bandwidth', 'SpectralEdge', 'MarkerValues', 'Coherence', 'PLV'};
    freqBandsFixedOrder = {[1 3], [4 7], [8 13], [13 30], [30 45]};
    
    i = 1;
    for biomarker = 1 : 10
        obj.group{i}.biomarkers = biomarkersFixedOrder{biomarker};
        obj.group{i}.subBiomarkers = subBiomarkersFixedOrder{biomarker};
        obj.group{i}.biomarkerIdentifiers = freqBandsFixedOrder;
        i = i + 1;
    end
end