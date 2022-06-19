function [goalPosition, maxSimTime] = parameters()

    goalPosition = [0.5; 0; adjustAngle(deg2rad(0))];

    maxSimTime = 15; % s

end