function [output_freq_domain,output_fft]= TLH3_freq_extraction(erpdata)


    output_freq_domain=zeros(61,size(erpdata,3),5);
    output_fft=zeros(61,size(erpdata,3),257);

    wb= waitbar(0,'this step takes a lot time')
    for k=1:size(erpdata,3)

        waitbar(k/size(erpdata,3));
        for i=1:61
            data=erpdata(i,:,k);
            
          
            [alpha_power,beta_power,theta_power,delta_power,total_power,fft_data]=TLH3_corr_power(data);
            output_freq_domain(i,k,1)=alpha_power;%
            output_freq_domain(i,k,2)=beta_power;%
            output_freq_domain(i,k,3)=theta_power;%
            output_freq_domain(i,k,4)=delta_power;%
            output_freq_domain(i,k,5)=total_power;%
            %output_fft(i,1:length(fft_data))=fft_data;
        end

    end
    delete(wb);


end