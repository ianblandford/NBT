classdef nbt_ranksum < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_ranksum(obj)
            obj.testOptions.tail = 'both';
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj,1); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj,2); %with parameters);
            %add test of same subjects
            
            
            %Perform test
            for bID=1:size(Data1.dataStore,1)   
                  D1 = Data1{bID,1};
                  D2 = Data2{bID,1};
                  for chID=1:size(D1,1)
                    [obj.pValues(chID,bID)] = ranksum(D1(chID,:)', D2(chID,:)','tail',  obj.testOptions.tail); 
                  end
            end
            %options
            
        end
    end
    
end

