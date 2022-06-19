function scene = mainApp(sim, clientID)

    scene = Scene(sim, clientID);
    scene.addStatusBarMessage('Session started!');
    scene.addStatusBarMessage('Session closed!');

end