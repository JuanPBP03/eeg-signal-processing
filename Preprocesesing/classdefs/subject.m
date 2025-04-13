classdef subject < handle
    properties
        Id
        health
        Data
    end

    methods
        function obj = subject(Id, healthy)
            obj.Id = Id;
            obj.health = healthy;
        end
    end
end