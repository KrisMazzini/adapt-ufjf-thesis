function [xInit, yInit, map] = addInitialPosition(map)

    xlabel("Choose robot initial position with left mouse button");

    uiwait(msgbox("Choose robot initial position with left mouse button"), 10);

    [xInit, yInit] = ginput(1);
    xInit = round(xInit);
    yInit = round(yInit);

    plot(xInit, yInit, "ob");
    plot(xInit, yInit, "*b");
    text(xInit - 0.25, yInit + 0.3, "Start", "Color", "blue")

    map(yInit,xInit) = 2;

end