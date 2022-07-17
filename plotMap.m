function plotMap(lines, cols)

    hold on; box on;
    
    for i = 0.5 : cols + 0.5
        plot(i * ones(1, lines + 1), 0.5 : lines + 0.5, 'k')
    end
    
    for i = 0.5 : lines + 0.5
        plot(0.5 : cols + 0.5, i * ones(1, cols + 1), 'k')
    end
    
    axis equal

end