classdef nbt_ttest2 < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_ttest2()
            obj.testOptions.tail = 'both';
            obj.testOptions.vartype = 'equal';
            obj.testName = 'Parametric (Bi-variate): Student unpaired t-test';
            obj.groupStatHandle = @nanmean;
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); 
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); 
            %Perform test
            for bID=1:Data1.numBiomarkers  
                [~, obj.pValues(:,bID), ~, obj.statStruct{bID,1}] = ttest2(Data1{bID,1}',Data2{bID,1}','tail',  obj.testOptions.tail,'vartype', obj.testOptions.vartype);
            end
        end
    end
    
end

