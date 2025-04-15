classdef EEGTest < handle
    %Test
    %   Detailed explanation goes here

    properties
        Id   % Task ID
        Source
        Cleaned
    end
    properties(Dependent)
        Duration         % duration of test in seconds
        times            % time stamp of each sample
        samples          % total number of samples
        Data             % full data for task
        Channel
        Channels
        Nchannels
        Subnum
        samplerate
        FFT
        magFFT
        normFFT
        FFTfreq
    end
    
    methods (Access = ?EEGData)
        function obj = EEGTest(taskID)

            if nargin == 0
                return
            elseif nargin == 1
                obj.Id = taskID;
            else
                error("You must initialize this object with a taskID"); 
            end
            
        end
    end
    methods
        function data = get.Data(obj)
            data = obj.Source.Data(obj.Id);
            data = data{1};
        end
        function subdata = getSubjectData(obj, subjectID, channel)
            %GETSUBJECTDATA Extracts EEG signal for a subject and channel
            %   signal = getSubjectData(obj, subject, channel)
            %
            %   Inputs:
            %     subjectID - subjectId either immediate or from subject
            %     class
            %     channel - string (e.g. 'Fp1') or index. Must match
            %     EEGTest Channel map
            %   Output:
            %     subdata - EEG samples [N x 1] from specified subject and channel
            if ~any(obj.Source.Channels==channel)
                error("Requested channel %d exceeds number of available channels (%d)", channel, obj.numChannels);
            end
            subdata = squeeze(obj.Data(subjectID, :, obj.Channel(channel)));
        end
        
        function prop = get.samples(obj)
            prop = size(obj.Data,2);
        end

        function prop = get.times(obj)
            prop = (0:(obj.samples-1))/obj.samplerate;
        end
        function prop = get.Duration(obj)
            prop = obj.samples/obj.Source.samplerate;
        end
        function prop = get.Channel(obj)
            prop = obj.Source.Channel;
        end
        function prop = get.Subnum(obj)
            prop = height(obj.Data);
        end
        function prop = get.Channels(obj)
            prop = obj.Source.Channels;
        end
        function prop = get.samplerate(obj)
            prop = obj.Source.samplerate;
        end
        function prop = get.Nchannels(obj)
            prop = size(obj.Data,3);
        end
        function fftdata = get.FFT(obj)
            fftdata = fft(obj.Data,[],2);
        end
        function mag = get.magFFT(obj)
            mag = abs(obj.FFT);
        end
        function norm = get.normFFT(obj)
            norm = zeros(obj.Subnum,obj.samples,obj.Nchannels);
            mFFT = obj.magFFT;
            for i = 1:obj.Nchannels
                norm(:,:,i) = mFFT(:,:,i)./max(mFFT(:,:,i),[],2);
            end
        end
        function f = get.FFTfreq(obj)
            
            f = obj.samplerate / obj.samples * (0:obj.samples-1);
        end
        function rmSubject(obj,exclude)
            if size(exclude, 2) > obj.Subnum
                error("Exclude must have less entries than the number of subjects");
            end
            keep = setdiff(1:size(obj.Data,1), exclude);  % rows to keep
            obj.Data = obj.Data(keep, :, :);
        end
        function filtered = filterData(obj, fil)
                raw = pagetranspose(obj.Data);
                filtered = pagetranspose(filtfilt(fil,raw));
        end
        function set.Data(obj, data)
            obj.Source.Data(obj.Id) = {data};
        end
    end
end