classdef subject < handle
    properties
        Id
        health
    end

    methods
        function obj = subject(Id, healthy)
            obj.Id = Id;
            obj.health = healthy;
        end

        function sample = getData(obj, test, channel)
            sample = test.getSubjectData(obj, channel);
        end
    end
end