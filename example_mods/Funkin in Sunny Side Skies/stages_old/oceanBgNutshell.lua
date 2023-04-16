function onCreate()
	-- background stuffs
	makeLuaSprite('oceanBgNutshell1', 'oceanBgNutshell1', -825, -900);
	setScrollFactor('oceanBgNutshell1', 1.0, 1.0);
	scaleObject('oceanBgNutshell1', 3.0, 3.0);
	
	makeLuaSprite('oceanBgNutshell2', 'oceanBgNutshell2', -825, -900);
	setScrollFactor('oceanBgNutshell2', 1.0, 1.0);
	scaleObject('oceanBgNutshell2', 3.0, 3.0);

	makeLuaSprite('oceanBgNutshell3a', 'oceanBgNutshell3', -825, -900);
	setScrollFactor('oceanBgNutshell3a', 1.0, 1.0);
	scaleObject('oceanBgNutshell3a', 3.0, 3.0);

	makeLuaSprite('oceanBgNutshell3b', 'oceanBgNutshell3', -825, -900);
	setScrollFactor('oceanBgNutshell3b', 1.0, 1.0);
	scaleObject('oceanBgNutshell3b', 3.0, 3.0);
	setProperty('oceanBgNutshell3b.flipX', true);

	makeLuaSprite('oceanBgNutshell4a', 'oceanBgNutshell4', -825, -900);
	setScrollFactor('oceanBgNutshell4a', 1.0, 1.0);
	scaleObject('oceanBgNutshell4a', 3.0, 3.0);
	
	makeLuaSprite('oceanBgNutshell4b', 'oceanBgNutshell4', -825, -900);
	setScrollFactor('oceanBgNutshell4b', 1.0, 1.0);
	scaleObject('oceanBgNutshell4b', 3.0, 3.0);
	setProperty('oceanBgNutshell4b.flipX', true);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('oceanBgNutshell1', false);
	addLuaSprite('oceanBgNutshell2', false);
	addLuaSprite('oceanBgNutshell3a', false);
	addLuaSprite('oceanBgNutshell3b', false);
	addLuaSprite('oceanBgNutshell4a', true);
	addLuaSprite('oceanBgNutshell4b', true);

	setProperty('defaultCamZoom', 0.775);

	--[[if (getProperty(songName) == 'Eye Spy' or getProperty(songName) == 'Free the End') then
		setProperty('defaultCamZoom', 1.0);
	else
		setProperty('defaultCamZoom', 0.8);
	end]]--
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end