classdef EEGData < handle

    properties (SetAccess = private)
        groupData
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

            if nargin < 4 || isempty(taskIDs)
                taskIDs = 1:numel(groupData);
            end
            if numel(groupData) ~= numel(taskIDs)
                error("Number of task IDs must match number of tasks in groupData.");
            end
            obj.Task = dictionary();
            for i = 1:numel(groupData)
                obj.Task(taskIDs(i)) = EEGTest(taskIDs(i));
            end
            obj.groupData = dictionary(taskIDs,groupData);
            obj.Ntests = numel(groupData);
            obj.samplerate = fs;
            obj.Channels = channels;
            obj.TaskIDs = taskIDs;
            obj.Channel = dictionary(channels,1:numel(channels));
            obj.linkSources()
        end
        function filtered = filterData(obj,task)
        end
    end
end