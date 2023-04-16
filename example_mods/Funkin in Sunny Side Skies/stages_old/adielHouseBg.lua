function onCreate()
	-- background stuffs
	makeLuaSprite('adielHouseBg1', 'adielHouseBg1', -1050, -1600);
	--setScrollFactor('adielHouseBg1', 0.65, 0.65);
	scaleObject('adielHouseBg1', 3, 3);
	setProperty('adielHouseBg1.antialiasing', false);
	
	makeLuaSprite('adielHouseBg2', 'adielHouseBg2', -1050, -1600);
	--setScrollFactor('adielHouseBg2', 0.7, 0.7);
	scaleObject('adielHouseBg2', 3, 3);
	setProperty('adielHouseBg2.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('adielHouseBg1', false);
	addLuaSprite('adielHouseBg2', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end