function optimalPath = aStar(mapObj)

optimalPath = [];

lines = mapObj.matrixSize;
cols = mapObj.matrixSize;

map = mapObj.matrix;
plotMap(lines, cols);
hold on;
plotOccupiedCells(map, mapObj.cellSize);

[xInit, yInit, map] = addInitialPosition(map);
[xGoal, yGoal, map] = addFinalPosition(map);

xCurr = xInit;
yCurr = yInit;

xNeigh = xInit;
yNeigh = yInit;

init2currCost = cost(xInit, yInit, xCurr, yCurr);
curr2neighCost = cost(xCurr, yCurr, xNeigh, yNeigh);

gCost = init2currCost + curr2neighCost;
hCost = cost(xGoal, yGoal, xNeigh, yNeigh);

minFunction = gCost + hCost;

hold on;
if lines < 11 && cols < 11
    text(xNeigh - 0.25, yNeigh - 0.25, sprintf("%.2f", minFunction))
end
hold off;

openCells = [0, xCurr, yCurr, xNeigh, yNeigh, init2currCost, minFunction];

[xObstacles, yObstacles] = find(map == -1);
closedCells = [xObstacles, yObstacles];
closedCells = [closedCells; [xCurr, yCurr]];

while (xCurr ~= xGoal) || (yCurr ~= yGoal)
    for dx = -1:1
        for dy = -1:1
            
            xNeigh = xCurr + dx;
            yNeigh = yCurr + dy;

            neighbourWithinMap = ( ...
                0 < xNeigh && xNeigh <= cols && ...
                0 < yNeigh && yNeigh <= lines ...
            );

            neighbourIsNotClosedCell = max( ...
                xNeigh == closedCells(:,1) & ...
                yNeigh == closedCells(:,2) ...
            ) == 0;

            if neighbourIsNotClosedCell && neighbourWithinMap
                curr2neighCost = cost(xNeigh, yNeigh, xCurr, yCurr);

                gCost = curr2neighCost + init2currCost;
                hCost = cost(xGoal, yGoal, xNeigh, yNeigh);

                minFunction = gCost + hCost;

                if sum(openCells(:,4) == xNeigh & openCells(:,5) == yNeigh) == 1
                    openIndex = find(openCells(:,4) == xNeigh & openCells(:,5) == yNeigh);
                    if openCells(openIndex, 7) > minFunction
                        openCells(openIndex, 2) = xCurr;
                        openCells(openIndex, 3) = yCurr;
                        openCells(openIndex, 6) = gCost;
                        openCells(openIndex, 7) = minFunction;
                    end
                else
                    openCells = [openCells; [true, xCurr, yCurr, xNeigh, yNeigh, gCost, minFunction]];
                end
            end
        end
    end

    freeCells = find(openCells(:,1) == 1);

    if size(freeCells, 1) > 0
        minFunctionInd = freeCells(find(min(openCells(freeCells,7)) == openCells(freeCells, 7), 1, 'first'));
        xCurr = openCells(minFunctionInd, 4);
        yCurr = openCells(minFunctionInd, 5);

        init2currCost = openCells(minFunctionInd, 6);
        closedCells = [closedCells; [xCurr, yCurr]];

        openCells(minFunctionInd, 1) = 0;
    else
        disp('All cells were analysed. There is no possible path.')
        break
    end

end

xInverse = closedCells(end, 1);
yInverse = closedCells(end, 2);

if (xInverse == xGoal) && (yInverse == yGoal)

    optimalPath = [xInverse, yInverse];

    invInd = find(xInverse == openCells(:,4) & yInverse == openCells(:,5) & 0 == openCells(:,1), 1, 'last');
    totalCost = openCells(invInd, 7);

    while (xInverse ~= xInit) || (yInverse ~= yInit)

        invInd = find(xInverse == openCells(:,4) & yInverse == openCells(:,5) & 0 == openCells(:,1), 1, 'last');

        xInverse = openCells(invInd, 2);
        yInverse = openCells(invInd, 3);

        optimalPath = [optimalPath; [xInverse, yInverse]];
    end

    optimalPath = optimalPath(end:-1:1, :);

    hold on
    plot(optimalPath(:,1), optimalPath(:,2), 'b', 'LineWidth', 2)
    hold off
end

end