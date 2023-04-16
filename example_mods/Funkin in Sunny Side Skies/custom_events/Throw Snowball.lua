function onCreate()
	--[[precacheSound('swish');
	precacheSound('snowballImpact');

	makeAnimatedLuaSprite('adamAnimations', 'characters/adamNutshell', getProperty('boyfriend.x'), getProperty('boyfriend.y'));
	addAnimationByPrefix('adamAnimations', 'dodge', 'Dodge', 24, false);
	addAnimationByPrefix('adamAnimations', 'snowballHit', 'Snowball Hit', 24, false);
	setProperty('adamAnimations.scale.x', 3);
	setProperty('adamAnimations.scale.y', 3);
	setProperty('adamAnimations.antialiasing', false);
	setProperty('adamAnimations.offset.y', 50);
	setObjectOrder('adamAnimations', getObjectOrder('boyfriendGroup'));
	setProperty('adamAnimations.alpha', 0);

	--objectPlayAnimation('adamAnimations', 'dodge', false);
	--removeLuaSprite('adamAnimations', false);
	--runTimer('adamAnimComplete', 0.1, 1);

	makeAnimatedLuaSprite('chaseAnimations', 'characters/chaseNutshell', getProperty('dad.x'), getProperty('dad.y'));
	addAnimationByPrefix('chaseAnimations', 'pack', 'Snowball Pack', 24, false);
	addAnimationByPrefix('chaseAnimations', 'throw', 'Snowball Throw', 24, false);
	setProperty('chaseAnimations.scale.x', 3);
	setProperty('chaseAnimations.scale.y', 3);
	setProperty('chaseAnimations.antialiasing', false);
	setProperty('chaseAnimations.flipX', true);
	setProperty('chaseAnimations.offset.y', 50);
	setObjectOrder('chaseAnimations', getObjectOrder('dadGroup'));
	setProperty('chaseAnimations.alpha', 0);

	--objectPlayAnimation('chaseAnimations', 'throw', false);
	--removeLuaSprite('chaseAnimations', false);
	--runTimer('chaseAnimComplete', 0.1, 1);]]--
	close();
end

--[[function onUpdate(elapsed)
	--setProperty('controls.LEFT', false);
	--for i = 0, getProperty('unspawnNotes.length') - 1 do
		--if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Hurt Note' then
			--setPropertyFromGroup('unspawnNotes', i, 'canBeHit', false);
		--end
	--end
end

-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Throw Snowball' then
		addLuaSprite('chaseAnimations', true);
		doTweenAlpha('chaseHide', 'dad', 0, 0.01, 'linear');
		setProperty('chaseAnimations.alpha', 1);
		objectPlayAnimation('chaseAnimations', 'throw', true);
		--characterPlayAnim('dad', 'throw', true);
		runTimer('chaseAnimComplete', 1, 1);

		playSound('swish', 5, 'swish');
		runTimer('snowballImpact', 0.1, 1);
		--debugPrint('Event triggered: ', name, value1, value2);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'snowballImpact' then
		if getProperty('boyfriend.color') ~= -7829368 then
			addLuaSprite('adamAnimations', true);
			doTweenAlpha('adamHide', 'boyfriend', 0, 0.01, 'linear');
			setProperty('adamAnimations.alpha', 1);
			playSound('snowballImpact', 5, 'snowballImpact');
			objectPlayAnimation('adamAnimations', 'snowballHit', true);
			runTimer('adamAnimComplete', 1, 1);

			setProperty('boyfriend.stunned', true);
			--characterPlayAnim('boyfriend', 'snowballHit', true);
			--setProperty('health', 0.01);
			runTimer('snowballWipe', 1, 1);
		end
	elseif tag == 'snowballWipe' then
		setProperty('boyfriend.stunned', false);
	elseif tag == 'chaseAnimComplete' then
		doTweenAlpha('chaseHide', 'dad', 1, 0.01, 'linear');
		removeLuaSprite('chaseAnimations', false);
	elseif tag == 'adamAnimComplete' then
		doTweenAlpha('adamHide', 'boyfriend', 1, 0.01, 'linear');
		removeLuaSprite('adamAnimations', false);
	end
end]]--