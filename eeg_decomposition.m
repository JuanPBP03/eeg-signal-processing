% ========== DATA SEGMENTATION ==========
load("MADHD.mat")
Fs = 256; % Sampling frequency
val_MADHD = MADHD{1, 1}; % Data for Task 1
ch1_MADHD = val_MADHD(:, :, 1); % Channel 1 Cz
subj1_ch1_MADHD = val_MADHD(1, :, 1); % Subject 1 - Channel 1
N = length(subj1_ch1_MADHD); % Number of data points
time = (0:N-1) / Fs; % Time vector

% ========== Decomposition in Frequency Domain ==========

% Apply Fast Fourier Transform (FFT)
subj1_ch1_MADHD_fft = fft(subj1_ch1_MADHD);
% Two-sided amplitude spectrum
P2 = abs(subj1_ch1_MADHD_fft / N);
% One-sided amplitude spectrum
P1 = P2(1:N/2 + 1);
% Multiply the spectrum in the positive frequencies by 2
% except for P1(1) = 0 and P1(end) = Nyquist frequency
P1(2:end-1) = P1(2:end-1) * 2;
% Frequency domain
f = Fs / N * (0:(N/2));
% Plot the single-sided amplitude spectrum for Raw EEG Data
figure(1);
subplot(6, 1, 1);
plot(f, P1);
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Raw EEG Data')

% Define EEG bands
delta = (f >= 0.5 & f < 4);
theta = (f >= 4 & f < 8);
alpha = (f >= 8 & f < 12);
beta = (f >= 12 & f < 30);
gamma = (f >= 30 & f < 100);

subplot(6, 1, 2);
plot(f(delta), P1(delta), 'k');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Delta Wave')
subplot(6, 1, 3);
plot(f(theta), P1(theta), 'r');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Theta Wave')
subplot(6, 1, 4);
plot(f(alpha), P1(alpha), 'g');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Alpha Wave')
subplot(6, 1, 5);
plot(f(beta), P1(beta), 'm');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Beta Wave')
subplot(6, 1, 6);
plot(f(gamma), P1(gamma), 'y');
xlabel('Frequency (Hz)'); ylabel('Amplitude');
legend('Gamma Wave')

% ========== Decomposition in Time Domain ==========

% Apply bandpass filter to EEG signal
time_vector = (0:N-1) / Fs;
figure(2);
subplot(6, 1, 1);
plot(time_vector, subj1_ch1_MADHD);
xlabel('Time (s)'); ylabel('Amplitude');
legend('Raw EEG Data')

% Apply bandpass filters for each band
delta_time = bandpass(subj1_ch1_MADHD, [0.5 4], Fs);
theta_time = bandpass(subj1_ch1_MADHD, [4 8], Fs);
alpha_time = bandpass(subj1_ch1_MADHD, [8 12], Fs);
beta_time = bandpass(subj1_ch1_MADHD, [12 30], Fs);
gamma_time = bandpass(subj1_ch1_MADHD, [30 100], Fs);

subplot(6, 1, 2);
plot(time_vector, delta_time, 'k');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Delta Wave')
subplot(6, 1, 3);
plot(time_vector, theta_time, 'r');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Theta Wave')
subplot(6, 1, 4);
plot(time_vector, alpha_time, 'g');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Aplha Wave')
subplot(6, 1, 5);
plot(time_vector, beta_time, 'm');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Beta Wave')
subplot(6, 1, 6);
plot(time_vector, gamma_time, 'y');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Gamma Wave')

% ========== FEATURE EXTRACTION in Time Domain ==========
% Delta band
%delta_mean = mean(delta_time); % Mean
delta_median = median(delta_time); % Median
delta_std = std(delta_time); % Standard deviation
delta_var = var(delta_time); % Variance
delta_skew = skewness(delta_time); % Skewness
delta_RMS = rms(delta_time); % Root-mean-square (RMS)
delta_kurto = kurtosis(delta_time); % Kurtosis

% Theta band
%theta_mean = mean(theta_time); % Mean
theta_median = median(theta_time); % Median
theta_std = std(theta_time); % Standard deviation
theta_var = var(theta_time); % Variance
theta_skew = skewness(theta_time); % Skewness
theta_RMS = rms(theta_time); % Root-mean-square (RMS)
theta_kurto = kurtosis(theta_time); % Kurtosis

% Alpha band
%alpha_mean = mean(alpha_time); % Mean
alpha_median = median(alpha_time); % Median
alpha_std = std(alpha_time); % Standard deviation
alpha_var = var(alpha_time); % Variance
alpha_skew = skewness(alpha_time); % Skewness
alpha_RMS = rms(alpha_time); % Root-mean-square (RMS)
alpha_kurto = kurtosis(alpha_time); % Kurtosis

% Beta band
%delta_mean = mean(beta_time); % Mean
beta_median = median(beta_time); % Median
beta_std = std(beta_time); % Standard deviation
beta_var = var(beta_time); % Variance
beta_skew = skewness(beta_time); % Skewness
beta_RMS = rms(beta_time); % Root-mean-square (RMS)
beta_kurto = kurtosis(beta_time); % Kurtosis

% Gamma band
%gamma_mean = mean(gamma_time); % Mean
gamma_median = median(gamma_time); % Median
gamma_std = std(gamma_time); % Standard deviation
gamma_var = var(gamma_time); % Variance
gamma_skew = skewness(gamma_time); % Skewness
gamma_RMS = rms(gamma_time); % Root-mean-square (RMS)
gamma_kurto = kurtosis(gamma_time); % Kurtosis

% Put data into a table
FrequencyBand = ["Delta"; "Theta"; "Aplha"; "Beta"; "Gamma"];
Median = [delta_median; theta_median; alpha_median; beta_median; gamma_median];
StandardDeviation = [delta_std; theta_std; alpha_std; beta_std; gamma_std];
Variance = [delta_var; theta_var; alpha_var; beta_var; gamma_var];
Skewness = [delta_skew; theta_skew; alpha_skew; beta_skew; gamma_skew];
RMS = [delta_RMS; theta_RMS; alpha_RMS; beta_RMS; gamma_RMS];
Kurtosis = [delta_kurto; theta_kurto; alpha_kurto; beta_kurto; gamma_kurto];
features = table(FrequencyBand, Median, StandardDeviation, Variance, Skewness, RMS, Kurtosis)

% ========== POWER ==========
delta_power = sum(P1(delta).^2);
theta_power = sum(P1(theta).^2);
alpha_power = sum(P1(alpha).^2);
beta_power = sum(P1(beta).^2);
gamma_power = sum(P1(delta).^2);
theta_beta_ratio = theta_power/beta_ratio;
BandPower = [delta_power; theta_power; alpha_power; beta_power; gamma_power];
features = table(FrequencyBand, BandPower)
