function onCreate()
	setProperty('boyfriend.x', -1200);
	setProperty('dad.x', 420);
	
	local camX = (getProperty('dad.x') + getProperty('dad.width') / 2) + 150;
	local camY = (getProperty('dad.y') + getProperty('dad.height') / 2) - 100;
	camX = camX + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]');
	camY = camY + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]');

	triggerEvent('Camera Follow Pos', tonumber(camX), tonumber(camY));
	
	close(true);
end

--[[function onCreatePost()
	runHaxeCode(
		camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
		camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
		camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
	);
	--setProperty('camFollowPos.x', getProperty('camPos.x'));
	--setProperty('camFollowPos.y', getProperty('camPos.y'));
	--setProperty('camFollow.x', camX);
	--setProperty('camFollow.y', camY);
	--setProperty('camFollowPos.x', camX);
	--setProperty('camFollowPos.y', camY);
	--setProperty('isCameraOnForcedPos', true);
	
	--debugPrint('test');

	close(true);
end]]--