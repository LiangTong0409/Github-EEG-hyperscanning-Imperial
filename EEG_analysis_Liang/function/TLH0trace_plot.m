
Fs=512;

t = 0:1/Fs:15-1/Fs;

p=18.51.*sin((pi.*t)/1.547).*sin((pi.*t)/2.875);
figure(1)
plot(t,p)
title('Trace');
xlabel('Time'); 
ylabel('Amplitude');

%%
figure(2);
N=length(p)
y0 = abs(fft(p)); 
%f= n*(fs/N)
f = (0:N-1)*Fs/N
plot(f,y0);
xlim([0 10])
xlabel('Frequency'); 
ylabel('Amplitude'); 