function onCreate()
	-- background stuffs
	makeLuaSprite('autumnLeafCafeSketchBg1', 'autumnLeafCafeSketchBg1', -1050, -1600);
	--setScrollFactor('autumnLeafCafeSketchBg1', 0.65, 0.65);
	scaleObject('autumnLeafCafeSketchBg1', 3, 3);
	setProperty('autumnLeafCafeSketchBg1.antialiasing', false);
	
	makeLuaSprite('autumnLeafCafeSketchBg2', 'autumnLeafCafeSketchBg2', -1050, -1600);
	--setScrollFactor('autumnLeafCafeSketchBg2', 0.7, 0.7);
	scaleObject('autumnLeafCafeSketchBg2', 3, 3);
	setProperty('autumnLeafCafeSketchBg2.antialiasing', false);

	makeLuaSprite('autumnLeafCafeSketchBg3', 'autumnLeafCafeSketchBg3', -1050, -1600);
	--setScrollFactor('autumnLeafCafeSketchBg3', 0.9, 0.9);
	scaleObject('autumnLeafCafeSketchBg3', 3, 3);
	setProperty('autumnLeafCafeSketchBg3.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('autumnLeafCafeSketchBg1', false);
	addLuaSprite('autumnLeafCafeSketchBg2', false);
	addLuaSprite('autumnLeafCafeSketchBg3', false);
	setObjectOrder('dadGroup', getObjectOrder('autumnLeafCafeSketchBg3'));

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end