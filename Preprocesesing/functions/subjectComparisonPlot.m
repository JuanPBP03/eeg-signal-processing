function subjectComparisonPlot(Test, channel, data)
    arguments
        Test
        channel = 1
        data = []
    end

    if isstring(channel)
        channel = Test.Channel(channel);
    end

    % Get sample rate and number of samples
    fs = Test.samplerate;
    N = size(Test.Data, 2);  % time samples

    % If no data provided, default to normalized FFT
    if isempty(data)
        raw = Test.Data(:, :, channel);  % [subjects x time]
        fftdata = abs(fft(raw, [], 2));  % FFT along time axis
        data = fftdata ./ max(fftdata, [], 2);  % normalize each subject
    end

    % X-axis: Frequency
    Hz = fs / N * (0:N-1);

    % Plot
    hold on;
    for i = 1:size(data, 1)
        plot3(Hz, i * ones(size(Hz)), data(i, :));
    end
    hold off;

    ylabel('Subject');
    title('3D Subject Comparison Plot');
    grid on;
    yticks(1:Test.Subnum);
    yticklabels("S" + string(1:Test.Subnum));
    view(45, 60);
    xlim([0 fs/2]);
end
