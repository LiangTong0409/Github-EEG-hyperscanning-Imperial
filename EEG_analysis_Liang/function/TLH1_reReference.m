function [EEG] = TLH1_reReference(sub,exp,EEG)
%EEG = pop_loadset([exp.eegpath '\iMa'  exp.filterLab 'c' exp.name '_P' num2str(sub) '.set']);

% CAR reference (Common Average Reference - 128 electrodes)
EEG = pop_reref( EEG, [1:61] ,'keepref','on');
EEG = eeg_checkset( EEG );

% Bipolar re-reference
% See: https://eeglab.org/tutorials/ConceptsGuide/rereferencing_background.html

filename = ['r' EEG.filename];
EEG.filename = filename;

EEG = pop_saveset( EEG, filename, exp.preprocessingpath);
end