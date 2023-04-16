-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)

function onCreatePost()
	--debugPrint(dadName);
	if dadName == 'dandyRobot1' or dadName == 'dandyRobot2' then
		setProperty('dad.alpha', 0.75);
		setBlendMode('dad', 'multiply');
		--debugPrint('test');
		--[[makeLuaSprite('dandyRobot', 'characters/dandyRobot2', getProperty('dad.x'), getProperty('dad.y'));
		setProperty('dandyRobot.scale.x', 3);
		setProperty('dandyRobot.scale.y', 3);
		setBlendMode('dandyRobot', 'multiply');
		addAnimationByPrefix('dandyRobot', 'singUP', 'Sing Up', 24, false);
		addAnimationByPrefix('dandyRobot', 'singRIGHT', 'Sing Right', 24, false);
		addLuaSprite('dandyRobot', true);
		setObjectOrder('dandyRobot', getObjectOrder('dadGroup'));]]--
	elseif boyfriendName == 'dandyRobot1' or boyfriendName == 'dandyRobot2' then
		setProperty('boyfriend.alpha', 0.75);
		setBlendMode('boyfriend', 'multiply');
		--makeLuaSprite('dandyRobotPlayer', 'characters/dandyRobot2', getProperty('boyfriend.x'), getProperty('boyfriend.y'));
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Character' then
		if dadName == 'dandyRobot1' or dadName == 'dandyRobot2' then
			setProperty('dad.alpha', 0.75);
			setBlendMode('dad', 'multiply');
		elseif boyfriendName == 'dandyRobot1' or dadName == 'dandyRobot2' then
			setProperty('boyfriend.alpha', 0.75);
			setBlendMode('boyfriend', 'multiply');
		end
	end
end

--function onUpdate(elapsed)
	--[[if getProperty('dandyRobot.animation.curAnim.finished') then
		setProperty('dad.alpha', 1);
		setProperty('dandyRobot.alpha', 0);
	end]]--
--end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	--[[if dadName == 'dandyRobot' then
		if direction == 2 then
			setProperty('dad.alpha', 0);
			setProperty('dandyRobot.alpha', 1);
			objectPlayAnimation('dandyRobot', 'singUP', true);
		elseif direction == 3 then
			setProperty('dad.alpha', 0);
			setProperty('dandyRobot.alpha', 1);
			objectPlayAnimation('dandyRobot', 'singRIGHT', true);
		else
			setProperty('dad.alpha', 1);
			setProperty('dandyRobot.alpha', 0);
		end
	end]]--
	--[[elseif dadName == 'dandyRobot2' then
		if direction == 0 then
			triggerEvent('Change Character', 'dad', 'dandyRobot1');
			triggerEvent('Play Animation', 'singLEFT', 'dad');
		elseif direction == 1 then
			triggerEvent('Change Character', 'dad', 'dandyRobot1');
			triggerEvent('Play Animation', 'singDOWN', 'dad');
		end
	end]]--
	--debugPrint(dadName);
	if dadName == 'dandyRobot2' then
		if direction == 0 then
			triggerEvent('Change Character', 'dad', 'dandyRobot1');
			runTimer('dadSingLeft', 0.1, 1);
		elseif direction == 1 then
			triggerEvent('Change Character', 'dad', 'dandyRobot1');
			runTimer('dadSingDown', 0.1, 1);
		end
	elseif dadName == 'dandyRobot1' then
		if direction == 2 then
			triggerEvent('Change Character', 'dad', 'dandyRobot2');
			runTimer('dadSingUp', 0.1, 1);
		elseif direction == 3 then
			triggerEvent('Change Character', 'dad', 'dandyRobot2');
			runTimer('dadSingRight', 0.1, 1);
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if boyfriendName == 'dandyRobot1' then
		if direction == 2 then
			--triggerEvent('Change Character', 'boyfriend', 'dandyRobot2');
			setProperty('dad.curCharacter', 'dandyRobot2');
			runTimer('bfSingUp', 0.1, 1);
		elseif direction == 3 then
			--triggerEvent('Change Character', 'boyfriend', 'dandyRobot2');
			setProperty('dad.curCharacter', 'dandyRobot2');
			runTimer('bfSingRight', 0.1, 1);
		end
	elseif boyfriendName == 'dandyRobot2' then
		if direction == 0 then
			--triggerEvent('Change Character', 'boyfriend', 'dandyRobot1');
			setProperty('dad.curCharacter', 'dandyRobot1');
			runTimer('bfSingLeft', 0.1, 1);
		elseif direction == 1 then
			--triggerEvent('Change Character', 'boyfriend', 'dandyRobot1');
			setProperty('dad.curCharacter', 'dandyRobot1');
			runTimer('bfSingDown', 0.1, 1);
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dadSingLeft' then
		setProperty('dad.alpha', 0.75);
		objectPlayAnimation('dad', 'singLEFT', true);
	elseif tag == 'dadSingDown' then
		setProperty('dad.alpha', 0.75);
		objectPlayAnimation('dad', 'singDOWN', true);
	elseif tag == 'dadSingUp' then
		setProperty('dad.alpha', 0.75);
		objectPlayAnimation('dad', 'singUP', true);
	elseif tag == 'dadSingRight' then
		setProperty('dad.alpha', 0.75);
		objectPlayAnimation('dad', 'singRIGHT', true);
	elseif tag == 'bfSingLeft' then
		objectPlayAnimation('boyfriend', 'singLEFT', true);
	elseif tag == 'bfSingDown' then
		objectPlayAnimation('boyfriend', 'singDOWN', true);
	elseif tag == 'bfSingUp' then
		objectPlayAnimation('boyfriend', 'singUP', true);
	elseif tag == 'bfSingRight' then
		objectPlayAnimation('boyfriend', 'singRIGHT', true);
	end
end