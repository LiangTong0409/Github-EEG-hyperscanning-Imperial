function [EEG] = TLH1_baselineData(sub,exp,EEG)

%% BASELINES: 
% Calculate different baselines w
%PreEvent: 200ms before event
EEG1 = EEG;

EEG1_preEvent= EEG1; 

%% PreEvent baseline
%Calculate PreEvente baseline - this should neutralise effects of anticipatory build-up

t.preEvent_baseline_idx = ([EEG1.times] >= -200 & [EEG1.times] <= 0);%200ms before event
t.preEvent_baseline = squeeze(mean(EEG1.data(:,t.preEvent_baseline_idx,:),2));

for e = 1:length(EEG1.epoch) 
%PreEvent
EEG1_preEvent.data(:,:,e) = EEG1.data(:,:,e) - t.preEvent_baseline(:,e); %Baseline
     
end


EEG1.preEvent_baseline = t.preEvent_baseline; 

EEG1 = eeg_checkset( EEG1);


%By default, subtract:
% switch default
%     case 'preEvent'
%         EEG1.data(1:128,:,:) = EEG1_prePulse.data(1:128,:,:);

% end

disp(size(EEG1.data));


EEG1.filename = ['b_' EEG1.filename];


EEG1 = eeg_checkset( EEG1);


% 
EEG1= pop_saveset(EEG1, EEG1.filename, exp.preprocessingpath); %  for corrected





end