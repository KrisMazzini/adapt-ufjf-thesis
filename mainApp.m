function [scene, timeStampedRobot, goal] = mainApp(sim, clientID)

    simTime = 0;

    [goalPosition, maxSimTime] = parameters();
    maxDistanceError = 0.1;
    maxAngleError = deg2rad(1);

    scene = Scene(sim, clientID);
    scene.addStatusBarMessage('Session started!');
    
    goal = Robot(goalPosition);
    robot = Robot(scene.robotPosition);
    timeStampedRobot = robot;
    controller = CloseLoopControl(robot, goal);

    while ( ...
            (controller.rho > maxDistanceError) || ...
            (abs(controller.err(3)) > maxAngleError) ...
    ) && simTime < maxSimTime

        tic
        
        controller = controller.shouldDriveBackwards(controller.alpha);

        velocity = controller.kRho * controller.rho;
        velocity = min(velocity, robot.maxVelocity);

        if (controller.driveBackwards)
            velocity = -velocity;
        end

        angularVelocity = ( ...
            controller.kAlpha * controller.alpha + ...
            controller.kBeta * controller.beta ...
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
        controller = CloseLoopControl(robot, goal);

        timeStampedRobot.position = robot.position;
        timeStampedRobot = timeStampedRobot.addPositionHistory;

        simTime = simTime + toc;
        disp(['Simulation Time: ', num2str(simTime), ' s']);

    end

    scene.setRobotVelocity(scene.rightMotor, 0);
    scene.setRobotVelocity(scene.leftMotor, 0);

    scene.addStatusBarMessage('Session closed!');

end