function onCreate()
    if getPropertyFromClass('ClientPrefs', 'shaders') then
        addCharacterToList('chaseSandLandFlipnoteShader', 'dad');
        addCharacterToList('adamSandLandFlipnoteShader', 'boyfriend');
    else
        addCharacterToList('chaseFlipnoteBlue', 'dad');
        addCharacterToList('chaseSandLandFlipnoteRed', 'dad');
        addCharacterToList('chaseSandLandFlipnoteBlue', 'dad');
        addCharacterToList('adamFlipnoteBlue', 'boyfriend');
        addCharacterToList('adamSandLandFlipnoteRed', 'boyfriend');
        addCharacterToList('adamSandLandFlipnoteBlue', 'boyfriend');
        addCharacterToList('chaseBoomboxFlipnoteBlue', 'gf');
        precacheImage('noteAssetsFlipnoteBlue');
        precacheImage('noteSplashesFlipnoteBlue');
    end
    addCharacterToList('noGf', 'gf');
    
    --[[makeAnimatedLuaSprite('wahoo', 'songSprites/wahoo', 0, 0);
    setProperty('wahoo.scale.x', 2);
    setProperty('wahoo.scale.y', 2);
	setProperty('wahoo.x', getProperty('camOther.width') / 2 - getProperty('wahoo.frameWidth') / 2);
	setProperty('wahoo.y', getProperty('camOther.height') / 2 - getProperty('wahoo.frameHeight') / 2);
    addAnimationByPrefix('wahoo', 'wa', 'Wa', 24, false);
    addAnimationByPrefix('wahoo', 'hoo', 'Hoo', 24, false);
	setObjectCamera('wahoo', 'hud');
    setProperty('wahoo.antialiasing', false);

    --wa();]]--
    --close();
end

function onBeatHit()
    --[[if curBeat == 78 then
        wa();
    elseif curBeat == 79 then
        hoo();
    elseif curBeat == 94 then
        wa();
    elseif curBeat == 95 then
        hoo();
    elseif curBeat == 110 then
        wa();
    elseif curBeat == 111 then
        hoo();
    elseif curBeat == 230 then
        wa();
    elseif curBeat == 231 then
        hoo();
    elseif curBeat == 246 then
        wa();
    elseif curBeat == 247 then
        hoo();
    elseif curBeat == 280 then
        --turnBlue();
        triggerEvent('Turn Blue', '', '');
    elseif curBeat > 280 then
        blueNotes();
    end]]--

    if curBeat == 120 then
        zoomIn();
    elseif curBeat == 216 then
        zoomOut();
    elseif curBeat == 280 then
        zoomIn();
    elseif curBeat == 392 then
        zoomOut();
    end

    --[[if curBeat == 1 then
        wa();
    elseif curBeat == 2 then
        hoo();
    end]]--
end

function zoomIn()
    setProperty('boyfriendGroup.x', 1080);
    --setProperty('boyfriendGroup.y', 100);
    --setProperty('gfGroup.x', 400);
    --setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', -210);
    --setProperty('dadGroup.y', 100);

    setProperty('defaultCamZoom', 0.6);
    setProperty('camGame.zoom', 0.8);
    setProperty('cameraSpeed', 999);
    runTimer('resetCameraSpeed', 0.1, 1);
    triggerEvent('Camera Follow Pos', '690', '300');

    local tempStr = 'FlipnoteRed';
    if getProperty('youreBlueNow') then
        tempStr = 'FlipnoteBlue';
    end
    triggerEvent('Change Character', 'dad', 'chaseSandLand' .. tempStr);
    triggerEvent('Change Character', 'gf', 'noGf');
    triggerEvent('Change Character', 'boyfriend', 'adamSandLand' .. tempStr);

    triggerEvent('Flash White', 'camHUD', '');

    setProperty('sandLandBg2a.alpha', 1);
    setProperty('sandLandBg2b.alpha', 1);
    setProperty('sandLandBg3a.alpha', 1);
    setProperty('sandLandBg3b.alpha', 1);
end

function zoomOut()
    setProperty('boyfriendGroup.x', 870);
    --setProperty('boyfriendGroup.y', 100);
    --setProperty('gfGroup.x', 400);
    --setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', 0);
    --setProperty('dadGroup.y', 100);

    setProperty('defaultCamZoom', 0.75);
    setProperty('camGame.zoom', 1.0);
    setProperty('cameraSpeed', 999);
    runTimer('resetCameraSpeed', 0.1, 1);
    triggerEvent('Camera Follow Pos', '', '');

    local tempStr = 'FlipnoteRed';
    if getProperty('youreBlueNow') then
        tempStr = 'FlipnoteBlue';
    end
    triggerEvent('Change Character', 'dad', 'chase' .. tempStr);
    triggerEvent('Change Character', 'gf', 'chaseBoombox' .. tempStr);
    triggerEvent('Change Character', 'boyfriend', 'adam' .. tempStr);

    triggerEvent('Flash White', 'camHUD', '');

    setProperty('sandLandBg2a.alpha', 0);
    setProperty('sandLandBg2b.alpha', 0);
    setProperty('sandLandBg3a.alpha', 0);
    setProperty('sandLandBg3b.alpha', 0);
end

function onTimerCompleted(tag, loops, loopsLeft)
    --[[if tag == 'wahooDisappear' then
        removeLuaSprite('wahoo', false);
    end]]--

    if tag == 'resetCameraSpeed' then
        setProperty('cameraSpeed', 1);
    end
end

--[[function turnBlue()
    triggerEvent('Change Character', 'dad', 'chaseFlipnoteBlue');
    triggerEvent('Change Character', 'boyfriend', 'adamFlipnoteBlue');
    triggerEvent('Change Character', 'gf', 'chaseBoomboxFlipnoteBlue');

    blueNotes();
end

function blueNotes()
    for i = 0, getProperty('notes.length') - 1 do
        if (getPropertyFromGroup('notes', i, 'texture') == 'noteAssetsFlipnoteRed') then
            setPropertyFromGroup('notes', i, 'texture', 'noteAssetsFlipnoteBlue');
            setPropertyFromGroup('notes', i, 'noteSplashTexture', 'noteSplashesFlipnoteBlue');
        end
    end
end

function wa()
    addLuaSprite('wahoo', false);
    objectPlayAnimation('wahoo', 'wa');
end

function hoo()
    objectPlayAnimation('wahoo', 'hoo');
    runTimer('wahooDisappear', 2, 1);
end]]--