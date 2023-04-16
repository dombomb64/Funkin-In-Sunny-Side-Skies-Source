function onCreate()
	-- background stuffs
	makeLuaSprite('whiteVoid', 'whiteVoid', -1050, -1600);
	setScrollFactor('whiteVoid', 0, 0);
	scaleObject('whiteVoid', 3, 3);
	setProperty('whiteVoid.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('whiteVoid', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end