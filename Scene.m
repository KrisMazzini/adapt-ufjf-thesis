classdef Scene
    properties
        sim
        clientID
        rightMotor
        leftMotor
        pioneerP3DX
        floor
    end
    methods

        function obj = Scene(sim, clientID)
            obj.sim = sim;
            obj.clientID = clientID;
            obj.rightMotor = obj.getElement('Pioneer_p3dx_rightMotor');
            obj.leftMotor = obj.getElement('Pioneer_p3dx_leftMotor');
            obj.pioneerP3DX = obj.getElement('Pioneer_p3dx');
            obj.floor = obj.getElement('Floor');
        end

        function element = getElement(obj, elementString)
            element = obj.sim.simxGetObjectHandle( ...
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

    end
end