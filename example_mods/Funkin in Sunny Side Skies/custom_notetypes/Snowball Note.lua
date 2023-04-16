function onCreate()
	--[[for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Snowball Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'snowballNoteAssetsNutshell');
			if getPropertyFromGroup('unspawnNotes', i, 'noteData') < 4 then
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			end

			--if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				--setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			--end
			
			--[setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', 0);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 0);]--
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0);
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0);
		end
	end]]--
	close();
end

--[[function onUpdate(elapsed)
	if isDodging == true then
		setProperty('boyfriend.alpha', 0.5);
		doTweenColor(tag:String, vars:String, targetColor:String, duration:Float, ease:String)
	else
		setProperty('boyfriend.alpha', 1.0);
		doTweenColor(tag:String, vars:String, targetColor:String, duration:Float, ease:String)
	end
end]]--

--[[function goodNoteHit(id, noteData, noteType, isSustainNote)
	--debugPrint(getProperty('boyfriend.color'));
	if noteType == 'Snowball Note' then
		isDodging = true;
		--setProperty('boyfriend.alpha', 0.5);

		addLuaSprite('adamAnimations', true);
		doTweenAlpha('adamHide', 'boyfriend', 0, 0.01, 'linear');
		setProperty('adamAnimations.alpha', 1);
		objectPlayAnimation('adamAnimations', 'dodge', true);
		runTimer('adamAnimComplete', 1, 1);

		--characterPlayAnim('boyfriend', 'dodge', true);
		doTweenColor('dodgeColor', 'boyfriend', '888888', 0.01, 'linear');
		doTweenAlpha('dodgeAlpha', 'boyfriend', 0.0, 0.01, 'linear');
		runTimer('dodgeStop', 1, 1);
	end
end

--function opponentNoteHit(id, noteData, noteType, isSustainNote)
	--if noteType == 'Mine' then
		--setPropertyFromGroup('notes', id, 'noAnimation', true);
	--end
--end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dodgeStop' then
		isDodging = false;
		--setProperty('boyfriend.alpha', 1.0);
		doTweenAlpha('dodgeAlpha', 'boyfriend', 1.0, 0.01, 'linear');
		doTweenColor('dodgeColor', 'boyfriend', 'ffffff', 0.01, 'linear');
	--[elseif tag == 'snowballImpact' then
		if isDodging == false then
			playSound('snowballImpact', 5, 'snowballImpact');
			setProperty('health', 0.01);
		end]--
	elseif tag == 'chaseAnimComplete' then
		doTweenAlpha('chaseHide', 'dad', 1, 0.01, 'linear');
		removeLuaSprite('chaseAnimations', false);
	elseif tag == 'adamAnimComplete' then
		doTweenAlpha('adamHide', 'boyfriend', 1, 0.01, 'linear');
		removeLuaSprite('adamAnimations', false);
	end
end]]--