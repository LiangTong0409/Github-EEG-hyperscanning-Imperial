function    [EEG1 EEG2] = TLH1_epochData(sub,exp)

for color =1:2 % Green or yellow 1=G 2=Y
% Load preprocessed data and epoch around Motion and Rest
EEG = pop_loadset( [exp.preprocessingpath 'af2c_'  num2str(sub) exp.name{color} '.set'] );

filename1 = ['M' EEG.filename];
EEG1 = pop_epoch( EEG, {  'MotionStart'  }, [-0.3 14.7], 'newname', filename1, 'epochinfo', 'yes');
EEG1 = eeg_checkset( EEG1 );
EEG1 = pop_saveset( EEG1, filename1, exp.preprocessingpath);

filename2 = ['R' EEG.filename];
EEG2 = pop_epoch( EEG, {  'RestEnd'  }, [-0.3 2.7], 'newname', filename2, 'epochinfo', 'yes');
EEG2 = eeg_checkset( EEG2 );
EEG2 = pop_saveset( EEG2, filename2, exp.preprocessingpath);

% filename3 = ['A' EEG.filename];
% EEG2 = pop_epoch( EEG, {  'MotionStart'  }, [-6.5 20.5], 'newname', filename3, 'epochinfo', 'yes');
% EEG2 = eeg_checkset( EEG2 );
% EEG2 = pop_saveset( EEG2, filename3, exp.eegpath);


end
end