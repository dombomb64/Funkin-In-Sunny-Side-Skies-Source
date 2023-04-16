function onCreate()
	--[[for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Backup Sing' then
			--if (getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteAssetsNutshell') then
				--setPropertyFromGroup('unspawnNotes', i, 'texture', 'hurtNoteAssetsNutshell');
			--else
				--setPropertyFromGroup('unspawnNotes', i, 'texture', 'HURTNOTE_assets');
			--end

			--if getPropertyFromGroup('unspawnNotes', i, 'noteData') < 4 then
				--setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true); -- Turned off because this is handled by source now
			--end

			--if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				--setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			--end
		end
	end]]--
	close();
end

--[[function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Backup Sing' then
		--setProperty('health', getProperty('health') - 0.1);
		setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendHoldTimer', 0);
		if noteData == 0 then
			objectPlayAnimation('boyfriend2', 'singLEFT', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singLEFT');
		elseif noteData == 1 then
			objectPlayAnimation('boyfriend2', 'singDOWN', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singDOWN');
		elseif noteData == 2 then
			objectPlayAnimation('boyfriend2', 'singUP', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singUP');
		elseif noteData == 3 then
			objectPlayAnimation('boyfriend2', 'singRIGHT', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singRIGHT');
		end
	end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Backup Sing' then
		--setPropertyFromGroup('notes', id, 'noAnimation', true);
		if noteData == 0 then
			objectPlayAnimation('dad2', 'singLEFT', true);
			--setProperty('dad2.animation.curAnim.name', 'singLEFT');
			--luaDebugMode = true;
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singLEFT');
			--debugPrint(getGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation'));
		elseif noteData == 1 then
			objectPlayAnimation('dad2', 'singDOWN', true);
			--setProperty('dad2.animation.curAnim.name', 'singDOWN');
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singDOWN');
			--debugPrint(getGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation'));
		elseif noteData == 2 then
			objectPlayAnimation('dad2', 'singUP', true);
			--setProperty('dad2.animation.curAnim.name', 'singUP');
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singUP');
			--debugPrint(getGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation'));
		elseif noteData == 3 then
			objectPlayAnimation('dad2', 'singRIGHT', true);
			--setProperty('dad2.animation.curAnim.name', 'singRIGHT');
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation', 'singRIGHT');
			--debugPrint(getGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'dadAnimation'));
		end
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Backup Sing' then
		if noteData == 0 then
			objectPlayAnimation('boyfriend2', 'singLEFTmiss', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singLEFTmiss');
		elseif noteData == 1 then
			objectPlayAnimation('boyfriend2', 'singDOWNmiss', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singDOWNmiss');
		elseif noteData == 2 then
			objectPlayAnimation('boyfriend2', 'singUPmiss', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singUPmiss');
		elseif noteData == 3 then
			objectPlayAnimation('boyfriend2', 'singRIGHTmiss', true);
			setGlobalFromScript('Funkin in Sunny Side Skies/scripts/backupCharacters', 'boyfriendAnimation', 'singRIGHTmiss');
		end
	end
end]]--