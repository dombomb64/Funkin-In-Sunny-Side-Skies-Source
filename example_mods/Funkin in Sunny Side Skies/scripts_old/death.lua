function onCreate()
	--debugPrint(getPropertyFromClass('GameOverSubstate', 'camFollow.x'));
	
	--debugPrint(songName);
	--if (songName == 'Best Friend') then
	if boyfriendName ~= 'bf' and boyfriendName ~= 'bf-pixel' then
		makeAnimatedLuaSprite('chaseGameOver', 'characters/chaseGameOver', 400, 100);
		setObjectCamera('chaseGameOver', 'hud');
		setProperty('chaseGameOver.scale.x', 3);
		setProperty('chaseGameOver.scale.y', 3);
		setProperty('chaseGameOver.antialiasing', false);
		addAnimationByPrefix('chaseGameOver', 'open', 'Mouth Open', 24, true);
		addAnimationByPrefix('chaseGameOver', 'closed', 'Mouth Closed', 24, true);
		setScrollFactor('chaseGameOver', 0, 0);
		setProperty('chaseGameOver.alpha', 0);

		--setPropertyFromClass('GameOverSubstate', 'camFollow.x', getProperty('boyfriend.x'));
		--setPropertyFromClass('GameOverSubstate', 'camFollow.y', getProperty('boyfriend.y'));
		--setPropertyFromClass('GameOverSubstate', 'updateCamera', true);
		setPropertyFromClass('GameOverSubstate', 'characterName', 'chaseGameOver'); --Character json file for the death animation
		setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'micDrop'); --put in mods/sounds/
		--setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
		--setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
	end
end

function onUpdate()
	--if getProperty('boyfriend.animation.curAnim.name') == 'firstDeath' and getProperty('boyfriend.animation.curAnim.finished') and getProperty('boyfriend.startedDeath') then
		--characterPlayAnim('boyfriend', 'deathLoop', true);
	--end
	if getProperty('boyfriend.startedDeath') then
		setProperty('chaseGameOver.alpha', 1);
	end
end

function onGameOverStart()
	--setProperty('inGameOver', false);
	--setProperty('persistentUpdate', true);
	--setProperty('persistentDraw', true);
	--runTimer('chaseOpenMouth', 0.01, 1);
	--setPropertyFromClass('GameOverSubstate', 'characterName', 'chaseGameOver');
	--cameraSetTarget('boyfriend');

	setProperty('boyfriend.alpha', 0);
	addLuaSprite('chaseGameOver');
	objectPlayAnimation('chaseGameOver', 'open', true);

	--setProperty('inGameOver', true);
	--return Function_Continue;
end

function onGameOverConfirm()
	objectPlayAnimation('chaseGameOver', 'closed', true);
	cameraFade('hud', '0xFF000000', 2, true);
	--doTweenAlpha('chaseGameOver', 'alpha', 0, 3, 'linear');
end

--[[function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'chaseOpenMouth' then
		setObjectCamera('chaseGameOver', 'hud');
		makeAnimatedLuaSprite('chaseGameOver', 'chaseGameOver', 0, 0);
		addAnimationByPrefix('chaseGameOver', 'open', 'Mouth Open', 24, true);
		addAnimationByPrefix('chaseGameOver', 'closed', 'Mouth Closed', 24, true);
		addLuaSprite('chaseGameOver', true);
		setScrollFactor('chaseGameOver', 0, 0);
		objectPlayAnimation('chaseGameOver', 'open', true);
	end
end]]--