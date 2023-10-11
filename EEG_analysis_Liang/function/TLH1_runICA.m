function [] = TLH1_runICA(sub,exp,EEG)

[EEG1] = pop_resample(EEG,100); %Try downsampling just for ICA

EEG1 = EEG;
tic()
EEG1 = pop_runica(EEG1, 'icatype', 'runica', 'extended',0,'interrupt','on', 'chanind', [1:61]);
toc()

EEG.icawinv = EEG1.icawinv;
EEG.icasphere = EEG1.icasphere;
EEG.icaweights = EEG1.icaweights;
EEG.icachansind = EEG1.icachansind;
% 
% data4pca = double(reshape(EEG1.data(1:exp.nEEGchans,:,:),[exp.nEEGchans,size(EEG1.data,2)*size(EEG1.data,3)]));
% %PCA 
% [pc,eigvec,sv] = runpca(data4pca, 10);

% Upload ICA components to full-sample dataset
EEG=  pop_saveset(EEG, ['ICA' EEG.filename], exp.preprocessingpath); %  for corrected


clear EEG;


end