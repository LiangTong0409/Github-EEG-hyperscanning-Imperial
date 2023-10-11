clc
clear all
exp.hi5path           = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\raw data\Hi5_data\'];%Hi5 raw
exp.eegpath          = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\raw data\EEG_data\'];%EEG raw
exp.preprocessingpath= ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\preprocess data\'];% preprocess eeg data here
exp.plotpath          = ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\finial data\'];% save finial or plot data here
exp.datainfopath=  ['C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\data_info\']% eeg momtage and event marker file

%%
%123
fid = fopen([exp.hi5path 'P123455_Datalog.tsv']);
%data = cell2mat(h5read('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\Data_test\EEG\RecordSession_P5_testpilot12021.07.22_11.37.51.hdf5','//RawData/AcquisitionTaskDescription'));


Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);
%%
%123 G
EEGmarker = readlines('P123_G_2023-07-21_11-05-07.vmrk');

% only in 123, wrong recording time debug
time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));
%
time2 = cell2mat(extractBetween(EEGmarker(15),strfind(EEGmarker(15),'New Segment,,217496,1,0,')+24,strfind(EEGmarker(15),'000')));

year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)

%
year2 = str2double(extractBetween(time2,1,4))
month2 = str2double(extractBetween(time2,5,6))
day2 = str2double(extractBetween(time2,7,8))
hour2 = str2double(extractBetween(time2,9,10))
minute2 = str2double(extractBetween(time2,11,12))
second2 = str2double(extractBetween(time2,13,14))
ms2 = str2double(extractBetween(time2,15,17))

D2 = datetime(year2,month2,day2,hour2,minute2,second2)

format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time
EEGstarttime2 = (double(convertTo(D2,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms2)/1000%%EEG start time

%actual_time(1)
datevec(3772781339)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime2 + 434.98+3600% uk summer time 3600%%%%%%%%%%%%%+ (EEGstarttime2-EEGstarttime1)only for 123 here buf fix


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('123G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);
%%
%123 Y
EEGmarker = readlines('P123_Y_2023-07-21_11-05-34.vmrk');

% only in 123, wrong recording time debug
time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));
%
time2 = cell2mat(extractBetween(EEGmarker(15),strfind(EEGmarker(15),'New Segment,,206317,1,0,')+24,strfind(EEGmarker(15),'000')));

year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)

%
year2 = str2double(extractBetween(time2,1,4))
month2 = str2double(extractBetween(time2,5,6))
day2 = str2double(extractBetween(time2,7,8))
hour2 = str2double(extractBetween(time2,9,10))
minute2 = str2double(extractBetween(time2,11,12))
second2 = str2double(extractBetween(time2,13,14))
ms2 = str2double(extractBetween(time2,15,17))

D2 = datetime(year2,month2,day2,hour2,minute2,second2)

