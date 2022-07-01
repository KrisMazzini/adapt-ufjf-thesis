classdef PotentialField
    properties (Constant)
        kAtt = 1/4;
        kRep = 1/40;
    end
    properties (Dependent)
        rho
        fAtt
        fRep
    end
    properties
        current
        goal
        err
        obstacles
        collision = false
    end
    methods
        
        function obj = PotentialField(current, goal, obstacles)
            obj.current = current;
            obj.goal = goal;
            obj.obstacles = obstacles;
            obj.err = obj.getErr;
        end

        function error = getErr(obj)
            error = obj.goal.position - obj.current.position;
        end

        function rho = get.rho(obj)
            dx = obj.err(1);
            dy = obj.err(2);

            rho = sqrt(dx^2 + dy^2);
        end

        function fAtt = get.fAtt(obj)
            fAtt = obj.kAtt * obj.err(1:2);
        end

        function fRep = get.fRep(obj)
            fRep = [0;0];
            for ind = 1:length(obj.obstacles)
                fRep = fRep + calculateObstacleRep(obj, obj.obstacles(ind));
            end

        end

        function fTot = getFTot(obj)
            fTot = obj.fAtt + obj.fRep;
        end

        function obsFRep = calculateObstacleRep(obj, obstacle)
            dx = obstacle.position(1) - obj.current.position(1);
            dy = obstacle.position(2) - obj.current.position(2);
            distance = sqrt(dx.^2 + dy.^2);

            underInfluenceZone = distance <= obj.current.body.influenceZone;

            if underInfluenceZone
                
                Z = ( ...
                    1./distance .* ...
                    (1/obj.current.body.influenceZone - 1./distance) ...
                );

                obsFRep = obj.kRep * [
                    sum(Z .* (obstacle.position(1) - obj.current.position(1)))
                    sum(Z .* (obstacle.position(2) - obj.current.position(2)))
                ];

                if distance <= obj.current.body.collisionZone
                    obsFRep = [Inf, Inf];
                end

            else
                obsFRep = [0;0];
            end
        end

    end
end