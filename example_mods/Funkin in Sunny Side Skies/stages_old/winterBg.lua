function onCreate()
	-- background stuffs
	makeLuaSprite('winterBg1', 'winterBg1', -300, -700);
	setScrollFactor('winterBg1', 0.65, 0.65);
	scaleObject('winterBg1', 0.8, 0.8);
	
	makeLuaSprite('winterBg2', 'winterBg2', -300, -700);
	setScrollFactor('winterBg2', 0.7, 0.7);
	scaleObject('winterBg2', 0.8, 0.8);

	makeLuaSprite('winterBg3', 'winterBg3', -315, -600);
	setScrollFactor('winterBg3', 0.9, 0.9);
	scaleObject('winterBg3', 0.75, 0.75);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('winterBg1', false);
	addLuaSprite('winterBg2', false);
	addLuaSprite('winterBg3', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end