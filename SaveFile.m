function SaveFile(speech, fs)

[file_name,path] = uiputfile('.wav');
filename_final = strcat(path,file_name);
audiowrite(filename_final,speech,fs)

end