classdef nbt_signrank < nbt_PairedStat
    properties
    end
    
    methods
        function obj = nbt_signrank(obj)
            obj.testOptions.tail = 'both';
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj); %with parameters);
            %add test of same subjects
            
            
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                [pValues{bID}] = signrank(Data1{bID,1}', Data2{bID,1}','tail',  obj.testOptions.tail);
            end
            %options
            
        end
    end
    
end

