local bgX = -1050;
local bgWidth = 0;

function onCreate()
	-- background stuffs
	local scrollSpeed = 0.25;
	makeLuaSprite('alacrityBg1', 'alacrityBg1', bgX, -1600);
	setScrollFactor('alacrityBg1', 0, 0);
	scaleObject('alacrityBg1', 3, 3);
	setProperty('alacrityBg1.antialiasing', false);
	
	--makeLuaSprite('alacrityBg2', 'alacrityBg2', -1050, -1600);
	--setScrollFactor('alacrityBg2', 0.5, 0.5);
	--scaleObject('alacrityBg2', 3, 3);
	--setProperty('alacrityBg2.antialiasing', false);

	makeLuaSprite('alacrityBg3a', 'alacrityBg3', bgX, -1600);
	setScrollFactor('alacrityBg3a', scrollSpeed, scrollSpeed);
	scaleObject('alacrityBg3a', 3, 3);
	setProperty('alacrityBg3a.antialiasing', false);

	bgWidth = getProperty('alacrityBg3a.width');

	makeLuaSprite('alacrityBg3b', 'alacrityBg3', bgX - bgWidth, -1600);
	setScrollFactor('alacrityBg3b', scrollSpeed, scrollSpeed);
	scaleObject('alacrityBg3b', 3, 3);
	setProperty('alacrityBg3b.antialiasing', false);

	makeLuaSprite('alacrityBg4a', 'alacrityBg4', bgX, -1600);
	setScrollFactor('alacrityBg4a', scrollSpeed, scrollSpeed);
	scaleObject('alacrityBg4a', 3, 3);
	setProperty('alacrityBg4a.antialiasing', false);

	makeLuaSprite('alacrityBg4b', 'alacrityBg4', bgX + bgWidth, -1600);
	setScrollFactor('alacrityBg4b', scrollSpeed, scrollSpeed);
	scaleObject('alacrityBg4b', 3, 3);
	setProperty('alacrityBg4b.antialiasing', false);
	
	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
	end

	addLuaSprite('alacrityBg1', false);
	--addLuaSprite('alacrityBg2', false);
	addLuaSprite('alacrityBg3a', false);
	addLuaSprite('alacrityBg3b', false);
	addLuaSprite('alacrityBg4a', false);
	addLuaSprite('alacrityBg4b', false);

	setProperty('defaultCamZoom', 0.5);

	--debugPrint(bgWidth);

	bgTween();

	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onTweenCompleted(tag)
	if tag == 'bgScroll3a' then
		setProperty('alacrityBg3a.x', bgX);
		setProperty('alacrityBg3b.x', bgX - bgWidth);
		setProperty('alacrityBg4a.x', bgX);
		setProperty('alacrityBg4b.x', bgX + bgWidth);
		--runTimer('bgTween', 0.05, 1);
		bgTween();
		--debugPrint('test');
	end
end

--[[function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'bgTween' then
		bgTween();
	end
end]]--

function bgTween()
	local scrollTime = crochet / 1000 * 32;
	doTweenX('bgScroll3a', 'alacrityBg3a', bgX + bgWidth, scrollTime, 'linear');
	doTweenX('bgScroll3b', 'alacrityBg3b', bgX, scrollTime, 'linear');
	doTweenX('bgScroll4a', 'alacrityBg4a', bgX - bgWidth, scrollTime, 'linear');
	doTweenX('bgScroll4b', 'alacrityBg4b', bgX, scrollTime, 'linear');
end