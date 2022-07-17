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
        firstXIndex = walls(i).findFirstCellX(map.xIndex2coordinates, map.cellSize);
        firstYIndex = walls(i).findFirstCellY(map.yIndex2coordinates, map.cellSize);
        lastXIndex = walls(i).findLastCellX(map.xIndex2coordinates, map.cellSize);
        lastYIndex = walls(i).findLastCellY(map.yIndex2coordinates, map.cellSize);

        xIndexes = firstXIndex:lastXIndex;
        yIndexes = firstYIndex:lastYIndex;

        for x = 1:length(xIndexes)
            for y = 1:length(yIndexes)
                occupiedCells = [occupiedCells; [xIndexes(x), yIndexes(y)]];
            end
        end

    end

    map = map.setObstacles(occupiedCells);

end