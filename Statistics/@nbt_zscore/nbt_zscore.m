classdef nbt_zscore < nbt_PairedStat
    properties
    end
    
    methods
        function obj = nbt_zscore(obj)
            % ?
            obj.testOptions.tail = 'both';
            obj.testName = 'Z-score';
            obj.groupStatHandle = @nanmean;
            obj.testOptions.vartype = 'equal';
            % ?
        end
        
        function obj = calculate(obj, StudyObj)
            nGroups = 1;
            if nGroups == 1
                Data1 = StudyObj.groups{1}.getData(obj);
                for bID=1:size(Data1.dataStore,1)
                    B = Data1.dataStore{bID,1};
                    B = B{1};
                    dim = 2;
                    sigma = nanstd(B,1,dim);
                    mu = nanmean(B,dim);

                    sigma(sigma==0) = 1;
                    z = bsxfun(@minus, B, mu);
                    z = bsxfun(@rdivide, z, sigma);

                    obj.statValues.mean = mu;
                    obj.statValues.sd = sigma;
                    obj.statValues.zscores = z;
                end
            elseif nGroups == 2
                % Get data
                Data1 = StudyObj.groups{obj.groups(1)}.getData(obj,1); %with parameters);
                Data2 = StudyObj.groups{obj.groups(2)}.getData(obj,2); %with parameters);
                
                for bID=1:size(Data1.dataStore,1)
                    B1 = Data1.dataStore{bID,1};
                    B2 = Data2.dataStore{bID,1};
                    
                    dim = 2;
                    sigma = nanstd(B2,1,dim);
                    mu = nanmean(B2,dim);
                    sigma(sigma==0) = 1;
                    z = bsxfun(@minus,B1, mu);
                    z = bsxfun(@rdivide, z, sigma);
                    obj.mean = mu;
                    obj.sd = sigma;
                    obj.zscores = z;
                    obj.mean1 = nanmean(B1,dim);
                end
            else
                error('nbt_Print can not handle more than two groups');
            end
        end
    end
end

