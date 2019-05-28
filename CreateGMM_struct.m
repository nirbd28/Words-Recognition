function GMM_struct = CreateGMM_struct(MFCC_GMM_path, k_gaussians, options, words_index_arr, Regularize)

for i=1:length(words_index_arr)
    GMM_struct(i).word = words_index_arr(i);
end

for i=1:length(words_index_arr)
    file_name=words_index_arr{i};
    filename_final = strcat(MFCC_GMM_path,'\', file_name, '.mat');
    load(filename_final,'-mat');
    disp(words_index_arr(i));
    
    GMM_struct(i).model = gmdistribution.fit(MFCCs_all',k_gaussians,'CovType','diagonal','Options',options,'Regularize', Regularize);    
end

gmm_name=strcat(MFCC_GMM_path,'\','GMM','.mat');
save(gmm_name,'GMM_struct');
Generate_Android_Models(GMM_struct, MFCC_GMM_path);


end