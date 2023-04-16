local isNutshell = false;

function onCreate()
	--[[for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fireball Note' then
			--if (getPropertyFromGroup('unspawnNotes', 0, 'noteSplashTexture') == 'noteSplashesNutshell') then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'autoSingNoteAssetsNutshell');
				--setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'noteSplashesNutshell');
			--else
				--setPropertyFromGroup('unspawnNotes', i, 'texture', 'HURTNOTE_assets');
			--end

			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '1');

			--if getPropertyFromGroup('unspawnNotes', i, 'noteData') < 4 then
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			--end

			--[if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			end]--
		end
	end]]--
	close();
end

--[[function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' then
			isNutshell = true;
			if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fireball Note' then
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'noteSplashesNutshell');
			end
		end
	end
end]]--

--function goodNoteHit(id, noteData, noteType, isSustainNote)
	--if noteType == 'Fireball Note' then
		--setProperty('health', getProperty('health') - 0.1);
	--end
--end

--function opponentNoteHit(id, noteData, noteType, isSustainNote)
	--if noteType == 'Fireball Note' then
		--setPropertyFromGroup('notes', id, 'noAnimation', true);
	--end
--end

--[[function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Fireball Note' then
		
	end
end]]--