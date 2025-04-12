classdef EEGTest < handle
    %Test
    %   Detailed explanation goes here

    properties
        Duration % duration of test in seconds
        Channel % dictionary to convert alphanumerical channel IDs to array index
        Id % Task ID
        data % full data for task
        samplerate % test sample rate
        numChannels % number of channels in the task
    end

    methods
        function obj = EEGTest(taskID,chIDs, dataset, fs)
            %EEGTEST Construct an EEGTest object
            %   obj = EEGTest(taskId, chIDs, data, fs)
            %   taskId - Numeric ID of the task
            %   chIDs  - Array of channel labels or IDs (e.g., ["Fp1", "Fp2"] or [1, 2])
            %   dataset   - EEG data 1 x #tasks cell array [subjects x samples x channels]
            %   fs     - Sampling rate in Hz
            if nargin == 0
                return
            elseif nargin == 4
                obj.data = dataset{taskID};
                obj.samplerate = fs;
                obj.Id = taskID;
                obj.numChannels = length(chIDs);
                ch_nums = 1:obj.numChannels;
                obj.Channel = dictionary(chIDs,ch_nums);
                obj.Duration = size(obj.data, 2)/fs;
            else
                error("You must initialize this object with a taskID, channel IDs, data, and sample rate");
        
            end
        end
        function subdata = getSubjectData(obj, subject, channel)
            %GETSUBJECTDATA Extracts EEG signal for a subject and channel
            %   signal = getSubjectData(obj, subject, channel)
            %
            %   Inputs:
            %     subject - subject object. Must have .Id property (1-based)
            %     channel - string (e.g. 'Fp1') or index. Must match EEGTest channel map
            %
            %   Output:
            %     signal - EEG samples [N x 1] from specified subject and channel
            if channel > obj.numChannels
                error("Requested channel %d exceeds number of available channels (%d)", channel, obj.numChannels);
            end
            subdata = squeeze(obj.data(subject.Id, :, channel));
        end

    end
end