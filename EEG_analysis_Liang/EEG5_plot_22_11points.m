%%--------------------------------------------------------------------------------------------
%% select matrix and plot, similiar to the code below 
% 4. EEG plot script (exclude participant pair 1 for left hand) (plot for
% pre participants) 11 points or 22 points

% Author: Liang Tong
% Date: 19/8/2022

clc
clear
addpath(genpath('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning'));%code and data path


%% Set experimental analysis parameters
%exp.sub_id = [123,132];
exp.sub_id = [123,132,213,231,312,321,1230,1320,2130,2310,3120];

[exp] = TLH1_setup(exp);
%%
%%load data 
load('ERP_IBS_wtc.mat')% change here for time frequency
% %
% output_C(i,k,1)=mean(mean(WCOH(1:14,:),1));%Beta 1:14   13-30hz
% output_C(i,k,2)=mean(mean(WCOH(14:23,:),1));%Alpha 14:23 8-13Hz
% output_C(i,k,3)=mean(mean(WCOH(53:71,:),1));% 0.5-1.5hz 53:71
% output_C(i,k,4)=mean(mean(WCOH(1:14,5000:7500),1)); % Beta last 5 sec

% 12 particiticants

IBS_Hand12=zeros(61,12,4);
IBS_HP12=zeros(61,12,4);
IBS_Passive12=zeros(61,12,4);
IBS_RP12=zeros(61,12,4);
IBS_Solo12=zeros(61,12,4);
IBS_TG12=zeros(61,12,4);
IBS_Vision12=zeros(61,12,4);
% fix bug--solo
IBS_Solo_temp=zeros(61,276,4);
IBS_Solo_temp(:,2:276,:)=IBS_Solo;
IBS_Solo_temp(:,1,:)=IBS_Solo(:,1,:);
IBS_Solo=IBS_Solo_temp;

for i=1:12
    IBS_Hand12(:,i,:)=mean(IBS_Hand(:,(i-1)*23+1:i*23,:),2);
    IBS_HP12(:,i,:)=mean(IBS_HP(:,(i-1)*23+1:i*23,:),2);
    IBS_Passive12(:,i,:)=mean(IBS_Passive(:,(i-1)*23+1:i*23,:),2);
    IBS_RP12(:,i,:)=mean(IBS_RP(:,(i-1)*23+1:i*23,:),2);
    IBS_Solo12(:,i,:)=mean(IBS_Solo(:,(i-1)*23+1:i*23,:),2);
    IBS_TG12(:,i,:)=mean(IBS_TG(:,(i-1)*23+1:i*23,:),2);
    IBS_Vision12(:,i,:)=mean(IBS_Vision(:,(i-1)*23+1:i*23,:),2);
end

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=1; %(2 6 15 24 27) (17 13)
feature=2;

data=zeros(11,7);%% exclusde pair 1
data(1:12,1)=IBS_Vision12(channel,1:12,feature);
data(1:12,2)=IBS_Passive12(channel,1:12,feature);
data(1:12,3)=IBS_Hand12(channel,1:12,feature);
data(1:12,4)=IBS_Solo12(channel,1:12,feature);
data(1:12,5)=IBS_RP12(channel,1:12,feature);
data(1:12,6)=IBS_HP12(channel,1:12,feature);
data(1:12,7)=IBS_TG12(channel,1:12,feature);

figure (1)
boxplot(data,'Labels',{'Vision','Passive','Hand','Solo','RP','HP','TG'})
% ylim([0.2 0.45])
hold on
% scatter 
x = [ones(1,12) 2*ones(1,12) 3*ones(1,12) 4*ones(1,12) 5*ones(1,12) 6*ones(1,12) 7*ones(1,12)];
y1 = data(:,1);
y2 = data(:,2);
y3 = data(:,3);
y4 = data(:,4);
y5 = data(:,5);
y6 = data(:,6);
y7 = data(:,7);

