classdef (Abstract) nbt_Stat < nbt_Analysis
    % nbt_Stat contains analysis results.
    
    properties
        %Input
        testName
        testOptions
        pValues
        statValues
        statStruct
        statOptions = statset('UseParallel',true);
    end
    
    methods
        function StatObj = nbt_Stat()
            %empty
        end
        
        % plot()
        % createReport();
        function obj = calculate(obj)
        end
        % checkPreCondition();
                
    end
    
end

