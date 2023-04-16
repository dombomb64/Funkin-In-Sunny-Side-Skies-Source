function onCreate()
	--setProperty("instakillOnMiss", true);
	setProperty("healthBar.alpha", 0.0);
	setProperty("healthGain", 0);
	setProperty("healthLoss", 100);
	--cameraFade('hud', '0x00000000', 2, true);
	--noteTweenAlpha('noteFade1', 0, 0, 1, 'linear');
	--doTweenZoom('hudZoomIn', 'camHUD', 2, 10, 'sineInOut');
end

function onBeatHit(elapsed)
	if (curBeat == 64) then
		--camera tween to gf over crochet * 4 seconds except it doesn't exist
		--noteTweenAlpha('noteFade1', 0, 0, crochet / 4, 'sineInOut');
		--cameraFade('hud', getColorFromHex('0x00000000'), crochet * 4, true);
		doTweenZoom('hudZoomIn', 'camHUD', 4, 8, 'sineInOut');
	elseif (curBeat == 84) then
		setProperty("healthBar.alpha", 1.0);
		setProperty("healthGain", 1);
		setProperty("healthLoss", 1);
		--cameraFade('hud', getColorFromHex('0xFFFFFFFF'), crochet * 2, true);
		--doTweenZoom('hudZoomIn', 'camHUD', 1, 2, 'sineInOut');
	end
	if (curBeat >= 68 and curBeat < 132) then
		cameraShake('game', 0.01, 0.3);
	end
end