local blasters = {};
local blasterY = -900;
local fireballs = {};
local fireballY = 300;

local isNutshell = false;
local soundVolume = 5;

function onCreatePost()
	--debugPrint(stepCrochet);
	--isDownscroll = getPropertyFromClass('');
	precacheImage('flameAim');
	precacheImage('fireball');
	precacheSound('blasterCharge');
	precacheSound('blasterShoot');
	precacheSound('fireballExplode');

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
			isNutshell = true;
			break;
		end
	end
end

function onEvent(name, value1, value2)
	if name == 'Charge Blaster' then
		local isPlayer = false;
		if tonumber(value1) > 3 then
			isPlayer = true;
		end
		--debugPrint('test');
		--debugPrint(#blasters);

		local blasterName = 'blaster' .. #blasters + 1;
		--debugPrint(blasterName);
		blasters[#blasters + 1] = blasterName;

		makeAnimatedLuaSprite(blasterName, 'flameAim', 0, blasterY);
		addAnimationByPrefix(blasterName, 'charge', 'Charge', 24, false);
		addAnimationByPrefix(blasterName, 'shoot', 'Shoot', 24, false);
		--addAnimationByPrefix(blasterName, 'idle', 'Idle', 24, true);
		setObjectCamera(blasterName, 'hud');
		setProperty(blasterName .. '.antialiasing', false);
		--setProperty(blasterName .. '.scale.x', 2);
		--setProperty(blasterName .. '.scale.y', 2);
		--updateHitbox(blasterName);
		--setProperty(blasterName .. '.y', blasterY);
		--setProperty('camHUD.zoom', 0.25);

		local arrowWidthModifier = -10;
		if isNutshell then
			arrowWidthModifier = -50;
		end

		--debugPrint(getPropertyFromGroup('playerStrums', 0, 'width'));
		--debugPrint(getPropertyFromGroup('opponentStrums', tonumber(value1), 'x') .. ', ' .. getPropertyFromGroup('opponentStrums', tonumber(value1), 'width') .. ', ' .. getProperty(blasterName .. '.frameWidth'));
		if isPlayer then
			setProperty(blasterName .. '.x', getPropertyFromGroup('playerStrums', tonumber(value1) - 4, 'x') + (getPropertyFromGroup('playerStrums', tonumber(value1) - 4, 'width') / 2) - (getProperty(blasterName .. '.frameWidth') / 2) + arrowWidthModifier);
		else
			setProperty(blasterName .. '.x', getPropertyFromGroup('opponentStrums', tonumber(value1), 'x') + (getPropertyFromGroup('opponentStrums', tonumber(value1), 'width') / 2) - (getProperty(blasterName .. '.frameWidth') / 2) + arrowWidthModifier);
		end
		--debugPrint(getProperty(blasterName .. '.x'), getPropertyFromGroup('opponentStrums', tonumber(value1), 'x'));

		--debugPrint(getProperty(blasterName .. '.y'));
		if not downscroll then
			setProperty(blasterName .. '.flipY', true);
			setProperty(blasterName .. '.y', getProperty('camHUD.height') - getProperty(blasterName .. '.frameHeight') - blasterY);
		end
		--debugPrint(getProperty(blasterName .. '.y'));

		addLuaSprite(blasterName, true);
		objectPlayAnimation(blasterName, 'charge', true);

		if songName ~= 'Challeng-Edd Unfair' then
			runTimer('chargeSound' .. #blasters, 0.333, 1);
		end
	elseif name == 'Shoot Blaster' then
		if value2 ~= '' then
			local blasterIds = {};
			for i, v in ipairs(blasters) do
				blasterIds[i] = string.sub(v, -1);
			end
			debugPrint(blasterIds);
		end

		local blasterName = blasters[tonumber(value1)];
		--debugPrint(blasterName);
		objectPlayAnimation(blasterName, 'shoot', true);
		runTimer('blasterDespawn' .. value1, 5, 1);

		local fireballName = 'fireball' .. #fireballs + 1;
		fireballs[#fireballs + 1] = fireballName;

		--debugPrint(blasters);
		--debugPrint(fireballs);

		--updateHitbox('opponentStrums[0]');
		--setPropertyFromClass('ClientPrefs', 'downScroll', false);
		makeAnimatedLuaSprite(fireballName, 'fireball', 0, getProperty(blasterName .. '.y') + getProperty(blasterName .. '.height') - fireballY - 1024);
		addAnimationByPrefix(fireballName, 'idle', 'Idle', 24, true);
		addAnimationByPrefix(fireballName, 'explode', 'Explode', 24, false);
		setObjectCamera(fireballName, 'hud');
		setProperty(fireballName .. '.antialiasing', false);
		setProperty(fireballName .. '.x', getProperty(blasterName .. '.x'));

		if not downscroll then
			setProperty(fireballName .. '.flipY', true);
			setProperty(fireballName .. '.y', getProperty(blasterName .. '.y') + fireballY);
		end
		--debugPrint(getProperty(blasterName .. '.y') .. ',' .. getProperty(blasterName .. '.height') .. ',' .. getProperty(fireballName .. '.y'));

		addLuaSprite(fireballName, true);
		objectPlayAnimation(fireballName, 'idle', true);
		runTimer('fireballShoot' .. value1, crochet / 4000 * 3, 1);

		if songName ~= 'Challeng-Edd Unfair' then
			playSound('blasterShoot', soundVolume, 'blasterShoot' .. value1);
		end
	end

	--debugPrint('Event triggered: ', name, value1, value2);
end

function eventEarlyTrigger(name, value)
	if name == 'Charge Blaster' then
		return 333;
	end
end

function onUpdate(elapsed)
	for i, v in ipairs(fireballs) do
		if getProperty(v .. '.animation.curAnim.finished') then
			--debugPrint(v);
			--objectPlayAnimation(v, 'idle', true);
			removeLuaSprite(v, true);
			--table.remove(fireballs, i);
			--table.remove(blasters, i);
			--debugPrint('test');
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	--debugPrint(tag);
	if string.find(tag, 'blasterDespawn') ~= nil then
		--debugPrint(string.sub(string.gsub(tag, 'blasterDespawn', ''), 1, #string.gsub(tag, 'blasterDespawn', '')));
		local id = string.gsub(tag, 'blasterDespawn', '');
		id = tonumber(string.sub(id, 1, #id));
		--debugPrint(id);
		removeLuaSprite(blasters[id], true);
		blasters.remove(id);
		cancelTimer(tag);
		--debugPrint('test');
	elseif string.find(tag, 'fireballShoot') ~= nil then
		local id = string.gsub(tag, 'fireballShoot', '');
		id = tonumber(string.sub(id, 1, #id));
		doTweenY('fireballShoot' .. id, fireballs[id], getPropertyFromGroup('opponentStrums', 0, 'y') - getProperty(fireballs[id] .. '.frameHeight') / 2 + 85, crochet / 4000, 'circIn');
	elseif string.find(tag, 'chargeSound') ~= nil then
		--debugPrint('test');
		local id = string.gsub(tag, 'chargeSound', '');
		id = tonumber(string.sub(id, 1, #id));
		playSound('blasterCharge', soundVolume, 'blasterCharge' .. id);
	end
end

function onTweenCompleted(tag)
	if string.find(tag, 'fireballShoot') ~= nil then
		local id = string.gsub(tag, 'fireballShoot', '');
		id = tonumber(string.sub(id, 1, #id));
		objectPlayAnimation(fireballs[id], 'explode', true);

		if songName ~= 'Challeng-Edd Unfair' then
			playSound('fireballExplode', soundVolume, 'fireballExplode' .. id);
		end
	end
end