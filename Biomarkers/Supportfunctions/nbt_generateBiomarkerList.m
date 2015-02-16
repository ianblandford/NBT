function obj = nbt_generateBiomarkerList(grpNumber)
    obj = nbt_Analysis;
    
    biomarkersFixedOrder = {'Peakfit', 'Peakfit', 'DFA', 'Peakfit', 'OscB', 'Peakfit', 'Peakfit', 'AmpCorr', 'Coherence', 'Phaselock'};
    subBiomarkersFixedOrder = {'RelativePower', 'AbsolutePower', 'MarkerValues', 'CentralFreq', 'CumulativeLifetime', 'Bandwidth', 'SpectralEdge', 'MarkerValues', 'Coherence', 'PLV'};
    freqBandsFixedOrder = {[1 3], [4 7], [8 13], [13 30], [30 45]};
    
    i = 1;
    for biomarker = 1 : 10
        obj.group{grpNumber}.biomarkers{i} = biomarkersFixedOrder{biomarker};
        obj.group{grpNumber}.subBiomarkers{i} = subBiomarkersFixedOrder{biomarker};
        obj.group{grpNumber}.biomarkerIdentifiers{i} = freqBandsFixedOrder;
        i = i + 1;
    end
end