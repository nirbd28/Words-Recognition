function Generate_Android_Models(GMM_Models, path)

% Generate the GMM models of the words for the android application

file_name=strcat(path,'\','gmm_models.txt');
fileID=fopen(file_name, 'w');
if fileID~=-1
	for i=1:length(GMM_Models)
		fprintf(fileID,'%s\n',GMM_Models(i).word{1});
		fprintf(fileID,'NComponents ');
		fprintf(fileID,'%d\n',GMM_Models(i).model.NComponents);
		fprintf(fileID,'NDimenesions ');
		fprintf(fileID,'%d\n',GMM_Models(i).model.NDimensions);
        for j=1:GMM_Models(i).model.NComponents
			fprintf(fileID,'%s\n',GMM_Models(i).model.PComponents(j));
			for k=1:GMM_Models(i).model.NDimensions
				fprintf(fileID,'%s ',GMM_Models(i).model.mu(j,k));
			end
			fprintf(fileID,'\n');
			for k=1:GMM_Models(i).model.NDimensions
				fprintf(fileID,'%s ',GMM_Models(i).model.Sigma(1,k,j));
			end
			fprintf(fileID,'\n');
        end
	end
	fclose(fileID);
end

end