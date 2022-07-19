function map = getSceneMap

    map = Map;

    walls = [
        Block([0 9.85], [19.4 0.3])
        Block([0 -9.85], [19.4 0.3])
        Block([-9.85 0], [0.3 20])
        Block([9.85 0], [0.3 20])
        Block([-6.2 4.6], [7 0.15])
        Block([-2.625 8.2], [0.15 3])
        Block([6.2 4.6], [7 0.15])
        Block([2.625 8.2], [0.15 3])
        Block([1.2 6.625], [3 0.15])
        Block([-6.2 -4.6], [7 0.15])
        Block([-2.625 -8.2], [0.15 3])
        Block([6.2 -4.6], [7 0.15])
        Block([2.625 -8.2], [0.15 3])
        Block([1.2 -6.625], [3 0.15])
        Block([-6.2 0], [7 0.15])
        Block([6.2 0], [7 0.15])
    ];

    occupiedCells = [];
    for i = 1:length(walls)
        firstIndex = map.coordinates2index(walls(i).trueCoordinates(1,:));
        lastIndex = map.coordinates2index(walls(i).trueCoordinates(2,:));

        firstLine = firstIndex(1);
        firstCol = firstIndex(2);
        lastLine = lastIndex(1);
        lastCol = lastIndex(2);

        lines = firstLine:lastLine;
        cols = firstCol:lastCol;

        for lin = 1:length(lines)
            for col = 1:length(cols)
                occupiedCells = [occupiedCells; [lines(lin), cols(col)]];
            end
        end

    end

    map = map.setObstacles(occupiedCells);
    map = map.setVirtualObstacles;
end