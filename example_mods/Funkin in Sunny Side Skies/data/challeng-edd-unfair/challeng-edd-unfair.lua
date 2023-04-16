local pjX = 0;

function onCreate()
	pjX = getProperty('dad.x') - 1200;
	--precacheImage('characters/dudeTopDown');
	--addCharacterToList('jimAnnoyed', 'boyfriend');
	--addCharacterToList('dudeNutshell', 'dad');
	addCharacterToList('dandyRobot1', 'dad');
	addCharacterToList('dandyRobot2', 'dad');
	addCharacterToList('jimTopDown', 'boyfriend');
	--precacheImage('trashBag');
	--precacheImage('adamChallengEdd');
	--precacheImage('chaseChallengEdd');
	--precacheImage('pjChallengEdd');
	precacheImage('songSprites/appleThrow1');
	precacheImage('songSprites/appleThrow2');
	precacheImage('songSprites/appleExplosion1');
	precacheImage('songSprites/appleExplosion2');
	precacheImage('songSprites/appleExplosion3');

	--[[if difficulty ~= 3 then
		makeLuaSprite('trashBag', 'trashBag', -2600, 0);
		makeAnimatedLuaSprite('adam', 'adamChallengEdd', pjX - 300, getProperty('dad.y') - 100);
		makeAnimatedLuaSprite('chase', 'chaseChallengEdd', pjX - 600, getProperty('dad.y') + 100);
		makeAnimatedLuaSprite('pj', 'pjChallengEdd', pjX - 100, getProperty('dad.y'));

		addAnimationByPrefix('adam', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('adam', 'talk', 'Talk', 24, true);
		addAnimationByPrefix('adam', 'silent', 'Silent', 24, false);
		addAnimationByPrefix('chase', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('chase', 'talk', 'Talk', 24, true);
		addAnimationByPrefix('chase', 'silent', 'Silent', 24, false);
		--addAnimationByPrefix('pj', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('pj', 'talk', 'Talk', 24, true);
		addAnimationByPrefix('pj', 'silent', 'Silent', 24, false);

		setProperty('trashBag.scale.x', 3);
		setProperty('trashBag.scale.y', 3);
		setProperty('trashBag.antialiasing', false);
		setProperty('adam.scale.x', 3);
		setProperty('adam.scale.y', 3);
		setProperty('adam.antialiasing', false);
		setProperty('adam.flipX', true);
		setProperty('chase.scale.x', 3);
		setProperty('chase.scale.y', 3);
		setProperty('chase.antialiasing', false);
		setProperty('chase.flipX', true);
		setProperty('pj.scale.x', 3);
		setProperty('pj.scale.y', 3);
		setProperty('pj.antialiasing', false);

		addLuaSprite('trashBag', false);
		addLuaSprite('adam', false);
		addLuaSprite('chase', true);
	end]]--

	makeAnimatedLuaSprite('appleThrow1', 'songSprites/appleThrow1', 0, 0);
	makeAnimatedLuaSprite('appleThrow2', 'songSprites/appleThrow2', 0, 0);
	makeLuaSprite('appleExplosion1', 'songSprites/appleExplosion1', 0, 0);
	makeAnimatedLuaSprite('appleExplosion2', 'songSprites/appleExplosion2', 0, 0);
	makeLuaSprite('appleExplosion3', 'songSprites/appleExplosion3', 0, 0);

	addAnimationByPrefix('appleThrow1', 'idle', 'Idle', 24, true);
	addAnimationByPrefix('appleThrow2', 'idle', 'Idle', 24, false);
	addAnimationByPrefix('appleExplosion2', 'explode', 'Explode', 24, false);
	addAnimationByPrefix('appleExplosion2', 'idle', 'Idle', 24, true);

	setObjectCamera('appleThrow1', 'hud');
	setObjectCamera('appleThrow2', 'hud');
	setObjectCamera('appleExplosion1', 'hud');
	setObjectCamera('appleExplosion2', 'hud');
	setObjectCamera('appleExplosion3', 'hud');

	setProperty('appleThrow1.antialiasing', false);
	setProperty('appleThrow2.antialiasing', false);
	setProperty('appleExplosion1.antialiasing', false);
	setProperty('appleExplosion2.antialiasing', false);
	setProperty('appleExplosion3.antialiasing', false);

	setProperty('boyfriend2Group.x', getProperty('dad.x') - 210);
	setProperty('boyfriend2Group.y', getProperty('boyfriend.y'));
end

function onBeatHit()
	--[[if curBeat % 2 == 0 and curBeat < 398 then
		objectPlayAnimation('adam', 'idle', true);
		objectPlayAnimation('chase', 'idle', true);
	end]]--

	--if curBeat == 228 then
		--cameraFlash('game', '000000', 99999999, true);
	if curBeat == 231 then
		callScript('stages/dudeHouseBg', 'loadSkewBg', {});
	elseif curBeat == 232 then
		--cameraFlash('game', 'ffffff', crochet / 1000, true);
		setProperty('dadGroup.x', 0);
		--setProperty('boyfriend2.alpha', 1);
		--triggerEvent('Change Character', 'dad', 'dandyRobot1');
		setProperty('dad.alpha', 0.75);
		setBlendMode('dad', 'multiply');
		triggerEvent('Change Character', 'boyfriend', 'jimTopDown');
		setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1);
		setProperty('dadGroup.y', 2000);
		doTweenY('robotRise', 'dadGroup', 0, crochet / 1000 * 16, 'linear');
	--elseif curBeat == 264 then
		--debugPrint(getProperty('dad.x'));
		--setProperty('dadGroup.x', pjX);
		--setProperty('boyfriend2.alpha', 1);
		--triggerEvent('Change Character', 'dad', 'dandyRobot1');
		--setBlendMode('dad', 'multiply');
		--triggerEvent('Change Character', 'boyfriend', 'jimTopDown');
		--debugPrint(getProperty('dad.x'));
		
		--[[makeAnimatedLuaSprite('dudeIcon', 'winningIcons/icon-dudeNutshell', getProperty('iconP2.x'), getProperty('iconP2.y'));

		addAnimationByPrefix('dudeIcon', 'winning', 'Winning', 24, false);
		addAnimationByPrefix('dudeIcon', 'neutral', 'Neutral', 24, false);
		addAnimationByPrefix('dudeIcon', 'losing', 'Losing', 24, false);

		addLuaSprite('dudeIcon', true);

		setObjectCamera('dudeIcon', 'hud');
		setProperty('dudeIcon.flipX', true);
		objectPlayAnimation('dudeIcon', 'neutral', true);
		setObjectOrder('dudeIcon', getObjectOrder('iconP1') + 1);
		setProperty('dudeIcon.antialiasing', false);

		doTweenX('dudeIconX', 'dudeIcon.offset', -200, 0.25, 'sineInOut');]]--
	--elseif curBeat == 232 then
		--setProperty('boyfriend2.flipX', false);
		--setProperty('boyfriend2.x', getProperty('boyfriend2.x') - 100);
	elseif curBeat == 500 then
		cameraFlash('hud', '000000', 99999999, true);
	elseif curBeat == 504 then
		cameraFlash('hud', 'ffffff', crochet / 1000, true);
		addLuaSprite('appleThrow1', false);
		addLuaSprite('appleThrow2', false);
	elseif curBeat == 508 then
		cameraFlash('hud', 'ffffff', crochet / 1000, true);
		addLuaSprite('appleExplosion1', false);
		addLuaSprite('appleExplosion2', false);
		addLuaSprite('appleExplosion3', false);
		objectPlayAnimation('appleExplosion2', 'explode', true);
	elseif curBeat == 512 then
		cameraFade('hud', 'ffffff', crochet / 1000 * 4, true);
	elseif curBeat == 520 then
		cameraFade('hud', '0x00000000', 0.01, true);
		cameraFlash('hud', '000000', 99999999, true);
	end
end

function onStepHit()
	--[[if curStep == 1592 then
		setProperty('chase.flipX', false);
		objectPlayAnimation('chase', 'talk', 'true');
	elseif curStep == 1594 then
		setProperty('adam.x', getProperty('adam.x') - 100);
		setProperty('adam.flipX', false);
		--setProperty('pj.flipX', false);
		addLuaSprite('pj', false);
		objectPlayAnimation('pj', 'silent', 'true');
		setProperty('dad.alpha', 0);
	elseif curStep == 1612 then
		objectPlayAnimation('chase', 'silent', 'true');
	elseif curStep == 1615 then
		objectPlayAnimation('pj', 'talk', 'true');
	elseif curStep == 1639 then
		objectPlayAnimation('adam', 'silent', 'true');
	elseif curStep == 1650 then
		objectPlayAnimation('pj', 'silent', 'true');
	elseif curStep == 1652 then
		setProperty('adam.flipX', true);
		setProperty('adam.x', getProperty('adam.x') + 100);
	elseif curStep == 1659 then
		objectPlayAnimation('adam', 'talk', 'true');
	end]]--

	if curStep == 910 then
		runTimer('blackScreen', stepCrochet / 1000 / 2, 1);
		--debugPrint('test');
	end
end

function onUpdatePost(elapsed)
	--[[setProperty('dudeIcon.x', getProperty('iconP2.x'));
	setProperty('dudeIcon.y', getProperty('iconP2.y'));
	setProperty('dudeIcon.scale.x', getProperty('iconP2.scale.x'));
	setProperty('dudeIcon.scale.y', getProperty('iconP2.scale.y'));

	if getProperty('healthBar.percent') < 20 and getProperty('dudeIcon.animation.curAnim') ~= 'losing' then
		objectPlayAnimation('dudeIcon', 'losing', true);
	elseif getProperty('healthBar.percent') > 80 and getProperty('dudeIcon.animation.curAnim') ~= 'winning' then
		objectPlayAnimation('dudeIcon', 'winning', true);
	elseif getProperty('dudeIcon.animation.curAnim') ~= 'neutral' then
		objectPlayAnimation('dudeIcon', 'neutral', true);
	end]]--

	if getProperty('appleExplosion2.animation.curAnim.finished') then
		objectPlayAnimation('appleExplosion2', 'idle', false);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	--debugPrint(tag);
	if tag == 'blackScreen' then
		cameraFlash('game', '000000', 99999999, true);
	end
end