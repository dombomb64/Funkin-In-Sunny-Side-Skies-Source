function onCreate()
	--debugPrint(difficulty);
	--if difficulty == 3 then
		--[[--setProperty("instakillOnMiss", true);
		setProperty("healthBar.alpha", 0.0);
		setProperty("healthGain", 0);
		--setProperty("healthLoss", 100);
		setProperty("healthLoss", 0);]]--

		addCharacterToList('chaseImpostorDark', 'dad');
		addCharacterToList('adamCrewmateDark', 'bf');
		addCharacterToList('chaseImpostorRun', 'dad');
		addCharacterToList('adamCrewmateRun', 'bf');

		makeLuaSprite('emergencyMeeting1', 'songSprites/emergencyMeeting1', 0, 0);
		makeAnimatedLuaSprite('emergencyMeeting2', 'songSprites/emergencyMeeting2', 0, 0);
		makeAnimatedLuaSprite('emergencyMeeting3', 'songSprites/emergencyMeeting3', 0, 0);

		addAnimationByPrefix('emergencyMeeting2', 'idle', 'Idle', 24, true);
		addAnimationByPrefix('emergencyMeeting3', 'idle', 'Idle', 24, false);

		setObjectCamera('emergencyMeeting1', 'hud');
		setObjectCamera('emergencyMeeting2', 'hud');
		setObjectCamera('emergencyMeeting3', 'hud');

		setProperty('emergencyMeeting1.antialiasing', false);
		setProperty('emergencyMeeting2.antialiasing', false);
		setProperty('emergencyMeeting3.antialiasing', false);

		--makeIcons();
		--runTimer('makeIcons', 0.1, 1);
	--end
end

function onCreatePost()
	--makeIcons();
	--runTimer('makeIcons', 0.1, 1);
	runHaxeCode([[
		game.changeIcon('boyfriend', 'dombomb64');
		game.changeIcon('dad', 'jomjom412');
		game.healthBar.createFilledBar(0xFFFF4C5F, 0xFF73D0FF);
	]]);
end

function onBeatHit()
	--setProperty('bfIcon.alpha', 0);
	--setProperty('dadIcon.alpha', 0);

	if curBeat == 292 then
		removeLuaSprite('amongUsBg1', true);
		removeLuaSprite('amongUsBg2', true);

		addLuaSprite('darkAmongUsBg1', false);
		addLuaSprite('darkAmongUsBg2', false);
		addLuaSprite('darkAmongUsBg3', true);

		objectPlayAnimation('darkAmongUsBg2', 'idle', true);

		runHaxeCode([[
			game.triggerEventNote('Change Character', 'boyfriend', 'adamCrewmateDark');
			game.triggerEventNote('Change Character', 'dad', 'chaseImpostorDark');

			game.changeIcon('boyfriend', 'dombomb64');
			game.changeIcon('dad', 'jomjom412');
			game.healthBar.createFilledBar(0xFFFF4C5F, 0xFF73D0FF);
		]]);
	elseif curBeat == 356 then
		cameraFlash('game', '000000', 99999999, true);
	elseif curBeat == 360 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		removeLuaSprite('darkAmongUsBg1', true);
		removeLuaSprite('darkAmongUsBg2', true);
		removeLuaSprite('darkAmongUsBg3', true);

		addLuaSprite('whiteVoid', false);

		--[[setProperty('boyfriendGroup.x', 1020);
		setProperty('boyfriendGroup.y', 510);
		setProperty('dadGroup.x', 540);
		setProperty('dadGroup.y', 600);]]--

		setProperty('boyfriendGroup.x', 1020);
		setProperty('boyfriendGroup.y', 600);
		setProperty('dadGroup.x', 540);
		setProperty('dadGroup.y', 480);
		
		runHaxeCode([[
			game.triggerEventNote('Change Character', 'boyfriend', 'adamCrewmateRun');
			game.triggerEventNote('Change Character', 'dad', 'chaseImpostorRun');

			game.changeIcon('boyfriend', 'dombomb64');
			game.changeIcon('dad', 'jomjom412');
			game.healthBar.createFilledBar(0xFFFF4C5F, 0xFF73D0FF);
		]]);
	elseif curBeat == 488 then
		cameraFlash('game', '000000', 99999999, true);
	elseif curBeat == 490 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		addLuaSprite('emergencyMeeting1', false);
		addLuaSprite('emergencyMeeting2', false);
		objectPlayAnimation('emergencyMeeting2', 'idle', true);
	elseif curBeat == 491 then
		addLuaSprite('emergencyMeeting3', false);
		objectPlayAnimation('emergencyMeeting3', 'idle', true);
	elseif curBeat == 494 then
		removeLuaSprite('emergencyMeeting1', true);
		removeLuaSprite('emergencyMeeting2', true);
		removeLuaSprite('emergencyMeeting3', true);
		cameraFlash('hud', '000000', 99999999, true);
	end
