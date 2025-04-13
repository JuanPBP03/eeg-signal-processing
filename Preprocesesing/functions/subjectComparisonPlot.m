function subjectComparisonPlot(Test, channel)

if nargin < 2
    channel = 1;
elseif isstring(channel)
    channel = Test.Channel(channel);
end
fs = Test.Source.samplerate;
taskfft = abs(fft(Test.Data(:,:,channel),[],2));
taskfft = taskfft./max(taskfft,[],2);
len = length(Test.Data);
Hz = fs/len*(0:len-1);
hold on;

for i = 1:size(taskfft, 1)
    plot3(Hz, i * ones(size(Hz)), taskfft(i, :));  % x=freq, y=subject#, z=FFT
end

xlabel('Frequency (Hz)');
ylabel('Subject');
zlabel('|FFT|');
title('3D Plot of Subject FFTs');
grid on;
yticks(1:Test.Subnum);
view(45,60);
xlim([0 128])
hold off
end