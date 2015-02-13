classdef nbt_Analysis
    
    properties
        groupStatHandle % e.g. @nanmedian or @median to produce group statistics.
        groups
        group % 
        %group{x}.biomarkers
        %group{x}.subBiomarkers
        %group{x}.biomarkerIdentifiers
        %group{x}.class
        %biomarkerIdentifiers = cell(1,1);
        %subBiomarkers
        channels
        channelsRegionsSwitch
        uniqueBiomarkers
    end
    
    methods
        function obj = nbt_Analysis()
        end
        
    end
    
end

