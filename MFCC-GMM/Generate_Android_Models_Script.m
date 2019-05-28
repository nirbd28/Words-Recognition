%%
clc; clear all; close all;
%%
clc; clear all; close all;

project_path = pwd;
MFCC_GMM_path=strcat(project_path,'\','MFCC-GMM');
Function_MFCC_path=strcat(project_path,'\','Function_MFCC');
addpath(MFCC_GMM_path);

file_name=strcat(MFCC_GMM_path,'\','GMM.mat');
load(file_name);
Generate_Android_Models(GMM_struct, MFCC_GMM_path);

