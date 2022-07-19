function plotOccupiedCells(map, weight, cellSize, color)
    [rows, cols] = find(map == weight);

    style1 = strcat('s', color);
    style2 = strcat('*', color);


    plot(rows, cols, style1, 'MarkerSize', cellSize*10, 'LineWidth', cellSize*10);
    plot(rows, cols, style2, 'MarkerSize', cellSize*10, 'LineWidth', cellSize*10);
end