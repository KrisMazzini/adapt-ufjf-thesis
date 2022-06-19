function plotTimeStamp(robot, goal)

    time = length(robot.positionHistory);

    fig = figure;
    fig.Position = [0, 0, 1000, 1000];

    initialRobot = robot;
    initialRobot.position = robot.positionHistory(:,1);

    plotRobot(initialRobot, goal, 1);
    title('Press "space" to begin.');
    pause;

    for t = 1:time
        currentRobot = robot;
        currentRobot.position = robot.positionHistory(:,t);

        plotRobot(currentRobot, goal, t);
        drawnow
    end

end