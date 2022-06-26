classdef Scene
    properties (Constant)
        sonarsMinDistance = 0.05
        sonarsMaxDistance = 5
        sonarsInstallOrientation = deg2rad([ ...
            90 50 30 10 -10 -30 -50 -90, ...
            -90 -130 -150 -170 170 150 130 90 ...
        ])
    end
    properties (Dependent)
        robotPosition
        sonarsInstallPosition
        detectedPoints
    end
    properties
        sim
        clientID
        rightMotor
        leftMotor
        pioneerP3DX
        inertialFrame
        sonars
    end
    methods

        function obj = Scene(sim, clientID)
            obj.sim = sim;
            obj.clientID = clientID;
            obj.rightMotor = obj.getElement('Pioneer_p3dx_rightMotor');
            obj.leftMotor = obj.getElement('Pioneer_p3dx_leftMotor');
            obj.pioneerP3DX = obj.getElement('Pioneer_p3dx');
            obj.inertialFrame = obj.getElement('Floor');
            
            sonars = zeros(1,16);
            for i = 1:length(sonars)
                sonars(i) = obj.getElement(['Pioneer_p3dx_ultrasonicSensor' num2str(i)]);
            end
            obj.sonars = sonars;

            obj.setRobotVelocity(obj.rightMotor, 0);
            obj.setRobotVelocity(obj.leftMotor, 0);
        end

        function element = getElement(obj, elementString)
            [~, element] = obj.sim.simxGetObjectHandle( ...
                obj.clientID, ...
                elementString, ...
                obj.sim.simx_opmode_oneshot_wait ...
            );
        end

        function [handles, floatData] = getGroupData(obj)
            [~, handles, ~, floatData, ~] = obj.sim.simxGetObjectGroupData( ...
                obj.clientID, ...
                obj.sim.sim_object_proximitysensor_type, ...
                3 , obj.sim.simx_opmode_oneshot_wait ...
            );
        end

        function [detectionState, detectedPoint] = sonarReadings(obj, sonar)
            [~, detectionState, detectedPoint, ~, ~] = ( ...
                obj.sim.simxReadProximitySensor( ...
                    obj.clientID, ...
                    sonar, ...
                    obj.sim.simx_opmode_oneshot_wait ...
                ) ...
            );
        end

        function position = get.robotPosition(obj)
            for i = 1:5
                [~, position] = obj.sim.simxGetObjectPosition( ...
                    obj.clientID, ...
                    obj.pioneerP3DX, ...
                    obj.inertialFrame, ...
                    obj.sim.simx_opmode_oneshot_wait ...
                );
                [~, orientation] = obj.sim.simxGetObjectOrientation( ...
                    obj.clientID, ...
                    obj.pioneerP3DX, ...
                    obj.inertialFrame, ...
                    obj.sim.simx_opmode_oneshot_wait ...
                );
            end
            position(3) = adjustAngle(orientation(3));
            position = position';
        end

        function sonarsInstallPosition = get.sonarsInstallPosition(obj)
            for i = 1:5
                [handles, floatData] = obj.getGroupData;
            end
            for i = 1:length(obj.sonars)
                index(i) = find(handles(i) == obj.sonars);
            end
            sonarsInstallPosition = reshape(floatData, 3 , 16);
            sonarsInstallPosition = sonarsInstallPosition(: , index);
        end

        function detectedPoints = get.detectedPoints(obj)

            distances = zeros(1,16);
            detectedPoints = zeros(3, 16);
            for i = 1:16
                [detectionState, detectedPoint] = obj.sonarReadings(obj.sonars(i));
                detected = isequal(detectionState , 1);

                if detected
                    distances(i) = norm(detectedPoint);
                else
                    distances(i) = obj.sonarsMaxDistance;
                end

                xPosition = ( ...
                    obj.sonarsInstallPosition(1,i) + distances(i) * cos( ...
                        obj.robotPosition(3) + obj.sonarsInstallOrientation(i) ...
                    ) ...
                );
                
                yPosition = ( ...
                    obj.sonarsInstallPosition(2,i) + distances(i) * sin( ...
                        obj.robotPosition(3) + obj.sonarsInstallOrientation(i) ...
                    ) ...
                );

                zPosition = obj.sonarsInstallPosition(3,i);
                
                detectedPoints(:,i) = [xPosition; yPosition; zPosition];
            end

        end

        function setRobotVelocity(obj, element, velocity)
            obj.sim.simxSetJointTargetVelocity( ...
                obj.clientID, ...
                element, ...
                velocity, ...
                obj.sim.simx_opmode_oneshot ...
            );
        end

        function addStatusBarMessage(obj, message)
            obj.sim.simxAddStatusbarMessage( ...
                obj.clientID, ...
                message, ...
                obj.sim.simx_opmode_oneshot ...
            );
        end

        function disconnect(obj)
            obj.sim.simxGetPingTime(obj.clientID);

            obj.sim.simxStopSimulation( ...
                obj.clientID, ...
                obj.sim.simx_opmode_oneshot_wait ...
            );

            obj.sim.simxFinish(obj.clientID);

            disp('Disconnected!');
        end

    end
end