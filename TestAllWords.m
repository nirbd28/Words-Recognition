function struct=TestAllWords(frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr, words_index_arr, name_train_arr, name_test_arr, test_or_train, records_path)
clc;

%%% init struct
for i=1:length(words_index_arr)
    struct(i).Word=words_index_arr{i};
    struct(i).Ahat=0;
    struct(i).Shtaim=0;
    struct(i).Shalosh=0;
    struct(i).Arba=0;
    struct(i).Hamesh=0;
    struct(i).One=0;
    struct(i).Two=0;
    struct(i).Three=0;
    struct(i).Four=0;
    struct(i).Five=0;
    struct(i).Total=0;
    struct(i).Success_Rate=0;
end

%%% determine if train or test
if strcmp(test_or_train,'Test')
   name_arr=name_test_arr;
   display('Test')
else
    name_arr=name_train_arr;
    display('Train')
end

display(' ')
for i=1:length(words_index_arr)
    path=strcat(records_path,'\',words_index_arr(i));
    path=path{1};
    
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
            file_name_final = strcat(path,'\', name_arr{j}, num2str(count), '.wav');
            [speech, fs] = audioread(file_name_final);
            speech=CorrectSpeechSize(speech);
            %sound(speech,fs);
            
            %%% recognition
            [recognized_word, index]=WordsRecognition(speech, fs, frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr);
            
            %%% struct
            struct=Update_Struct(struct, i, index);
            
            %%% err
           if strcmp(words_arr{i}, recognized_word)
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
    
    display(words_index_arr{i});
    display(strcat('Count:',num2str(overall_count)));
    display(strcat('Count Success:',num2str(count_success)));
    display(strcat('Success Rate:',num2str(success_rate),'%'));
    display(' ');
     
end


end

%%%%%%%%%% struct function
function struct_out=Update_Struct(struct, word_i, rec_index)

struct(word_i).Total=struct(word_i).Total+1;
switch rec_index
    case 1
        struct(word_i).Ahat=struct(word_i).Ahat+1;
    case 2
        struct(word_i).Shtaim=struct(word_i).Shtaim+1;
    case 3
        struct(word_i).Shalosh=struct(word_i).Shalosh+1;
    case 4
        struct(word_i).Arba=struct(word_i).Arba+1;
    case 5
        struct(word_i).Hamesh=struct(word_i).Hamesh+1;
    case 6
        struct(word_i).One=struct(word_i).One+1;
    case 7
        struct(word_i).Two=struct(word_i).Two+1;
    case 8
        struct(word_i).Three=struct(word_i).Three+1;
    case 9
        struct(word_i).Four=struct(word_i).Four+1;
    case 10
        struct(word_i).Five=struct(word_i).Five+1;  
end

%%% succes rate
switch word_i
    case 1
        count_succes=struct(word_i).Ahat;
    case 2
        count_succes=struct(word_i).Shtaim;
    case 3
        count_succes=struct(word_i).Shalosh;
    case 4
        count_succes=struct(word_i).Arba;
    case 5
        count_succes=struct(word_i).Hamesh;
    case 6
        count_succes=struct(word_i).One;
    case 7
        count_succes=struct(word_i).Two;
    case 8
        count_succes=struct(word_i).Three;
    case 9
        count_succes=struct(word_i).Four;
    case 10
        count_succes=struct(word_i).Five;
end

struct(word_i).Success_Rate=(count_succes/struct(word_i).Total)*100;

struct_out=struct;

end

