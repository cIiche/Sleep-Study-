function [LP, RP, stim] = automatic_channel_assign(filePath)
%AUTOMATIC_CHANNEL_ASSIGN assigns left and right preoptic, and stim
% channels from electrode channel number on the array (from surgery notes) outside of EEG_CWTplot 

set_channels=[1 2 3] ; % set channel identities, stim should always be on index 5, no matter what channel  
if filePath == "C:\Users\Henry\MATLAB\Projects\Sleep_Study\Data\7_7_22 Voltage\"
    LP=set_channels(2);RP=set_channels(1);stim=set_channels(3);
end

