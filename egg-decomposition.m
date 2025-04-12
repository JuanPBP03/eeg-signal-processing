Fs = 256; % Sampling frequency
N = length(subj1_ch1_MADHD); % Number of data points
time = (0:N-1) / Fs; % Time vector
val_MADHD = MADHD{1, 1}; % Data for Task 1
ch1_MADHD = val_MADHD(:, :, 1); % Channel 1 Cz
subj1_ch1_MADHD = val_MADHD(1, :, 1); % Subject 1 - Channel 1

% ========== Frequency Domain ==========

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
% Plot the single-sided amplitude spectrum
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

% ========== Time Domain ==========

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
