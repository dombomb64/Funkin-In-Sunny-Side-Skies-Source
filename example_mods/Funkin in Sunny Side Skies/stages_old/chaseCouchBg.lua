function onCreate()
	-- background stuffs
	makeLuaSprite('chaseCouchBg1', 'chaseCouchBg1', -1050, -1600);
	--setScrollFactor('chaseCouchBg1', 0.65, 0.65);
	scaleObject('chaseCouchBg1', 3, 3);
	setProperty('chaseCouchBg1.antialiasing', false);
	
	makeLuaSprite('chaseCouchBg2', 'chaseCouchBg2', -1050, -1600);
	--setScrollFactor('chaseCouchBg2', 0.7, 0.7);
	scaleObject('chaseCouchBg2', 3, 3);
	setProperty('chaseCouchBg2.antialiasing', false);

	makeAnimatedLuaSprite('chaseCouchBg3', 'chaseCouchBg3', -1050, -1600);
	--setScrollFactor('chaseCouchBg3', 0.9, 0.9);
	scaleObject('chaseCouchBg3', 3, 3);
	--setProperty('chaseCouchBg3.scale.x', 3);
	--setProperty('chaseCouchBg3.scale.y', 3);
	setProperty('chaseCouchBg3.antialiasing', false);
	addAnimationByPrefix('chaseCouchBg3', 'danceLeft', 'Dance Left', 24, false);
	addAnimationByPrefix('chaseCouchBg3', 'danceRight', 'Dance Right', 24, false);

	makeLuaSprite('chaseCouchBg4', 'chaseCouchBg4', -1050, -1600);
	--setScrollFactor('chaseCouchBg4', 0.9, 0.9);
	scaleObject('chaseCouchBg4', 3, 3);
	setProperty('chaseCouchBg4.antialiasing', false);
	
	makeAnimatedLuaSprite('chaseCouchBg5', 'chaseCouchBg5', -1050, -1600);
	--setScrollFactor('chaseCouchBg5', 0.9, 0.9);
	scaleObject('chaseCouchBg5', 3, 3);
	--setProperty('chaseCouchBg5.scale.x', 3);
	--setProperty('chaseCouchBg5.scale.y', 3);
	setProperty('chaseCouchBg5.antialiasing', false);
	addAnimationByPrefix('chaseCouchBg5', 'idle', 'Idle', 24, true);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('chaseCouchBg1', false);
	addLuaSprite('chaseCouchBg2', false);
	addLuaSprite('chaseCouchBg3', true);
	addLuaSprite('chaseCouchBg5', true);
	addLuaSprite('chaseCouchBg4', true);

	playAnim('chaseCouchBg5', 'idle');

	runTimer('orderLegs', 0.01, 1);
	--setObjectOrder('adamStuckLegsPlayer', getObjectOrder('chaseCouchBg4') + 1);
	--debugPrint(getObjectOrder('chaseCouchBg4'));
	--debugPrint(getObjectOrder('adamStuckLegsPlayer'));

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

--[[function onBeatHit()
	if curBeat % 4 == 0 then
		objectPlayAnimation('chaseCouchBg3', 'danceLeft', true);
	elseif (curBeat + 2) % 4 == 0 then
		objectPlayAnimation('chaseCouchBg3', 'danceRight', true);
	end
end]]--

--[[function onCountdownTick(counter)
	if counter % 4 == 0 then
		objectPlayAnimation('chaseCouchBg3', 'danceLeft', true);
	elseif (counter + 2) % 4 == 0 then
		objectPlayAnimation('chaseCouchBg3', 'danceRight', true);
	end
end]]--

--[[function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'orderLegs' then
		--debugPrint('test');
		setObjectOrder('adamStuckLegsPlayer', getObjectOrder('chaseCouchBg4') + 1);
	end
end]]--