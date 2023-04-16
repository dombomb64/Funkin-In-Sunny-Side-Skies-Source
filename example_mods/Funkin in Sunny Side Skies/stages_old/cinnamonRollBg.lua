function onCreate()
	-- background stuffs
	makeLuaSprite('cinnamonRollBg', 'cinnamonRollBg', -1050, -1600);
	setScrollFactor('cinnamonRollBg', 0.5, 0.5);
	scaleObject('cinnamonRollBg', 3, 3);
	setProperty('cinnamonRollBg.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('cinnamonRollBg', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end