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

controller = PotentialField(robot, goal, obstacles);

map = getSceneMap;
map = map.setInit(map.coordinates2index(robot.position));
map = map.setGoal(map.coordinates2index(goal.position));

optimalPath = aStar(map);

while controller.rho > maxDistanceError && simTime < maxSimTime

    tic

    fTot = controller.getFTot();

    if (fTot(1) == Inf || fTot(2) == Inf)
        collisionWarning = 'A collision occured';
        disp(collisionWarning)
        scene.addStatusBarMessage(collisionWarning)
        break
    end

    velocity = norm(fTot, 2);
    velocity = min(velocity, robot.maxVelocity);

    angularVelocity = adjustAngle( ...
        atan2(fTot(2), fTot(1)) - ...
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

    robot = robot.move(scene.robotPosition);
    controller = PotentialField(robot, goal, obstacles);

    detectedPoints = scene.getDetectedPoints(robot.position);

    for i = 1:16
        obstacles(i) = obstacles(i).updatePosition(detectedPoints(:,i));
    end

    simTime = simTime + toc;
    disp(['Simulation Time: ', num2str(simTime), ' s']);

end

scene.setRobotVelocity(scene.rightMotor, 0);
scene.setRobotVelocity(scene.leftMotor, 0);

scene.addStatusBarMessage('Session closed!');
scene.disconnect;

plotTimeStamp(robot, goal, obstacles);

if controller.rho <= maxDistanceError
    title('Goal completed :)')
end

if simTime >= maxSimTime
   title('Max simulation time reached. Goal not completed!')
end