end

--[[function noteMiss(id, direction, noteType, isSustainNote)
	setProperty('health', 0);
end]]--

--[[function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'makeIcons' then
		--debugPrint('test');
		makeIcons();
	end
end

function makeIcons()
	removeLuaSprite('bfIcon', true);
	removeLuaSprite('dadIcon', true);
	setProperty('iconP1.alpha', 1);
	setProperty('iconP2.alpha', 1);

	--if getProperty('iconP1.char') == 'adamNutshell' or getProperty('iconP1.char') == 'kristenNutshell' or getProperty('iconP1.char') == 'chaseNutshell' or getProperty('iconP1.char') == 'elliotNutshell' or getProperty('iconP1.char') == 'senpaiNutshell' or getProperty('iconP1.char') == 'dudeNutshell' or getProperty('iconP1.char') == 'jimNutshell' or getProperty('iconP1.char') == 'pjNutshell' or getProperty('iconP1.char') == 'dandyNutshell' then
		makeBfIcon();
	--end

	--if getProperty('iconP2.char') == 'adamNutshell' or getProperty('iconP2.char') == 'kristenNutshell' or getProperty('iconP2.char') == 'chaseNutshell' or getProperty('iconP2.char') == 'elliotNutshell' or getProperty('iconP2.char') == 'senpaiNutshell' or getProperty('iconP2.char') == 'dudeNutshell' or getProperty('iconP2.char') == 'jimNutshell' or getProperty('iconP2.char') == 'pjNutshell' or getProperty('iconP2.char') == 'dandyNutshell' then
		makeDadIcon();
	--end
end

function makeBfIcon()
	--makeAnimatedLuaSprite('bfIcon', 'winningIcons/icon-' .. getProperty('iconP1.char'), getProperty('iconP1.x'), getProperty('iconP1.y'));
	makeAnimatedLuaSprite('db64Icon', 'winningIcons/icon-dombomb64', getProperty('iconP1.x'), getProperty('iconP1.y'));

	addAnimationByPrefix('db64Icon', 'winning', 'Winning', 24, true);
	addAnimationByPrefix('db64Icon', 'neutral', 'Neutral', 24, true);
	addAnimationByPrefix('db64Icon', 'losing', 'Losing', 24, true);

	addLuaSprite('db64Icon', true);

	setObjectCamera('db64Icon', 'hud');
	setProperty('db64Icon.flipX', true);
	objectPlayAnimation('db64Icon', 'neutral', true);
	setObjectOrder('db64Icon', getObjectOrder('iconP1'));
	setProperty('db64Icon.antialiasing', getProperty('iconP1.antialiasing'));

	setProperty('db64Icon.offset.x', -21);

	setProperty('iconP1.alpha', 0);
end

function makeDadIcon()
	--makeAnimatedLuaSprite('dadIcon', 'winningIcons/icon-' .. getProperty('iconP2.char'), getProperty('iconP2.x'), getProperty('iconP2.y'));
	makeAnimatedLuaSprite('jomjom412Icon', 'winningIcons/icon-jomjom412', getProperty('iconP2.x'), getProperty('iconP2.y'));

	addAnimationByPrefix('jomjom412Icon', 'winning', 'Winning', 24, true);
	addAnimationByPrefix('jomjom412Icon', 'neutral', 'Neutral', 24, true);
	addAnimationByPrefix('jomjom412Icon', 'losing', 'Losing', 24, true);

	addLuaSprite('jomjom412Icon', true);

	setObjectCamera('jomjom412Icon', 'hud');
	--setProperty('jomjom412Icon.flipX', true);
	objectPlayAnimation('jomjom412Icon', 'neutral', true);
	setObjectOrder('jomjom412Icon', getObjectOrder('iconP2'));
	setProperty('jomjom412Icon.antialiasing', getProperty('iconP2.antialiasing'));

	setProperty('jomjom412Icon.offset.x', 12);
	--setProperty('dad.healthColorArray[0]', 0);
	--setProperty('dad.healthColorArray[1]', 0);
	--setProperty('dad.healthColorArray[2]', 0);

	setProperty('iconP2.alpha', 0);
end]]--