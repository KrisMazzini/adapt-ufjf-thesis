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
    end
end