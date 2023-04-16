local cutsceneFinished = false;
local dialogueFinished = false;

function onStartCountdown()
	if not cutsceneFinished and isStoryMode and not seenCutscene then
		startVideo('raveyard');
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

function onTweenCompleted(tag)
	if (tag == 'bgFade') then
		removeLuaSprite('dialogueBg', true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('frustration', 'chase');
	end
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
	-- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end