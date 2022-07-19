classdef Map
    properties (Constant)
        frameSize = 20;
        cellSize = 0.5;
        obstacleWeight = -2;
        virtualObstacleWeight = -1;
        initPositionWeight = 2;
        goalPositionWeight = 0;
    end
    properties
        matrixSize
        matrix
    end
    methods
        function obj = Map
            obj.matrixSize = obj.frameSize / obj.cellSize;
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
            
            for x = -1:1
                for y = -1:1
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

        function obj = setInit(obj, index)
            obj.matrix(index(1), index(2)) = obj.initPositionWeight;
        end

        function obj = setGoal(obj, index)
            obj.matrix(index(1), index(2)) = obj.goalPositionWeight;
        end

        function index = coordinates2index(obj, coordinates)
            x = coordinates(1);
            y = coordinates(2);
            
            col = ceil(obj.matrixSize - ( ...
                (obj.frameSize/2 - x) * (obj.matrixSize - 1) / ...
                (obj.frameSize) ...
            ));

            line = ceil(obj.matrixSize - ( ...
                (obj.frameSize/2 - y) * (obj.matrixSize - 1) / ...
                (obj.frameSize) ...
            ));

            index = [line, col];
        end

        function coordinates = index2coordinates(obj, index)
            line = index(1);
            col = index(2);

            x = obj.frameSize/2 - ( ...
                (obj.frameSize) * (obj.matrixSize - col) / ...
                (obj.matrixSize - 1) ...
            );

            y = obj.frameSize/2 - ( ...
                (obj.frameSize) * (obj.matrixSize - line) / ...
                (obj.matrixSize - 1) ...
            );

            coordinates = [x, y];
        end
    end
end