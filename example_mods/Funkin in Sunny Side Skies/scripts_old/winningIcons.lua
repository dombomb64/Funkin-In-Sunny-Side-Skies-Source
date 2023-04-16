-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)
--
-- The icons have to go in images/winningIcons and have to have an XML file.
-- The XML file has to have the animations "Winning", "Losing", and "Neutral".
-- This also supports animated icons.
--
-- Related Scripts: iconOffsets, pixelIcons (You can use those, too.)

function onCreatePost()
	--debugPrint('winningIcons/icon-' .. getProperty('iconP1.char'));
	makeIcons();
end

--Ignore this lol I forgor about curAnim
--local animationFlag = 0; --0 = Already Playing BF Losing, 1 = Already Playing Neutral, 2 = Already Playing BF Winning, 3 = Updating to BF Losing, 4 = Updating to Neutral, 5 = Updating to BF Winning

function onUpdatePost()
	setProperty('bfIcon.x', getProperty('iconP1.x'));
	setProperty('bfIcon.scale.x', getProperty('iconP1.scale.x'));
	setProperty('bfIcon.scale.y', getProperty('iconP1.scale.y'));

	setProperty('dadIcon.x', getProperty('iconP2.x'));
	setProperty('dadIcon.scale.x', getProperty('iconP2.scale.x'));
	setProperty('dadIcon.scale.y', getProperty('iconP2.scale.y'));

	--debugPrint(getProperty('bfIcon.animation.curAnim'), getProperty('bfIcon.animation.finished'));
	--if getProperty('healthBar.percent') < 20 and ((getProperty('bfIcon.animation.curAnim') ~= 'losing' and getProperty('bfIcon.animation.curAnim') ~= 'bfIcon.animation.curAnim') or (getProperty('dadIcon.animation.curAnim') ~= 'winning' and getProperty('dadIcon.animation.curAnim') ~= 'dadIcon.animation.curAnim')) then
	if getProperty('healthBar.percent') < 20 and (getProperty('bfIcon.animation.curAnim') ~= 'losing' or getProperty('dadIcon.animation.curAnim') ~= 'winning') then
		objectPlayAnimation('bfIcon', 'losing', true);
		objectPlayAnimation('dadIcon', 'winning', true);
	elseif getProperty('healthBar.percent') > 80 and (getProperty('bfIcon.animation.curAnim') ~= 'winning' or getProperty('dadIcon.animation.curAnim') ~= 'losing') then
		objectPlayAnimation('bfIcon', 'winning', true);
		objectPlayAnimation('dadIcon', 'losing', true);
	elseif getProperty('bfIcon.animation.curAnim') ~= 'neutral' or getProperty('dadIcon.animation.curAnim') ~= 'neutral' then
		objectPlayAnimation('bfIcon', 'neutral', true);
		objectPlayAnimation('dadIcon', 'neutral', true);
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Character' then
		makeIcons();
	end

	--print('Event triggered: ', name, value1, value2);
end

function makeIcons()
	removeLuaSprite('bfIcon', true);
	removeLuaSprite('dadIcon', true);
	setProperty('iconP1.alpha', 1);
	setProperty('iconP2.alpha', 1);

	if getProperty('iconP1.char') == 'adamNutshell' or getProperty('iconP1.char') == 'adamAbuse' or getProperty('iconP1.char') == 'kristenNutshell' or getProperty('iconP1.char') == 'chaseNutshell' or getProperty('iconP1.char') == 'chaseAbuse' or getProperty('iconP1.char') == 'elliotNutshell' or getProperty('iconP1.char') == 'senpaiNutshell' or getProperty('iconP1.char') == 'dudeNutshell' or getProperty('iconP1.char') == 'jimNutshell' or getProperty('iconP1.char') == 'pjNutshell' or getProperty('iconP1.char') == 'dandyNutshell' or getProperty('iconP1.char') == 'jomjom412' or getProperty('iconP1.char') == 'dombomb64' then
		makeBfIcon();
	end

	if getProperty('iconP2.char') == 'adamNutshell' or getProperty('iconP2.char') == 'adamAbuse' or getProperty('iconP2.char') == 'kristenNutshell' or getProperty('iconP2.char') == 'chaseNutshell' or getProperty('iconP2.char') == 'chaseAbuse' or getProperty('iconP2.char') == 'elliotNutshell' or getProperty('iconP2.char') == 'senpaiNutshell' or getProperty('iconP2.char') == 'dudeNutshell' or getProperty('iconP2.char') == 'jimNutshell' or getProperty('iconP2.char') == 'pjNutshell' or getProperty('iconP2.char') == 'dandyNutshell' or getProperty('iconP1.char') == 'jomjom412' or getProperty('iconP1.char') == 'dombomb64' then
		makeDadIcon();
	end
end

function makeBfIcon()
	makeAnimatedLuaSprite('bfIcon', 'winningIcons/icon-' .. getProperty('iconP1.char'), getProperty('iconP1.x'), getProperty('iconP1.y'));

	addAnimationByPrefix('bfIcon', 'winning', 'Winning', 24, true);
	addAnimationByPrefix('bfIcon', 'neutral', 'Neutral', 24, true);
	addAnimationByPrefix('bfIcon', 'losing', 'Losing', 24, true);

	addLuaSprite('bfIcon', true);

	setObjectCamera('bfIcon', 'hud');
	setProperty('bfIcon.flipX', true);
	objectPlayAnimation('bfIcon', 'neutral', true);
	setObjectOrder('bfIcon', getObjectOrder('iconP1'));
	setProperty('bfIcon.antialiasing', getProperty('iconP1.antialiasing'));

	setProperty('iconP1.alpha', 0);
end

function makeDadIcon()
	makeAnimatedLuaSprite('dadIcon', 'winningIcons/icon-' .. getProperty('iconP2.char'), getProperty('iconP2.x'), getProperty('iconP2.y'));

	addAnimationByPrefix('dadIcon', 'winning', 'Winning', 24, true);
	addAnimationByPrefix('dadIcon', 'neutral', 'Neutral', 24, true);
	addAnimationByPrefix('dadIcon', 'losing', 'Losing', 24, true);

	addLuaSprite('dadIcon', true);

	setObjectCamera('dadIcon', 'hud');
	--setProperty('dadIcon.flipX', true);
	objectPlayAnimation('dadIcon', 'neutral', true);
	setObjectOrder('dadIcon', getObjectOrder('iconP2'));
	setProperty('dadIcon.antialiasing', getProperty('iconP2.antialiasing'));

	setProperty('iconP2.alpha', 0);
end