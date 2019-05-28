function [success_rate, count_success, overall_count]=TestAllSpeakers(frame_time, frame_lap, alpha, coeffs_num, path, GMM_struct, selected_word, words_arr, name_train_arr, name_test_arr, test_or_train)

%%% determine if train or test
if strcmp(test_or_train,'Test')
   name_arr=name_test_arr;
else
    name_arr=name_train_arr;
end

overall_count=0;
count_success=0;
flag=0;
for j=1:length(name_arr)
    count=0;
    while 1   
        try
            count=count+1;
            overall_count=overall_count+1;
            %%% load file + mfcc
            file_name_final = strcat(path, name_arr{j}, num2str(count), '.wav');
            [speech, fs] = audioread(file_name_final);
            speech=CorrectSpeechSize(speech);
            %sound(speech,fs);
            
            %%% recognition
            [recognized_word]=WordsRecognition(speech, fs, frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr);
            %%% err
           if strcmp(selected_word, recognized_word)
              flag=1;
              count_success = count_success + 1;
              success_rate = (count_success/overall_count) *100;   
           end   
        catch
           break; 
        end

    end
    overall_count=overall_count-1;
    success_rate = (count_success/overall_count) *100;
    
end

if flag==0
   success_rate=0;
end
    

end