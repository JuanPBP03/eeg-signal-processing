classdef EEGData < handle

    properties (SetAccess = private)
        Task
        Ntests
        samplerate
        Channels
        TaskIDs
        
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
                obj.Task(taskIDs(i)) = EEGTest(taskIDs(i),channels,groupData{i},fs);
            end
            obj.Ntests = numel(groupData);
            obj.samplerate = fs;
            obj.Channels = channels;
            obj.TaskIDs = taskIDs;
        end

    end
end