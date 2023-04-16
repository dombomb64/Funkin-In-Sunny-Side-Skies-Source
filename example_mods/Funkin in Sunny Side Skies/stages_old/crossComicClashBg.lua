function onCreate()
	-- background stuffs
	makeLuaSprite('crossComicClashBg1', 'crossComicClashBg1', -1050, -1600);
	--setScrollFactor('crossComicClashBg1', 0.65, 0.65);
	scaleObject('crossComicClashBg1', 3, 3);
	setProperty('crossComicClashBg1.antialiasing', false);
	
	makeAnimatedLuaSprite('crossComicClashBg2', 'crossComicClashBg2', -1050, -1600);
	--setScrollFactor('crossComicClashBg2', 0.7, 0.7);
	scaleObject('crossComicClashBg2', 3, 3);
	--setProperty('crossComicClashBg2.scale.x', 3);
	--setProperty('crossComicClashBg2.scale.y', 3);
	setProperty('crossComicClashBg2.antialiasing', false);
	addAnimationByPrefix('crossComicClashBg2', 'idle', 'Idle', 24, true);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('crossComicClashBg1', false);
	addLuaSprite('crossComicClashBg2', true);

	setProperty('defaultCamZoom', 0.75);

	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end