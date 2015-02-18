function  DataObj = getData(GrpObj,StatObj)
%Get data loads the data from a Database depending on the settings in the
%Group Object and the Statistics Object.
narginchk(1,2);

global NBTstudy
try
    NBTstudy = evalin('base','NBTstudy');
catch
   evalin('base','global NBTstudy');
   evalin('base','NBTstudy = nbt_Study;');
end

%grpNumber refers to the ordering in the StatObj
%grpNumber = GrpObj.grpNumber;
grpNumber = find(ismember(StatObj.groups, GrpObj.grpNumber)==1);
DataObj             = nbt_Data;

if ~exist('StatObj','var')
    for i=1:length(GrpObj.biomarkerList)
        [DataObj.biomarkers{i}, DataObj.biomarkerIdentifiers{i}, DataObj.subBiomarkers{i}, DataObj.classes{i}, DataObj.units{i}] = nbt_parseBiomarkerIdentifiers(GrpObj.biomarkerList{i});
    end
else
    DataObj.biomarkers = StatObj.group{grpNumber}.biomarkers;
    DataObj.subBiomarkers = StatObj.group{grpNumber}.subBiomarkers;
    DataObj.biomarkerIdentifiers = StatObj.group{grpNumber}.biomarkerIdentifiers;
    DataObj.classes = StatObj.group{grpNumber}.classes;
    DataObj.units = StatObj.group{grpNumber}.units;
end

numBiomarkers       = length(DataObj.biomarkers);
DataObj.dataStore   = cell(numBiomarkers,1);
DataObj.pool        = cell(numBiomarkers,1);
DataObj.poolKey     = cell(numBiomarkers,1);

switch GrpObj.databaseType
    %switch database type
    case 'NBTelement'
        %In this case we load the data directly from the NBTelements in base.
        %We loop over DataObj.biomarkers and generate a cell
        for bID=1:numBiomarkers
            
            if isempty(GrpObj.groupDifference) % regular group
                DataObj = createDataObj(DataObj,bID,GrpObj);
            else
                DataObj = createDataObj(DataObj,bID,NBTstudy.groups{GrpObj.groupDifference(1)});
                DataObj2 = createDataObj(DataObj,bID,NBTstudy.groups{GrpObj.groupDifference(2)});
                DataObj.dataStore = cellfun(@minus, DataObj.dataStore{1}, DataObj2.dataStore{1},'Un',0);
                DataObj.subjectList = [DataObj.subjectList; DataObj2.subjectList];
                DataObj.pool = [DataObj.pool; DataObj2.pool];
                DataObj.poolKey = [DataObj.poolKey; DataObj2.poolKey];
            end
            
         end
    case 'File'
end

DataObj.numSubjects = length(DataObj.subjectList{1,1}); %we assume there not different number of subjects per biomarker!
DataObj.numBiomarkers = size(DataObj.dataStore,1);
% Call outputformating here >


    function DataObj = createDataObj(DataObj,bID,GrpObj)
       
            biomarker = DataObj.biomarkers{bID};
            subBiomarker = DataObj.subBiomarkers{bID};
%            NBTelementCall = generateNBTelementCall(GrpObj);
            %then we generate the NBTelement call.
            NBTelementCall = ['nbt_GetData(' biomarker ',{'] ;
            %loop over Group parameters
            if (~isempty(GrpObj.parameters))
                groupParameters = fields(GrpObj.parameters);
                for gP = 1:length(groupParameters)
                    NBTelementCall = [NBTelementCall groupParameters{gP} ',{' ];
                    for gPP = 1:length(GrpObj.parameters.(groupParameters{gP}))-1
                        NBTelementCall = [NBTelementCall '''' GrpObj.parameters.(groupParameters{gP}){gPP} ''','];
                    end
                    gPP = length(GrpObj.parameters.(groupParameters{gP}));
                    NBTelementCall = [NBTelementCall '''' GrpObj.parameters.(groupParameters{gP}){gPP} '''};'];
                end
            end
            %then we loop over biomarker identifiers -
            % should be stored as a cell in a cell
            
            bIdentifiers = DataObj.biomarkerIdentifiers{bID};
            
            if(~isempty(bIdentifiers))
                % we need to add biomarker identifiers
                for bIdent = 1:size(bIdentifiers,1)
                    
                   if(ischar(bIdentifiers{bIdent,2} ))
                       if strcmp(bIdentifiers{bIdent,1},'Signals')
                        NBTelementCall = [NBTelementCall  bIdentifiers{bIdent,1} ',' '''' bIdentifiers{bIdent,2} '''' ';'];     
                       else
                        NBTelementCall = [NBTelementCall  biomarker '_' bIdentifiers{bIdent,1} ',' '''' bIdentifiers{bIdent,2} '''' ';'];
                       end
                   else
                       NBTelementCall = [NBTelementCall  biomarker '_' bIdentifiers{bIdent,1} ',' num2str(bIdentifiers{bIdent,2}) ';'];
                   end
                end
            end
           NBTelementCall = NBTelementCall(1:end-1); % to remove ';'
            NBTelementCall = [NBTelementCall '},' ''''  subBiomarker '''' ');'];
            [DataObj.dataStore{bID,1}, DataObj.pool{bID,1},  DataObj.poolKey{bID,1}] = evalin('base', NBTelementCall);
            snb = strfind(NBTelementCall,',');
            subNBTelementCall = NBTelementCall(snb(1):snb(end)-1);
            try
                [DataObj.subjectList{bID,1}] = evalin('base', ['nbt_GetData(Subject' subNBTelementCall ');']);
            catch me
                %Only one Subject?
             %   disp('Assuming only One subject?');
             %   [DataObj.subjectList{bID,1}] = evalin('base', 'constant{nbt_searchvector(constant , {''Subject''}),2};');
            end    
    end

end
