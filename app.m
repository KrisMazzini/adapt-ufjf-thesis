clear; close all; clc;

[sim, clientID] = server();
successfulConnection = (clientID == 0);
    
if ~successfulConnection
    disp('Failed connection between Matlab and CoppeliaSim.');
    return
end

disp('Successful Connection between Matlab and CoppeliaSim.');

simTime = 0;

[goalPosition, maxSimTime, maxDistanceError, ~] = parameters();

scene = Scene(sim, clientID);
scene.addStatusBarMessage('Session started!');

goal = Robot(goalPosition);
robot = Robot(scene.robotPosition);
for i = 1:16
    obstacles(i) = Obstacle;
end

detectedPoints = scene.getDetectedPoints(robot.position);

for i = 1:16
    obstacles(i) = obstacles(i).updatePosition(detectedPoints(:,i));
end

timeStampedRobot = robot;

controller = PotentialField(robot, goal, obstacles);

while controller.rho > maxDistanceError && simTime < maxSimTime

    tic

    if (controller.fTot(1) == Inf || controller.fTot(2) == Inf)
        disp('A collision occured')
        break
    end

    velocity = norm(controller.fTot, 2);
    velocity = min(velocity, robot.maxVelocity);

    angularVelocity = adjustAngle( ...
        atan2(controller.fTot(2), controller.fTot(1)) - ...
        robot.position(3) ...
    );

    robot = robot.adjustWheels(velocity, angularVelocity);

    scene.setRobotVelocity( ...
        scene.rightMotor, ...
        robot.rightWheelAngularVelocity ...
    );

    scene.setRobotVelocity( ...
        scene.leftMotor, ...
        robot.leftWheelAngularVelocity ...
    );

    robot = Robot(scene.robotPosition);
    controller = PotentialField(robot, goal, obstacles);

    detectedPoints = scene.getDetectedPoints(robot.position);

    for i = 1:16
        obstacles(i) = obstacles(i).updatePosition(detectedPoints(:,i));
    end

    timeStampedRobot.position = robot.position;
    timeStampedRobot = timeStampedRobot.addPositionHistory;

    simTime = simTime + toc;
    disp(['Simulation Time: ', num2str(simTime), ' s']);

end

scene.setRobotVelocity(scene.rightMotor, 0);
scene.setRobotVelocity(scene.leftMotor, 0);

scene.addStatusBarMessage('Session closed!');
scene.disconnect;

plotTimeStamp(timeStampedRobot, goal, obstacles);