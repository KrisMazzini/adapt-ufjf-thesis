classdef Scene
    properties
        sim
        clientID
        rightMotor
        leftMotor
        pioneerP3DX
        inertialFrame
    end
    methods

        function obj = Scene(sim, clientID)
            obj.sim = sim;
            obj.clientID = clientID;
            obj.rightMotor = obj.getElement('Pioneer_p3dx_rightMotor');
            obj.leftMotor = obj.getElement('Pioneer_p3dx_leftMotor');
            obj.pioneerP3DX = obj.getElement('Pioneer_p3dx');
            obj.inertialFrame = obj.getElement('Floor');

            obj.setVelocity(obj.rightMotor, 0);
            obj.setVelocity(obj.leftMotor, 0);
        end

        function element = getElement(obj, elementString)
            [~, element] = obj.sim.simxGetObjectHandle( ...
                obj.clientID, ...
                elementString, ...
                obj.sim.simx_opmode_oneshot_wait ...
            );
        end

        function addStatusBarMessage(obj, message)
            obj.sim.simxAddStatusbarMessage( ...
                obj.clientID, ...
                message, ...
                obj.sim.simx_opmode_oneshot ...
            );
        end

        function setVelocity(obj, element, velocity)
            obj.sim.simxSetJointTargetVelocity( ...
                obj.clientID, ...
                element, ...
                velocity, ...
                obj.sim.simx_opmode_oneshot ...
            );
        end

    end
end