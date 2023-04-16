local boyfriendDance = false; --If true, do danceLeft and danceRight instead of idle
local dadDance = false;

function onCreatePost()
	if songName == 'Cross-Comic Clash' then
		createCharacters('characters/chaseNutshell', 'characters/jimNutshell', false, true, false, true, false, false);
		setProperty('dad2.alpha', 0);
		setProperty('boyfriend2.alpha', 0);
	elseif songName == 'Challeng-Edd' then
		--createCharacters('characters/' .. getProperty('dad.curCharacter'), '', true, true, false, true, false, false);
		createCharacters('characters/dudeAnnoyed', '', true, true, false, true, true, false);
		setProperty('boyfriend2.x', getProperty('dad.x'));
		setProperty('boyfriend2.y', getProperty('dad.y'));
		setProperty('boyfriend2.alpha', 0);
	elseif songName == 'Challeng-Edd Unfair' then
		--createCharacters('characters/' .. getProperty('dad.curCharacter'), '', true, true, false, true, false, false);
		createCharacters('characters/dudeTopDown', '', true, true, false, true, false, false);
		setProperty('boyfriend2.x', getProperty('dad.x') - 210);
		setProperty('boyfriend2.y', getProperty('dad.y'));
		setProperty('boyfriend2.alpha', 0);
	end

	runTimer('backupDance', crochet / 1000, 5);
end

--[[function onCountdownTick(counter)
	if counter % 2 == 0 then
		objectPlayAnimation('boyfriend2', 'idle', true);
		objectPlayAnimation('dad2', 'idle', true);
	end
end]]--

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'backupDance' then
		backupDance(loopsLeft);
		--debugPrint('test');
	end
end

function onBeatHit()
	backupDance(curBeat);
end

function backupDance(beat)
	if beat % 2 == 0 and not boyfriendDance then
		objectPlayAnimation('boyfriend2', 'idle', true);
	elseif beat % 2 == 0 and boyfriendDance then
		objectPlayAnimation('boyfriend2', 'danceLeft', true);
	elseif (beat - 1) % 2 == 0 and boyfriendDance then
		objectPlayAnimation('boyfriend2', 'danceRight', true);
	end

	if beat % 2 == 0 and not dadDance then
		objectPlayAnimation('dad2', 'idle', true);
	elseif beat % 2 == 0 and dadDance then
		objectPlayAnimation('dad2', 'danceLeft', true);
	elseif (beat - 1) % 2 == 0 and dadDance then
		objectPlayAnimation('dad2', 'danceRight', true);
	end
end

function createCharacters(boyfriendImage, dadImage, boyfriendFlip, dadFlip, boyfriendFlipPoses, dadFlipPoses, boyfriendDanceType, dadDanceType)
	if boyfriendImage ~= '' then
		makeAnimatedLuaSprite('boyfriend2', boyfriendImage, getProperty('boyfriend.x') + 300, getProperty('boyfriend.y') - 30);
		addLuaSprite('boyfriend2', true);
		setObjectOrder('boyfriend2', getObjectOrder('boyfriendGroup'));
		setProperty('boyfriend2.scale.x', 3);
		setProperty('boyfriend2.scale.y', 3);
		setProperty('boyfriend2.antialiasing', false);
		setProperty('boyfriend2.flipX', boyfriendFlip);

		addAnimationByPrefix('boyfriend2', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('boyfriend2', 'danceLeft', 'Dance Left', 24, false);
		addAnimationByPrefix('boyfriend2', 'danceRight', 'Dance Right', 24, false);

		addAnimationByPrefix('boyfriend2', 'singLEFT', 'Sing Left', 24, false);
		addAnimationByPrefix('boyfriend2', 'singDOWN', 'Sing Down', 24, false);
		addAnimationByPrefix('boyfriend2', 'singUP', 'Sing Up', 24, false);
		addAnimationByPrefix('boyfriend2', 'singRIGHT', 'Sing Right', 24, false);

		addAnimationByPrefix('boyfriend2', 'singLEFTmiss', 'Miss Left', 24, false);
		addAnimationByPrefix('boyfriend2', 'singDOWNmiss', 'Miss Down', 24, false);
		addAnimationByPrefix('boyfriend2', 'singUPmiss', 'Miss Up', 24, false);
		addAnimationByPrefix('boyfriend2', 'singRIGHTmiss', 'Miss Right', 24, false);

		if boyfriendFlipPoses then
			addAnimationByPrefix('boyfriend2', 'singLEFT', 'Sing Right', 24, false);
			addAnimationByPrefix('boyfriend2', 'singRIGHT', 'Sing Left', 24, false);
			addAnimationByPrefix('boyfriend2', 'singLEFTmiss', 'Miss Right', 24, false);
			addAnimationByPrefix('boyfriend2', 'singRIGHTmiss', 'Miss Left', 24, false);
		end

		if boyfriendDanceType then
			boyfriendDance = true;
		end
	end

	if dadImage ~= '' then
		makeAnimatedLuaSprite('dad2', dadImage, getProperty('dad.x') - 300, getProperty('dad.y') - 30);
		addLuaSprite('dad2', true);
		setObjectOrder('dad2', getObjectOrder('dadGroup'));
		setProperty('dad2.scale.x', 3);
		setProperty('dad2.scale.y', 3);
		setProperty('dad2.antialiasing', false);
		setProperty('dad2.flipX', dadFlip);

		addAnimationByPrefix('dad2', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('dad2', 'danceLeft', 'Dance Left', 24, false);
		addAnimationByPrefix('dad2', 'danceRight', 'Dance Right', 24, false);

		addAnimationByPrefix('dad2', 'singLEFT', 'Sing Left', 24, false);
		addAnimationByPrefix('dad2', 'singDOWN', 'Sing Down', 24, false);
		addAnimationByPrefix('dad2', 'singUP', 'Sing Up', 24, false);
		addAnimationByPrefix('dad2', 'singRIGHT', 'Sing Right', 24, false);

		addAnimationByPrefix('dad2', 'singLEFTmiss', 'Miss Left', 24, false);
		addAnimationByPrefix('dad2', 'singDOWNmiss', 'Miss Down', 24, false);
		addAnimationByPrefix('dad2', 'singUPmiss', 'Miss Up', 24, false);
		addAnimationByPrefix('dad2', 'singRIGHTmiss', 'Miss Right', 24, false);

		if dadFlipPoses then
			addAnimationByPrefix('dad2', 'singLEFT', 'Sing Right', 24, false);
			addAnimationByPrefix('dad2', 'singRIGHT', 'Sing Left', 24, false);
			addAnimationByPrefix('dad2', 'singLEFTmiss', 'Miss Right', 24, false);
			addAnimationByPrefix('dad2', 'singRIGHTmiss', 'Miss Left', 24, false);
		end

		if dadDanceType then
			dadDance = true;
		end
	end
end