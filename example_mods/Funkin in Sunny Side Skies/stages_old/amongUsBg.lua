function onCreate()
	-- Light Bg
	makeLuaSprite('amongUsBg1', 'amongUsBg1', -500, -500);
	setScrollFactor('amongUsBg1', 1, 1);
	--scaleObject('amongUsBg1', 3, 3);
	setProperty('amongUsBg1.antialiasing', false);
	
	makeLuaSprite('amongUsBg2', 'amongUsBg2', -500, -500);
	setScrollFactor('amongUsBg2', 1, 1);
	--scaleObject('amongUsBg2', 3, 3);
	setProperty('amongUsBg2.antialiasing', false);

	-- Dark Bg
	makeLuaSprite('darkAmongUsBg1', 'darkAmongUsBg1', -800, -800);
	setScrollFactor('darkAmongUsBg1', 1, 1);
	setProperty('darkAmongUsBg1.scale.x', 3);
	setProperty('darkAmongUsBg1.scale.y', 3);
	setProperty('darkAmongUsBg1.antialiasing', false);
	updateHitbox('darkAmongUsBg1');

	makeAnimatedLuaSprite('darkAmongUsBg2', 'darkAmongUsBg2', -800, -800);
	setScrollFactor('darkAmongUsBg2', 1, 1);
	setProperty('darkAmongUsBg2.scale.x', 3);
	setProperty('darkAmongUsBg2.scale.y', 3);
	setProperty('darkAmongUsBg2.antialiasing', false);
	addAnimationByPrefix('darkAmongUsBg2', 'idle', 'Idle', 24, true);
	updateHitbox('darkAmongUsBg2');

	makeLuaSprite('darkAmongUsBg3', 'darkAmongUsBg3', -800, -800);
	setScrollFactor('darkAmongUsBg3', 1, 1);
	setProperty('darkAmongUsBg3.scale.x', 3);
	setProperty('darkAmongUsBg3.scale.y', 3);
	setProperty('darkAmongUsBg3.antialiasing', false);
	updateHitbox('darkAmongUsBg3');

	-- Running Bg
	makeLuaSprite('whiteVoid', 'whiteVoid', -500, -500);
	setScrollFactor('whiteVoid', 0, 0);
	setProperty('whiteVoid.scale.x', 3);
	setProperty('whiteVoid.scale.y', 3);
	setProperty('whiteVoid.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	-- background stuffs
	loadLightBg();
	
	--setProperty('gf.alpha', 0);
	--local gfAlpha = 0;

	--if (songName == 'Drippy') then
		--setProperty('gf.x', 300);
		--setProperty('gf.y', -1320);
		--doTweenX(gfX, 'gf', 300, 0, linear);
		--setProperty('gf.alpha', 1);
		--gfAlpha = 1;
	--end

	--doTweenAlpha('gfAlpha', 'gfGroup', gfAlpha, 0, 'linear');

	--setPropertyClass('ClientPrefs', 'globalAntialiasing', false);
	--setPropertyClass('ClientPrefs', 'camZooms', false);
	--setProperty('antialias', false);
	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function loadLightBg()
	addLuaSprite('amongUsBg1', false);
	addLuaSprite('amongUsBg2', true);
end

function loadDarkBg()
	addLuaSprite('darkAmongUsBg1', false);
	addLuaSprite('darkAmongUsBg2', false);
	addLuaSprite('darkAmongUsBg3', true);

	objectPlayAnimation('darkAmongUsBg2', 'idle', true);
end

function loadRunningBg()
	addLuaSprite('whiteVoid', false);
end

function removeBg()
	removeLuaSprite('amongUsBg1', false);
	removeLuaSprite('amongUsBg2', false);

	removeLuaSprite('darkAmongUsBg1', false);
	removeLuaSprite('darkAmongUsBg2', false);
	removeLuaSprite('darkAmongUsBg3', false);

	removeLuaSprite('whiteVoid', false);
end