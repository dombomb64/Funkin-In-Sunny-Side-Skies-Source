function onCreatePost()
	--debugPrint(getPropertyFromGroup('unspawnNotes', 0, 'noteSplashTexture'));

	local isNutshell = false;

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' then
			isNutshell = true;
			precacheImage('hurtNoteSplashesNutshell');
			break;
		end
	end

	--debugPrint(isNutshell);

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Hurt Note' and isNutshell then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'hurtNoteAssetsNutshell');
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'hurtNoteSplashesNutshell');
		elseif getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Hurt Note' then
			setPropertyFromGroup('unspawnNotes', i, 'earlyHitMult', 0.25);
			setPropertyFromGroup('unspawnNotes', i, 'lateHitMult', 0.5);
		end
	end

	close(true);
end