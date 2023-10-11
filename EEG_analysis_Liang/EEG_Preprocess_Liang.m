%%--------------------------------------------------------------------------------------------
%%  1. EEGlab analysis script
% Author: Liang Tong
% Date: 1/8/2022

%% Toolbox requirements: 
% - ERPlab (https://erpinfo.org/erplab) - for filtering
%https://erpinfo.org/order-of-steps
% - CSD toolbox
% (https://psychophysiology.cpmc.columbia.edu/software/csdtoolbox/) - for
% CSD implementation
% - TBT toolbox (https://github.com/mattansb/TBT) for trial by trial
% interpolation of bad channels
% ICA lable plugin: An automatic EEG independent component classifer plugin for EEGLAB
%https://github.com/sccn/ICLabel
%Viewprops : Shows the same information as the original EEGLAB pop_prop() function with the addition of a scrolling IC activity
%https://github.com/sccn/viewprops
clc
clear
addpath(genpath('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning'));%code and data path
%% Set experimental analysis parameters
%exp.sub_id = [123,132];
exp.sub_id = [213,231,312,321,1230,1320,2130,2310,3120,3210];
[exp] = TLH1_setup(exp);
%% STEP 0: Convert data to EEGlab format
% Convert data from .eeg to .set and .fdt
for sub = exp.sub_id(1:end)

        TLH1_convertData(sub, exp);% Green first then yellow, check name after
end
%% STEP 1: Filter data
% Filter data using the 0.1-30Hz
for sub = exp.sub_id(1:end)
    EEG = TLH1_filter(sub,exp);
end

%% STEP 2: Annotate data
% Add behavioural data matrices with information about each trial and event
% to the EEG structure. 
for sub = exp.sub_id(1:end)
    EEG = TLH1_annotateData(sub, exp);
end 
%% STEP 3: Epoch, detect bad channels & interpolate
for sub = exp.sub_id(1:end)
    [EEG1, EEG2]  = TLH1_epochData(sub,exp);  %Epoch around 'MotionStart'  0 15 sec and 'RestEnd' -0.5 3
    TLH1_manualChanCheck(sub,exp);
    clear EEG1; clear EEG2; close all;
end
%% STEP 4: Re-reference the data to the common average (i.e. average of all electrodes). 
% Reject epochs with eyeblinks during pulses, reject artefacts, & compute baselines & create trial list

%fidin=fopen('EventstoImport1.txt');
for sub = exp.sub_id(1:end)
    for color =1:2 % Green or yellow 1=G 2=Y
        EEG = pop_loadset([exp.preprocessingpath 'iMaf2c_'  num2str(sub) exp.name{color} '.set']);
        EEG = TLH1_reReference(sub,exp,EEG);

        EEG = pop_loadset([exp.preprocessingpath 'iRaf2c_'  num2str(sub) exp.name{color} '.set']);
        EEG = TLH1_reReference(sub,exp,EEG);
    end
end
%% STEP 5: run ICA and remove eye movement components (manually)
%Firfilt plugin
%Only remove blinks and saccades
%Plot --> Component maps --> In 2-D
%Tools --> Remove components from data-->"Plot single trials"
% click "Accept" on the pop up menu and save your corrected file by adding
% a 'c' at the beginning of your original file

for sub = exp.sub_id(1:end)
    for color =1:2 % Green or yellow 1=G 2=Y
        EEG = pop_loadset([exp.preprocessingpath 'riMaf2c_'  num2str(sub) exp.name{color} '.set']);
        TLH1_runICA(sub,exp, EEG);
        EEG = pop_loadset([exp.preprocessingpath 'riRaf2c_'  num2str(sub) exp.name{color} '.set']);
        TLH1_runICA(sub,exp, EEG);
    end
end
%% STEP 5.5 (optional):  remove eye movement components (using ICA lable plugin)
for sub = exp.sub_id(1:end)
    for color =1:2 % Green or yellow 1=G 2=Y
        EEG = pop_loadset([exp.preprocessingpath 'ICAriMaf2c_'  num2str(sub) exp.name{color} '.set']);
        TLH1_lableICA(sub,exp, EEG);
        EEG = pop_loadset([exp.preprocessingpath 'ICAriRaf2c_'  num2str(sub) exp.name{color} '.set']);
        TLH1_lableICA(sub,exp, EEG);
    end
end
%% STEP 6:baseline the data before 'MotionStart' and 'RestEnd'
%Baseline Correction
%https://www.jianshu.com/p/8e38573ca7aa
%TBT toolbox
%interpolate bad channels on a trial-by-trial basis-This avoids
% rejecting too many trials! 
%213Y not runTBT (1 channel is complete bad)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%manual step
% 3210Y missing first two trial, manual step

for sub = exp.sub_id(1:end)
    for color =1:2 % Green or yellow 1=G 2=Y
    %motion
    EEG = pop_loadset([exp.preprocessingpath 'cICAICAriMaf2c_'  num2str(sub) exp.name{color} '.set']);
    EEG = TLH1_baselineData(sub,exp,EEG); %Calculate baselines and save in a single data file; by default,preEvent: 200ms before event
     EEG = pop_loadset([exp.preprocessingpath 'b_cICAICAriMaf2c_'  num2str(sub) exp.name{color} '.set']);
     EEG = TLH1_cleanEpochs_M(sub,exp,EEG); % Threshold; remove epochs with > 200uV drifts in any channel
%rest
    EEG = pop_loadset([exp.preprocessingpath 'cICAICAriRaf2c_'  num2str(sub) exp.name{color} '.set']);
    EEG = TLH1_baselineData(sub,exp,EEG); %Calculate baselines and save in a single data file; by default,preEvent: 200ms before event
     EEG = pop_loadset([exp.preprocessingpath 'b_cICAICAriRaf2c_'  num2str(sub) exp.name{color} '.set']);
     EEG = TLH1_cleanEpochs_R(sub,exp,EEG); % Threshold; remove epochs with > 200uV drifts in any channel
    end
end
%% STEP 7: CSD filtering 
%https://psychophysiology.cpmc.columbia.edu/software/csdtoolbox/tutorial.html
for sub = exp.sub_id(1:end)
     for color =1:2 % Green or yellow 1=G 2=Y
   EEG = pop_loadset([exp.preprocessingpath 'ab_cICAICAriMaf2c_'  num2str(sub) exp.name{color} '.set']);
   TLH1_applyCSD(sub,exp,EEG);
   EEG = pop_loadset([exp.preprocessingpath 'ab_cICAICAriRaf2c_'  num2str(sub) exp.name{color} '.set']);
   TLH1_applyCSD(sub,exp,EEG);
     end
end
