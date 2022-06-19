function [goalPosition, maxSimTime] = parameters()

    goalPosition = [1.3; 1.4; adjustAngle(deg2rad(30))];

    maxSimTime = 60; % s

end