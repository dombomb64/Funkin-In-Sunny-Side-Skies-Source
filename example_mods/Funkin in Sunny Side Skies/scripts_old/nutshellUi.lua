-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)
-- Related Scripts: customBars, flipnoteUi, pixelArrows, pixelIcons (You can use those, too.)

isNutshell = false; -- This variable is not correctly set until after onCreatePost
isFlipnote = false;
isCustomStyle = false;
artStylePrefix = 'nutshellUi/';
artStylePrefixRating = 'nutshellUi/';

local showCombo = false;
local showComboNum = true;
local comboIdCounter = 9; -- 0 to 9, so there will be at most 10 sets of combo graphics at once

function onCreatePost()
	redoCreate();
end

--[[function onStartCountdown()
	runTimer('loadCountdownGraphicsNutshell', crochet / 1000, 5);
end]]--

--local loadGraphicCooldown = 0;

--[[function onUpdate(elapsed)
	if isNutshell == false then
		return;
	end

	--if curStep < 1 and loadGraphicCooldown == 0 then
	if curStep < 1 then
		loadGraphic('countdownReady', 'nutshellUi/ready');
		loadGraphic('countdownSet', 'nutshellUi/set');
		loadGraphic('countdownGo', 'nutshellUi/go');
		--loadGraphicCooldown = 10;
		--debugPrint(curStep);
	--else
		--loadGraphicCooldown = loadGraphicCooldown - 1;
	end
end]]--

--function onSongStart()
--end

function onCountdownTick(counter)
	--debugPrint('test');
	if isCustomStyle then
		if counter == 1 then
			--setProperty('countdownReady.offset.y', 5000);
			--runTimer('removeCountdownGraphics', 0, 1);
			--removeLuaSprite('countdownReady', true);
			loadGraphic('countdownReady', artStylePrefix .. 'ready');
			--setProperty('countdownReady.scale.x', 1);
			setProperty('countdownReady.antialiasing', false);
			--debugPrint('test');
			--makeLuaSprite('ready', 'nutshellUi/flipnote/ready', 0, 0);
			--setObjectCamera('ready', 'hud');
			--screenCenter('ready');
			--addLuaSprite('ready', true);
		elseif counter == 2 then
			--setProperty('countdownSet.offset.y', 5000);
			--runTimer('removeCountdownGraphics', 0, 1);
			--removeLuaSprite('countdownSet', true);
			loadGraphic('countdownSet', artStylePrefix .. 'set');
			setProperty('countdownSet.antialiasing', false);
		elseif counter == 3 then
			--setProperty('countdownGo.offset.y', 5000);
			--runTimer('removeCountdownGraphics', 0, 1);
			--removeLuaSprite('countdownGo', true);
			loadGraphic('countdownGo', artStylePrefix .. 'go');
			setProperty('countdownGo.antialiasing', false);
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'loadCountdownGraphicsNutshell' then
		if loopsLeft == 3 then
			loadGraphic('countdownReady', artStylePrefix .. 'ready');
			--setProperty('countdownReady.scale.x', 1);
			setProperty('countdownReady.antialiasing', false);
			--debugPrint('test');
		elseif loopsLeft == 2 then
			loadGraphic('countdownSet', artStylePrefix .. 'set');
			setProperty('countdownSet.antialiasing', false);
		elseif loopsLeft == 1 then
			loadGraphic('countdownGo', artStylePrefix .. 'go');
			setProperty('countdownGo.antialiasing', false);
		end
		--debugPrint('test');
	elseif string.find(tag, 'comboNumFade') ~= nil then
		local digit = string.sub(tag, 1, 1);
		local id = string.sub(tag, -1);
		--debugPrint(digit .. ', ' .. id);
		doTweenAlpha(tag, digit .. 'comboNum' .. id, 0, 0.2, 'linear');
	elseif string.find(tag, 'comboSpriteFade') ~= nil then
		--local digit = string.sub(tag, 1, 1);
		local id = string.sub(tag, -1);
		--debugPrint(digit .. ', ' .. id);
		doTweenAlpha(tag, 'comboSprite' .. id, 0, 0.2, 'linear');
	end
