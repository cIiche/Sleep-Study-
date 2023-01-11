function [LTRN, RTRN, LM, RM, LCA1H, RCA1H, stim] = automatic_channel_assign(filePath)
%AUTOMATIC_CHANNEL_ASSIGN assigns left and right preoptic, and stim
% channels from electrode channel number on the array (from surgery notes) outside of EEG_CWTplot 

    set_channels=[1 2 3 4 5] ; % set channel identities, stim should always be on index 5, no matter what channel  
if filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_7_22 Voltage\"
    set_channels=[1 2 3] ; % reset channel identities for this specific mouse 
    LTRN=set_channels(2);RTRN=set_channels(1);stim=set_channels(3);
elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_14_22 Voltage\" 
    LTRN=set_channels(3); RTRN=set_channels(1); LM=set_channels(4); RM=set_channels(2); stim=set_channels(5);
elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_21_22 Voltage\" 
    LTRN=set_channels(3); RTRN=set_channels(1); LCA1H=set_channels(4); RCA1H=set_channels(2); stim=set_channels(5);LM = 'lol'; RM='lol'; 
elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\08_02_22 Voltage\" 
    LTRN=set_channels(4); RTRN=set_channels(2); LCA1H=set_channels(3); RCA1H=set_channels(1); stim=set_channels(5);LM = 'lol'; RM='lol'; 
elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\08_04_22 Voltage\" 
    LTRN=set_channels(4); RTRN=set_channels(2); LCA1H=set_channels(3); RCA1H=set_channels(1); stim=set_channels(5);LM = 'lol'; RM='lol'; 
elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\12_22_22 m1\" 
     LTRN=set_channels(3); RTRN=set_channels(1); LCA1H='lol'; RCA1H='lol'; stim=set_channels(5);LM = set_channels(4); RM=set_channels(2); 
% elseif filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\12_22_22 m2\" 
%      LTRN=set_channels(); RTRN=set_channels(); LCA1H=set_channels(); RCA1H=set_channels(); stim=set_channels();LM = ; RM=; 
end

