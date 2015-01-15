classdef nbt_ttest2 < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_ttest2(obj)
            obj.testOptions.tail = 'both';
            obj.testOptions.vartype = 'equal';
            obj.testName = 'Parametric (Bi-variate): Student unpaired t-test';
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); %with parameters);
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                [~, obj.pValues(:,bID), ~, obj.statStruct{bID,1}] = ttest2(Data1{bID,1}',Data2{bID,1}','tail',  obj.testOptions.tail,'vartype', obj.testOptions.vartype);
            end
            %options
            
        end
    end
    
end

