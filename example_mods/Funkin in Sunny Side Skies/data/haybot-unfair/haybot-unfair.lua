local bfIcon = '';
local dadIcon = '';

function onCreatePost()
	bfIcon = getProperty('boyfriend.healthIcon');
	dadIcon = getProperty('dad.healthIcon');

	addCharacterToList('flappyGolf', 'boyfriend');
	addCharacterToList('flappyGolf', 'dad');
end

function onBeatHit()
	if curBeat == 32 then
		makeDadIcon('icon-tankman');
	elseif curBeat == 34 then
		destroyIcons();
	elseif curBeat == 40 then
		makeDadIcon('icon-tankman');
	elseif curBeat == 42 then
		destroyIcons();
	elseif curBeat == 48 then
		makeBfIcon('icon-tankman');
	elseif curBeat == 50 then
		destroyIcons();
	elseif curBeat == 56 then
		makeBfIcon('icon-tankman');
	elseif curBeat == 58 then
		destroyIcons();
	elseif curBeat == 96 then
		makeDadIcon('icon-tankman');
	elseif curBeat == 98 then
		destroyIcons();
	elseif curBeat == 104 then
		makeDadIcon('icon-tankman');
	elseif curBeat == 106 then
		destroyIcons();
	elseif curBeat == 112 then
		makeBfIcon('icon-tankman');
	elseif curBeat == 114 then
		destroyIcons();
	elseif curBeat == 120 then
		makeBfIcon('icon-tankman');
	elseif curBeat == 122 then
		destroyIcons();
	elseif curBeat == 144 then
		destroyIcons();
		makeDadIcon('icon-blackImpostor');
	elseif curBeat == 148 then
		destroyIcons();
	elseif curBeat == 152 then
		makeDadIcon('icon-blackImpostor');
	elseif curBeat == 156 then
		destroyIcons();
	elseif curBeat == 160 then
		makeBfIcon('icon-blackImpostor');
	elseif curBeat == 164 then
		destroyIcons();
	elseif curBeat == 168 then
		makeBfIcon('icon-blackImpostor');
	elseif curBeat == 172 then
		destroyIcons();
	elseif curBeat == 188 then
		makeDadIcon('icon-blackImpostor');
	elseif curBeat == 193 then
		destroyIcons();
	elseif curBeat == 204 then
		makeBfIcon('icon-blackImpostor');
	elseif curBeat == 208 then
		makeDadIcon('icon-mario');
	elseif curBeat == 209 then
		destroyIcons();
		makeDadIcon('icon-mario');
	elseif curBeat == 212 then
		destroyIcons();
		makeDadIcon('icon-hex');
	elseif curBeat == 216 then
		destroyIcons();
		makeDadIcon('icon-whitty');
	elseif curBeat == 220 then
		destroyIcons();
		makeDadIcon('icon-mom');
	elseif curBeat == 222 then
		destroyIcons();
		makeDadIcon('icon-enderEye');
	elseif curBeat == 224 then
		destroyIcons();
		makeBfIcon('icon-mario');
	elseif curBeat == 228 then
		destroyIcons();
		makeBfIcon('icon-hex');
	elseif curBeat == 232 then
		destroyIcons();
		makeBfIcon('icon-whitty');
	elseif curBeat == 236 then
		destroyIcons();
		makeBfIcon('icon-mom');
	elseif curBeat == 238 then
		destroyIcons();
		makeBfIcon('icon-enderEye');
	elseif curBeat == 240 then
		destroyIcons();
	elseif curBeat == 262 then
		triggerEvent('Change Character', 'dad', 'flappyGolf');
		triggerEvent('Change Character', 'boyfriend', 'flappyGolf');
	end
end

function onStepHit()
	if curStep == 554 then
		makeBfIcon('icon-blackImpostor');
	end
end

function onUpdate(elapsed)
	setProperty('bfIcon.x', getProperty('iconP1.x'));
	setProperty('bfIcon.y', getProperty('iconP1.y'));
	setProperty('bfIcon.scale.x', getProperty('iconP1.scale.x'));
	setProperty('bfIcon.scale.y', getProperty('iconP1.scale.y'));
	setProperty('dadIcon.x', getProperty('iconP1.x'));
	setProperty('dadIcon.y', getProperty('iconP1.y'));
	setProperty('dadIcon.scale.x', getProperty('iconP1.scale.x'));
	setProperty('dadIcon.scale.y', getProperty('iconP1.scale.y'));
end

function makeBfIcon(name)
	--[[makeLuaSprite('bfIcon', name, 0, 0);
	setObjectOrder('bfIcon', getObjectOrder('iconP1'));
	setProperty('bfIcon.flipX', true);
	setObjectCamera('bfIcon', 'hud');
	addLuaSprite('bfIcon', true);
	setProperty('iconP1.alpha', 0);]]--
	runHaxeCode([[
		game.changeIcon('boyfriend', ']] .. name .. [[');
	]]);
end

function makeDadIcon(name)
	--[[makeLuaSprite('dadIcon', name, 0, 0);
	setObjectOrder('dadIcon', getObjectOrder('iconP1'));
	--setProperty('dadIcon.flipX', true);
	setObjectCamera('dadIcon', 'hud');
	addLuaSprite('dadIcon', true);
	setProperty('iconP2.alpha', 0);]]--
	runHaxeCode([[
		game.changeIcon('dad', ']] .. name .. [[');
	]]);
end

function destroyIcons()
	--[[removeLuaSprite('bfIcon', true);
	removeLuaSprite('dadIcon', true);
	setProperty('iconP1.alpha', 1);
	setProperty('iconP2.alpha', 1);]]--
	runHaxeCode([[
		game.changeIcon('boyfriend', ']] .. bfIcon .. [[');
		game.changeIcon('dad', ']] .. dadIcon .. [[');
	]]);
end