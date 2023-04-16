-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)

function onCreate()
	--setProperty('strumLine.x', getProperty('STRUM_X_MIDDLESCROLL'));
	setProperty('strumLine.x', -278);
end

function onCreatePost()
	--local isMiddlescroll = getPropertyFromClass('ClientPrefs', 'middleScroll');
	--debugPrint(getProperty('SONG.arrowSkin'));
	--debugPrint(getPropertyFromGroup('playerStrums', 0, 'texture'));
	if getPropertyFromGroup('playerStrums', 0, 'texture') == 'noteAssetsStepmania' then
		makeLuaSprite('stepmaniaBg', 'menuDesat', 0, 0);
		setObjectCamera('stepmaniaBg', 'hud');
		setScrollFactor('stepmaniaBg', 0, 0);
		doTweenColor('bgColor', 'stepmaniaBg', '222222', 0.01, 'linear');
		addLuaSprite('stepmaniaBg', true);
		setObjectOrder('stepmaniaBg', 0);
		--setProperty('defaultCamZoom', 1);

		--setPropertyFromClass('ClientPrefs', 'middleScroll', true);
		--setProperty('strumLine.x', getProperty('STRUM_X_MIDDLESCROLL'));
		setProperty('strumLine.x', -278);
		noteTweenX('note0Offscreen', 0, -1000, 0.01, 'linear');
		noteTweenX('note1Offscreen', 1, -1000, 0.01, 'linear');
		noteTweenX('note2Offscreen', 2, screenWidth + 1000, 0.01, 'linear');
		noteTweenX('note3Offscreen', 3, screenWidth + 1000, 0.01, 'linear');

		--local arrowDist = 200;
		--[[debugPrint(getPropertyFromGroup('playerStrums', 0, 'x'));
		debugPrint(getPropertyFromGroup('playerStrums', 1, 'x'));
		debugPrint(getPropertyFromGroup('playerStrums', 2, 'x'));
		debugPrint(getPropertyFromGroup('playerStrums', 3, 'x'));]]--
		setPropertyFromGroup('playerStrums', 0, 'x', 412);
		setPropertyFromGroup('playerStrums', 1, 'x', 524);
		setPropertyFromGroup('playerStrums', 2, 'x', 636);
		setPropertyFromGroup('playerStrums', 3, 'x', 748);

		--[[setStrumX(4);
		setStrumX(5);
		setStrumX(6);
		setStrumX(7);]]--
		--noteTweenX('note4Move', 4, screenWidth / 2 - (arrowDist * 2), 0.01, 'linear');
		--noteTweenX('note5Move', 5, screenWidth / 2 - (arrowDist * 2), 0.01, 'linear');
		--noteTweenX('note6Move', 6, screenWidth / 2 + (arrowDist * 2), 0.01, 'linear');
		--noteTweenX('note7Move', 7, screenWidth / 2 + (arrowDist * 2), 'linear');


		--setPropertyFromGroup('dad.healthColorArray', 0, 0, 255);
	end

	--debugPrint(getProperty('dad.curCharacter'));
	if getProperty('dad.curCharacter') == 'stepmaniaEnemy' then
		runTimer('dadIconInvisible', 0.01, 1);
	end
	if getProperty('boyfriend.curCharacter') == 'stepmaniaPlayer' then
		runTimer('bfIconInvisible', 0.01, 1);
	end

	return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dadIconInvisible' then
		setProperty('iconP2.alpha', 0);
	elseif tag == 'bfIconInvisible' then
		setProperty('iconP1.alpha', 0);
		--debugPrint(getProperty('strumLine.x'));
	end
end

function setStrumX(strumNum)
	--noteTweenX('note' .. strumNum .. 'Init', strumNum, getProperty('STRUM_X_MIDDLESCROLL'), 0.01, 'linear');
	--local strumX = getProperty('STRUM_X_MIDDLESCROLL') + getProperty('Note.swagWidth') * getProperty('noteData');
	local strumX = -278 + getPropertyFromClass('Note', 'swagWidth') * strumNum;
	--debugPrint('h');
	strumX = strumX + 50;
	--strumX = strumX + (screenWidth / 2);
	noteTweenX('note' .. strumNum .. 'Move', strumNum, strumX, 0.01, 'linear');
end

--function onPause()
	--setPropertyFromClass('ClientPrefs', 'middleScroll', isMiddlescroll);
--end