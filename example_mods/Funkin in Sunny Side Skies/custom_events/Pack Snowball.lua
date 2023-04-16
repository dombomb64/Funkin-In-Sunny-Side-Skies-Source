function onCreate()
	--precacheSound('snowPack');
	close();
end

-- Event notes hooks
--[[function onEvent(name, value1, value2)
	if name == 'Pack Snowball' then
		addLuaSprite('chaseAnimations', true);
		doTweenAlpha('chaseHide', 'dad', 0, 0.01, 'linear');
		setProperty('chaseAnimations.alpha', 1);
		objectPlayAnimation('chaseAnimations', 'pack', true);
		--characterPlayAnim('dad', 'pack', true);
		runTimer('chaseAnimComplete', 1, 1);

		playSound('snowPack', 5, 'snowPack');
		--debugPrint('Event triggered: ', name, value1, value2);
	end
end


function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'chaseAnimComplete' then
		doTweenAlpha('chaseHide', 'dad', 1, 0.01, 'linear');
		removeLuaSprite('chaseAnimations', false);
	elseif tag == 'adamAnimComplete' then
		doTweenAlpha('adamHide', 'boyfriend', 1, 0.01, 'linear');
		removeLuaSprite('adamAnimations', false);
	end
end]]--