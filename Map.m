classdef Map
    properties (Constant)
        frameSize = 20;
        cellSize = 0.2;
        obstacleWeight = -2;
        virtualObstacleWeight = -1;
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
        function obj = setVirtualObstacles(obj)
            virtualObstacles = [];

            [rows, cols] = find(obj.matrix == obj.obstacleWeight);
            
            for x = -3:3
                for y = -3:3
                    virtualObstacles = [virtualObstacles; [rows + x, cols + y]];
                end
            end

            for ind = 1:length(virtualObstacles)
                x = virtualObstacles(ind,1);
                y = virtualObstacles(ind, 2);

                validIndexes = ( ...
                    x > 0 && y > 0 && ...
                    x <= obj.matrixSize && y <= obj.matrixSize ...
                );

                if validIndexes
                    if (obj.matrix(x, y) ~= obj.obstacleWeight)
                        obj.matrix(x, y) = obj.virtualObstacleWeight;
                    end
                end
            end

        end
    end
end