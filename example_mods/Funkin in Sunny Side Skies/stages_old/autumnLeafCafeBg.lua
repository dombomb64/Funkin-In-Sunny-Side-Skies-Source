function onCreate()
	-- background stuffs
	makeLuaSprite('autumnLeafCafeBg1', 'autumnLeafCafeBg1', -1050, -1600);
	--setScrollFactor('autumnLeafCafeBg1', 0.65, 0.65);
	scaleObject('autumnLeafCafeBg1', 3, 3);
	setProperty('autumnLeafCafeBg1.antialiasing', false);
	
	makeLuaSprite('autumnLeafCafeBg2', 'autumnLeafCafeBg2', -1050, -1600);
	--setScrollFactor('autumnLeafCafeBg2', 0.7, 0.7);
	scaleObject('autumnLeafCafeBg2', 3, 3);
	setProperty('autumnLeafCafeBg2.antialiasing', false);

	makeLuaSprite('autumnLeafCafeBg3', 'autumnLeafCafeBg3', -1050, -1600);
	--setScrollFactor('autumnLeafCafeBg3', 0.9, 0.9);
	scaleObject('autumnLeafCafeBg3', 3, 3);
	setProperty('autumnLeafCafeBg3.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('autumnLeafCafeBg1', false);
	addLuaSprite('autumnLeafCafeBg2', false);
	addLuaSprite('autumnLeafCafeBg3', false);
	setObjectOrder('boyfriendGroup', getObjectOrder('autumnLeafCafeBg3'));

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end