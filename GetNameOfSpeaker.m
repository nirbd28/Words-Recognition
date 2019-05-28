function name = GetNameOfSpeaker(file_name)

flag=0;
max_rep=40;
for i=1:max_rep
    try
        file_name_temp=strsplit(file_name,num2str(i));
        name=file_name_temp{2};
        flag=1;
        name=file_name_temp{1};
        break;
    catch
        
    end
end
if flag==0
    name=strsplit(file_name,'.');
    name=name{1};
end

end