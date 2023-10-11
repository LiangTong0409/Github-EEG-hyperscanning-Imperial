%%--------------------------------------------------------------------------------------------
%% select matrix and plot, similiar to the code below 
% 3. EEG plot script

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

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=1; %(6 39 15 24 27) (17 13)
feature=1;

data=zeros(276,7);
data(:,1)=IBS_Vision(channel,:,feature);
data(:,2)=IBS_Passive(channel,:,feature);
data(:,3)=IBS_Hand(channel,:,feature);
data(1:275,4)=IBS_Solo(channel,:,feature);% C_solo reject 1 trial pair
data(:,5)=IBS_RP(channel,:,feature);
data(:,6)=IBS_HP(channel,:,feature);
data(:,7)=IBS_TG(channel,:,feature);

figure (1)
boxplot(data,'Labels',{'Vision','Passive','Hand','Solo','RP','HP','TG'})
% ylim([0.2 0.45])
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
% trial=5;% change here
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
tbl1 = array2table(c,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"])
% p = anova1(data(:,5:7))
%%
%%load data
load('ERP_hyper.mat')% change here for time frequency
% 
%         output_C(i,k,1)=R(1,2);%corrlation
%         output_C(i,k,2)=mean(cxy(34:55));%coherence- 8-13
%         output_C(i,k,3)=mean(cxy(3:18));%corrlation 1-4Hz
%         output_C(i,k,4)=mean(cxy(55:121));%coherence 13-30

%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=6; %(6 39 15 24 27)
feature=2;


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
% swarmchart(x,y,'.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %check if dyad difference
trial=9;% change here
x = [ones(1,23) 2*ones(1,23) 3*ones(1,23) 4*ones(1,23) 5*ones(1,23) 6*ones(1,23) 7*ones(1,23)];
y1 = data((1:23)*trial,1);
y2 = data((1:23)*trial,2);
y3 = data((1:23)*trial,3);
y4 = data((1:23)*trial,4);
y5 = data((1:23)*trial,5);
y6 = data((1:23)*trial,6);
y7 = data((1:23)*trial,7);

y = [y1; y2; y3; y4; y5; y6; y7];
swarmchart(x,y,'.')
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
stats.gnames={'Vision','Passive','Hand','Solo','RP','HP','TG'}';
[c,m,h,gnames] = multcompare(stats)
% p = anova1(data)
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
%% Vision and Passive no haptic feedback vs all haptic feedback 
channel=6; %(6 39 15 24 27)
feature=1;


data=zeros(276*2,7);
data(1:276,1)=F_Vision_G(channel,:,feature);
data(1:276,2)=F_Passive_G(channel,:,feature);
data(1:276,3)=F_Hand_G(channel,:,feature);
data(1:275,4)=F_Solo_G(channel,:,feature);% C_solo reject 1 trial pair
data(1:276,5)=F_RP_G(channel,:,feature);
data(1:276,6)=F_HP_G(channel,:,feature);
data(1:276,7)=F_TG_G(channel,:,feature);


data(277:552,1)=F_Vision_G(channel,:,feature);
data(277:552,2)=F_Passive_G(channel,:,feature);
data(277:552,3)=F_Hand_G(channel,:,feature);
data(277:552-1,4)=F_Solo_G(channel,:,feature);% C_solo reject 1 trial pair
data(277:552,5)=F_RP_G(channel,:,feature);
data(277:552,6)=F_HP_G(channel,:,feature);
data(277:552,7)=F_TG_G(channel,:,feature);

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
% p = anova1(data)
% p = anova1(data(:,5:7))
[p,t,stats] = anova1(data)
stats.gnames={'Vision','Passive','Hand','Solo','RP','HP','TG'}';
[c,m,h,gnames] = multcompare(stats)

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
stats.gnames={'Vision','Passive','Hand','Solo','RP','HP','TG'}';
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

% 
% 
% 
% %% low vs high stifness
% 
% channel=25;
% feature=2;
% 
% data=zeros(300,2);
% data(1:100,1)=Time_HP_H(channel,:,feature);
% data(101:200,1)=Time_RP_H(channel,:,feature);
% data(201:300,1)=Time_TG_H(channel,:,feature);
% data(1:100,2)=Time_HP_L(channel,:,feature);
% data(101:200,2)=Time_RP_L(channel,:,feature);
% data(201:300,2)=Time_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'High stifness','Low stifness'})
% ylim([0 15])
% 
% %% HP vs RP vs TG high stifness
% channel=25;
% feature=2;
% 
% data=zeros(100,3);
% data(1:100,1)=Time_HP_H(channel,:,feature);
% data(1:100,2)=Time_RP_H(channel,:,feature);
% data(1:100,3)=Time_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% 
% %% HP vs RP vs TG low stifness
% channel=25;
% feature=2;
% 
% data=zeros(100,3);
% data(1:100,1)=Time_HP_L(channel,:,feature);
% data(1:100,2)=Time_RP_L(channel,:,feature);
% data(1:100,3)=Time_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% ylim([0 15])
% %% all condition
% channel=17;
% feature=2;
% 
% data=zeros(100,5);
% data(:,1)=Time_Solo_S(channel,:,feature);
% data(:,2)=Time_Passive(channel,:,feature);
% data(:,3)=Time_HP_H(channel,:,feature);
% data(:,4)=Time_RP_H(channel,:,feature);
% data(:,5)=Time_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'Solo','Passive','HP','RP','TG'})
% % if feature==1
% %     title('Mean')
% %     ylim([-3 3])
% % end
% 
% %% Frequency domain plot
% 
% load('ERP_Matrix_Freq.mat')% change here for time frequency
% % %alpha_band = [8 13]; % Alpha band frequency range in Hz
% % beta_band = [14 30]; % Beta band frequency range in Hz
% % theta_band = [4 7]; % Theta band frequency range in Hz
% % delta_band = [1 4]; % Delta band frequency range in Hz
% 
% %         output_freq_domain(i,1)=alpha_power;%
% %         output_freq_domain(i,2)=beta_power;%
% %         output_freq_domain(i,3)=theta_power;%
% %         output_freq_domain(i,4)=delta_power;%
% %         output_freq_domain(i,5)=total_power;%
% %% Solo and Passive no haptic feedback vs all haptic feedback
% channel=25;
% feature=2;
% 
% data=zeros(100,2);
% data(:,1)=Freq_Solo_S(channel,:,feature);
% data(:,2)=Freq_Passive(channel,:,feature);
% 
% 
% boxplot(data,'Labels',{'Solo','Passive'})
% %ylim([0 15])
% 
% %% low vs high stifness
% 
% channel=25;
% feature=2;
% 
% data=zeros(300,2);
% data(1:100,1)=Freq_HP_H(channel,:,feature);
% data(101:200,1)=Freq_RP_H(channel,:,feature);
% data(201:300,1)=Freq_TG_H(channel,:,feature);
% data(1:100,2)=Freq_HP_L(channel,:,feature);
% data(101:200,2)=Freq_RP_L(channel,:,feature);
% data(201:300,2)=Freq_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'High stifness','Low stifness'})
% %ylim([0 1.2])
% 
% 
% %% HP vs RP vs TG high stifness
% channel=25;
% feature=2;
% 
% data=zeros(100,3);
% data(1:100,1)=Freq_HP_H(channel,:,feature);
% data(1:100,2)=Freq_RP_H(channel,:,feature);
% data(1:100,3)=Freq_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% 
% %% HP vs RP vs TG low stifness
% channel=25;
% feature=2;
% 
% data=zeros(100,3);
% data(1:100,1)=Freq_HP_L(channel,:,feature);
% data(1:100,2)=Freq_RP_L(channel,:,feature);
% data(1:100,3)=Freq_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% 
% %% all condition
% channel=25;
% feature=4;
% 
% data=zeros(100,5);
% data(:,1)=Freq_Solo_S(channel,:,feature);
% data(:,2)=Freq_Passive(channel,:,feature);
% data(:,3)=Freq_HP_H(channel,:,feature);
% data(:,4)=Freq_RP_H(channel,:,feature);
% data(:,5)=Freq_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'Solo','Passive','HP','RP','TG'})
% %ylim([0 2.5])
% 
% 
% 
% 
% %% Entropy plot
% 
% load('ERP_Matrix_Entropy.mat')% change here for time frequency
% 
% %% Solo and Passive no haptic feedback vs all haptic feedback
% channel=25;
% feature=1;
% 
% data=zeros(100,2);
% data(:,1)=Entropy_Solo_S(channel,:,feature);
% data(:,2)=Entropy_Passive(channel,:,feature);
% 
% 
% boxplot(data,'Labels',{'Solo','Passive'})
% %ylim([0 15])
% 
% %% low vs high stifness
% 
% channel=25;
% feature=1;
% 
% data=zeros(300,2);
% data(1:100,1)=Entropy_HP_H(channel,:,feature);
% data(101:200,1)=Entropy_RP_H(channel,:,feature);
% data(201:300,1)=Entropy_TG_H(channel,:,feature);
% data(1:100,2)=Entropy_HP_L(channel,:,feature);
% data(101:200,2)=Entropy_RP_L(channel,:,feature);
% data(201:300,2)=Entropy_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'High stifness','Low stifness'})
% %ylim([0 1.2])
% 
% 
% %% HP vs RP vs TG high stifness
% channel=25;
% feature=1;
% 
% data=zeros(100,3);
% data(1:100,1)=Entropy_HP_H(channel,:,feature);
% data(1:100,2)=Entropy_RP_H(channel,:,feature);
% data(1:100,3)=Entropy_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% 
% %% HP vs RP vs TG low stifness
% channel=25;
% feature=1;
% 
% data=zeros(100,3);
% data(1:100,1)=Entropy_HP_L(channel,:,feature);
% data(1:100,2)=Entropy_RP_L(channel,:,feature);
% data(1:100,3)=Entropy_TG_L(channel,:,feature);
% 
% boxplot(data,'Labels',{'HP','RP','TG'})
% 
% %% all condition
% channel=25;
% feature=1;
% 
% data=zeros(100,5);
% data(:,1)=Entropy_Solo_S(channel,:,feature);
% data(:,2)=Entropy_Passive(channel,:,feature);
% data(:,3)=Entropy_HP_H(channel,:,feature);
% data(:,4)=Entropy_RP_H(channel,:,feature);
% data(:,5)=Entropy_TG_H(channel,:,feature);
% 
% boxplot(data,'Labels',{'Solo','Passive','HP','RP','TG'})
%ylim([0 2.5])