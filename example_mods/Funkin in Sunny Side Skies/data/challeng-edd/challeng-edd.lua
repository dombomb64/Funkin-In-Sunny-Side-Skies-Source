local pjX = 0;

function onCreate()
	pjX = getProperty('dad.x') - 1200;
	--precacheImage('characters/dudeAnnoyed');
	addCharacterToList('jimAnnoyed', 'boyfriend');
	addCharacterToList('pjNutshell', 'dad');
	precacheImage('songSprites/trashBag');
	precacheImage('songSprites/adamChallengEdd');
	precacheImage('songSprites/chaseChallengEdd');
	precacheImage('songSprites/pjChallengEdd');

	--if difficulty ~= 3 then
		makeLuaSprite('trashBag', 'songSprites/trashBag', -2600, 0);
		makeAnimatedLuaSprite('adam', 'songSprites/adamChallengEdd', pjX - 300, getProperty('dad.y') - 100);
		makeAnimatedLuaSprite('chase', 'songSprites/chaseChallengEdd', pjX - 600, getProperty('dad.y') + 100);
		makeAnimatedLuaSprite('pj', 'songSprites/pjChallengEdd', pjX - 100, getProperty('dad.y'));

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

		setProperty('trashBag.alpha', 0);
		setProperty('adam.alpha', 0);
		setProperty('chase.alpha', 0);
		--debugPrint('test');
	--end

	setProperty('boyfriend2Group.x', getProperty('dad.x'));
	setProperty('boyfriend2Group.y', getProperty('dad.y'));
end

function onBeatHit()
	--debugPrint('test');
	if curBeat % 2 == 0 and curBeat < 398 then
		objectPlayAnimation('adam', 'idle', true);
		objectPlayAnimation('chase', 'idle', true);
	end

	if curBeat == 228 then
		--debugPrint(getProperty('dad.x'));
		setProperty('dadGroup.x', pjX);
		--setProperty('boyfriend2.alpha', 1);
		setProperty('trashBag.alpha', 1);
		setProperty('adam.alpha', 1);
		setProperty('chase.alpha', 1);
		triggerEvent('Change Character', 'dad', 'pjNutshell');
		triggerEvent('Change Character', 'boyfriend', 'jimAnnoyed');
		triggerEvent('Change Character', 'boyfriend2', 'dudeAnnoyed');
		setProperty('boyfriend2.flipX', true);
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
	elseif curBeat == 232 then
		setProperty('boyfriend2.flipX', false);
		setProperty('boyfriend2.x', getProperty('boyfriend2.x') - 100);
	end
end

function onStepHit()
	--debugPrint('test');
	if curStep == 1592 then
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
	end
end

--[[function onUpdatePost(elapsed)
	setProperty('dudeIcon.x', getProperty('iconP2.x'));
	setProperty('dudeIcon.y', getProperty('iconP2.y'));
	setProperty('dudeIcon.scale.x', getProperty('iconP2.scale.x'));
	setProperty('dudeIcon.scale.y', getProperty('iconP2.scale.y'));

	if getProperty('healthBar.percent') < 20 and getProperty('dudeIcon.animation.curAnim') ~= 'losing' then
		objectPlayAnimation('dudeIcon', 'losing', true);
	elseif getProperty('healthBar.percent') > 80 and getProperty('dudeIcon.animation.curAnim') ~= 'winning' then
		objectPlayAnimation('dudeIcon', 'winning', true);
	elseif getProperty('dudeIcon.animation.curAnim') ~= 'neutral' then
		objectPlayAnimation('dudeIcon', 'neutral', true);
	end
end]]--