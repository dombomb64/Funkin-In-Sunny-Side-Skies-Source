function onCreate()
	setProperty('defaultCamZoom', 0.6);
	setProperty('camGame.zoom', 0.6);

	precacheSound('amongUsKill');
end

function onStepHit()
	if curStep == 2394 then
		playSound('amongUsKill', 5, 'amongUsKill');
	end
end