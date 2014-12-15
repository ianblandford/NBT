function  DataObj = getData(GrpObj,Parameters)
%Get data loads the data from a Database depending on the settings in the
%Group Object and the Statistics Object.
%grpNumber refers to the ordering in the StatObj
StatObj = Parameters{1};
grpNumber = Parameters{2};
DataObj             = nbt_Data;
DataObj.biomarkers  = StatObj.group{grpNumber}.biomarkers;
DataObj.biomarkerIdentifiers = StatObj.group{grpNumber}.biomarkerIdentifiers;
DataObj.subBiomarkers = StatObj.group{grpNumber}.subBiomarkers;
DataObj.classes = StatObj.group{grpNumber}.classes;


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
            biomarker = StatObj.group{grpNumber}.biomarkers{bID};
            subBiomarker = StatObj.group{grpNumber}.subBiomarkers{bID};
            %then we generate the NBTelement call.
            NBTelementCall = ['nbt_GetData(' biomarker ',{'] ;
            %loop over Group parameters
            groupParameters = fields(GrpObj.parameters);
            for gP = 1:length(groupParameters)
                NBTelementCall = [NBTelementCall groupParameters{gP} ',{' ];
                for gPP = 1:length(GrpObj.parameters.(groupParameters{gP}))-1
                    NBTelementCall = [NBTelementCall '''' GrpObj.parameters.(groupParameters{gP}){gPP} ''','];
                end
                gPP = length(GrpObj.parameters.(groupParameters{gP}));
                NBTelementCall = [NBTelementCall '''' GrpObj.parameters.(groupParameters{gP}){gPP} '''};'];
            end
            %then we loop over biomarker identifiers -
            % should be stored as a cell in a cell
            
            bIdentifiers = StatObj.group{grpNumber}.biomarkerIdentifiers{bID};
            
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
            [~, subNBTelementCall]= strtok(NBTelementCall,',');
            subNBTelementCall = strtok(subNBTelementCall,'}');
            try
                [DataObj.subjectList{bID,1}] = evalin('base', ['nbt_GetData(Subject' subNBTelementCall '});']);
            catch me
                %Only one Subject?
             %   disp('Assuming only One subject?');
             %   [DataObj.subjectList{bID,1}] = evalin('base', 'constant{nbt_searchvector(constant , {''Subject''}),2};');
            end
        end
    case 'File'
end

% Call outputformating here >

end
