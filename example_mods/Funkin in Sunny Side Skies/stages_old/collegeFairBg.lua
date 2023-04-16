function onCreate()
	-- background stuffs
	makeLuaSprite('collegeFairBg1', 'collegeFairBg1', -1050, -1600);
	--setScrollFactor('collegeFairBg1', 0.65, 0.65);
	scaleObject('collegeFairBg1', 3, 3);
	setProperty('collegeFairBg1.antialiasing', false);
	
	makeLuaSprite('collegeFairBg2', 'collegeFairBg2', -1050, -1600);
	--setScrollFactor('collegeFairBg2', 0.7, 0.7);
	scaleObject('collegeFairBg2', 3, 3);
	setProperty('collegeFairBg2.antialiasing', false);

	makeAnimatedLuaSprite('collegeFairBg3', 'collegeFairBg3', -1050, -1600);
	--setScrollFactor('collegeFairBg3', 0.9, 0.9);
	scaleObject('collegeFairBg3', 3, 3);
	--setProperty('collegeFairBg3.scale.x', 3);
	--setProperty('collegeFairBg3.scale.y', 3);
	setProperty('collegeFairBg3.antialiasing', false);
	addAnimationByPrefix('collegeFairBg3', 'idle', 'Idle', 24, false);

	makeLuaSprite('collegeFairBg4', 'collegeFairBg4', -1050, -1600);
	--setScrollFactor('collegeFairBg4', 0.9, 0.9);
	scaleObject('collegeFairBg4', 3, 3);
	setProperty('collegeFairBg4.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('collegeFairBg1', false);
	addLuaSprite('collegeFairBg2', false);
	addLuaSprite('collegeFairBg3', false);
	addLuaSprite('collegeFairBg4', false);

	setProperty('defaultCamZoom', 0.75);

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onBeatHit()
	if curBeat % 2 == 0 then
		objectPlayAnimation('collegeFairBg3', 'idle', true);
	end
end

function onCountdownTick(counter)
	if counter % 4 == 0 then
		objectPlayAnimation('collegeFairBg3', 'idle', true);
	end
end