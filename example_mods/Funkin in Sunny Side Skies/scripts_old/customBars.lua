-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)
-- Related Scripts: nutshellUi, flipnoteUi, pixelArrows, pixelIcons (You can use those, too.)

function onCreatePost()
	--debugPrint(getPropertyFromGroup('unspawnNotes', 0, 'texture'));
	--debugPrint(getProperty('SONG.arrowSkin'));
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		--if getPropertyFromGroup('unspawnNotes', i, 'texture') == 'noteAssetsNutshell' then
		if getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'hurtNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'crucialNoteSplashesNutshell' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteRed' or getPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture') == 'noteSplashesFlipnoteBlue' then
			makeLuaSprite('healthBarOverlay', 'healthBarOverlay', getProperty('healthBar.x'), getProperty('healthBar.y') - 14);
			setScrollFactor('healthBarOverlay', 0, 0);
			setObjectCamera('healthBarOverlay', 'hud');
			setObjectOrder('healthBarOverlay', getObjectOrder('healthBar') + 1);
			setProperty('healthBarOverlay.antialiasing', false);
			addLuaSprite('healthBarOverlay', false);

			makeLuaSprite('timeBarOverlay', 'timeBarOverlay', getProperty('timeBar.x'), getProperty('timeBar.y') - 14);
			setScrollFactor('timeBarOverlay', 0, 0);
			setObjectCamera('timeBarOverlay', 'hud');
			setObjectOrder('timeBarOverlay', getObjectOrder('timeBar') + 1);
			setProperty('timeBarOverlay.antialiasing', false);
			addLuaSprite('timeBarOverlay', false);

			--setProperty('timeBarOverlay.alpha', 0);

			break;
		end
	end
end

--function onSongStart()
	--doTweenAlpha('timeBarOverlayAlpha', 'alpha', 1, 0.5, 'circOut');
--end

function onUpdate(elapsed)
	setProperty('healthBarOverlay.alpha', getProperty('healthBar.alpha'));
	setProperty('timeBarOverlay.alpha', getProperty('timeBar.alpha'));
end

function onEndSong()
	setProperty('timeBarOverlay.visible', false);
	return Function_Continue;
end