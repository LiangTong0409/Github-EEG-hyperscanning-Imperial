function [EEG] = TLH1_annotateData(sub,exp, EEG)

for color =1:2 % Green or yellow 1=G 2=Y
    % % Load converted data

    EEG = pop_loadset([exp.preprocessingpath 'f2c_'  num2str(sub) exp.name{color} '.set']);

    % % Add channel locations
    EEG=pop_chanedit(EEG, 'load' ,{append(exp.datainfopath,'loc64_Liang_Cz_centred.ced')})
    %
    % % add event
    EEG = pop_importevent(EEG, 'append','no','event',append(exp.datainfopath, [num2str(sub) exp.name{color} '.txt']),'fields',{'latency','type'},'skipline',1,'timeunit',1,'align',NaN);

%% delete EOG channel
    EEG=  pop_select(EEG,'rmchannel',[32,13,19]);


    filename = ['a' EEG.filename];
    %EEG = pop_epoch( EEG, {  'RestStart'  }, [0  26], 'newname', filename, 'epochinfo', 'yes');

    %save
    EEG = eeg_checkset( EEG );




    EEG = pop_saveset( EEG, filename, exp.preprocessingpath);


end

end
