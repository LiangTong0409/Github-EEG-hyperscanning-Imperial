
%提取不同条件3维矩阵 channel*trial*特征值
%%
%% Toolbox requirements: 

% wavelet choerence transforn toolbox
%%
% Author: Liang Tong
% Date: 19/8/2022

clc
clear
addpath(genpath('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning'));%code and data path

%% Set experimental analysis parameters
%exp.sub_id = [123,132];
exp.sub_id = [123,132,213,231,312,321,1230,1320,2130,2310,3120,3210];

[exp] = TLH1_setup(exp);
%%
%wtc for IBS % 3 hours
con=[1 2 3 7 8 9 10];%%%%%%%%%%%%%%%%%%%%%change here 7 8 9 10 1 2 3

for con = con(1:end)
    switch con
        case 1
            filename = ['RP'];
        case 2
            filename = ['HP'];
        case 3
            filename = ['TG'];            
        case 7
            filename = ['Solo'];
        case 8
            filename = ['Passive'];
        case 9
            filename = ['Vision'];
        case 10
            filename = ['Hand'];
    end

    EEG_G = pop_loadset([exp.plotpath filename '_G' '.set'])
    EEG_Y = pop_loadset([exp.plotpath filename '_Y' '.set'])


    % EEG=pop_resample(EEG,100);
    [output_C]=TLH3_ibs_wtc_extraction(EEG_G.data,EEG_Y.data);
    switch con
        case 1
            IBS_RP=output_C;
        case 2
            IBS_HP=output_C;
        case 3
            IBS_TG=output_C;        
        case 7
            IBS_Solo=output_C;
        case 8
            IBS_Passive=output_C;
        case 9
            IBS_Vision =output_C;
        case 10
            IBS_Hand=output_C;


    end
end


