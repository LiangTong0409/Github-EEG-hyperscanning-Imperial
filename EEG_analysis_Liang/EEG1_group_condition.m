%1拆分EEG文件
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
% experiment conditions
con=[1 2 3 7 8 9 10];%%%%%%%%%%%%%%%%%%%%%change here 7 8 9 10 1 2 3

for con = con(1:end)
    switch con
        case 7 % solo
            range=1:23;
            filename = ['Solo'];
            range3210G=range(2:23);% solo range 3:23 for 3210G
            range3210Y=range(1:22);% solo range 1:21 for 3210Y ;beaause '''3210Y''' missing 1 trials

        case 8
            range=93:115;
            filename=  ['Passive'];
            range3210G=range;%
            range3210Y=range-1;%
        case 9
            range=116:138;
            filename=  ['Vision'];
            range3210G=range;%
            range3210Y=range-1;%
        case 10
            range=139:161;
            filename=  ['Hand'];
            range3210G=range;%
            range3210Y=range-1;%


    end



    for color =1:2 % Green or yellow 1=G 2=Y
        % 3210 as start beaause '''3210Y''' missing 2 trials
        EEG = pop_loadset([exp.preprocessingpath 'ab_cICAICAriMaf2c_3210'  exp.name{color} '.set']);

        switch con
            case 1
                range=70:92;
                filename=  ['RP'];
                range3210G=range;%
                range3210Y=range-1;%
            case 2
                range=47:69;
                filename=  ['HP'];
                range3210G=range;%
                range3210Y=range-1;%
            case 3
                range=24:46;
                filename=  ['TG'];
                range3210G=range;%
                range3210Y=range-1;%
        end



        if color==1
            range3210=range3210G;
        elseif color==2
            range3210=range3210Y;
        end

        mergedEEG=pop_select(EEG,'trial' ,range3210); %

        for sub = exp.sub_id(1:end)

            EEG = pop_loadset([exp.preprocessingpath 'ab_cICAICAriMaf2c_'  num2str(sub) exp.name{color} '.set']);


            switch con
                case 1
                    if sub==123 || sub==3120 % bug fix, mode 123 here
                        range=24:46;
                    elseif sub==132 || sub==1320
                        range=24:46;
                    elseif sub==213 || sub==2130
                        range=47:69;
                    elseif sub==312 || sub==1230 % bug fix, mode 312 here
                        range=47:69;
                    elseif sub==231 || sub==2310
                        range=70:92;
                    elseif sub==321 % 3210 used before as a starter and missing 1 trial 3210Y
                        range=70:92;
                    end
                case 2
                    if sub==123 || sub==3120 % bug fix, mode 123 here
                        range=47:69;
                    elseif sub==132 || sub==1320
                        range=70:92;
                    elseif sub==213 || sub==2130
                        range=24:46;
                    elseif sub==312 || sub==1230 % bug fix, mode 312 here
                        range=70:92;
                    elseif sub==231 || sub==2310
                        range=24:46;
                    elseif sub==321 % 3210 used before as a starter and missing 1 trial 3210Y
                        range=47:69;
                    end

                case 3
                    if sub==123 || sub==3120 % bug fix, mode 123 here
                        range=70:92;
                    elseif sub==132 || sub==1320
                        range=47:69;
                    elseif sub==213 || sub==2130
                        range=70:92;
                    elseif sub==312 || sub==1230 % bug fix, mode 312 here
                        range=24:46;
                    elseif sub==231 || sub==2310
                        range=47:69;
                    elseif sub==321 % 3210 used before as a starter and missing 1 trial 3210Y
                        range=24:46;
                    end

            end

            OUTEEG= pop_select(EEG,'trial' ,range);

            mergedEEG = pop_mergeset(mergedEEG, OUTEEG);
        end

        mergedEEG = eeg_checkset( mergedEEG );
        filename = [filename '_' exp.name{color}];
        mergedEEG = pop_saveset( mergedEEG, filename, exp.plotpath );
    end
end






