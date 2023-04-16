local allowCountdown = false;
local trippyStrums = false;
local trippySwapTime = 0;
local trippyUi = false;
--local trueTime = 0;

function onSongStart()
	trippySwapTime = crochet / 1000 * 8;
	--trueTime = getProperty('songLength');
	--debugPrint(trueTime);
	setProperty('songLength', 120000);
end

function onStartCountdown()
	-- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
	if not allowCountdown and isStoryMode and not seenCutscene then
		makeLuaSprite('dialogueBg', 'menuDesat', screenWidth / 2, screenHeight / 2);
		setObjectCamera('dialogueBg', 'hud');
		setScrollFactor('dialogueBg', 0, 0);
		doTweenColor('bgColor', 'dialogueBg', '222222', 0.01, 'linear');
		addLuaSprite('dialogueBg', true);

		setProperty('inCutscene', true);
		runTimer('startDialogue', 0.8);
		allowCountdown = true;
		return Function_Stop;
	end
	doTweenAlpha('bgFade', 'dialogueBg', 0, 1, 'sineInOut');
	return Function_Continue;
end

function onTweenCompleted(tag)
	if (tag == 'bgFade') then
		removeLuaSprite('dialogueBg', true);
	elseif tag == 'trippyStrumsSwap0' then
		noteTweenX('trippyStrumsUnswap0', 0, defaultOpponentStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap1', 1, defaultOpponentStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap2', 2, defaultOpponentStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap3', 3, defaultOpponentStrumX3, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap4', 4, defaultPlayerStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap5', 5, defaultPlayerStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap6', 6, defaultPlayerStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsUnswap7', 7, defaultPlayerStrumX3, trippySwapTime, 'sineInOut');
	elseif tag == 'trippyStrumsUnswap0' and trippyStrums then
		noteTweenX('trippyStrumsSwap0', 0, defaultPlayerStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap1', 1, defaultPlayerStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap2', 2, defaultPlayerStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap3', 3, defaultPlayerStrumX3, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap4', 4, defaultOpponentStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap5', 5, defaultOpponentStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap6', 6, defaultOpponentStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap7', 7, defaultOpponentStrumX3, trippySwapTime, 'sineInOut');
	elseif tag == 'trippyStrumsUnswap0' then
		noteTweenAlpha('trippyStrumsShow0', 0, 1, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsShow1', 1, 1, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsShow2', 2, 1, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsShow3', 3, 1, crochet / 1000, 'circInOut');
	elseif tag == 'trippyUiLeft' and trippyUi then
		doTweenAngle('trippyUiRight', 'camHUD', 10, trippySwapTime, 'sineInOut');
	elseif tag == 'trippyUiLeft' then
		doTweenAngle('trippyUiCenter', 'camHUD', 0, trippySwapTime, 'sineInOut');
	elseif tag == 'trippyUiRight' then
		doTweenAngle('trippyUiLeft', 'camHUD', -10, trippySwapTime, 'sineInOut');
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'trouble');
	end
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
	-- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end

function onBeatHit()
	if curBeat == 387 then
		--cameraFlash('game', '000000', 99999999, true);
		triggerEvent('Cut to Black', '', '');
	elseif curBeat == 393 then
		runHaxeCode([[
			game.modchartTweens.set('tweenSongLength', FlxTween.tween(game, {songLength: 164134}, Conductor.crochet / 1000 * 3, {ease: FlxEase.sineInOut,
				onComplete: function(twn:FlxTween) {
					PlayState.instance.callOnLuas('onTweenCompleted', ['tweenSongLength']);
					PlayState.instance.modchartTweens.remove('tweenSongLength');

					#if desktop
					// Updating Discord Rich Presence (with Time Left)
					DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), true, songLength, getLogoName(dad.curCharacter));
					#end
				}
			}));
		]]);
	elseif curBeat == 396 then
		--cameraFlash('game', 'ffffff', crochet / 1000, true);
		triggerEvent('Flash White', '', '');
		trippyStrums = true;
		noteTweenX('trippyStrumsSwap0', 0, defaultPlayerStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap1', 1, defaultPlayerStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap2', 2, defaultPlayerStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap3', 3, defaultPlayerStrumX3, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap4', 4, defaultOpponentStrumX0, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap5', 5, defaultOpponentStrumX1, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap6', 6, defaultOpponentStrumX2, trippySwapTime, 'sineInOut');
		noteTweenX('trippyStrumsSwap7', 7, defaultOpponentStrumX3, trippySwapTime, 'sineInOut');
		noteTweenAlpha('trippyStrumsHide0', 0, 0.5, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsHide1', 1, 0.5, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsHide2', 2, 0.5, crochet / 1000, 'circInOut');
		noteTweenAlpha('trippyStrumsHide3', 3, 0.5, crochet / 1000, 'circInOut');
		--setProperty('songLength', trueTime);
	--elseif curBeat == 400 then
		--trippyStrums = false;
	elseif curBeat == 460 then
	--elseif curBeat == 4 then
		trippyUi = true;
		--setProperty('camHUD.zoom', 0.5);
		--doTweenZoom('hudNoCutoff', 'camHUD', 2, crochet / 1000 * 32, 'linear');
		--debugPrint(getProperty('camHUD.scroll.y'));
		--setProperty('camHUD.height', getProperty('camHUD.height') * 2);

		--local tempX = getProperty('camHUD.width') / 2;
		--local tempY = getProperty('camHUD.height') / 2;

		--setProperty('camHUD.scroll.y', getProperty('camHUD.scroll.y') * 2);
		--setProperty('camHUD.scroll.y', -1000);

		--[[runHaxeCode(
			//game.camHUD.focusOn(new FlxPoint(0, 1000));
			//game.camHUD.updateFollow();
			//game.camHUD.updateScroll();
			//game.camHUD.setScale(0.5, 2);
			game.camHUD.zoom = 0.5;
			//FlxTween.tween(game.camHUD, {zoom: 0.5}, crochet / 1000 * 1, {ease: FlxEase.quadInOut});
			game.camHUD.setSize(game.camHUD.width * 2, game.camHUD.height * 2);
			//game.camHUD.focusOn(new FlxPoint(game.camHUD.width / 2, game.camHUD.height / 2));
		);]]--

		--debugPrint(getProperty('camHUD.scroll.x'));
		--debugPrint(getProperty('camHUD.scroll.y'));
		doTweenAngle('trippyUiLeft', 'camHUD', -10, trippySwapTime, 'sineInOut');
	elseif curBeat == 523 then
		--cameraFlash('game', '000000', 99999999, true);
		triggerEvent('Cut to Black', '', '');
	elseif curBeat == 528 then
		trippyStrums = false;
		trippyUi = false;
		--cameraFlash('game', 'ffffff', crochet / 1000, true);
		triggerEvent('Flash White', '', '');
	end
end
