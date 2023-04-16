function onCreate()
	-- background stuffs
	makeLuaSprite('arcadeBlitz1', 'arcadeBlitz1', -300, -700);
	setScrollFactor('arcadeBlitz1', 0.65, 0.65);
	scaleObject('arcadeBlitz1', 0.8, 0.8);
	
	makeLuaSprite('arcadeBlitz2', 'arcadeBlitz2', -300, -700);
	setScrollFactor('arcadeBlitz2', 0.7, 0.7);
	scaleObject('arcadeBlitz2', 0.8, 0.8);

	makeLuaSprite('arcadeBlitz3', 'arcadeBlitz3', -315, -600);
	setScrollFactor('arcadeBlitz3', 0.9, 0.9);
	scaleObject('arcadeBlitz3', 0.75, 0.75);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('arcadeBlitz1', false);
	addLuaSprite('arcadeBlitz2', false);
	addLuaSprite('arcadeBlitz3', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end