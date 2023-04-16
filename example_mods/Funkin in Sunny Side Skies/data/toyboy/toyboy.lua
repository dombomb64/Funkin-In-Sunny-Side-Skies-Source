function onCreate()
	setProperty('skipCountdown', true);
	setProperty('camGame.zoom', 0.65);
end

function onBeatHit()
	if curBeat == 0 then
		setProperty('camGame.zoom', 0.65);
	elseif curBeat == 2 then
		setProperty('camGame.zoom', 0.7);
	elseif curBeat == 4 then
		setProperty('camGame.zoom', 0.75);
	elseif curBeat == 6 then
		setProperty('camGame.zoom', 0.8);
	elseif curBeat == 8 then
		setProperty('defaultCamZoom', 0.60);
		--setProperty('camGame.zoom', 0.60);
	elseif curBeat == 455 then
		setProperty('cameraSpeed', 999);
	elseif curBeat == 459 then
		cameraSetTarget('boyfriend');
	end
end