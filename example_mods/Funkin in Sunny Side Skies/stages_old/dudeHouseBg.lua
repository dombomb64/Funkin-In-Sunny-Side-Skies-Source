--local defaultCameraSpeed = 0;

function onCreate()
	-- background stuffs
	precacheImage('dudeHouseSkewBg1');
	precacheImage('dudeHouseSkewBg2');
	precacheImage('dudeHouseSkewBg3');
	precacheImage('dudeHouseSkewBg4');
	precacheImage('dudeHouseSkewBg5');
	loadNormalBg();

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

--[[function onBeatHit()
	if songName == 'Challeng-Edd Unfair' and curBeat == 231 then
		loadSkewBg();
	end
end]]--

--[[function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'defaultCameraSpeed' then
		setProperty('cameraSpeed', defaultCameraSpeed);
	end
end]]--

function loadNormalBg()
	removeLuaSprite('dudeHouseSkewBg1', false);
	removeLuaSprite('dudeHouseSkewBg2', false);
	removeLuaSprite('dudeHouseSkewBg3', false);
	removeLuaSprite('dudeHouseSkewBg4', false);
	removeLuaSprite('dudeHouseSkewBg5', false);

	setProperty('boyfriendGroup.x', 870);
	setProperty('boyfriendGroup.y', 102);
	setProperty('gfGroup.x', 400);
	setProperty('gfGroup.y', 0);
	setProperty('dadGroup.x', 0);
	setProperty('dadGroup.y', 102);

	makeLuaSprite('dudeHouseBg1', 'dudeHouseBg1', -600, 600);
	setScrollFactor('dudeHouseBg1', 0.2, 0.2);
	--scaleObject('dudeHouseBg1', 0.8, 0.8);
	setProperty('dudeHouseBg1.scale.x', 3);
	setProperty('dudeHouseBg1.scale.y', 3);
	setProperty('dudeHouseBg1.antialiasing', false);
	
	makeLuaSprite('dudeHouseBg2', 'dudeHouseBg2', -600, -1900);
	setScrollFactor('dudeHouseBg2', 0.6, 0.6);
	--scaleObject('dudeHouseBg2', 0.8, 0.8);
	setProperty('dudeHouseBg2.scale.x', 3);
	setProperty('dudeHouseBg2.scale.y', 3);
	setProperty('dudeHouseBg2.antialiasing', false);

	makeLuaSprite('dudeHouseBg3', 'dudeHouseBg3', -600, -1900);
	--setScrollFactor('dudeHouseBg3', 0.9, 0.9);
	--scaleObject('dudeHouseBg3', 0.75, 0.75);
	setProperty('dudeHouseBg3.scale.x', 3);
	setProperty('dudeHouseBg3.scale.y', 3);
	setProperty('dudeHouseBg3.antialiasing', false);

	makeLuaSprite('dudeHouseBg4', 'dudeHouseBg4', -600, -1900);
	--setScrollFactor('dudeHouseBg4', 0.9, 0.9);
	--scaleObject('dudeHouseBg4', 0.75, 0.75);
	setProperty('dudeHouseBg4.scale.x', 3);
	setProperty('dudeHouseBg4.scale.y', 3);
	setProperty('dudeHouseBg4.antialiasing', false);

	makeLuaSprite('dudeHouseBg5', 'dudeHouseBg5', -600, -1900);
	--setScrollFactor('dudeHouseBg5', 0.9, 0.9);
	--scaleObject('dudeHouseBg5', 0.75, 0.75);
	setProperty('dudeHouseBg5.scale.x', 3);
	setProperty('dudeHouseBg5.scale.y', 3);
	setProperty('dudeHouseBg5.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('dudeHouseBg1', false);
	addLuaSprite('dudeHouseBg2', false);
	addLuaSprite('dudeHouseBg3', false);
	addLuaSprite('dudeHouseBg4', false);
	addLuaSprite('dudeHouseBg5', false);

	setProperty('defaultCamZoom', 0.5);
	--[[defaultCameraSpeed = getProperty('cameraSpeed');
	setProperty('cameraSpeed', 9999);
	runTimer('defaultCameraSpeed', 0.1, 1);]]--
end


function loadSkewBg()
	removeLuaSprite('dudeHouseBg1', false);
	removeLuaSprite('dudeHouseBg2', false);
	removeLuaSprite('dudeHouseBg3', false);
	removeLuaSprite('dudeHouseBg4', false);
	removeLuaSprite('dudeHouseBg5', false);

	setProperty('boyfriendGroup.x', 870);
	setProperty('boyfriendGroup.y', 102);
	setProperty('gfGroup.x', 291);
	setProperty('gfGroup.y', 0);
	setProperty('dadGroup.x', -210);
	setProperty('dadGroup.y', 102);

	makeLuaSprite('dudeHouseSkewBg1', 'dudeHouseSkewBg1', -600, 0);
	setScrollFactor('dudeHouseSkewBg1', 0.2, 0.2);
	--scaleObject('dudeHouseSkewBg1', 0.8, 0.8);
	setProperty('dudeHouseSkewBg1.scale.x', 3);
	setProperty('dudeHouseSkewBg1.scale.y', 3);
	setProperty('dudeHouseSkewBg1.antialiasing', false);
	
	makeLuaSprite('dudeHouseSkewBg2', 'dudeHouseSkewBg2', -600, -2500);
	setScrollFactor('dudeHouseSkewBg2', 0.6, 0.6);
	--scaleObject('dudeHouseSkewBg2', 0.8, 0.8);
	setProperty('dudeHouseSkewBg2.scale.x', 3);
	setProperty('dudeHouseSkewBg2.scale.y', 3);
	setProperty('dudeHouseSkewBg2.antialiasing', false);

	makeLuaSprite('dudeHouseSkewBg3', 'dudeHouseSkewBg3', -600, -2500);
	--setScrollFactor('dudeHouseSkewBg3', 0.9, 0.9);
	--scaleObject('dudeHouseSkewBg3', 0.75, 0.75);
	setProperty('dudeHouseSkewBg3.scale.x', 3);
	setProperty('dudeHouseSkewBg3.scale.y', 3);
	setProperty('dudeHouseSkewBg3.antialiasing', false);

	makeLuaSprite('dudeHouseSkewBg4', 'dudeHouseSkewBg4', -600, -2500);
	--setScrollFactor('dudeHouseSkewBg4', 0.9, 0.9);
	--scaleObject('dudeHouseSkewBg4', 0.75, 0.75);
	setProperty('dudeHouseSkewBg4.scale.x', 3);
	setProperty('dudeHouseSkewBg4.scale.y', 3);
	setProperty('dudeHouseSkewBg4.antialiasing', false);

	makeLuaSprite('dudeHouseSkewBg5', 'dudeHouseSkewBg5', -600, -2500);
	--setScrollFactor('dudeHouseSkewBg5', 0.9, 0.9);
	--scaleObject('dudeHouseSkewBg5', 0.75, 0.75);
	setProperty('dudeHouseSkewBg5.scale.x', 3);
	setProperty('dudeHouseSkewBg5.scale.y', 3);
	setProperty('dudeHouseSkewBg5.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('dudeHouseSkewBg1', false);
	addLuaSprite('dudeHouseSkewBg2', false);
	addLuaSprite('dudeHouseSkewBg3', false);
	addLuaSprite('dudeHouseSkewBg4', false);
	addLuaSprite('dudeHouseSkewBg5', false);

	setProperty('defaultCamZoom', 0.25);
	--[[defaultCameraSpeed = getProperty('cameraSpeed');
	setProperty('cameraSpeed', 9999);
	runTimer('defaultCameraSpeed', 0.25, 1);]]--

	close();
end