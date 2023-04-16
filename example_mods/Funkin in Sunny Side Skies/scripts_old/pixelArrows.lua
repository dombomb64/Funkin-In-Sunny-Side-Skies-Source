-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it was me messing around.)
-- Related Scripts: customBars, nutshellUi, flipnoteUi, pixelIcons (You can use those, too.)

isNutshell = false;

function onCreatePost(elapsed)
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteRed' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteBlue' then
			isNutshell = true;
			--debugPrint('nutshell');
			break;
		end
	end

	--setPropertyFromGroup('notes', 0, 'scale.x', 2);
	--setPropertyFromGroup('notes', 0, 'antialiasing', false);
	--local i = 0;
	--for i = 0, 3, 1 do
		--setPropertyFromGroup('opponentStrums', i, 'antialiasing', false);
		--setPropertyFromGroup('playerStrums', i, 'antialiasing', false);
	--end
	--setProperty('songSpeed', (curBeat % 2) + 1);

	if isNutshell then
		for i = 0, getProperty('unspawnNotes.length') - 1 do
			setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false);
		end
	end
end

--[[local curStep = 0; 
function onStepHit()
	--setProperty('songSpeed', (curStep % 2 * 0.025) + 1);
	--setProperty('songSpeed', (curStep % 2 * 0.5) + 1);
	triggerEvent('Change Scroll Speed', (curStep % 2 * 0.25) + 0.5, stepCrochet / 1000 / 2);
	curStep = curStep + 1;
	--debugPrint(curStep);
	--debugPrint(getProperty('songSpeed'));
end]]--