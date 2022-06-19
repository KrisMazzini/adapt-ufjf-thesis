function [goal, maxSimTime, maxDistanceErr, maxAngleErr] = parameters()

    goal = [-1.3; 0; adjustAngle(deg2rad(0))];
    maxSimTime = 60; % s
    maxDistanceErr = 0.01;
    maxAngleErr = deg2rad(0.1);

end