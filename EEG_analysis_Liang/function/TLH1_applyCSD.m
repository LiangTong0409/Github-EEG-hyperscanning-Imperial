function [] = TLH1_applyCSD(sub,exp,EEG)
%Relies on CSD toolbox
%See https://psychophysiology.cpmc.columbia.edu/software/csdtoolbox/tutorial.html
%Load CSD transform
ConvertLocations('loc61_Liang_Cz_centred.ced');
E = textread('channel.txt','%s');
M = ExtractMontage('10-5-System_Mastoids_EGI129.csd',E);
%MapMontage(M);
[G,H] = GetGH(M);
% TO DO: check that these coordinates are obtained using the right lambda
% and m parameters - see tutorial. 
        
figure; plot(mean(EEG.data(1:61,:,:),3)');
EEG = eeg_checkset( EEG );

%% Apply CSD to epoched, BASELINED data, but only to EEG channels
X = [];
tic();
for e = 1:length(EEG.epoch)
    X(:,:,e) = CSD(EEG.data(1:61,:,e), G,H);
end
toc();
%This takes about 3 minutes per participant!
EEG.data(1:61,:,:) = X/10;
%figure; plot(mean(EEG.data(1:61,:,:),3)');
%ylim([-8 6]);
EEG = eeg_checkset( EEG );
filename = ['csd_' EEG.filename];
EEG = pop_saveset( EEG, filename, exp.preprocessingpath);



end