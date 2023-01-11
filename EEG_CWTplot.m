%% Authors: Alissa Phutirat, Henry Tan :D 
% This script plots CWTs from .mat labchart files for the Mourad Lab Sleep Study as an average of the
% brain activity for each of 4 channels during 10 second epochs of US stimulus
clear all
close all
clc

%% Load Voltage Data

% filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_7_22 Voltage\' ;
% filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_14_22 Voltage\' ;
% filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_21_22 Voltage\' ;
% filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\08_02_22 Voltage\'; 
filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\08_04_22 Voltage\'; 
% filePath = 'C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\12_22_22 m1\'; 

fileName = 'Trial 3' ;
disp(fileName) 
load([filePath,fileName]);

baselinenormal = input("Normalize data with baseline?: '1' = yes, '0' = no: ") ;
%% set parameters
[LTRN, RTRN, LM, RM, LCA1H, RCA1H, stim] = automatic_channel_assign(filePath); % preset experiment channel assignment based on surgery notes 

%% Set sampling rate and time axis
fs = 10000 ;
timeax=1:dataend(1); % set time axis
time=timeax/fs/60; % frames to seconds to minutes (these are the time values for each data point)
timesec=timeax./fs;
tottime=length(timeax)./fs./60; % total experiment block length in minutes 

%% find median baseline rms for normalization

if baselinenormal == 1 
    baseline = dir([filePath 'baseline.mat']); 
    baseline_medians_matrix = [];
    rms_baseline=[];
    disp(baseline.name);
    load([filePath baseline.name])
    calc_baseline;
end 
%% Organize data into structure array
alldata=[]; %initialize structure array (alldata is a struct)
if filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_7_22 Voltage\" 
    alldata.RTRNdata=data(datastart(RTRN):dataend(RTRN));% Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
    alldata.LTRNdata=data(datastart(LTRN):dataend(LTRN));
    alldata.stimdata=data(datastart(stim):dataend(stim));
    alldata.LTRNRTRNbipolardata=alldata.LTRNdata-alldata.RTRNdata;
    names={'RTRNdata','LTRNdata', 'stimdata', 'LTRNRTRNbipolardata'};
% elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_14_22 Voltage\" || filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\12_22_22 m1\"
    elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\12_22_22 m1\"
    alldata.RTRNdata=data(datastart(RTRN):dataend(RTRN));% Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
    alldata.LTRNdata=data(datastart(LTRN):dataend(LTRN));
    alldata.stimdata=data(datastart(stim):dataend(stim));
    alldata.LTRNRTRNbipolardata=alldata.LTRNdata-alldata.RTRNdata;
    alldata.LMdata=data(datastart(LM):dataend(LM));
    alldata.RMdata=data(datastart(RM):dataend(RM));
    names={'RTRNdata','LTRNdata','RMdata','LMdata', 'stimdata', 'LTRNRTRNbipolardata'};
else 
    alldata.RTRNdata=data(datastart(RTRN):dataend(RTRN));% Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
    alldata.LTRNdata=data(datastart(LTRN):dataend(LTRN));
    alldata.stimdata=data(datastart(stim):dataend(stim));
    alldata.LTRNRTRNbipolardata=alldata.LTRNdata-alldata.RTRNdata;
    alldata.LCA1Hdata=data(datastart(LCA1H):dataend(LCA1H));
    alldata.RCA1Hdata=data(datastart(RCA1H):dataend(RCA1H));
    names={'RTRNdata','LTRNdata','RCA1Hdata','LCA1Hdata', 'stimdata', 'LTRNRTRNbipolardata'};
end 

%% plot raw data
figure
for i=1:length(names)
    subplot(length(names),1,i)
    plot(time,alldata.(char(names(i)))) % this is plotting time in minutes, but if you want seconds, use timesec instead of time
    title(names(i));
end
xlabel('time (minutes)')

%% Filter the raw data with a lowpass butterworth filter 

lowEnd = 2; % Hz
highEnd = 55; % Hz
filterOrder = 3; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(fs/2)); % Generate filter coefficients

for ii=1:length(names)
filteredData.(char(names(ii))) = filtfilt(b, a,alldata.(char(names(ii)))); % Apply filter to data using zero-phase filtering
end

%% detect stimuli
index_stim=[];%initialize reference array of stimulus onsets for STAs
index_allstim=[];%secondary array of stimuli for identifying first pulse of a train. 

X=alldata.stimdata;
X=X-min(X);
X=X/max(X);
Y=X>0.5;
%Y=X>0.04;used during debugging, works as well
Z=diff(Y);
index_allstim=find(Z>0.04);
index_allstim=index_allstim+1;

%find first pulse of each train, if stimulation contains trains
index_trains=diff(index_allstim)>20000;
index_allstim(1)=[];
index_stim=index_allstim(index_trains);

%% Create STAs
for i=1:length(names) %initiate data array to hold STAs
stas.(char(names(i)))=[];
end

tb=1; %time before stim to start STA
ta=9; %time after stim to end STA

for i=1:length(names)
    for j=2:(length(index_stim)-1) %cycle through stimuli         
        if baselinenormal == 1
            stas.(char(names(i)))=[stas.(char(names(i))); (filteredData.(char(names(i)))((index_stim(j)-fs*tb):(index_stim(j)+fs*ta)))/rms_baseline];
        else
            stas.(char(names(i)))=[stas.(char(names(i))); filteredData.(char(names(i)))((index_stim(j)-fs*tb):(index_stim(j)+fs*ta))];
        end
    end 
end

%% plot filtered STAS
figure
x2=1:length(stas.(char(names(1)))); % make an x axis
x2=x2/fs-1; % convert x axis from samples to time 
for i=1:(length(names)-1)
    subplot(length(names)-1,1,i)
    a=median(stas.(char(names(i))));
    a=a-median(stas.(char(names(i)))(1:fs));
    a=a/100*1000;
    asmooth=smoothdata(a); % smooth the data 
    plot(x2,asmooth,'linewidth',1.5)
    ylim([-0.01 0.01])
    ylabel(names(i))
end
subplot(4,1,4)
xlabel('time after stimulus onset (s)')

%% plot filtered CWTs of STAs
% ticks=[0:.005:.1];
% ticks=[0:0.01:.1];
ticks=[0:0.001:.1];
clear yticks
clear yticklabels

% investigate nexttile to put all cwts together for easy snipping
    for i=1:length(names)    
%     for i=1:length(names)  
        figure
        caxis_track=[];
        %ylabels={'V1bipolar (Hz)';'S1A (Hz)';'S1V1(Hz)'; '40hzStim (Hz)'};
        xlabel('time after stimulus onset (s)');
        mediansig=median(stas.(char(names(i))));
        [minfreq,maxfreq] = cwtfreqbounds(length(mediansig),fs); %determine the bandpass bounds for the signal
        cwt(mediansig,[],fs);
        ylabel('Frequency (Hz)')
        colormap(jet)
        title(names(i))
        ylim([.001, .06])
        yticks(ticks)

        yticklabels({  0 1.0000 2.0000 3.0000 4.0000 5.0000 6.0000 7.0000 8.0000 9.0000 10.0000 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 20.0000 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 30 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 40 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 50})
        set(gca,'FontSize',12)

%         caxis([0.00, .0011])
        caxis([0.00, .0003])
        % pngFileName = sprintf('plot_%d.fig', i);
        % fullFileName = fullfile(folder, pngFileName);
		
	    % Then save it
	    % export_fig(fullFileName);
        % saveas(gcf, pngFileName)
	

    end
