 Description of what this script does 

fs=tickrate(1);
time=1:dataend(1);
time=time/fs/60;

%Organize data into structure array
alldata=[]; %initialize structure array
baseline_data=[];

alldata.LTRNdata=data(datastart(LTRN):dataend(LTRN));
% alldata.S1Ldata=data(datastart(S1L):dataend(S1L));
% alldata.S1Rdata=data(datastart(S1R):dataend(S1R));
% alldata.V1Rdata=data(datastart(V1R):dataend(V1R));

[bb,aa]=butter(3,[2,55]/(fs/2)); %trying to get the us noise out, 3 to 200
baseline=filtfilt(bb,aa,alldata.LTRNdata')'; % used for the butter filter

baseline_medians = zeros(1,54) ;
    for ii=0:53 % limit may be 54; so 0:53 = 54 sec 
% baseline_medians = zeros(1,length(baseline/fs)) ;
%     for ii=0:(length(baseline/fs)- 1) 
            name=['sec_' num2str(ii+1)];
            first=baseline(:,(ii*fs)+1:fs*(ii+1));
            second=baseline(:,(1+ii)*fs+1:fs*(1+ii)+fs);
            third=baseline(:,((2+ii)*fs+1):(fs*(2+ii)+fs));
            fourth=baseline(:,(3+ii)*fs+1:fs*(3+ii)+fs);
            fifth=baseline(:,(4+ii)*fs+1:fs*(4+ii)+fs);
            sixth=baseline(:,(5+ii)*fs+1:fs*(5+ii)+fs);
            baseline_data.(name)=[first second third fourth fifth sixth];
            baseline_medians(1, ii+1) = median(abs(baseline_data.(name)));
    end
    
baseline_medians_matrix = [baseline_medians_matrix ; baseline_medians] ;
% 6_24_22 change 
rms_baseline = median(baseline_medians);


