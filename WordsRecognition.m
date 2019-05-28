function [recognized_word, index]=WordsRecognition(speech, fs, frame_time, frame_lap, alpha, coeffs_num, GMM_struct, words_arr)

MFCCs=Feature_Extraction(speech, fs, frame_time, frame_lap, alpha, coeffs_num);

for i=1:length(GMM_struct)
   [~, NlogL(i)] = posterior(GMM_struct(i).model, MFCCs'); 
end

[~, index]=min(NlogL);
recognized_word = words_arr(index);


end