function onCreate()
	--debugPrint(difficulty);
	--debugPrint(getProperty('camHUD.width') .. ', ' .. getProperty('camHUD.height'));
	--if difficulty == 3 then
		--setProperty("instakillOnMiss", true);
		--setProperty("healthBar.alpha", 0.0);
		--setProperty("healthGain", 0);
		--setProperty("healthLoss", 100);
		--setProperty("healthLoss", 0);

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
	--end
end

--[[function onCreatePost()
	setProperty('missLimit', -1);
end]]--

function onBeatHit()
	if curBeat == 292 then
		--[[removeLuaSprite('amongUsBg1', true);
		removeLuaSprite('amongUsBg2', true);

		addLuaSprite('darkAmongUsBg1', false);
		addLuaSprite('darkAmongUsBg2', false);
		addLuaSprite('darkAmongUsBg3', true);]]--

		objectPlayAnimation('darkAmongUsBg2', 'idle', true);
	elseif curBeat == 356 then
		cameraFlash('game', '000000', 99999999, true);
	elseif curBeat == 360 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		--[[removeLuaSprite('darkAmongUsBg1', true);
		removeLuaSprite('darkAmongUsBg2', true);
		removeLuaSprite('darkAmongUsBg3', true);

		addLuaSprite('whiteVoid', false);]]--

		--[[setProperty('boyfriendGroup.x', 1020);
		setProperty('boyfriendGroup.y', 510);
		setProperty('dadGroup.x', 540);
		setProperty('dadGroup.y', 600);]]--

		setProperty('boyfriendGroup.x', 1020);
		setProperty('boyfriendGroup.y', 600);
		setProperty('dadGroup.x', 540);
		setProperty('dadGroup.y', 480);
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