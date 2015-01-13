classdef nbt_permutationtestUnPaired < nbt_UnPairedStat
    properties
    end
    
    methods
        function obj = nbt_permutationtestUnpaired(obj)
            obj.testOptions.numPermutations = 5000;
            obj.testOptions.statFunction = @mean;
        end
        
        
        function obj = calculate(obj, StudyObj)
            %Get data
            Data1 = StudyObj.groups{obj.groups(1)}.getData(obj,1); %with parameters);
            Data2 = StudyObj.groups{obj.groups(2)}.getData(obj,2); %with parameters);
            
            
            %Perform test
            
            for bID=1:size(Data1.dataStore,1)   
                D1 = Data1{bID,1};
                D2 = Data2{bID,1};
                for chID=1:size(D1,1)
                    [obj.pValues(chID,bID), obj.statStruct.mean_difference(chID,bID), obj.statStruct.N_s(chID,bID), obj.statStruct.p_low(chID,bID), obj.statStrcut.p_high(chID,bID)] = nbt_permutationtest(D1(chID,:)',D2(chID,:)',obj.testOptions.numPermutations,0,obj.testOptions.statFunction);
                end
            end
        end
    end
    
end

