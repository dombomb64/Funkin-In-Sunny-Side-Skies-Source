function onCreate()
	-- background stuffs
	makeLuaSprite('winterBgNutshell1', 'winterBgNutshell1', -1050, -1600);
	--setScrollFactor('winterBgNutshell1', 0.65, 0.65);
	scaleObject('winterBgNutshell1', 3, 3);
	setProperty('winterBgNutshell1.antialiasing', false);
	
	makeLuaSprite('winterBgNutshell2', 'winterBgNutshell2', -1050, -1600);
	--setScrollFactor('winterBgNutshell2', 0.7, 0.7);
	scaleObject('winterBgNutshell2', 3, 3);
	setProperty('winterBgNutshell2.antialiasing', false);

	makeLuaSprite('winterBgNutshell3', 'winterBgNutshell3', -1050, -1600);
	--setScrollFactor('winterBgNutshell3', 0.9, 0.9);
	scaleObject('winterBgNutshell3', 3, 3);
	setProperty('winterBgNutshell3.antialiasing', false);

	makeLuaSprite('winterBgNutshell4', 'winterBgNutshell4', -1050, -1600);
	--setScrollFactor('winterBgNutshell4', 0.9, 0.9);
	scaleObject('winterBgNutshell4', 3, 3);
	setProperty('winterBgNutshell4.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('winterBgNutshell1', false);
	addLuaSprite('winterBgNutshell2', false);
	addLuaSprite('winterBgNutshell3', false);
	addLuaSprite('winterBgNutshell4', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end