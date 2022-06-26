function plotObstacles(obstacles, time)
    
    quantityOfObstacles = length(obstacles);
        
    obstaclesPositions = zeros(3, quantityOfObstacles);
    for i = 1:quantityOfObstacles
        if time > length(obstacles(i).history(1,:))
            time = length(obstacles(i).history(1,:));
        end
        obstaclesPositions(:,i) = obstacles(i).history(:,time);
    end

    plot(obstaclesPositions(1,:), obstaclesPositions(2,:), '-*')

end