end

function onTweenCompleted(tag)
	if string.find(tag, 'comboNumFade') ~= nil then
		local digit = string.sub(tag, 1, 1);
		local id = string.sub(tag, -1);
		removeLuaSprite(digit .. 'comboNum' .. id, true);
	elseif string.find(tag, 'comboSpriteFade') ~= nil then
		local id = string.sub(tag, -1);
		--debugPrint(id);
		removeLuaSprite('comboSprite' .. id, true);
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	--debugPrint(getPropertyFromGroup('notes', id, 'hitCausesMiss'));
	if not isSustainNote and not getPropertyFromGroup('notes', id, 'hitCausesMiss') and isCustomStyle then
		popUpScore();
	end
end

function popUpScore()
	-- Update ID Counter
	if comboIdCounter == 9 then
		comboIdCounter = 0;
	else
		comboIdCounter = comboIdCounter + 1;
	end
	-- "Combo" Text
	comboSpriteName = 'comboSprite' .. comboIdCounter;

	makeLuaText('comboText', tostring(getProperty('combo')), 0, screenWidth * 0.35, 0);
	setTextSize('comboText', 32);
	setProperty('comboText.y', getProperty('camHUD.height') / 2 - getProperty('comboText.height') / 2);

	makeLuaSprite(comboSpriteName, artStylePrefixRating .. 'combo', getProperty('comboText.x'), getProperty('comboText.y'));
	setObjectCamera(comboSpriteName, 'hud');
	--setProperty(comboSpriteName .. '.x', getProperty('comboText.x'));
	setProperty(comboSpriteName .. '.acceleration.y', getRandomInt(200, 300));
	setProperty(comboSpriteName .. '.velocity.y', -getRandomInt(140, 160));
	setProperty(comboSpriteName .. '.x', getProperty(comboSpriteName .. '.x') + getPropertyFromClass('ClientPrefs', 'comboOffset[0]'));
	setProperty(comboSpriteName .. '.y', getProperty(comboSpriteName .. '.y') - getPropertyFromClass('ClientPrefs', 'comboOffset[1]') + 60);
	if not hideHud and showCombo then
		addLuaSprite(comboSpriteName, false);
	end

	--local comboSpriteScale = math.floor(getProperty(comboSpriteName .. '.width') * 0.7);
	setGraphicSize(comboSpriteName, math.floor(getProperty(comboSpriteName .. '.width') * 0.7), math.floor(getProperty(comboSpriteName .. '.height') * 0.7));
	--setProperty(comboSpriteName .. '.scale.x', comboSpriteScale);
	--setProperty(comboSpriteName .. '.scale.y', comboSpriteScale);
	setProperty(comboSpriteName .. '.antialiasing', false);
	--debugPrint('test');
	--debugPrint(getProperty(comboSpriteName .. '.scale.x') .. ', ' .. getProperty(comboSpriteName .. '.scale.y'));

	local separatedScore = {};
	if getProperty('combo') >= 1000 then
		table.insert(separatedScore, math.floor(getProperty('combo') / 1000) % 10);
	end
	table.insert(separatedScore, math.floor(getProperty('combo') / 100) % 10);
	table.insert(separatedScore, math.floor(getProperty('combo') / 10) % 10);
	table.insert(separatedScore, getProperty('combo') % 10);
	--debugPrint(separatedScore);

	-- Combo Numbers
	for i, v in ipairs(separatedScore) do
		local numSpriteName = i .. 'comboNum' .. comboIdCounter;

		makeLuaSprite(numSpriteName, artStylePrefixRating .. 'num' .. v);
		setObjectCamera(numSpriteName, 'hud');
		setProperty(numSpriteName .. '.x', getProperty('comboText.x') + (43 * (i - 1)) - 90 + getPropertyFromClass('ClientPrefs', 'comboOffset[2]'));
		setProperty(numSpriteName .. '.y', getProperty('camHUD.height') / 2 - getProperty(numSpriteName .. '.height') / 2 + 80 - getPropertyFromClass('ClientPrefs', 'comboOffset[3]'));
		setGraphicSize(numSpriteName, math.floor(getProperty(numSpriteName .. '.width') * 0.5), math.floor(getProperty(numSpriteName .. '.height') * 0.5));
		setProperty(numSpriteName .. '.antialiasing', false);
		setProperty(numSpriteName .. '.acceleration.y', getRandomInt(200, 300));
		setProperty(numSpriteName .. '.velocity.y', -getRandomInt(140, 160));
		setProperty(numSpriteName .. '.velocity.x', getRandomInt(-5, 5));
		if not hideHud and showComboNum then
			addLuaSprite(numSpriteName, false);
		end
		runTimer(i .. 'comboNumFade' .. comboIdCounter, crochet * 0.002, 1);
		--doTweenAlpha(i .. 'comboNumFade' .. comboIdCounter, numSpriteName, 0, 0.2, 'linear');
	end
	runTimer('comboSpriteFade' .. comboIdCounter, crochet * 0.002, 1);
