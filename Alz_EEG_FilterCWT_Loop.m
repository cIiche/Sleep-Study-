% This code is designed to loop the alzheimers analysis sewuence (that
% produces CWTs)


close all
clear all
clc

%folder='\\Mac\Home\Desktop\Mourad Lab\Crying\haha\';
folder='/Users/tessa/OneDrive - UW/Mourad Lab/Alz Data /08_01_18'
filePattern = fullfile(folder, '*.mat');
file_list=dir(filePattern);
%%
% %%
% %set parameters
% set_channels=[1 2 3 4 6];
% ch_names={'S1','A1','V1R','V1L','stim'};
% on_stim=3;
% thresh=0.3;
% 
% %create data arrays
% for i=1:length(ch_names)-1
%     peaks.(char(strcat(ch_names(i),'_med')))=[];
%     peaks.(char(strcat(ch_names(i),'_iso')))=[];
%     indx.(char(strcat(ch_names(i),'_med')))=[];
%     indx.(char(strcat(ch_names(i),'_iso')))=[];
% end

% measure each file 
for k=1:length(file_list)    
baseFileName = file_list(k).name;
  fullFileName = fullfile(folder, baseFileName);
  fprintf('Now reading %s\n', fullFileName);
    load(fullFileName)
    Alz_EEG_FilterCWT   
end
