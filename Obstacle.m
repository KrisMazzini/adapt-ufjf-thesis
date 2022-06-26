classdef Obstacle
    properties
        position = []
        history = []
    end
    methods
        function obj = updatePosition(obj, detectedPoint)
            obj.position = detectedPoint;
            obj.history = [obj.history, detectedPoint];
        end
    end
end