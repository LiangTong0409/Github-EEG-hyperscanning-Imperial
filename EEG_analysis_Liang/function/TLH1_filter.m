function [EEG] = TLH1_filter(sub,exp) 

% 
%     filename = ['c_'  num2str(sub) exp.name{color} ];
%     EEG = pop_saveset(EEG, filename, exp.preprocessingpath);
for color =1:2 % Green or yellow 1=G 2=Y

    EEG = pop_loadset( [exp.preprocessingpath '\c_' num2str(sub) exp.name{color} '.set'] );

    % Filter
    %EEG  = pop_basicfilter( EEG,  1:64 , 'Cutoff', [exp.filter.lowerbound  exp.filter.upperbound], 'Design', 'butter', 'Filter', 'bandpass', 'Boundary', [], 'order', 4);
    
    EEG = pop_eegfiltnew(EEG, 'locutoff',2,'hicutoff',30,'revfilt',0,'plotfreqz',0,'filtorder',500);
    EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1,'plotfreqz',0,'filtorder',500);
    

% 0.5 Hz for ICA, o.1Hz for ERP

    EEG = eeg_checkset( EEG );
    if exp.filter.lowerbound == 0.1
        filename = ['f01' EEG.filename];
    elseif exp.filter.lowerbound == 2
        filename = ['f2' EEG.filename];
    end

    EEG.filename = filename;
    EEG = pop_saveset( EEG, filename, exp.preprocessingpath);
end

end

% EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',0);
% EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1,'plotfreqz',0,'filtorder',500);