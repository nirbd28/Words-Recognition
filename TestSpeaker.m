function [success_rate, count_success, count, name]=TestSpeaker(frame_time, frame_lap, alpha, coeffs_num, path, file_name, GMM_struct, selected_word, words_arr)

name = GetNameOfSpeaker(file_name);

flag=0;
count=0;
count_success=0;
while 1   
    try
        count=count+1;
        %%% load file + mfcc
        file_name_final = strcat(path, name, num2str(count), '.wav');
        [speech, fs] = audioread(file_name_final);
        speech=CorrectSpeechSize(speech);
        %sound(speech,fs);
        
        %%% recognition
        [recognized_word]=WordsRecognition(speech, fs, frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr);
        %%% err
       if strcmp(selected_word, recognized_word)
          flag=1;
          count_success = count_success + 1;
          success_rate = (count_success/count) *100;   
       end   
    catch
       break; 
    end
    
end
count=count-1;
success_rate = (count_success/count) *100;
if flag==0
    success_rate=0;
end

end