--local botplay = false;

function onCreate()
	--[[--botplay = getProperty('cpuControlled');
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Backup Auto Sing' then
			--if (getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteAssetsNutshell') then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'autoSingNoteAssetsNutshell');
			--else
				--setPropertyFromGroup('unspawnNotes', i, 'texture', 'HURTNOTE_assets');
			--end

			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0);
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0);
			setPropertyFromGroup('unspawnNotes', i, 'hitsoundDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true);
			--setPropertyFromGroup('unspawnNotes', i, 'alpha', 0);

			--if getPropertyFromGroup('unspawnNotes', i, 'noteData') < 4 then
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			--end

			--if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				--setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			--end
		end
	end]]--
	close();
end

--[[function onUpdate(elapsed)
	--setProperty('cpuControlled', botplay);
	for i = 0, getProperty('notes.length') - 1 do
		--debugPrint(getPropertyFromGroup('notes', 4, 'distance'));
		--if getPropertyFromGroup('notes', i, 'noteType') == 'Backup Auto Sing' then
			--setPropertyFromGroup('notes', i, 'alpha', 0);
		--end

		if getPropertyFromGroup('notes', i, 'noteType') == 'Backup Auto Sing' and (getPropertyFromGroup('notes', i, 'canBeHit') == true or (getPropertyFromGroup('notes', i, 'strumTime') > getPropertyFromClass('Conductor', 'songPosition') - (getPropertyFromClass('Conductor', 'safeZoneOffset') * getPropertyFromGroup('notes', i, 'lateHitMult')) and getPropertyFromGroup('notes', i, 'strumTime') < getPropertyFromClass('Conductor', 'songPosition') + (getPropertyFromClass('Conductor', 'safeZoneOffset') * getPropertyFromGroup('notes', i, 'earlyHitMult')))) then
			--debugPrint(getPropertyFromGroup('notes', i, 'data'));
			--setProperty('cpuControlled', true);
			--setProperty('noteWasHit', true);

			if getPropertyFromGroup('notes', i, 'mustPress') then
				setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendHoldTimer', 0);
				if getPropertyFromGroup('notes', i, 'noteData') == 0 then
					objectPlayAnimation('boyfriend2', 'singLEFT', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singLEFT');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 1 then
					objectPlayAnimation('boyfriend2', 'singDOWN', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singDOWN');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 2 then
					objectPlayAnimation('boyfriend2', 'singUP', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singUP');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 3 then
					objectPlayAnimation('boyfriend2', 'singRIGHT', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singRIGHT');
				end
			else
				if getPropertyFromGroup('notes', i, 'noteData') == 0 then
					objectPlayAnimation('dad2', 'singLEFT', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singLEFT');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 1 then
					objectPlayAnimation('dad2', 'singDOWN', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singDOWN');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 2 then
					objectPlayAnimation('dad2', 'singUP', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singUP');
				elseif getPropertyFromGroup('notes', i, 'noteData') == 3 then
					objectPlayAnimation('dad2', 'singRIGHT', true);
					setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singRIGHT');
				end
			end

			removeFromGroup('notes', i);
		--else
			--setProperty('cpuControlled', botplay);
		end
	end
end]]--

--[[function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Backup Auto Sing' then
		--setProperty('health', getProperty('health') - 0.1);
		--setPropertyFromGroup('playerStrums', noteData, );
		--objectPlayAnimation('playerStrums[' .. noteData .. ']', 'confirm', true);
	end
end]]--

--function opponentNoteHit(id, noteData, noteType, isSustainNote)
	--if noteType == 'Backup Auto Sing' then
		--setPropertyFromGroup('notes', id, 'noAnimation', true);
	--end
--end