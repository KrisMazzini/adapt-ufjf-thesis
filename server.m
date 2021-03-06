function [sim, clientID] = server()
    
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

end