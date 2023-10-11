function [output_C]= TLH3_ibs_wtc_extraction(erpdata1,erpdata2)

output_C=zeros(61,size(erpdata1,3),4);
%     output_entropy=zeros(61,size(erpdata,3),3);
wb= waitbar(0,'this step takes a lot time')
for k=1:size(erpdata1,3)
    waitbar(k/size(erpdata1,3));
    for i=1:61
        data1=erpdata1(i,:,k);
        data2=erpdata2(i,:,k);
        %time domain analysis
        %             [M,S,CV,RMS]= TL3_corr_timedomain(data);%
%         R = corrcoef(data1,data2);
%         [cxy,f] = mscohere(data1,data2,[],[],[],500);
%[Rsq,period,scale,coi,sig95]=wtc(data1,data2,500);
[WCOH,WCS,F]=wcoherence(data1,data2,500,'FrequencyLimits',[0.1 30]);


% Alpha 14:23
% 0.5-1.5hz 53:71
%IBS= Wcoh select frequency band
output_C(i,k,1)=mean(mean(WCOH(1:14,:),1));%Beta 1:14   13-30hz
        output_C(i,k,2)=mean(mean(WCOH(14:23,:),1));%Alpha 14:23 8-13Hz
        output_C(i,k,3)=mean(mean(WCOH(53:71,:),1));% 0.5-1.5hz 53:71
        output_C(i,k,4)=mean(mean(WCOH(1:14,5000:7500),1)); % Beta last 5 sec


%         R5 = corrcoef(data1(4500:7000),data2(4500:7000));
%         cxy5 = mscohere(data1(4500:7000),data2(4500:7000));
% ww=1;
%         output_C(i,k,1)=R(1,2);%corrlation
%         output_C(i,k,2)=mean(cxy(34:55));%coherence- 8-13
%         output_C(i,k,3)=mean(cxy(3:18));%corrlation 1-4Hz
%         output_C(i,k,4)=mean(cxy(55:121));%coherence 13-30



        %             output_C(i,k,3)=CV;%Coefficient of variation
        %             output_C(i,k,4)=RMS;% root-mean-square (RMS)
        %entropy analysis
        %             m=2; r=0.25;
        %             output_entropy(i,k,1)= TL3_FuzzyEn(data,m,r);
        %         output_entropy(i,k,2)=TL3_SampEn(data,m,r);
        %         output_entropy(i,k,3)=TL3_ApEn(data,m,r);
    end


end
delete(wb);

end