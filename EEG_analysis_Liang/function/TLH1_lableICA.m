function [] = TLH1_lableICA(sub,exp,EEG)

EEG = iclabel(EEG);



% only reject eye compoment
%Brain, Muscle, Eye, Heart, Line Noise, Channel Noise, Other.
threshold = [0 0;0.95 1; 0.9 1; 0.95 1; 0.95 1; 0.95 1; 0 0];
  EEG = pop_icflag(EEG, threshold);

  rejected_comps = find(EEG.reject.gcompreject > 0);
  
  disp(rejected_comps)
EEG = pop_subcomp(EEG, rejected_comps);
EEG = eeg_checkset(EEG);


% Upload ICA components to full-sample dataset
EEG=  pop_saveset(EEG, ['cICA' EEG.filename], exp.preprocessingpath); %  for corrected
clear EEG;


end