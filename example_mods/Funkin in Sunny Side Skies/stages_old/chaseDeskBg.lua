function onCreate()
	-- background stuffs
	makeLuaSprite('chaseDeskBg1', 'chaseDeskBg1', -1050, -1600);
	--setScrollFactor('chaseDeskBg1', 0.65, 0.65);
	scaleObject('chaseDeskBg1', 3, 3);
	setProperty('chaseDeskBg1.antialiasing', false);
	
	makeLuaSprite('chaseDeskBg2', 'chaseDeskBg2', -1050, -1600);
	--setScrollFactor('chaseDeskBg2', 0.7, 0.7);
	scaleObject('chaseDeskBg2', 3, 3);
	setProperty('chaseDeskBg2.antialiasing', false);

	makeLuaSprite('chaseDeskBg3', 'chaseDeskBg3', -1050, -1600);
	--setScrollFactor('chaseDeskBg3', 0.9, 0.9);
	scaleObject('chaseDeskBg3', 3, 3);
	--setProperty('chaseDeskBg3.scale.x', 3);
	--setProperty('chaseDeskBg3.scale.y', 3);
	setProperty('chaseDeskBg3.antialiasing', false);

	makeLuaSprite('darkFg', 'darkFg', -1050, -1600);
	--setScrollFactor('darkFg', 0.9, 0.9);
	scaleObject('darkFg', 3, 3);
	setProperty('darkFg.antialiasing', false);
	setBlendMode('darkFg', 'multiply');

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('chaseDeskBg1', false);
	addLuaSprite('chaseDeskBg2', false);
	addLuaSprite('chaseDeskBg3', false);
	addLuaSprite('darkFg', true);

	--setProperty('boyfriend.alpha', 0);
	doTweenAlpha('bfHide', 'boyfriendGroup', 0, 0.01, 'linear');

	--runTimer('orderLegs', 0.01, 1);
	--setObjectOrder('adamStuckLegsPlayer', getObjectOrder('chaseDeskBg4') + 1);
	--debugPrint(getObjectOrder('chaseDeskBg4'));
	--debugPrint(getObjectOrder('adamStuckLegsPlayer'));

	setProperty('defaultCamZoom', 0.75);

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onCreatePost()
	local camX = (getProperty('dad.x') + getProperty('dad.width') / 2) + 150;
	local camY = (getProperty('dad.y') + getProperty('dad.height') / 2) - 100;
	camX = camX + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]');
	camY = camY + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]');
	
	triggerEvent('Camera Follow Pos', tonumber(camX), tonumber(camY));
	--debugPrint('test');

	close(true);
end

--[[function onBeatHit()
	--cameraSetTarget('dad');
	setProperty('camFollow.x', (getProperty('dad.x') + getProperty('dad.width') / 2) + 150);
	setProperty('camFollow.y', (getProperty('dad.y') + getProperty('dad.height') / 2) - 100);
	--setProperty('camFollow.x', getProperty('camFollow.x') + getPropertyFromGroup('dad.cameraPosition', 0, 0) + getPropertyFromGroup('opponentCameraOffset', 0, 0));
	--setProperty('camFollow.y', getProperty('camFollow.y') + getPropertyFromGroup('dad.cameraPosition', 1, 0) + getPropertyFromGroup('opponentCameraOffset', 1, 0));
	setProperty('camFollow.x', getProperty('camFollow.x') + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'));
	setProperty('camFollow.y', getProperty('camFollow.y') + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'));
	--debugPrint(getProperty('camFollow.x') .. ', ' .. getProperty('camFollow.y'));
	--runEvent('Camera Follow Pos', );
	cancelTween('cameraTwn');
end]]--