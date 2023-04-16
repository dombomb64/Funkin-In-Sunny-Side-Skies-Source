function onCreate()
	-- background stuffs
	makeLuaSprite('arcadeBlitzNutshell1', 'arcadeBlitzNutshell1', -1050, -1600);
	--setScrollFactor('arcadeBlitzNutshell1', 0.65, 0.65);
	--scaleObject('arcadeBlitzNutshell1', 0.8, 0.8);
	setProperty('arcadeBlitzNutshell1.antialiasing', false);
	
	makeLuaSprite('arcadeBlitzNutshell2', 'arcadeBlitzNutshell2', -1050, -1600);
	--setScrollFactor('arcadeBlitzNutshell2', 0.7, 0.7);
	--scaleObject('arcadeBlitzNutshell2', 0.8, 0.8);
	setProperty('arcadeBlitzNutshell2.antialiasing', false);

	makeLuaSprite('arcadeBlitzNutshell3', 'arcadeBlitzNutshell3', -1050, -1600);
	--setScrollFactor('arcadeBlitzNutshell3', 0.9, 0.9);
	--scaleObject('arcadeBlitzNutshell3', 0.75, 0.75);
	setProperty('arcadeBlitzNutshell3.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('arcadeBlitzNutshell1', false);
	addLuaSprite('arcadeBlitzNutshell2', false);
	addLuaSprite('arcadeBlitzNutshell3', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end