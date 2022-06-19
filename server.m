clear; close all; clc;

sim = remApi('remoteApi');
sim.simxFinish(-1);

localHostConnectionAddress = '127.0.0.1';
connectionPort = 19999;
waitUntilConnected = true;
doNotReconnectOnceDisconnected = true;
timeoutMs = 5000;
commThreadCycleMs = 5;

clientID = sim.simxStart( ...
    localHostConnectionAddress, ...
    connectionPort, ...
    waitUntilConnected, ...
    doNotReconnectOnceDisconnected, ...
    timeoutMs, ...
    commThreadCycleMs ...
);

successfulConnection = (clientID == 0);

if ~successfulConnection
    disp('Failed connection between Matlab and CoppeliaSim.');
    return
end

disp('Successful Connection between Matlab and CoppeliaSim.');

scene = mainApp(sim, clientID);

sim.simxGetPingTime(clientID);
sim.simxFinish(clientID);

disp('Disconnected!')