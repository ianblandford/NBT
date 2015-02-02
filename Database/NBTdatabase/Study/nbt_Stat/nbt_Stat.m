classdef nbt_Stat
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        testOptions
        groups
        group % This is wh
        %group{x}.biomarkers
        %group{x}.subBiomarkers
        %group{x}.biomarkerIdentifiers
        %group{x}.class
        %biomarkerIdentifiers = cell(1,1);
        %subBiomarkers
        channels
        channelsRegionsSwitch
        uniqueBiomarkers
        pValues
        sigPValues
        ccPValues
        qPValues
        
        statValues
        statStruct 
        statOptions = statset('UseParallel',true);    
    end
    
    methods
        function StatObj = nbt_Stat()
            
        end
        
       % plot()
       % createReport();
       function obj = calculate(obj)
          
       end
       % checkPreCondition();
        
    end
    
end

