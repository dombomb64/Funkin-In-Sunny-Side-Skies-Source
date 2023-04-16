function onCreate()
	-- background stuffs
	precacheImage('runBg1');
	precacheImage('runBg2');
	loadStillBg();

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onBeatHit()
	if curBeat == 188 then
		--makeGraphic('blackScreen', 1000, 1000, "000000");
		--addLuaSprite('blackScreen', true);
		--setScrollFactor('blackScreen', 1, 1);
		--setObjectCamera('blackScreen', 'hud');
		cameraFlash('game', '000000', 99999999, true);
	--elseif curBeat == 191 then
		--loadRunBg();
	elseif curBeat == 192 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		--removeLuaSprite('blackScreen', true);
		loadRunBg();
	elseif curBeat == 383 then
		cameraFlash('game', '000000', 99999999, true);
	elseif curBeat == 384 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		loadStillBg();
	elseif curBeat == 508 then
		cameraFlash('game', '000000', 99999999, true);
	elseif curBeat == 512 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		loadRunBg();
	elseif curBeat == 580 then
		cameraFade('game', '000000', crochet / 1000, true);
		loadRunBg();
	end
end

function loadStillBg()
	removeLuaSprite('runBg1', true);
	removeLuaSprite('runBg2', true);

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

	setProperty('boyfriend.x', 870);
	setProperty('boyfriend.y', 100);
	setProperty('gf.x', 400);
	setProperty('gf.y', 0);
	setProperty('dad.x', 0);
	setProperty('dad.y', 102);
end

function loadRunBg()
	removeLuaSprite('arcadeBlitzNutshell1', true);
	removeLuaSprite('arcadeBlitzNutshell2', true);
	removeLuaSprite('arcadeBlitzNutshell3', true);

	makeAnimatedLuaSprite('runBg1', 'runBg1', -500, -500);
	scaleObject('runBg1', 3, 3);
	setProperty('runBg1.antialiasing', false);
	addAnimationByPrefix('runBg1', 'scroll', 'Scroll', 24, true);

	makeLuaSprite('runBg2', 'runBg2', -500, -500);
	scaleObject('runBg2', 3, 3);
	setProperty('runBg2.antialiasing', false);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('runBg1', false);
	addLuaSprite('runBg2', false);

	objectPlayAnimation('runBg1', 'scroll');

	setProperty('defaultCamZoom', 0.5);

	setProperty('boyfriend.x', 1320);
	setProperty('boyfriend.y', 720);
	setProperty('gf.x', 700);
	setProperty('gf.y', 510);
	setProperty('dad.x', 510);
	setProperty('dad.y', 270);
end