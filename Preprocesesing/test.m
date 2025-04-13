taskfft = abs(fft(H_Test1.Data(:,:,1),[],2));
taskfft = taskfft./max(taskfft,[],2);
subnum = 1:13;
len = length(signals);
Hz = fs/len*(0:len-1);
figure;
hold on;

for i = 1:size(taskfft, 1)
    plot3(Hz, i * ones(size(Hz)), taskfft(i, :));  % x=freq, y=subject#, z=FFT
end

xlabel('Frequency (Hz)');
ylabel('Subject');
zlabel('|FFT|');
title('3D Plot of Subject FFTs');
grid on;
xlim([0 128])