format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time
EEGstarttime2 = (double(convertTo(D2,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms2)/1000%%EEG start time

%actual_time(1)
% datevec(3772781339)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime2 + 412.62+3600% uk summer time 3600%%%%%%%%%%%%%+ (EEGstarttime2-EEGstarttime1)only for 123 here buf fix


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('123Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%%
%132
clc

fid = fopen([exp.hi5path 'P132_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);

%%
%132 G
EEGmarker = readlines('P132_G_2023-07-26_11-54-41.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('132G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%132 Y
EEGmarker = readlines('P132_Y_2023-07-26_11-54-23.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('132Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%213
clc

fid = fopen([exp.hi5path 'P213_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%213 G
EEGmarker = readlines('P213_G_2023-07-24_12-47-45.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('213G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%213 Y
EEGmarker = readlines('P213_Y_2023-07-24_12-49-21.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('213Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%231
clc

fid = fopen([exp.hi5path 'P231_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%231 G
EEGmarker = readlines('P231_G_2023-07-27_14-02-10.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('231G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%231 Y
EEGmarker = readlines('P231_Y_2023-07-27_14-02-08.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('231Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%312
clc

fid = fopen([exp.hi5path 'P312_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%312 G
EEGmarker = readlines('P312_G_2023-07-28_15-28-15.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('312G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%312 Y
EEGmarker = readlines('P312_Y_2023-07-28_15-29-11.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('312Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%321
clc

fid = fopen([exp.hi5path 'P3211_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%321 G
EEGmarker = readlines('P321_G_2023-07-25_12-59-51.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('321G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%321 Y
EEGmarker = readlines('P321_Y_2023-07-25_12-59-48.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('321Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%1230
clc

fid = fopen([exp.hi5path 'P1230_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%1230 G
EEGmarker = readlines('P1230_G_2023-07-31_15-01-25.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('3120G.txt','w');% fix bug here
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%1230 Y
EEGmarker = readlines('P1230_Y_2023-07-31_15-01-22.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('3120Y.txt','w');% fix bug here
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);
%%
%1320
clc

fid = fopen([exp.hi5path 'P1320_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%1320 G
EEGmarker = readlines('P1320_G_2023-08-03_14-54-11.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('1320G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%1320 Y
EEGmarker = readlines('P1320_Y_2023-08-03_14-54-08.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('1320Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%2310
clc

fid = fopen([exp.hi5path 'P2310_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%2310 G
EEGmarker = readlines('P2310_G_2023-08-07_13-35-59.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('2310G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%2310 Y
EEGmarker = readlines('P2310_Y_2023-08-07_13-35-56.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('2310Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%2130
clc

fid = fopen([exp.hi5path 'P2130_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%2130 G
EEGmarker = readlines('P2130_G_2023-08-02_10-26-52.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('2130G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%2130 Y
EEGmarker = readlines('P2130_Y_2023-08-02_10-26-48.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('2130Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);
%%
%3120
clc

fid = fopen([exp.hi5path 'P3120_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%3120 G
EEGmarker = readlines('P3120_G_2023-08-01_14-34-54.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('1230G.txt','w');% fix bug here
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%3120 Y
EEGmarker = readlines('P3120_Y_2023-08-01_14-34-54.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('1230Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);

%%
%3210
clc

fid = fopen([exp.hi5path 'P3210_Datalog.tsv']);
Hi5_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
fclose(fid);

%Extract variables from cell
raw_time = Hi5_data{1};
raw_trial_num = Hi5_data{2};
target_angle = Hi5_data{3};
rest_active = Hi5_data{40};
actual_time = Hi5_data{39};

trial_num_change = abs(conv(raw_trial_num,[1 -1])) > 0;%set trial change positions to 1 otherwise zero
trial_start_indicies = find(trial_num_change==1);%find indices of trial start time % shoule be 163, 162 for 99 trial 163 for end of the exp fron colv
trial_durations = diff(trial_start_indicies(1:162));%find duration of each trial - every 1500 +100 rest samples should be 161 trials
n = 1:161;

trial_end_indicies = trial_start_indicies(2:162) - 1;
%%%%%%%%%%%%%%%%%%fix bug
%trial_start_indicies = trial_start_indicies(1:end-1)

trial_start_times(n) = actual_time(trial_start_indicies(n));%find corresponding times of trial number change
trial_end_times(n) = actual_time(trial_end_indicies(n));%find corresponding times of trial number change

%check this should be 161 * 15+3+1 sec
trial_time_durations = trial_end_times-trial_start_times;%find corresponding change of time duration of trials - these are different

%same as above but for events (trial start times and motion begin/rest end
event_num_change = abs(conv(rest_active,[1 -1]));%find trial and event time changes
%%%%%%%%%%%%%%%%%fix bug
event_start_indicies = find((event_num_change==5)|(event_num_change==4)|(event_num_change==1));% nan to-4 or 1 to-4 or 1 to nan
%event_start_indicies = find(event_num_change==4)

%check this should be 100 and 1500 x 321 because of diff
event_durations = diff(event_start_indicies)
% start times for both trial start times and motion begin/rest

%event_start_indicies = event_start_indicies;
event_end_indicies(1:321) = event_start_indicies(2:end)-1;
event_end_indicies(322)= trial_start_indicies(162)-1; % fix bug , here now should be 161*2=322 %%% should be same as trial_end_indicies(161)

n = 1:322;
event_start_times0(n) = actual_time(event_start_indicies(n));
event_end_times0(n) = actual_time(event_end_indicies(n));
%check this should be 360- +300 and +2000 
event_durations1 = (event_end_times0-event_start_times0).';% this should be equal to event_durations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
event_start_time_durations = diff(event_start_times0);
event_time_end_durations = diff(event_end_times0);


%3120 G
EEGmarker = readlines('P3210_G_2023-08-08_16-10-48.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'0000')));% fix bug  0000 here


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600 % uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('3210G.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);


%3210 Y
EEGmarker = readlines('P3210_Y_2023-08-08_16-15-01.vmrk');


time1 = cell2mat(extractBetween(EEGmarker(12),strfind(EEGmarker(12),'New Segment,,1,1,0,')+19,strfind(EEGmarker(12),'000')));


year1 = str2double(extractBetween(time1,1,4))
month1 = str2double(extractBetween(time1,5,6))
day1 = str2double(extractBetween(time1,7,8))
hour1 = str2double(extractBetween(time1,9,10))
minute1 = str2double(extractBetween(time1,11,12))
second1 = str2double(extractBetween(time1,13,14))
ms1 = str2double(extractBetween(time1,15,17))

D1 = datetime(year1,month1,day1,hour1,minute1,second1)


format long g
EEGstarttime1 = (double(convertTo(D1,'epochtime','Epoch','1904-01-01','TicksPerSecond',1000))+ms1)/1000%%EEG start time

%actual_time(1)

Eventstarttime=event_start_times0(1)%%event start times
zero_calibration =  Eventstarttime-EEGstarttime1 +3600% uk summer time 3600


event_start_times = event_start_times0 - Eventstarttime+ zero_calibration;
%event_start_times_test = event_start_times0 - EEGstarttime;
event_end_times = event_end_times0-Eventstarttime+zero_calibration;

events = sort([event_start_times event_end_times]);%combine events

%write to file
a = events;
x = diff(events);
fileID = fopen('3210Y.txt','w');
fprintf(fileID,'latency\ttype\n');

type = ""

for i = 1:size(a')
    
if mod(i,4) == 1
    type = "RestStart";
elseif mod(i,4) == 2
    type = "RestEnd";
elseif mod(i,4) == 3
    type = "MotionStart";
elseif mod(i,4) == 0
    type = "MotionEnd";
end
    
fprintf(fileID,'%f\t'+type+'\n',a(i));
type
a(i)
end

fclose(fileID);