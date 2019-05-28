function MFCC_AllWords(frame_time, frame_lap, alpha, coeffs_num, name_train_arr, words_index_arr, MFCC_GMM_path, records_path)

for j=1:length(words_index_arr)
    path=strcat(records_path,'\',words_index_arr{j},'\');
    
    MFCCs_all=[];
    for i=1:length(name_train_arr)
        count=1;
        name=name_train_arr{i};
        while 1
           try       
               count_str = int2str(count);
               file_name_final = strcat(path, name, count_str, '.wav');
               [speech, fs] = audioread( file_name_final );
               %sound(speech,fs);
               count=count+1;
               MFCCs=Feature_Extraction(speech, fs, frame_time, frame_lap, alpha, coeffs_num);
               MFCCs_all = [MFCCs_all MFCCs];

           catch
               break;
           end   
        end   
    end

    mat_name=strcat(MFCC_GMM_path,'\',words_index_arr{j},'.mat');
    save(mat_name,'MFCCs_all');

end

end