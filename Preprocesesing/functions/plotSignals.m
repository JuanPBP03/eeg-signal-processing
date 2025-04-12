function plotSignals(fs, signals, times, names)
len = length(signals);
Hz = fs/len*(0:len-1);

for i = 1:2
    fsig = abs(fft(signals(i,:)));
    fsig = fsig/max(fsig);
    
    figure(i);
    subplot(2,1,1);
    plot(times,signals(i,:));
    xlabel("Time (s)");
    title(names(i));
    subplot(2,1,2);
    plot(Hz,fsig);
    ylabel("Normalized Power Spectrum");
    xlabel("Frequency (Hz)")
    xlim([0 128])
end
end