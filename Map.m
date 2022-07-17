classdef Map
    properties (Constant)
        frameSize = 20;
        cellSize = 0.2;
        obstacleWeight = -1;
    end
    properties
        xIndex2coordinates
        yIndex2coordinates
        matrixSize
        matrix
    end
    methods
        function obj = Map
            obj.matrixSize = obj.frameSize / obj.cellSize;
            obj.xIndex2coordinates = -obj.frameSize/2 : obj.cellSize : obj.frameSize/2 - obj.cellSize;
            obj.yIndex2coordinates = obj.frameSize/2 : -obj.cellSize : -obj.frameSize/2 + obj.cellSize;
            obj.matrix = ones(obj.matrixSize);
        end
        function obj = setObstacles(obj, indexes)
            for ind = 1:length(indexes)
                x = indexes(ind,1);
                y = indexes(ind, 2);
                obj.matrix(x, y) = obj.obstacleWeight;
            end
        end
    end
end