y = [y1; y2; y3; y4; y5; y6; y7];
swarmchart(x,y,'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%check if dyad difference
% trial=1;% change here
% x = [ones(1,23) 2*ones(1,23) 3*ones(1,23) 4*ones(1,23) 5*ones(1,23) 6*ones(1,23) 7*ones(1,23)];
% y1 = data((1:23)*trial,1);
% y2 = data((1:23)*trial,2);
% y3 = data((1:23)*trial,3);
% y4 = data((1:23)*trial,4);
% y5 = data((1:23)*trial,5);
% y6 = data((1:23)*trial,6);
% y7 = data((1:23)*trial,7);
% 
% y = [y1; y2; y3; y4; y5; y6; y7];
% swarmchart(x,y,'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check if trial difference
% range_pre=[1:11, (1:11)+23, (1:11)+23*2,(1:11)+23*3,(1:11)+23*4,(1:11)+23*5,(1:11)+23*6,(1:11)+23*7,(1:11)+23*8,(1:11)+23*9,(1:11)+23*10,(1:11)+23*11];
% range_post=[12:22, (12:22)+23, (12:22)+23*2,(12:22)+23*3,(12:22)+23*4,(12:22)+23*5,(12:22)+23*6,(12:22)+23*7,(12:22)+23*8,(12:22)+23*9,(12:22)+23*10,(12:22)+23*11];
% 
% range=range_post;% change here
% x = [ones(1,132) 2*ones(1,132) 3*ones(1,132) 4*ones(1,132) 5*ones(1,132) 6*ones(1,132) 7*ones(1,132)];
% y1 = data(range,1);
% y2 = data(range,2);
% y3 = data(range,3);
% y4 = data(range,4);
% y5 = data(range,5);
% y6 = data(range,6);
% y7 = data(range,7);
% 
% y = [y1; y2; y3; y4; y5; y6; y7];
% swarmchart(x,y,'.')

hold off

[p,t,stats] = anova1(data)
stats.gnames={'Vision','Passive','Hand','Solo','RP','HP','TG'}';
[c,m,h,gnames] = multcompare(stats)

tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
tbl.("Group") = gnames(tbl.("Group"));
tbl.("Control Group") = gnames(tbl.("Control Group"))
% p = anova1(data(:,5:7))


%%
%freq
%%
%%load data
load('ERP_freq.mat')% change here for time frequency
%             output_freq_domain(i,k,1)=alpha_power;%
%             output_freq_domain(i,k,2)=beta_power;%
%             output_freq_domain(i,k,3)=theta_power;%
%             output_freq_domain(i,k,4)=delta_power;%
%             output_freq_domain(i,k,5)=total_power;%

% 12 particiticants

F_Hand_G12=zeros(61,12,5);
F_HP_G12=zeros(61,12,5);
F_Passive_G12=zeros(61,12,5);
F_RP_G12=zeros(61,12,5);
F_Solo_G12=zeros(61,12,5);
F_TG_G12=zeros(61,12,5);
F_Vision_G12=zeros(61,12,5);

F_Hand_Y12=zeros(61,12,5);
F_HP_Y12=zeros(61,12,5);
F_Passive_Y12=zeros(61,12,5);
F_RP_Y12=zeros(61,12,5);
F_Solo_Y12=zeros(61,12,5);
F_TG_Y12=zeros(61,12,5);
F_Vision_Y12=zeros(61,12,5);
% fix bug--solo
F_Solo_Gtemp=zeros(61,276,5);
F_Solo_Gtemp(:,2:276,:)=F_Solo_G;
F_Solo_Gtemp(:,1,:)=F_Solo_G(:,1,:);
F_Solo_G=F_Solo_Gtemp;

F_Solo_Ytemp=zeros(61,276,5);
F_Solo_Ytemp(:,2:276,:)=F_Solo_Y;
F_Solo_Ytemp(:,1,:)=F_Solo_Y(:,1,:);
F_Solo_Y=F_Solo_Ytemp;

for i=1:12
    F_Hand_G12(:,i,:)=mean(F_Hand_G(:,(i-1)*23+1:i*23,:),2);
    F_HP_G12(:,i,:)=mean(F_HP_G(:,(i-1)*23+1:i*23,:),2);
    F_Passive_G12(:,i,:)=mean(F_Passive_G(:,(i-1)*23+1:i*23,:),2);
    F_RP_G12(:,i,:)=mean(F_RP_G(:,(i-1)*23+1:i*23,:),2);
    F_Solo_G12(:,i,:)=mean(F_Solo_G(:,(i-1)*23+1:i*23,:),2);
   F_TG_G12(:,i,:)=mean(F_TG_G(:,(i-1)*23+1:i*23,:),2);
    F_Vision_G12(:,i,:)=mean(F_Vision_G(:,(i-1)*23+1:i*23,:),2);

    F_Hand_Y12(:,i,:)=mean(F_Hand_Y(:,(i-1)*23+1:i*23,:),2);
    F_HP_Y12(:,i,:)=mean(F_HP_Y(:,(i-1)*23+1:i*23,:),2);
    F_Passive_Y12(:,i,:)=mean(F_Passive_Y(:,(i-1)*23+1:i*23,:),2);
    F_RP_Y12(:,i,:)=mean(F_RP_Y(:,(i-1)*23+1:i*23,:),2);
    F_Solo_Y12(:,i,:)=mean(F_Solo_Y(:,(i-1)*23+1:i*23,:),2);
   F_TG_Y12(:,i,:)=mean(F_TG_Y(:,(i-1)*23+1:i*23,:),2);
    F_Vision_Y12(:,i,:)=mean(F_Vision_Y(:,(i-1)*23+1:i*23,:),2);
end

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=24; %(6 39 15 24 27)
feature=1;


data=zeros(12*2,7);
data(1:12,1)=F_Vision_G12(channel,:,feature);
data(1:12,2)=F_Passive_G12(channel,:,feature);
data(1:12,3)=F_Hand_G12(channel,:,feature);
data(1:12,4)=F_Solo_G12(channel,:,feature);
data(1:12,5)=F_RP_G12(channel,:,feature);
data(1:12,6)=F_HP_G12(channel,:,feature);
data(1:12,7)=F_TG_G12(channel,:,feature);


data(13:24,1)=F_Vision_Y12(channel,:,feature);
data(13:24,2)=F_Passive_Y12(channel,:,feature);
data(13:24,3)=F_Hand_Y12(channel,:,feature);
data(13:24,4)=F_Solo_Y12(channel,:,feature);
data(13:24,5)=F_RP_Y12(channel,:,feature);
data(13:24,6)=F_HP_Y12(channel,:,feature);
data(13:24,7)=F_TG_Y12(channel,:,feature);

figure (2)
boxplot(data,'Labels',{'Vision','Passive','Hand','Solo','RP','HP','TG'})
% ylim([0 250])
hold on
% scatter 
x = [ones(1,12*2) 2*ones(1,12*2) 3*ones(1,12*2) 4*ones(1,12*2) 5*ones(1,12*2) 6*ones(1,12*2) 7*ones(1,12*2)];
y1 = data(:,1);
y2 = data(:,2);
y3 = data(:,3);
y4 = data(:,4);
y5 = data(:,5);
y6 = data(:,6);
y7 = data(:,7);

y = [y1; y2; y3; y4; y5; y6; y7];
swarmchart(x,y,'.')
hold off
% p = anova1(data)
% p = anova1(data(:,5:7))
[p,t,stats] = anova1(data)
stats.gnames={'Vision','Passive','Hand','Solo','RP','HP','TG'}';
[c,m,h,gnames] = multcompare(stats)

tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
tbl.("Group") = gnames(tbl.("Group"));
tbl.("Control Group") = gnames(tbl.("Control Group"))

% test 12 vs 12 point
channel=24; %(6 39 15 24 27)
feature=1;
figure(3)

scatter(1,F_Vision_G12(channel,:,feature),'.','red')
hold on
scatter(1.2,F_Vision_Y12(channel,:,feature),'*','red')

scatter(2,F_Passive_G12(channel,:,feature),'.','red')
scatter(2.2,F_Passive_Y12(channel,:,feature),'*','red')

scatter(3,F_Hand_G12(channel,:,feature),'.','red')
scatter(3.2,F_Hand_Y12(channel,:,feature),'*','red')

scatter(4,F_Solo_G12(channel,:,feature),'.','red')
scatter(4.2,F_Solo_Y12(channel,:,feature),'*','red')

scatter(5,F_HP_G12(channel,:,feature),'.','red')
scatter(5.2,F_HP_Y12(channel,:,feature),'*','red')

scatter(6,F_RP_G12(channel,:,feature),'.','red')
scatter(6.2,F_RP_Y12(channel,:,feature),'*','red')


scatter(7,F_TG_G12(channel,:,feature),'.','red')
scatter(7.2,F_TG_Y12(channel,:,feature),'*','red')
hold off

figure(4)
scatter(F_Vision_G12(channel,:,feature),F_Vision_Y12(channel,:,feature))
hold on
scatter(F_Passive_G12(channel,:,feature),F_Passive_Y12(channel,:,feature))
scatter(F_Hand_G12(channel,:,feature),F_Hand_Y12(channel,:,feature))
scatter(F_Solo_G12(channel,:,feature),F_Solo_Y12(channel,:,feature))
scatter(F_Vision_G12(channel,:,feature),F_Vision_Y12(channel,:,feature))
hold on
scatter(F_HP_G12(channel,:,feature),F_HP_Y12(channel,:,feature))
scatter(F_RP_G12(channel,:,feature),F_RP_Y12(channel,:,feature))
scatter(F_TG_G12(channel,:,feature),F_TG_Y12(channel,:,feature))
hold off

%%
%%
%%load data
load('ERP_hyper.mat')% change here for time frequency
% 
%         output_C(i,k,1)=R(1,2);%corrlation
%         output_C(i,k,2)=mean(cxy(34:55));%coherence- 8-13
%         output_C(i,k,3)=mean(cxy(3:18));%corrlation 1-4Hz
%         output_C(i,k,4)=mean(cxy(55:121));%coherence 13-30

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=1; %(6 39 15 24 27)
feature=1;


data=zeros(276,7);
data(:,1)=C_Vision(channel,:,feature);
data(:,2)=C_Passive(channel,:,feature);
data(:,3)=C_Hand(channel,:,feature);
data(1:275,4)=C_Solo(channel,:,feature);% C_solo reject 1 trial pair
data(:,5)=C_RP(channel,:,feature);
data(:,6)=C_HP(channel,:,feature);
data(:,7)=C_TG(channel,:,feature);

figure (1)
boxplot(data,'Labels',{'Vision','Passive','Hand','Solo','RP','HP','TG'})

hold on
% scatter 
x = [ones(1,276) 2*ones(1,276) 3*ones(1,276) 4*ones(1,276) 5*ones(1,276) 6*ones(1,276) 7*ones(1,276)];
y1 = data(:,1);
y2 = data(:,2);
y3 = data(:,3);
y4 = data(:,4);
y5 = data(:,5);
y6 = data(:,6);
y7 = data(:,7);

y = [y1; y2; y3; y4; y5; y6; y7];
swarmchart(x,y,'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %check if dyad difference
% trial=9;% change here
% x = [ones(1,23) 2*ones(1,23) 3*ones(1,23) 4*ones(1,23) 5*ones(1,23) 6*ones(1,23) 7*ones(1,23)];
% y1 = data((1:23)*trial,1);
% y2 = data((1:23)*trial,2);
% y3 = data((1:23)*trial,3);
% y4 = data((1:23)*trial,4);
% y5 = data((1:23)*trial,5);
% y6 = data((1:23)*trial,6);
% y7 = data((1:23)*trial,7);
% 
% y = [y1; y2; y3; y4; y5; y6; y7];
% swarmchart(x,y,'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check if trial difference
% range_pre=[1:11, (1:11)+23, (1:11)+23*2,(1:11)+23*3,(1:11)+23*4,(1:11)+23*5,(1:11)+23*6,(1:11)+23*7,(1:11)+23*8,(1:11)+23*9,(1:11)+23*10,(1:11)+23*11];
% range_post=[12:22, (12:22)+23, (12:22)+23*2,(12:22)+23*3,(12:22)+23*4,(12:22)+23*5,(12:22)+23*6,(12:22)+23*7,(12:22)+23*8,(12:22)+23*9,(12:22)+23*10,(12:22)+23*11];
% 
% range=range_pre;% change here
% x = [ones(1,132) 2*ones(1,132) 3*ones(1,132) 4*ones(1,132) 5*ones(1,132) 6*ones(1,132) 7*ones(1,132)];
% y1 = data(range,1);
% y2 = data(range,2);
% y3 = data(range,3);
% y4 = data(range,4);
% y5 = data(range,5);
% y6 = data(range,6);
% y7 = data(range,7);
% 
% y = [y1; y2; y3; y4; y5; y6; y7];
% swarmchart(x,y,'.')
hold off

[p,t,stats] = anova1(data)
[c,m,h,gnames] = multcompare(stats)
% p = anova1(data)
% p = anova1(data(:,5:7))

%%
%entropy
%%
%%load data
load('ERP_FuzzEn.mat')% change here for time frequency

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=13; %(6 39 15 24 27)(13 17)
feature=1;


data=zeros(276*2,7);
data(1:276,1)=FuzzEn_Vision_G(channel,:,feature);
data(1:276,2)=FuzzEn_Passive_G(channel,:,feature);
data(1:276,3)=FuzzEn_Hand_G(channel,:,feature);
data(1:275,4)=FuzzEn_Solo_G(channel,:,feature);% C_solo reject 1 trial pair
data(1:276,5)=FuzzEn_RP_G(channel,:,feature);
data(1:276,6)=FuzzEn_HP_G(channel,:,feature);
data(1:276,7)=FuzzEn_TG_G(channel,:,feature);


data(277:552,1)=FuzzEn_Vision_G(channel,:,feature);
data(277:552,2)=FuzzEn_Passive_G(channel,:,feature);
data(277:552,3)=FuzzEn_Hand_G(channel,:,feature);
data(277:552-1,4)=FuzzEn_Solo_G(channel,:,feature);% C_solo reject 1 trial pair
data(277:552,5)=FuzzEn_RP_G(channel,:,feature);
data(277:552,6)=FuzzEn_HP_G(channel,:,feature);
data(277:552,7)=FuzzEn_TG_G(channel,:,feature);

figure (2)
boxplot(data,'Labels',{'Vision','Passive','Hand','Solo','RP','HP','TG'})
% ylim([0 250])
hold on
% scatter 
x = [ones(1,276*2) 2*ones(1,276*2) 3*ones(1,276*2) 4*ones(1,276*2) 5*ones(1,276*2) 6*ones(1,276*2) 7*ones(1,276*2)];
y1 = data(:,1);
y2 = data(:,2);
y3 = data(:,3);
y4 = data(:,4);
y5 = data(:,5);
y6 = data(:,6);
y7 = data(:,7);

y = [y1; y2; y3; y4; y5; y6; y7];
swarmchart(x,y,'.')
hold off

[p,t,stats] = anova1(data);
[c,m,h,gnames] = multcompare(stats);
tbl1 = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"])
% p = anova1(data)
% p = anova1(data(:,5:7))

%HP RP TG
% 
% channel=24;
% feature=1;
% data=zeros(276,3);
% data(:,1)=C_RP(channel,:,feature);
% data(:,2)=C_HP(channel,:,feature);
% data(:,3)=C_TG(channel,:,feature);
% figure (2)
% boxplot(data,'Labels',{'RP','HP','TG'})
% ylim([0 15])