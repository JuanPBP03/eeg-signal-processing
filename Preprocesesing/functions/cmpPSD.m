function cmpPSD(Test, freqrange, colors, channels)
    arguments
        Test
        freqrange
        colors = lines(Test.Nchannels)
        channels = [];
    end
    if isempty(channels)
        channels = Test.Channels;
    end
    if isstring(channels)
        channelnum = Test.Channel(channels);
    else
        channelnum = channels;
    end
    x = Test.Data(:,:,:);
    N = size(x,2);
    fs = Test.samplerate;
    L = length(Test.Channels);
    
    hold on
    for i = 1:Test.Subnum
        for j = channelnum
        [pxx, f] =periodogram(x(i,:,j),rectwin(N),N,fs);
        db = 10*log10(pxx);
        plot3(f,(i-0.2+(j-1)*0.4/(L-1))*ones(size(f)),db,'Color',colors(j,:));
        end
    end
    hold off
    xlabel("Frequency (Hz)")
    ylabel("Subject Number");
    zlabel("Power/Frequency (dB/Hz)");
    title("Power Spectral Density Comparison");
   
    yticks(0:Test.Subnum)
    yticklabels(0:Test.Subnum)
    grid on
    legend off
    view(90,0);
    if nargin > 3
        xlim(freqrange);
    end
    
    
end