function plotOccupiedCells(map, cellSize)
    [rows, cols] = find(map == -1);

    plot(rows, cols, 'sk', 'MarkerSize', cellSize*10, 'LineWidth', cellSize*10);
    plot(rows, cols, '*k', 'MarkerSize', cellSize*10, 'LineWidth', cellSize*10);
end