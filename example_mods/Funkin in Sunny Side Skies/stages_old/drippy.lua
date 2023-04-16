function onCreate()
	-- background stuffs
	makeLuaSprite('amongUsBg1', 'amongUsBg1', -500, -500);
	setScrollFactor('amongUsBg1', 1, 1);
	--scaleObject('amongUsBg1', 3, 3);
	
	makeLuaSprite('amongUsBg2', 'amongUsBg2', -500, -500);
	setScrollFactor('amongUsBg2', 1, 1);
	--scaleObject('amongUsBg2', 3, 3);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('amongUsBg1', false);
	addLuaSprite('amongUsBg2', true);

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

	--cameraSetTarget('dad');

	--setPropertyClass('ClientPrefs', 'globalAntialiasing', false);
	--setPropertyClass('ClientPrefs', 'camZooms', false);
	--setProperty('antialias', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end