cd('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\plot\');
save('ERP_IBS_wtc','IBS_RP','IBS_HP','IBS_TG','IBS_Solo','IBS_Passive','IBS_Vision','IBS_Hand');
disp("saved")
%%
%corr and coherence
con=[1 2 3 7 8 9 10];%%%%%%%%%%%%%%%%%%%%%change here 7 8 9 10 1 2 3

for con = con(1:end)
    switch con
        case 1
            filename = ['RP'];
        case 2
            filename = ['HP'];
        case 3
            filename = ['TG'];            
        case 7
            filename = ['Solo'];
        case 8
            filename = ['Passive'];
        case 9
            filename = ['Vision'];
        case 10
            filename = ['Hand'];
    end

    EEG_G = pop_loadset([exp.plotpath filename '_G' '.set'])
    EEG_Y = pop_loadset([exp.plotpath filename '_Y' '.set'])


    % EEG=pop_resample(EEG,100);
    [output_C]=TLH3_hyper_extraction(EEG_G.data,EEG_Y.data);
    switch con
        case 1
            C_RP=output_C;
        case 2
            C_HP=output_C;
        case 3
            C_TG=output_C;
        
        case 7
            C_Solo=output_C;
        case 8
            C_Passive=output_C;
        case 9
            C_Vision =output_C;
        case 10
            C_Hand=output_C;


    end
end


cd('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\plot\');
save('ERP_hyper','C_RP','C_HP','C_TG','C_Solo','C_Passive','C_Vision','C_Hand');
disp("saved")

%%

%frequency domain
con=[1 2 3 7 8 9 10];%%%%%%%%%%%%%%%%%%%%%change here 7 8 9 10 1 2 3

for con = con(1:end)
    switch con
        case 1
            filename = ['RP'];
        case 2
            filename = ['HP'];
        case 3
            filename = ['TG'];            
        case 7
            filename = ['Solo'];
        case 8
            filename = ['Passive'];
        case 9
            filename = ['Vision'];
        case 10
            filename = ['Hand'];
    end

    EEG_G = pop_loadset([exp.plotpath filename '_G' '.set'])
    EEG_Y = pop_loadset([exp.plotpath filename '_Y' '.set'])


    % EEG=pop_resample(EEG,100);
    [output_G,output_fft]=TLH3_freq_extraction(EEG_G.data);
    [output_Y,output_fft]=TLH3_freq_extraction(EEG_Y.data);
    switch con
        case 1
            F_RP_G=output_G;
            F_RP_Y=output_Y;
        case 2
            F_HP_G=output_G;
            F_HP_Y=output_Y;
        case 3
            F_TG_G=output_G; 
            F_TG_Y=output_Y; 
        case 7
            F_Solo_G=output_G;
            F_Solo_Y=output_Y;
        case 8
            F_Passive_G=output_G;
            F_Passive_Y=output_Y;
        case 9
            F_Vision_G =output_G;
            F_Vision_Y =output_Y;
        case 10
            F_Hand_G=output_G;
            F_Hand_Y=output_Y;


    end
end


cd('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\plot\');
save('ERP_freq','F_RP_G','F_RP_Y','F_HP_G','F_HP_Y','F_TG_G','F_TG_Y','F_Solo_G','F_Solo_Y','F_Passive_G','F_Passive_Y','F_Vision_G','F_Vision_Y','F_Hand_G','F_Hand_Y');
disp("saved")

%%

%entropy  8 hours
con=[1 2 3 7 8 9 10];%%%%%%%%%%%%%%%%%%%%%change here 7 8 9 10 1 2 3

for con = con(1:end)
    switch con
        case 1
            filename = ['RP'];
        case 2
            filename = ['HP'];
        case 3
            filename = ['TG'];            
        case 7
            filename = ['Solo'];
        case 8
            filename = ['Passive'];
        case 9
            filename = ['Vision'];
        case 10
            filename = ['Hand'];
    end

    EEG_G = pop_loadset([exp.plotpath filename '_G' '.set'])
    EEG_Y = pop_loadset([exp.plotpath filename '_Y' '.set'])


    % EEG=pop_resample(EEG,100);

        EEG_G=pop_resample(EEG_G,125);% to save time
          EEG_Y=pop_resample(EEG_Y,125);% to save time



    [output_entropy_G]=TLH3_entropy_extraction(EEG_G.data);
    [output_entropy_Y]=TLH3_entropy_extraction(EEG_Y.data);
%     [output_G,output_fft]=TLH3_freq_extraction(EEG_G.data);
%     [output_Y,output_fft]=TLH3_freq_extraction(EEG_Y.data);
    switch con
        case 1
            FuzzEn_RP_G=output_entropy_G;
            FuzzEn_RP_Y=output_entropy_Y;
        case 2
            FuzzEn_HP_G=output_entropy_G;
            FuzzEn_HP_Y=output_entropy_Y;
        case 3
            FuzzEn_TG_G=output_entropy_G; 
            FuzzEn_TG_Y=output_entropy_Y; 
        case 7
            FuzzEn_Solo_G=output_entropy_G;
            FuzzEn_Solo_Y=output_entropy_Y;
        case 8
            FuzzEn_Passive_G=output_entropy_G;
            FuzzEn_Passive_Y=output_entropy_Y;
        case 9
            FuzzEn_Vision_G =output_entropy_G;
            FuzzEn_Vision_Y =output_entropy_Y;
        case 10
            FuzzEn_Hand_G=output_entropy_G;
            FuzzEn_Hand_Y=output_entropy_Y;


    end
end


cd('C:\Users\Liang Tong\OneDrive - Imperial College London\IC\s2\IC-project\hyperscanning\EEG_analysis_Liang\plot\');
save('ERP_FuzzEn','FuzzEn_RP_G','FuzzEn_RP_Y','FuzzEn_HP_G','FuzzEn_HP_Y','FuzzEn_TG_G','FuzzEn_TG_Y','FuzzEn_Solo_G','FuzzEn_Solo_Y','FuzzEn_Passive_G','FuzzEn_Passive_Y','FuzzEn_Vision_G','FuzzEn_Vision_Y','FuzzEn_Hand_G','FuzzEn_Hand_Y');
disp("saved")




