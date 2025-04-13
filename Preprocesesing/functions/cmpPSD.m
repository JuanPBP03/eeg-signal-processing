function cmpPSD(Test, colors, freqrange, channels)
    arguments
        Test
        colors
        freqrange
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
        plot3(f,(i-0.2+(j-1)*0.4/(L-1))*ones(size(f)),db,'Color',colors(j));
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
    view(90,0);
    legend(channels)
    if nargin > 3
        xlim(freqrange);
    end
    
    
end