function [goal, maxSimTime, maxDistanceErr, maxAngleErr] = parameters()

    goal = [5.3; 6; adjustAngle(deg2rad(90))];
    maxSimTime = 60; % s
    maxDistanceErr = 0.01;
    maxAngleErr = deg2rad(5);

end