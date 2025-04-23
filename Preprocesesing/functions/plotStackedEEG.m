function plotStackedEEG(Test, channels, spacing)
    arguments
        Test
        channels = []
        spacing = []
    end

    if isempty(channels)
        channels = Test.Channels;
    end
    if isstring(channels)
        channelnum = Test.Channel(channels);
    else
        channelnum = channels;
    end

    data = Test.Data(:, :, channelnum);  % [Sub x Time x Chan]
    fs = Test.samplerate;
    t = (0:size(data,2)-1) / fs;
    nSub = Test.Subnum;
    L = length(channelnum);

    % Normalize spacing if not provided
    if isempty(spacing)
        maxval = max(abs(data), [], 'all');
        spacing = maxval * 2;  % double the peak amplitude
    end

     
    hold on;
    for i = 1:nSub
        for j = 1:L
            y = squeeze(data(i,:,j));
            y = y - mean(y);  % remove DC offset
            offset = (i - 1) * spacing + (j - (L+1)/2) * spacing * 0.25;  % centered spread
            plot(t, y + offset, 'k');  % all black, or use color(j)
        end
    end

    % Y-axis ticks and labels
    yticks(spacing * (0:nSub-1));
    yticklabels("S" + string(1:nSub));
    
    xlabel("Time (s)");
    ylabel("Subject");
    title("Stacked EEG Signals by Subject and Channel");
    grid on;
end
