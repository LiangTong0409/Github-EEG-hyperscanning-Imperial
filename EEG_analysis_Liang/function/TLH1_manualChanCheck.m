function [] = TLH1_manualChanCheck(sub,exp)

for color =1:2 % Green or yellow 1=G 2=Y

    EEG1=pop_loadset( [exp.preprocessingpath 'Maf2c_'  num2str(sub) exp.name{color} '.set'] );

    EEG2=pop_loadset( [exp.preprocessingpath 'Raf2c_'  num2str(sub) exp.name{color} '.set'] );

    exp.ImportantChans = [2 6 39 15 24 27 61]; % electrodes around CPz (where CPP is), Fz (CNV) and left and right motor cortex (see 'cap_32_layout_medium.jpg')
    % Also mark front-most channels:
    exp.FrontChans = [1 2 3 4 30 31 31 33]; % at the very front edge SD can be high not necessarily because channels are bad but because person is blinking /moving eyes. We don't want to interpolate GOOD electrodes that later will HELP us pick up artifacts that we want to throw out.
    exp.rerefchan = [15]; % pick a channel to re-reference the data to and get a second picture of variance across channels - important just because sometimes the reference used to load the EEG might itself have been bad during the recording...

    % Load in the epoched data
    % EEG = pop_loadset([exp.filepath '/P1_fatmc' (exp.name) '_P1.set']);

    % Concatenate all epochs and get Standard deviation (SD) per channel
    clear SD SDoz
    conc = reshape(EEG1.data(1:exp.nEEGchans,:,:),[exp.nEEGchans,size(EEG1.data,2)*size(EEG1.data,3)]); % concatenate all trials


    % it's worth also looking at SD when referenced to somewhere else - electrode (25) for example - just to make sure you haven't missed any bad channels
    conc2 = conc - repmat(conc(exp.rerefchan,:),[exp.nEEGchans,1]);
    for q=1:exp.nEEGchans % include externals later it have time (EMG data), because it might be a good idea to check whether those are noisy too
        SD(q,1) = std(conc(q,:)); % measure S.D. of each channel
        SD2(q,1) = std(conc2(q,:));
    end

    % Are there any channels that stick out in terms of standard deviation?
    % To check, plot the SD per channel:
    figure (1)
    subplot(2,1,1); hold on; plot(SD(1:exp.nEEGchans,:)); ylim([0 200]) % we only plot the channels in the cap because external electrodes are often higher variance (e.g. you might be recording EMG) and annoyingly set the scale so you always have to zoom in, and the purpose here is to identify channels for interpolation which is ALWAYS only the 128 cap channels

    % mark the important channels specified above - this is just a visual aid to know which you should particularly consider
    for e=1:length(exp.ImportantChans)
        plot([1 1]*exp.ImportantChans(e),[0 max(SD(exp.ImportantChans(e),:))],'b')
    end
    % mark the front edge channels as well, again a visual aid to know where blinks are likely to create higher variance (through no fault of the electrodes)
    for e=1:length(exp.FrontChans)
        plot([1 1]*exp.FrontChans(e),[0 max(SD(exp.FrontChans(e),:))],'k') % front edge channels in BLACK
    end

    %Identify candidate bad channels
    candidates = find(SD(1:exp.nEEGchans,:) > 50 | (SD(1:exp.nEEGchans,:) < 1 & (SD2(1:exp.nEEGchans,:) < 1)));
    exclCandidates = setdiff(candidates,exp.FrontChans);

    for e=1:length(exclCandidates)
        plot([1 1]*exclCandidates(e),[0 max(SD(exclCandidates(e),:))],'r') % candidate noisy channels in RED
    end

    subplot(2,1,2); hold on; plot(SD2(1:exp.nEEGchans,:)); ylim([0 200])
    % mark the important channels specified above - this is just a visual aid to know which you should particularly consider
    for e=1:length(exp.ImportantChans)
        plot([1 1]*exp.ImportantChans(e),[0 max(SD(exp.ImportantChans(e),:))],'b')
    end
    for e=1:length(exp.FrontChans)
        plot([1 1]*exp.FrontChans(e),[0 max(SD(exp.FrontChans(e),:))],'k') % front edge channels in BLACK
    end

    ch2interp = exclCandidates; % makes an empty cell array for filling in the bad channels for this subject

    disp(['Channels to interpolate: ' num2str(exclCandidates')]);
%     prompt = 'Confirm interpolation selection? y/n [y]: ';
%     str = input(prompt,'s');
     str='y'

    if strcmp(str,'y')
        %Interpolate in Motion epochs
        EEG1 = eeg_interp(EEG1,ch2interp);
        EEG1.interpolated = ch2interp;
        EEG = eeg_checkset( EEG1 );
        filename = ['i' EEG1.filename];
        EEG1 = pop_saveset( EEG1, filename, exp.preprocessingpath);
        clear EEG1;

        %Interpolate same channels in Rest epochs
        EEG2 = eeg_interp(EEG2,ch2interp);
        EEG2.interpolated = ch2interp;
        EEG = eeg_checkset( EEG2 );
        filename = ['i' EEG2.filename];
        EEG2 = pop_saveset( EEG2, filename, exp.preprocessingpath);

    else
        disp('Interpolation aborted');
    end
    %return;
end

