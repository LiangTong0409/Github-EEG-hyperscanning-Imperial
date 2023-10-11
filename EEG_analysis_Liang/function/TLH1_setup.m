function [exp] = TLH1_setup(exp); 

%% EXPERIMENT & PARTICIPANT INFO 
exp.name            = {'G','Y'};
exp.nsub              = length(exp.sub_id);

%% PATH INFO 

addpath('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\EEGLAB\eeglab-develop');%eeglab
addpath(genpath('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning'));%main script path
cd('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang')%function


exp.hi5path           = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\raw data\Hi5_data\'];%Hi5 raw
exp.eegpath          = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\raw data\EEG_data\'];%EEG raw
exp.preprocessingpath= ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\preprocess data\'];
exp.plotpath          = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\finial data\'];
exp.datainfopath= ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\data_info\']% eeg momtage and event marker file

%% FILTERING 
exp.filter.lowerbound = 2; % When 0.1, files are labelled f01; when 0.01, files are just labelled f.
exp.filter.upperbound = 30;% <beta

if exp.filter.lowerbound == 0.01
    exp.filterLab = 'f';
elseif exp.filter.lowerbound == 0.1
    exp.filterLab = 'f01';
end
% Analysis parameters & labels 
exp.filterLabs = {'_f', '_f01'}; %Filter lab = _f if filter .01, _f01 if .1
exp.icaLabs = {'', '_ica'}; % no ica, ica labels. 
exp.csdLabs = {'', '_csd'};

%% Run analysis
eeglab

% %% SETUP INFO 
% exp.fs                = 512;
% 
% 
% % External channel info 
% 
% %extensior and flexor
% % exp.chan.emgE = 33; 
% % exp.chan.emgF = 34; 
% 
% 
 exp.nEEGchans = 61; % remove Eog M1 and M2
% exp.nchans = 33; % Last channel is empty; 
% 
% exp.eegChans = [1:32];
% 
% exp.srate    = 512; %sampling rate 
% %% Experimental parameters 
% 
% exp.conditions=[1:9]%
% %% Processing parameters
% %% FILTERING 
% exp.filter.lowerbound = 0.1; % When 0.1, files are labelled f01; when 0.01, files are just labelled f.
% exp.filter.upperbound = 30;% <beta
% 
% if exp.filter.lowerbound == 0.01
%     exp.filterLab = 'f';
% elseif exp.filter.lowerbound == 0.1
%     exp.filterLab = 'f01';
% end
% % Analysis parameters & labels 
% exp.filterLabs = {'_f', '_f01'}; %Filter lab = _f if filter .01, _f01 if .1
% exp.icaLabs = {'', '_ica'}; % no ica, ica labels. 
% exp.csdLabs = {'', '_csd'};
% 
% %% Plotting parameters 
% %load 
% %% ARTEFACT REJECTION 
% exp.lowthresh = -150; 
% exp.upthresh = 150;

