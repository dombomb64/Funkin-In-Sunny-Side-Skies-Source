--[[isDodging = false;

--function onCreate()
	--addLuaScript('.../.../custom_notetypes/Snowball Note')
	--local isDodging = false;
--end

function onUpdate(elapsed)
	if getProperty('FlxG.keys.justPressed.SPACE') == true then
		isDodging = true;
		runTimer('dodgeStop', 1, 1);
		debugPrint('dodge');
	end
	
	if isDodging == true then
		setProperty('boyfriend.alpha', 0.5);
		setProperty('boyfriend.color', '0x888888');
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dodgeStop' then
		isDodging = false;
	elseif tag == 'snowballImpact' then
		if isDodging == false then
			playSound('snowballImpact', 5, 'snowballImpact');
		end
	end
end]]--

local cutsceneFinished = false;
local dialogueFinished = false;
local endDialogueFinished = false;

function onStartCountdown()
	if not cutsceneFinished and isStoryMode and not seenCutscene then
		startVideo('freeTime');
		cutsceneFinished = true;

		makeLuaSprite('dialogueBg', 'menuDesat', screenWidth / 2, screenHeight / 2);
		setObjectCamera('dialogueBg', 'hud');
		setScrollFactor('dialogueBg', 0, 0);
		doTweenColor('bgColor', 'dialogueBg', '222222', 0.01, 'linear');
		addLuaSprite('dialogueBg', true);

		return Function_Stop;
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	elseif not dialogueFinished and isStoryMode and not seenCutscene then
		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		dialogueFinished = true;
		return Function_Stop;
	end
	doTweenAlpha('bgFade', 'dialogueBg', 0, 1, 'sineInOut');
	return Function_Continue;
end

--[[function onBeatHit()
	if curBeat == 256 and isStoryMode then
		makeLuaSprite('dialogueBg', 'menuDesat', 0, 0);
		setObjectCamera('dialogueBg', 'hud');
		setScrollFactor('dialogueBg', 0, 0);
		setProperty('dialogueBg.alpha', 0);
		doTweenColor('bgColor', 'dialogueBg', '222222', 0.01, 'linear');
		addLuaSprite('dialogueBg', true);
		doTweenAlpha('bgFade', 'dialogueBg', 1, 1, 'sineInOut');
	end
end]]--

function onEndSong()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not endDialogueFinished and isStoryMode then
		makeLuaSprite('dialogueBg', 'menuDesat', 0, 0);
		setObjectCamera('dialogueBg', 'hud');
		setScrollFactor('dialogueBg', 0, 0);
		setProperty('dialogueBg.alpha', 0);
		doTweenAlpha('bgFadeIn', 'dialogueBg', 1, 0.5, 'sineInOut');
		doTweenColor('bgColor', 'dialogueBg', '222222', 0.01, 'linear');
		addLuaSprite('dialogueBg', true);

		setProperty('inCutscene', true);
		runTimer('startEndingDialogue', 0.8);
		endDialogueFinished = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onTweenCompleted(tag)
	if (tag == 'bgFadeOut') then
		removeLuaSprite('dialogueBg', true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'frustration');
	elseif tag == 'startEndingDialogue' then -- Timer completed, play dialogue
		startDialogue('endingDialogue', 'kristen');
	end
end