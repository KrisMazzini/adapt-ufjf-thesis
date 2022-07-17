function [xGoal, yGoal, map] = addFinalPosition(map)

    xlabel("Choose robot final position with left mouse button");

    uiwait(msgbox("Choose robot final position with left mouse button"), 10);

    [xGoal, yGoal] = ginput(1);
    xGoal = round(xGoal);
    yGoal = round(yGoal);

    plot(xGoal, yGoal, "or");
    plot(xGoal, yGoal, "*r");
    text(xGoal - 0.4, yGoal + 0.3, "Goal", "Color", "red")

    map(yGoal,xGoal) = 0;

end