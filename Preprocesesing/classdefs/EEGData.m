classdef EEGData < handle

    properties (SetAccess = ?EEGTest)
        Data
        Task
        Ntests
        samplerate
        Channels
        Channel
        TaskIDs
        
    end
    methods (Access = private)
        function linkSources(obj)
            keys = obj.Task.keys;
            for i = 1:numel(keys)
                obj.Task(keys(i)).Source = obj;
            end
        end
    end
    methods
        function obj = EEGData(groupData,channels,fs,taskIDs)
            arguments
                groupData
                channels
                fs
                taskIDs = 1:numel(groupData);
            end
            if numel(groupData) ~= numel(taskIDs)
                error("Number of task IDs must match number of tasks in groupData.");
            end
            obj.Task = dictionary();
            for i = 1:numel(groupData)
                obj.Task(taskIDs(i)) = EEGTest(taskIDs(i));
            end
            obj.Data = dictionary(taskIDs,groupData);
            obj.Ntests = numel(groupData);
            obj.samplerate = fs;
            obj.Channels = channels;
            obj.TaskIDs = taskIDs;
            obj.Channel = dictionary(channels,1:numel(channels));
            obj.linkSources()
        end
        function cleanDataset = rmUnfiltered(obj)
            arguments
                obj
            end
            
            for i = 1:obj.Ntests
                f = obj.samplerate/obj.Task(i).samples*(0:obj.Task(i).samples-1);
                rawFFT = obj.Task(i).normFFT;
                raw = obj.Task(i).Data;
                badIDx = find(f>49 & f<51);
                chpass = squeeze(rawFFT(:,badIDx,:)<0.01);
                subpass = all(chpass==1,[2 3]);
                cleanData{i} = raw(subpass,:,:);
            end
            cleanDataset = EEGData(cleanData,obj.Channels,obj.samplerate);
        end

        function filteredDataset = filteredData(obj, filter)
            for i = 1:obj.Ntests
               filtered{i} = obj.Task(i).filterData(filter);
            end
            filteredDataset = EEGData(filtered,obj.Channels,obj.samplerate);
        end
        function rmSubject(obj,nums)
            for i = 1:obj.Ntests
                obj.Task(i).rmSubject(nums);
            end
        end
    end
end