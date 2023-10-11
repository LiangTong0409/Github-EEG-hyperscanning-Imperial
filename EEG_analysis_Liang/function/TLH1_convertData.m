function [] = TLH1_convertData(sub,exp)

%Convert data from eeg format to .set (EEGlab) format

    % wrong name when exp, change here

    if sub==1230 
        sub=3120;
        disp('change!!!!!!!!!!!!!! 1230 to 3120')

    elseif sub==3120
        sub=1230;
        disp('change!!!!!!! 3120 to 1230')

    end


for color =1:2 % Green or yellow 1=G 2=Y

    EEG = pop_loadbv%( 'filename',filename1,'filepath','C:\Users\Liang Tong\OneDrive\文档\Data_test');
    disp('Check: subject_num:')
    disp(num2str(sub))
    disp('subject_color:')
    disp(num2str(exp.name{color}))
    EEG = eeg_checkset( EEG );
    filename = ['c_'  num2str(sub) exp.name{color} ];
    EEG = pop_saveset(EEG, filename, exp.preprocessingpath);
end

end