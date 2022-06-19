function [goal, maxSimTime, maxDistanceErr, maxAngleErr] = parameters()

    goal = [-1.3; -1.6; adjustAngle(deg2rad(90))];
    maxSimTime = 60; % s
    maxDistanceErr = 0.1;
    maxAngleErr = deg2rad(5);

end