end

--[[function checkNutshell() -- To be run only after unspawnNotes has been filled (onCreatePost and onwards)
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
			isNutshell = true;
			isCustomStyle = true;
			--debugPrint('nutshell');
			break;
		end
	end
end

function checkFlipnote()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		--if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteRed' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteBlue' then
			isFlipnote = true;
			isCustomStyle = true;
			--debugPrint('flipnote');
			break;
		end
	end
end]]--

function checkStyle() -- To be run only after unspawnNotes has been filled (onCreatePost and onwards)
	isNutshell = false;
	isFlipnote = false;
	isCustomStyle = false;
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
			isNutshell = true;
			isCustomStyle = true;
			--debugPrint('nutshell');
			break;
		end
	end
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		--if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteRed' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteBlue' then
			isFlipnote = true;
			isCustomStyle = true;
			--debugPrint('flipnote');
			break;
		end
	end
end

function redoCreate()
	showCombo = getProperty('showCombo');
	showComboNum = getProperty('showComboNum');

	--checkNutshell();
	--checkFlipnote();
	checkStyle();

	if not isNutshell then
		--debugPrint('test');
		if isFlipnote then
			artStylePrefix = 'nutshellUi/flipnote/';
		else
			return;
		end
	end

	--isCustomStyle = true;

	setProperty('showCombo', false);
	setProperty('showComboNum', false);

	precacheImage(artStylePrefixRating .. 'sick');
	precacheImage(artStylePrefixRating .. 'good');
	precacheImage(artStylePrefix .. 'bad');
	precacheImage(artStylePrefix .. 'shit');
	precacheImage(artStylePrefix .. 'ready');
	precacheImage(artStylePrefix .. 'set');
	precacheImage(artStylePrefix .. 'go');
	precacheImage(artStylePrefix .. 'combo');
	precacheImage(artStylePrefixRating .. 'num0');
	precacheImage(artStylePrefixRating .. 'num1');
	precacheImage(artStylePrefixRating .. 'num2');
	precacheImage(artStylePrefixRating .. 'num3');
	precacheImage(artStylePrefixRating .. 'num4');
	precacheImage(artStylePrefixRating .. 'num5');
	precacheImage(artStylePrefixRating .. 'num6');
	precacheImage(artStylePrefixRating .. 'num7');
	precacheImage(artStylePrefixRating .. 'num8');
	precacheImage(artStylePrefixRating .. 'num9');

	setProperty('ratingsData[0].image', artStylePrefixRating .. 'sick');
	setProperty('ratingsData[1].image', artStylePrefixRating .. 'good');
	setProperty('ratingsData[2].image', artStylePrefix .. 'bad');
	setProperty('ratingsData[3].image', artStylePrefix .. 'shit');

	--runTimer('loadCountdownGraphics', crochet / 1000, 5);

	--[[setProperty('introAlts[0]', 'nutshellUi/ready');
	setProperty('introAlts[1]', 'nutshellUi/set');
	setProperty('introAlts[2]', 'nutshellUi/go');]]--
	--popUpScore();
	--runTimer('1comboNumFade0', crochet * 0.002, 1);
end