function [goalPosition, maxSimTime] = parameters()

    goalPosition = [0; 0; adjustAngle(deg2rad(0))];

    maxSimTime = 20; % s

end