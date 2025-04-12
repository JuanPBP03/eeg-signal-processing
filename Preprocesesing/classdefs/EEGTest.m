classdef EEGTest < handle
    %Test
    %   Detailed explanation goes here

    properties
        Id   % Task ID
        Source
    end
    properties(Dependent)
        Duration         % duration of test in seconds
        times            % time stamp of each sample
        samples          % total number of samples
        Data             % full data for task
        Channel
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
            data = obj.Source.groupData(obj.Id);
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
            prop = 0:(1/obj.Source.samplerate):obj.Duration;
        end
        function prop = get.Duration(obj)
            prop = obj.samples/obj.Source.samplerate;
        end
        function prop = get.Channel(obj)
            prop = obj.Source.Channel;
        end
    end
end