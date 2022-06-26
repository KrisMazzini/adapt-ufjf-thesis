function plotRobot(robot, goal, obstacles, time)

    plotBody(goal, 'y');
    plotBody(robot, 'r');
    plotObstacles(obstacles, time)

    hold on;

    plot( ...
        robot.positionHistory(1,1:time), ...
        robot.positionHistory(2,1:time), ...
        'b', 'lineWidth', 2 ...
    );

    hold off;
    axis equal;
    xlabel('x [m]');
    ylabel('y [m]');
    title(sprintf( ...
        'x = %.4f m  |  y = %.4f m  |  theta = %.4f˚', ...
        robot.position(1), ...
        robot.position(2), ...
        rad2deg(robot.position(3)) ...
    ));
    grid on;
    drawnow
end