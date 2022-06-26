function plotTimeStamp(robot, goal, obstacles)

    time = length(robot.positionHistory);

    fig = figure;
    fig.Position = [0, 0, 1000, 1000];

    initialRobot = robot;
    initialRobot.position = robot.positionHistory(:,1);

    plotRobot(initialRobot, goal, obstacles, 1);
    title('Press "space" to begin.');
    pause;

    for t = 1:time
        currentRobot = robot;
        currentRobot.position = robot.positionHistory(:,t);

        plotRobot(currentRobot, goal, obstacles, t);
        drawnow
    end

end