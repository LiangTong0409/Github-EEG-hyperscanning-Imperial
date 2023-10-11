function [output_entropy]= TLH3_feature_extraction(erpdata)


interested_channels=[6 39 15 24 27 17 13];%%%%to save time % only run interested channels
%     output_time_domain=zeros(32,size(erpdata,3),4);
    output_entropy=zeros(61,size(erpdata,3),3);
    wb= waitbar(0,'this step takes a lot time')
    for k=1:size(erpdata,3)

        waitbar(k/size(erpdata,3));
        for i=interested_channels(1:end) %%%%to save time
            data=erpdata(i,:,k);
%             %time domain analysis
%             [M,S,CV,RMS]= TL3_corr_timedomain(data);%
%             output_time_domain(i,k,1)=M;%mean
%             output_time_domain(i,k,2)=S;%STD
%             output_time_domain(i,k,3)=CV;%Coefficient of variation
%             output_time_domain(i,k,4)=RMS;% root-mean-square (RMS)
            %entropy analysis
            m=2; r=0.25;
            %tic
            output_entropy(i,k,1)= TLH3_FuzzyEn(data,m,r);
            %toc
            %         output_entropy(i,k,2)=TL3_SampEn(data,m,r);
            %         output_entropy(i,k,3)=TL3_ApEn(data,m,r);
        end

    end
   delete(wb); 
end



