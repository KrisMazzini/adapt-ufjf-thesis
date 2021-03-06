classdef Robot
    properties (Constant)
        wheelRadius = (1/2) * (195/1000)
        wheelAxis = (1/2) * (381/1000)
        maxVelocity = 0.2;
    end
    properties (Dependent)
        velocity
        angularVelocity
        inertialFrameVelocity
    end
    properties
        position = [0; 0; 0]
        positionHistory = []
        body
        leftWheelAngularVelocity = 0
        rightWheelAngularVelocity = 0
    end
    methods

        function obj = Robot(position)
            obj.position = position;
            obj.positionHistory = obj.position;
            obj.body = obj.getBody();
        end

        function velocity = get.velocity(obj)
            velocity = obj.wheelRadius/2 * ( ...
                obj.rightWheelAngularVelocity + ...
                obj.leftWheelAngularVelocity ...
            );

            if velocity >= 0
                velocity = min(velocity, obj.maxVelocity);
            else
                velocity = max(velocity, -obj.maxVelocity);
            end
        end

        function angularVelocity = get.angularVelocity(obj)
            angularVelocity = obj.wheelRadius/obj.wheelAxis * ( ...
                obj.rightWheelAngularVelocity - ...
                obj.leftWheelAngularVelocity ...
            );
        end

        function inertialFrameVelocity = get.inertialFrameVelocity(obj)
            theta = obj.position(3);
            inertialFrameVelocity = [
                cos(theta) 0
                sin(theta) 0
                0          1
            ] * [obj.velocity; obj.angularVelocity];
        end

        function robotBody = getBody(obj)
            robotBody = RobotBody(obj);
        end

        function obj = adjustWheels(obj, velocity, angularVelocity)
            wheels = [
                1/obj.wheelRadius,  obj.wheelAxis/(2*obj.wheelRadius)
                1/obj.wheelRadius, -obj.wheelAxis/(2*obj.wheelRadius)
            ] * [velocity; angularVelocity];

            obj.rightWheelAngularVelocity = wheels(1);
            obj.leftWheelAngularVelocity = wheels(2);
        end

        function obj = move(obj, newPosition)
            obj.position = newPosition;
            obj.body = obj.getBody();
            obj.position(3) = adjustAngle(obj.position(3));
            obj = obj.addPositionHistory();
        end

        function obj = addPositionHistory(obj)
            obj.positionHistory = [obj.positionHistory, obj.position];
        end

    end
end