function [goalPosition, maxSimTime] = parameters()

    goalPosition = [-1; 0; adjustAngle(deg2rad(0))];

    maxSimTime = 60; % s

end