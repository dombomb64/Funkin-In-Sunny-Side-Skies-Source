-- NOTE:
-- If you use any characters mentioned in this script in your mod, please:
-- 1. Give credit to me, dombomb64.
-- 2. Use this script and all related files mentioned (e.g. said characters' legs).

function onCreatePost()
	makeLegs();
end

function onStartCountdown()
	runTimer('legsDance', crochet / 1000, 5);
end

function onEvent(name, value1, value2)
	--if name == 'Change Character' and value2 == 'kristenRun' or value2 == 'adamRun' or value2 == 'adamStuck' then
	if name == 'Change Character' then
		runTimer('makeLegs', 0.01, 1);
	end

	--print('Event triggered: ', name, value1, value2);
end

function onBeatHit()
	legsDance(curBeat);
end

--[[function onStepHit()
	--if curStep % 2 == 0 then
		objectPlayAnimation('adamStuckLegs', 'idle', false);
		objectPlayAnimation('adamStuckLegsPlayer', 'idle', false);
	--end
end]]--

--[[function onCountdownTick(counter)
	--loadGraphic('countdownReady', 'nutshellUi/ready');
	--loadGraphic('countdownSet', 'nutshellUi/set');
	--loadGraphic('countdownGo', 'nutshellUi/shit');
	--setProperty('introAlts[0]', 'nutshellUi/ready');
	--setProperty('introAlts[1]', 'nutshellUi/set');
	--setProperty('introAlts[2]', 'nutshellUi/go');
	--objectPlayAnimation('boyfriend2', 'idle', true);
	--objectPlayAnimation('dad2', 'idle', true);
	if counter % 2 == 0 then
		objectPlayAnimation('kristenLegs', 'danceLeft', true);
		objectPlayAnimation('kristenLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('adamLegs', 'danceLeft', true);
		objectPlayAnimation('adamLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('chaseImpostorLegs', 'danceLeft', true);
		objectPlayAnimation('chaseImpostorLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('adamCrewmateLegs', 'danceLeft', true);
		objectPlayAnimation('adamCrewmateLegsPlayer', 'danceLeft', true);
	elseif (counter + 1) % 2 == 0 then
		objectPlayAnimation('kristenLegs', 'danceRight', true);
		objectPlayAnimation('kristenLegsPlayer', 'danceRight', true);
		objectPlayAnimation('adamLegs', 'danceRight', true);
		objectPlayAnimation('adamLegsPlayer', 'danceRight', true);
		objectPlayAnimation('chaseImpostorLegs', 'danceRight', true);
		objectPlayAnimation('chaseImpostorLegsPlayer', 'danceRight', true);
		objectPlayAnimation('adamCrewmateLegs', 'danceRight', true);
		objectPlayAnimation('adamCrewmateLegsPlayer', 'danceRight', true);
	end
	objectPlayAnimation('adamStuckLegs', 'idle', true);
	objectPlayAnimation('adamStuckLegsPlayer', 'idle', true);
end]]--

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'makeLegs' then
		makeLegs();
	elseif tag == 'legsDance' then
		legsDance(loopsLeft + 1);
	end
end

function onUpdate(elapsed)
	setProperty('kristenLegs.x', getProperty('dad.x'));
	setProperty('kristenLegs.y', getProperty('dad.y'));
	setProperty('kristenLegsPlayer.x', getProperty('boyfriend.x'));
	setProperty('kristenLegsPlayer.y', getProperty('boyfriend.y'));
	setProperty('adamLegs.x', getProperty('dad.x'));
	setProperty('adamLegs.y', getProperty('dad.y'));
	setProperty('adamLegsPlayer.x', getProperty('boyfriend.x'));
	setProperty('adamLegsPlayer.y', getProperty('boyfriend.y'));
	setProperty('adamStuckLegs.x', getProperty('dad.x'));
	setProperty('adamStuckLegs.y', getProperty('dad.y'));
	setProperty('adamStuckLegsPlayer.x', getProperty('boyfriend.x'));
	setProperty('adamStuckLegsPlayer.y', getProperty('boyfriend.y'));
	setProperty('adamCrewmateLegs.x', getProperty('dad.x'));
	setProperty('adamCrewmateLegs.y', getProperty('dad.y'));
	setProperty('adamCrewmateLegsPlayer.x', getProperty('boyfriend.x'));
	setProperty('adamCrewmateLegsPlayer.y', getProperty('boyfriend.y'));
	setProperty('chaseImpostorLegs.x', getProperty('dad.x'));
	setProperty('chaseImpostorLegs.y', getProperty('dad.y'));
	setProperty('chaseImpostorShush.x', getProperty('dad.x'));
	setProperty('chaseImpostorShush.y', getProperty('dad.y'));
	setProperty('chaseImpostorShush.offset.y', getProperty('dad.offset.y'));
	setProperty('chaseImpostorLegsPlayer.x', getProperty('boyfriend.x'));
	setProperty('chaseImpostorLegsPlayer.y', getProperty('boyfriend.y'));
	setProperty('chaseImpostorShushPlayer.x', getProperty('boyfriend.x'));
	setProperty('chaseImpostorShushPlayer.y', getProperty('boyfriend.y'));
	setProperty('chaseImpostorShushPlayer.offset.y', getProperty('boyfriend.offset.y'));

	if (dadName == 'chaseImpostorRun' or dadName == 'chaseImpostorRunSimilarities') and getProperty('dad.animation.curAnim.name') == 'singRIGHT' and getProperty('dad.animation.curAnim.curFrame') == 0 then
		objectPlayAnimation('chaseImpostorShush', 'singRIGHT');
	--elseif dadName == 'chaseImpostorRun' and getProperty('dad.animation.curAnim.name') ~= 'singRIGHT' then
	elseif getProperty('dad.animation.curAnim.curFrame') ~= 0 then
		objectPlayAnimation('chaseImpostorShush', 'idle');
	end

	if (boyfriendName == 'chaseImpostorRun' or boyfriendName == 'chaseImpostorRunSimilarities') and getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' and getProperty('boyfriend.animation.curAnim.curFrame') == 0 then
		objectPlayAnimation('chaseImpostorShushPlayer', 'singRIGHT');
	--elseif boyfriendName == 'chaseImpostorRun' and getProperty('boyfriend.animation.curAnim.name') ~= 'singRIGHT' then
	elseif getProperty('boyfriend.animation.curAnim.curFrame') ~= 0 then
		objectPlayAnimation('chaseImpostorShushPlayer', 'idle');
	end

	local amongUsLegFrameDad = -1;
	if getProperty('chaseImpostorLegs.animation.curAnim.curFrame') ~= 'chaseImpostorLegs.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('chaseImpostorLegs.animation.curAnim.curFrame');
	--elseif getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame') ~= 'chaseImpostorLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame');
	elseif getProperty('adamCrewmateLegs.animation.curAnim.curFrame') ~= 'adamCrewmateLegs.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('adamCrewmateLegs.animation.curAnim.curFrame');
	--elseif getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame') ~= 'adamCrewmateLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame');
	end

	local amongUsLegFrameBf = -1;
	--if getProperty('chaseImpostorLegs.animation.curAnim.curFrame') ~= 'chaseImpostorLegs.animation.curAnim.curFrame' then amongUsLegFrameBf = getProperty('chaseImpostorLegs.animation.curAnim.curFrame');
	if getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame') ~= 'chaseImpostorLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameBf = getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame');
	--elseif getProperty('adamCrewmateLegs.animation.curAnim.curFrame') ~= 'adamCrewmateLegs.animation.curAnim.curFrame' then amongUsLegFrameBf = getProperty('adamCrewmateLegs.animation.curAnim.curFrame');
	elseif getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame') ~= 'adamCrewmateLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameBf = getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame');
	end

	local humanLegFrameDad = -1;
	if getProperty('kristenLegs.animation.curAnim.curFrame') ~= 'kristenLegs.animation.curAnim.curFrame' then humanLegFrameDad = getProperty('kristenLegs.animation.curAnim.curFrame');
	--elseif getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame') ~= 'chaseImpostorLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame');
	elseif getProperty('adamLegs.animation.curAnim.curFrame') ~= 'adamLegs.animation.curAnim.curFrame' then humanLegFrameDad = getProperty('adamLegs.animation.curAnim.curFrame');
	--elseif getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame') ~= 'adamCrewmateLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame');
	end

	local humanLegFrameBf = -1;
	if getProperty('kristenLegsPlayer.animation.curAnim.curFrame') ~= 'kristenLegsPlayer.animation.curAnim.curFrame' then humanLegFrameBf = getProperty('kristenLegsPlayer.animation.curAnim.curFrame');
	--elseif getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame') ~= 'chaseImpostorLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('chaseImpostorLegsPlayer.animation.curAnim.curFrame');
	elseif getProperty('adamLegsPlayer.animation.curAnim.curFrame') ~= 'adamLegsPlayer.animation.curAnim.curFrame' then humanLegFrameBf = getProperty('adamLegsPlayer.animation.curAnim.curFrame');
	--elseif getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame') ~= 'adamCrewmateLegsPlayer.animation.curAnim.curFrame' then amongUsLegFrameDad = getProperty('adamCrewmateLegsPlayer.animation.curAnim.curFrame');
	end

	--debugPrint(amongUsLegFrameDad);
	--debugPrint(getProperty('chaseImpostorLegs.animation.curAnim.curFrame'));

	if amongUsLegFrameDad == 0 then setProperty('chaseImpostorLegs.offset.y', 0); setProperty('dad.offset.y', 0); setProperty('adamCrewmateLegs.offset.y', 0); setProperty('dad.offset.y', -9);
	elseif amongUsLegFrameDad == 1 then setProperty('chaseImpostorLegs.offset.y', 0); setProperty('dad.offset.y', -9); setProperty('adamCrewmateLegs.offset.y', 0); setProperty('dad.offset.y', -18);
	elseif amongUsLegFrameDad == 2 then setProperty('chaseImpostorLegs.offset.y', 30); setProperty('dad.offset.y', 30); setProperty('adamCrewmateLegs.offset.y', 30); setProperty('dad.offset.y', 21);
	elseif amongUsLegFrameDad == 3 then setProperty('chaseImpostorLegs.offset.y', 39); setProperty('dad.offset.y', 39); setProperty('adamCrewmateLegs.offset.y', 39); setProperty('dad.offset.y', 27);
	elseif amongUsLegFrameDad == 4 or amongUsLegFrameDad == 5 then setProperty('chaseImpostorLegs.offset.y', 42); setProperty('dad.offset.y', 42); setProperty('adamCrewmateLegs.offset.y', 51); setProperty('dad.offset.y', 30);
	elseif amongUsLegFrameDad >= 6 then setProperty('chaseImpostorLegs.offset.y', 39); setProperty('dad.offset.y', 39); setProperty('adamCrewmateLegs.offset.y', 39); setProperty('dad.offset.y', 27);
	end

	if amongUsLegFrameBf == 0 then setProperty('adamCrewmateLegsPlayer.offset.y', 0); setProperty('boyfriend.offset.y', -9); setProperty('chaseImpostorLegsPlayer.offset.y', 0); setProperty('boyfriend.offset.y', 0);
	elseif amongUsLegFrameBf == 1 then setProperty('adamCrewmateLegsPlayer.offset.y', 0); setProperty('boyfriend.offset.y', -18); setProperty('chaseImpostorLegsPlayer.offset.y', 0); setProperty('boyfriend.offset.y', -9);
	elseif amongUsLegFrameBf == 2 then setProperty('adamCrewmateLegsPlayer.offset.y', 30); setProperty('boyfriend.offset.y', 21); setProperty('chaseImpostorLegsPlayer.offset.y', 30); setProperty('boyfriend.offset.y', 30);
	elseif amongUsLegFrameBf == 3 then setProperty('adamCrewmateLegsPlayer.offset.y', 39); setProperty('boyfriend.offset.y', 27); setProperty('chaseImpostorLegsPlayer.offset.y', 39); setProperty('boyfriend.offset.y', 39);
	elseif amongUsLegFrameBf == 4 or amongUsLegFrameBf == 5 then setProperty('adamCrewmateLegsPlayer.offset.y', 51); setProperty('boyfriend.offset.y', 30); setProperty('chaseImpostorLegsPlayer.offset.y', 42); setProperty('boyfriend.offset.y', 51);
	elseif amongUsLegFrameBf >= 6 then setProperty('adamCrewmateLegsPlayer.offset.y', 39); setProperty('boyfriend.offset.y', 27); setProperty('chaseImpostorLegsPlayer.offset.y', 39); setProperty('boyfriend.offset.y', 39);
	end

	local isDadIdle = (getProperty('dad.animation.curAnim.name') == 'danceLeft' or getProperty('dad.animation.curAnim.name') == 'danceRight'); -- Would check for a basic idle too, but it's not needed
	local isBfIdle = (getProperty('boyfriend.animation.curAnim.name') == 'danceLeft' or getProperty('boyfriend.animation.curAnim.name') == 'danceRight');
	--debugPrint(isDadIdle, ', ', isBfIdle);

	if humanLegFrameDad == 0 and not isDadIdle then setProperty('dad.offset.y', 0);
	elseif humanLegFrameDad == 2 and not isDadIdle then setProperty('dad.offset.y', -18);
	elseif humanLegFrameDad == 4 and not isDadIdle then setProperty('dad.offset.y', 6);
	elseif humanLegFrameDad >= 6 and not isDadIdle then setProperty('dad.offset.y', 12);
	elseif isDadIdle then setProperty('dad.offset.y', 0);
	end
	
	if humanLegFrameBf == 0 and not isBfIdle then setProperty('boyfriend.offset.y', 0);
	elseif humanLegFrameBf == 2 and not isBfIdle then setProperty('boyfriend.offset.y', -18);
	elseif humanLegFrameBf == 4 and not isBfIdle then setProperty('boyfriend.offset.y', 6);
	elseif humanLegFrameBf >= 6 and not isBfIdle then setProperty('boyfriend.offset.y', 12);
	elseif isBfIdle then setProperty('boyfriend.offset.y', 0);
	end
end

function legsDance(beat)
	--debugPrint('test');
	if beat % 2 == 0 then
		objectPlayAnimation('kristenLegs', 'danceLeft', true);
		objectPlayAnimation('kristenLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('adamLegs', 'danceLeft', true);
		objectPlayAnimation('adamLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('chaseImpostorLegs', 'danceLeft', true);
		objectPlayAnimation('chaseImpostorLegsPlayer', 'danceLeft', true);
		objectPlayAnimation('adamCrewmateLegs', 'danceLeft', true);
		objectPlayAnimation('adamCrewmateLegsPlayer', 'danceLeft', true);
	elseif (beat + 1) % 2 == 0 then
		objectPlayAnimation('kristenLegs', 'danceRight', true);
		objectPlayAnimation('kristenLegsPlayer', 'danceRight', true);
		objectPlayAnimation('adamLegs', 'danceRight', true);
		objectPlayAnimation('adamLegsPlayer', 'danceRight', true);
		objectPlayAnimation('chaseImpostorLegs', 'danceRight', true);
		objectPlayAnimation('chaseImpostorLegsPlayer', 'danceRight', true);
		objectPlayAnimation('adamCrewmateLegs', 'danceRight', true);
		objectPlayAnimation('adamCrewmateLegsPlayer', 'danceRight', true);
	end
	objectPlayAnimation('adamStuckLegs', 'idle', true);
	objectPlayAnimation('adamStuckLegsPlayer', 'idle', true);
end

function makeLegs()
	--debugPrint(dadName);
	--debugPrint(boyfriendName);
	removeLuaSprite('kristenLegs', false);
	removeLuaSprite('kristenLegsPlayer', false);
	removeLuaSprite('adamLegs', false);
	removeLuaSprite('adamLegsPlayer', false);
	removeLuaSprite('adamStuckLegs', false);
	removeLuaSprite('adamStuckLegsPlayer', false);
	removeLuaSprite('chaseImpostorLegs', false);
	removeLuaSprite('chaseImpostorLegsPlayer', false);
	removeLuaSprite('adamCrewmateLegs', false);
	removeLuaSprite('adamCrewmateLegsPlayer', false);

	if (dadName == 'kristenRun') then
		makeAnimatedLuaSprite('kristenLegs', 'characters/kristenLegs', getProperty('dad.x'), getProperty('dad.y'));

		addAnimationByIndices('kristenLegs', 'danceLeft', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		addAnimationByIndices('kristenLegs', 'danceRight', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);

		setProperty('kristenLegs.scale.x', 3);
		setProperty('kristenLegs.scale.y', 3);
		updateHitbox('kristenLegs');

		setProperty('kristenLegs.offset.x', -30);
		setProperty('kristenLegs.offset.y', -372);

		setProperty('kristenLegs.flipX', true);

		setProperty('kristenLegs.antialiasing', false);

		setObjectOrder('kristenLegs', getObjectOrder('dadGroup'));

		addLuaSprite('kristenLegs', false);

		--setBlendMode('kristenLegs', 'add');
		--debugPrint(getObjectOrder('kristenLegs'), 'test');
		--debugPrint('a');
	end

	if (boyfriendName == 'kristenRun') then
		makeAnimatedLuaSprite('kristenLegsPlayer', 'characters/kristenLegs', getProperty('boyfriend.x'), getProperty('boyfriend.y'));

		addAnimationByIndices('kristenLegsPlayer', 'danceLeft', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		addAnimationByIndices('kristenLegsPlayer', 'danceRight', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);

		setProperty('kristenLegsPlayer.scale.x', 3);
		setProperty('kristenLegsPlayer.scale.y', 3);
		updateHitbox('kristenLegsPlayer');

		setProperty('kristenLegsPlayer.offset.x', -201);
		setProperty('kristenLegsPlayer.offset.y', -372);

		--setProperty('kristenLegsPlayer.flipX', 3);

		setProperty('kristenLegsPlayer.antialiasing', false);

		setObjectOrder('kristenLegsPlayer', getObjectOrder('boyfriendGroup'));

		addLuaSprite('kristenLegsPlayer', false);

		--setBlendMode('kristenLegsPlayer', 'add');
		--debugPrint(getObjectOrder('kristenLegs'), 'test');
		--debugPrint('a');
	end

	if (dadName == 'adamRun') then
		makeAnimatedLuaSprite('adamLegs', 'characters/adamLegs', getProperty('dad.x'), getProperty('dad.y'));

		addAnimationByIndices('adamLegs', 'danceRight', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		addAnimationByIndices('adamLegs', 'danceLeft', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);

		setProperty('adamLegs.scale.x', 3);
		setProperty('adamLegs.scale.y', 3);
		updateHitbox('adamLegs');

		setProperty('adamLegs.offset.x', -30);
		setProperty('adamLegs.offset.y', -372);

		--setProperty('adamLegs.flipX', true);

		setProperty('adamLegs.antialiasing', false);

		setObjectOrder('adamLegs', getObjectOrder('dadGroup'));

		addLuaSprite('adamLegs', false);

		--setBlendMode('adamLegs', 'add');
		--debugPrint(getObjectOrder('adamLegs'), 'test');
		--debugPrint('a');
	end

	if (boyfriendName == 'adamRun') then
		makeAnimatedLuaSprite('adamLegsPlayer', 'characters/adamLegs', getProperty('boyfriend.x'), getProperty('boyfriend.y'));

		addAnimationByIndices('adamLegsPlayer', 'danceRight', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		addAnimationByIndices('adamLegsPlayer', 'danceLeft', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);

		setProperty('adamLegsPlayer.scale.x', 3);
		setProperty('adamLegsPlayer.scale.y', 3);
		updateHitbox('adamLegsPlayer');

		setProperty('adamLegsPlayer.offset.x', -30);
		setProperty('adamLegsPlayer.offset.y', -372);

		setProperty('adamLegsPlayer.flipX', true);

		setProperty('adamLegsPlayer.antialiasing', false);

		setObjectOrder('adamLegsPlayer', getObjectOrder('boyfriendGroup'));

		addLuaSprite('adamLegsPlayer', false);

		--setBlendMode('adamLegsPlayer', 'add');
		--debugPrint(getObjectOrder('adamLegs'), 'test');
		--debugPrint('a');
	end

	if (dadName == 'adamStuck') then
		makeAnimatedLuaSprite('adamStuckLegs', 'characters/adamStuck', getProperty('dad.x'), getProperty('dad.y'));

		--addAnimationByIndices('adamStuckLegs', 'danceRight', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		--addAnimationByIndices('adamStuckLegs', 'danceLeft', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);
		addAnimationByPrefix('adamStuckLegs', 'idle', 'Legs Idle', 24, false);

		setProperty('adamStuckLegs.scale.x', 3);
		setProperty('adamStuckLegs.scale.y', 3);
		updateHitbox('adamStuckLegs');

		setProperty('adamStuckLegs.offset.x', 0);
		setProperty('adamStuckLegs.offset.y', 0);

		setProperty('adamStuckLegs.flipX', true);

		setProperty('adamStuckLegs.antialiasing', false);

		setObjectOrder('adamStuckLegs', getObjectOrder('dadGroup') + 1);

		addLuaSprite('adamStuckLegs', false);

		--setBlendMode('adamStuckLegs', 'add');
		--debugPrint(getObjectOrder('adamStuckLegs'), 'test');
		--debugPrint('a');
	end

	if (boyfriendName == 'adamStuck') then
		makeAnimatedLuaSprite('adamStuckLegsPlayer', 'characters/adamStuck', getProperty('boyfriend.x'), getProperty('boyfriend.y'));

		--addAnimationByIndices('adamStuckLegsPlayer', 'danceRight', 'Run', '1, 2, 3, 4, 5, 6, 7, 8, 9', 24);
		--addAnimationByIndices('adamStuckLegsPlayer', 'danceLeft', 'Run', '13, 14, 15, 16, 17, 18, 19, 20, 21', 24);
		addAnimationByPrefix('adamStuckLegsPlayer', 'idle', 'Legs Idle', 24, false);

		setProperty('adamStuckLegsPlayer.scale.x', 3);
		setProperty('adamStuckLegsPlayer.scale.y', 3);
		updateHitbox('adamStuckLegsPlayer');

		--debugPrint(getProperty('adamStuckLegsPlayer.offset.x'));
		setProperty('adamStuckLegsPlayer.offset.x', 0);
		setProperty('adamStuckLegsPlayer.offset.y', 0);

		--setProperty('adamStuckLegsPlayer.flipX', true);

		setProperty('adamStuckLegsPlayer.antialiasing', false);

		setObjectOrder('adamStuckLegsPlayer', getObjectOrder('boyfriendGroup') + 1);

		addLuaSprite('adamStuckLegsPlayer', false);

		--setBlendMode('adamStuckLegsPlayer', 'add');
		--debugPrint(getObjectOrder('adamStuckLegs'), 'test');
		--debugPrint('a');
	end

	if (dadName == 'chaseImpostorRun' or dadName == 'chaseImpostorRunSimilarities') then
		makeAnimatedLuaSprite('chaseImpostorLegs', 'characters/chaseImpostorLegs', getProperty('dad.x'), getProperty('dad.y'));
		makeAnimatedLuaSprite('chaseImpostorShush', 'characters/chaseImpostorRunShush', getProperty('dad.x'), getProperty('dad.y'));

		addAnimationByPrefix('chaseImpostorLegs', 'danceLeft', 'Dance Left', 24, false);
		addAnimationByPrefix('chaseImpostorLegs', 'danceRight', 'Dance Right', 24, false);
		addAnimationByPrefix('chaseImpostorShush', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('chaseImpostorShush', 'singRIGHT', 'Sing Right', 24, false);

		setProperty('chaseImpostorLegs.scale.x', 3);
		setProperty('chaseImpostorLegs.scale.y', 3);
		setProperty('chaseImpostorShush.scale.x', 3);
		setProperty('chaseImpostorShush.scale.y', 3);
		--updateHitbox('chaseImpostorLegs');

		--setProperty('chaseImpostorLegs.offset.x', -30);
		--setProperty('chaseImpostorLegs.offset.y', -372);

		setProperty('chaseImpostorLegs.flipX', getProperty('dad.flipX'));
		setProperty('chaseImpostorShush.flipX', getProperty('dad.flipX'));

		setProperty('chaseImpostorLegs.antialiasing', false);
		setProperty('chaseImpostorShush.antialiasing', false);

		setObjectOrder('chaseImpostorLegs', getObjectOrder('dadGroup') + 1);
		setObjectOrder('chaseImpostorShush', getObjectOrder('dadGroup') + 2);

		addLuaSprite('chaseImpostorLegs', true);
		addLuaSprite('chaseImpostorShush', true); 

		--setBlendMode('chaseImpostorLegs', 'add');
		--debugPrint(getObjectOrder('chaseImpostorLegs'), 'test');
		--debugPrint('a');
	end

	if (boyfriendName == 'chaseImpostorRun' or boyfriendName == 'chaseImpostorRunSimilarities') then
		makeAnimatedLuaSprite('chaseImpostorLegsPlayer', 'characters/chaseImpostorLegs', getProperty('boyfriend.x'), getProperty('boyfriend.y'));
		makeAnimatedLuaSprite('chaseImpostorShushPlayer', 'characters/chaseImpostorRunShush', getProperty('dad.x'), getProperty('dad.y'));

		addAnimationByPrefix('chaseImpostorLegsPlayer', 'danceLeft', 'Dance Left', 24, false);
		addAnimationByPrefix('chaseImpostorLegsPlayer', 'danceRight', 'Dance Right', 24, false);
		addAnimationByPrefix('chaseImpostorShushPlayer', 'idle', 'Idle', 24, false);
		addAnimationByPrefix('chaseImpostorShushPlayer', 'singRIGHT', 'Sing Right', 24, false);

		setProperty('chaseImpostorLegsPlayer.scale.x', 3);
		setProperty('chaseImpostorLegsPlayer.scale.y', 3);
		setProperty('chaseImpostorShushPlayer.scale.x', 3);
		setProperty('chaseImpostorShushPlayer.scale.y', 3);
		--updateHitbox('chaseImpostorLegsPlayer');

		--setProperty('chaseImpostorLegsPlayer.offset.x', -30);
		--setProperty('chaseImpostorLegsPlayer.offset.y', -372);

		setProperty('chaseImpostorLegsPlayer.flipX', getProperty('boyfriend.flipX'));
		setProperty('chaseImpostorShushPlayer.flipX', getProperty('boyfriend.flipX'));

		setProperty('chaseImpostorLegsPlayer.antialiasing', false);
		setProperty('chaseImpostorShushPlayer.antialiasing', false);

		setObjectOrder('chaseImpostorLegsPlayer', getObjectOrder('boyfriendGroup') + 1);
		setObjectOrder('chaseImpostorShushPlayer', getObjectOrder('boyfriendGroup') + 2);

		addLuaSprite('chaseImpostorLegsPlayer', true);
		addLuaSprite('chaseImpostorShushPlayer', true);

		--setBlendMode('chaseImpostorLegsPlayer', 'add');
		--debugPrint(getObjectOrder('chaseImpostorLegsPlayer'), 'test');
		--debugPrint('a');
	end

	if (dadName == 'adamCrewmateRun' or dadName == 'adamCrewmateRunSimilarities') then
		makeAnimatedLuaSprite('adamCrewmateLegs', 'characters/adamCrewmateLegs', getProperty('dad.x'), getProperty('dad.y'));

		addAnimationByPrefix('adamCrewmateLegs', 'danceRight', 'Dance Left', 24, false);
		addAnimationByPrefix('adamCrewmateLegs', 'danceLeft', 'Dance Right', 24, false);

		setProperty('adamCrewmateLegs.scale.x', 3);
		setProperty('adamCrewmateLegs.scale.y', 3);
		--updateHitbox('adamCrewmateLegs');

		--setProperty('adamCrewmateLegs.offset.x', -30);
		--setProperty('adamCrewmateLegs.offset.y', -372);

		setProperty('adamCrewmateLegs.flipX', getProperty('dad.flipX'));

		setProperty('adamCrewmateLegs.antialiasing', false);

		setObjectOrder('adamCrewmateLegs', getObjectOrder('dadGroup') + 1);

		addLuaSprite('adamCrewmateLegs', true);

		--setBlendMode('adamCrewmateLegs', 'add');
		--debugPrint(getObjectOrder('adamCrewmateLegs'), 'test');
		--debugPrint('a');
	end

	if (boyfriendName == 'adamCrewmateRun' or boyfriendName == 'adamCrewmateRunSimilarities') then
		makeAnimatedLuaSprite('adamCrewmateLegsPlayer', 'characters/adamCrewmateLegs', getProperty('boyfriend.x'), getProperty('boyfriend.y'));

		addAnimationByPrefix('adamCrewmateLegsPlayer', 'danceRight', 'Dance Left', 24, false);
		addAnimationByPrefix('adamCrewmateLegsPlayer', 'danceLeft', 'Dance Right', 24, false);

		setProperty('adamCrewmateLegsPlayer.scale.x', 3);
		setProperty('adamCrewmateLegsPlayer.scale.y', 3);
		--updateHitbox('adamCrewmateLegsPlayer');

		--setProperty('adamCrewmateLegsPlayer.offset.x', -30);
		--setProperty('adamCrewmateLegsPlayer.offset.y', -372);

		setProperty('adamCrewmateLegsPlayer.flipX', getProperty('boyfriend.flipX'));

		setProperty('adamCrewmateLegsPlayer.antialiasing', false);

		setObjectOrder('adamCrewmateLegsPlayer', getObjectOrder('boyfriendGroup') + 1);

		addLuaSprite('adamCrewmateLegsPlayer', true);

		--setBlendMode('adamCrewmateLegsPlayer', 'add');
		--debugPrint(getObjectOrder('adamCrewmateLegsPlayer'), 'test');
		--debugPrint('a');
		--runEvent('Camera Follow Pos', getProperty('adamCrewmateLegsPlayer'));
	end

	objectPlayAnimation('kristenLegs', 'danceLeft');
	objectPlayAnimation('kristenLegsPlayer', 'danceLeft');
	objectPlayAnimation('adamLegs', 'danceLeft');
	objectPlayAnimation('adamLegsPlayer', 'danceLeft');
	objectPlayAnimation('adamStuckLegs', 'idle');
	objectPlayAnimation('adamStuckLegsPlayer', 'idle');
	objectPlayAnimation('chaseImpostorLegs', 'danceLeft');
	objectPlayAnimation('chaseImpostorShush', 'idle');
	objectPlayAnimation('chaseImpostorLegsPlayer', 'danceLeft');
	objectPlayAnimation('chaseImpostorShushPlayer', 'idle');
	objectPlayAnimation('adamCrewmateLegs', 'danceLeft');
	objectPlayAnimation('adamCrewmateLegsPlayer', 'danceLeft');
end