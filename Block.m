classdef Block
    properties (Dependent)
        trueCoordinates
    end
    properties
        coordidates
        dimensions
    end
    methods
        function obj = Block(coordinates, dimensions)
            obj.coordidates = coordinates;
            obj.dimensions = dimensions;
        end

        function trueCoordinates = get.trueCoordinates(obj)
            trueCoordinates = [
                obj.coordidates - obj.dimensions / 2
                obj.coordidates + obj.dimensions / 2
            ];
        end

        function index = findFirstCellX(obj, relation, cellSize)
            index = find(( ...
                relation <= obj.trueCoordinates(1,1) & ...
                relation >= (obj.trueCoordinates(1,1) - cellSize) ...
            ), 1);
        end

        function index = findFirstCellY(obj, relation, cellSize)
            index = find(( ...
                relation >= obj.trueCoordinates(2,2) & ...
                relation <= (obj.trueCoordinates(2,2) + cellSize) ...
            ), 1);
        end

        function index = findLastCellX(obj, relation, cellSize)
            index = find(( ...
                relation <= obj.trueCoordinates(2,1) & ...
                relation >= (obj.trueCoordinates(2,1) - cellSize) ...
            ), 1);
        end

        function index = findLastCellY(obj, relation, cellSize)
            index = find(( ...
                relation >= obj.trueCoordinates(1,2) & ...
                relation <= (obj.trueCoordinates(1,2) + cellSize) ...
            ), 1);
        end
    end
end