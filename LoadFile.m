function [speech, fs, file_name, path]=LoadFile()

[file_name,path] = uigetfile('.wav');
filename_final = strcat(path,file_name);
[speech, fs] = audioread( filename_final );

speech=CorrectSpeechSize(speech);

end