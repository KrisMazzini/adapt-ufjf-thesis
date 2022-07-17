function plotPosition(xInit, yInit, color)

    style1 = strcat("o", color);
    style2 = strcat("*", color);

    plot(xInit, yInit, style1);
    plot(xInit, yInit, style2);

end