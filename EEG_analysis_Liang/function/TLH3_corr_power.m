function [alpha_power,beta_power,theta_power,delta_power,total_power,fft_data]=TLH3_corr_power(x)%corr_power(x,n)
%计算数据的功率，x是待计算数据

% signal_data=x;
% % Define signal properties
% fs = 250; % Hz (sampling frequency)
% T = 1/fs; % s (sampling period)
% L = length(signal_data); % number of samples
% t = (0:L-1)*T; % time vector
% 
% % Compute the FFT of the signal
% fft_data = abs(fft(signal_data));
% fft_data = fft_data(1:L/2); % discard negative frequency components
% 
% % Compute the frequency axis of the FFT
% freq_axis = linspace(0, fs/2, L/2);
% 
% % Plot the power spectral density (PSD) of the signal
% plot(freq_axis, 10*log10(fft_data.^2));
% xlabel('Frequency (Hz)');
% ylabel('Power (dB)');
%%
% Set parameters
eeg_data=x;
fs = 500; % Sampling frequency in Hz
window_size = 2*fs; % Window size in samples
noverlap = 0; % Overlap size in samples
%
alpha_band = [8 13]; % Alpha band frequency range in Hz
beta_band = [14 30]; % Beta band frequency range in Hz
theta_band = [4 7]; % Theta band frequency range in Hz
delta_band = [1 4]; % Delta band frequency range in Hz


% Compute power spectrum
[Pxx, f] = pwelch(eeg_data, window_size, noverlap, [], fs);
% Find frequency indices for each band
alpha_indices = find(f>=alpha_band(1) & f<=alpha_band(2));
beta_indices = find(f>=beta_band(1) & f<=beta_band(2));
theta_indices = find(f>=theta_band(1) & f<=theta_band(2));
delta_indices = find(f>=delta_band(1) & f<=delta_band(2));

% Compute sum of power in each band
alpha_power = sum(Pxx(alpha_indices));
beta_power = sum(Pxx(beta_indices));
theta_power = sum(Pxx(theta_indices));
delta_power = sum(Pxx(delta_indices));
total_power = alpha_power+beta_power+theta_power+delta_power;

%
fft_data=10*log10(Pxx);

% Plot power spectrum
% figure;
% plot(f, 10*log10(Pxx));
% xlabel('Frequency (Hz)');
% ylabel('Power (dB)');
% title('Power Spectrum');

end