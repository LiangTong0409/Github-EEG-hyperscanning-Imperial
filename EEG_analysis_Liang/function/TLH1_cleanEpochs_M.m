function [EEG] = TLH1_cleanEpochs_M(sub,exp, EEG)

% [EEG1 Indexes] = pop_eegthresh(EEG, 1, 1:128, lowthresh, upthresh, -0.200, 2, 1, 0);
% if EEG.filename == 'b_cICAICAriMaf2c_231Y.set'
% 
%     filename = ['a' EEG.filename];
%     EEG = pop_saveset( EEG, filename, exp.preprocessingpath);
% 
% else
    EEG1 = pop_eegthresh(EEG, 1, 1:61,-150 , 150 ,-0.2 , 14, 1, 0);
    [EEG1,comrej, badlist]= pop_TBT(EEG1,EEG1.reject.rejthreshE, 62,1 ,0);
    %   >>  EEG1 = pop_TBT(EEG1,bads,EEG.nbchan,1,plot_bads,chanlocs);



    %Rewrite EEG channels on original datafile; keep externals as they were.
    EEG.data(1:61,:,:) = EEG1.data(1:61,:,:)
    EEG.badList_TBT = badlist;

    EEG = eeg_checkset( EEG );
    filename = ['a' EEG.filename];
    EEG = pop_saveset( EEG, filename, exp.preprocessingpath);
% end

end