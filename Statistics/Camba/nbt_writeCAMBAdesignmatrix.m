function nbt_writeCAMBAdesignmatrix(template, Data)

for i=1:length(template)
   
   disp([template{i,1} ' ' num2str(Data(i))]) ;
end

end