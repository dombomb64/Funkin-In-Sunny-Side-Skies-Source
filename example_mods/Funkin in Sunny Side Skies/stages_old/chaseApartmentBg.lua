function onCreate()
	-- background stuffs
	makeLuaSprite('chaseApartmentBg1', 'chaseApartmentBg1', -600, -900);
	setScrollFactor('chaseApartmentBg1', 0.5, 0.5);
	scaleObject('chaseApartmentBg1', 2, 2);
	setProperty('chaseApartmentBg1.antialiasing', false);
	
	makeLuaSprite('chaseApartmentBg2', 'chaseApartmentBg2', -600, -900);
	setScrollFactor('chaseApartmentBg2', 0.5, 0.5);
	scaleObject('chaseApartmentBg2', 2, 2);
	setProperty('chaseApartmentBg2.antialiasing', false);

	makeLuaSprite('chaseApartmentBg3', 'chaseApartmentBg3', -600, -900);
	setScrollFactor('chaseApartmentBg3', 0.5, 0.5);
	scaleObject('chaseApartmentBg3', 2, 2);
	setProperty('chaseApartmentBg3.antialiasing', false);

	makeLuaSprite('chaseApartmentBg4', 'chaseApartmentBg4', -600, -900);
	setScrollFactor('chaseApartmentBg4', 0.5, 0.5);
	scaleObject('chaseApartmentBg4', 2, 2);
	setProperty('chaseApartmentBg4.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('chaseApartmentBg1', false);
	addLuaSprite('chaseApartmentBg2', false);
	--addLuaSprite('chaseApartmentBg3', false);
	--addLuaSprite('chaseApartmentBg4', false);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end