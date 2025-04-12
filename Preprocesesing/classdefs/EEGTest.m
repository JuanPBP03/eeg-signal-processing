classdef EEGTest < handle
    %Test
    %   Detailed explanation goes here

    properties
        Id                                      % Task ID
        chIDs 
        Data                                    % full data for task
        samplerate                              % test sample rate
        Channel  % dictionary to convert alphanumerical channel IDs to array index
    end
    properties(Dependent)
        Duration         % duration of test in seconds
        numChannels     % number of data channels
        times           % time stamp of each sample
        samples     % total number of samples
        
    end

    methods
        function obj = EEGTest(taskID,chIDs, dataset, fs)
            %EEGTEST Construct an EEGTest object
            %   obj = EEGTest(taskId, chIDs, data, fs)
            %   taskId - Numeric ID of the task
            %   chIDs  - Array of channel labels or IDs (e.g., ["Fp1", "Fp2"] or [1, 2])
            %   dataset   - EEG data [subjects x samples x channels]
            %   fs     - Sampling rate in Hz
            if nargin == 0
                return
            elseif nargin == 4
                obj.Data = dataset;
                obj.samplerate = fs;
                obj.Id = taskID;
                obj.chIDs = chIDs;
                obj.Channel = dictionary(obj.chIDs,1:length(obj.chIDs));
            else
                error("You must initialize this object with a taskID, channel IDs, data, and sample rate"); 
            end
            
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
            %     signal - EEG samples [N x 1] from specified subject and channel
            if channel > obj.numChannels
                error("Requested channel %d exceeds number of available channels (%d)", channel, obj.numChannels);
            end
            subdata = squeeze(obj.Data(subjectID, :, channel));
        end
        function prop = get.samples(obj)
            prop = size(obj.Data,2);
        end

        function prop = get.times(obj)
            prop = 0:1/obj.samplerate:obj.Duration;
        end

        function prop = get.numChannels(obj)
            prop = length(obj.chIDs);
        end
        function prop = get.Duration(obj)
            prop = obj.samples/obj.samplerate;
        end
    end
end