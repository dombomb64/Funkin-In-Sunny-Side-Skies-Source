function onCreate()
	-- background stuffs
	makeAnimatedLuaSprite('runBg1', 'runBg1', -500, -500);
	--setScrollFactor('runBg1', 1, 1);
	scaleObject('runBg1', 3, 3);
	setProperty('runBg1.antialiasing', false);
	addAnimationByPrefix('runBg1', 'scroll', 'Scroll', 24, true);

	makeLuaSprite('runBg2', 'runBg2', -500, -500);
	scaleObject('runBg2', 3, 3);
	setProperty('runBg2.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('runBg1', false);
	addLuaSprite('runBg2', false);

	objectPlayAnimation('runBg1', 'scroll');

	setProperty('defaultCamZoom', 0.5);

	--setPropertyClass('ClientPrefs', 'globalAntialiasing', false);
	--setPropertyClass('ClientPrefs', 'camZooms', false);
	--setProperty('antialias', false);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end