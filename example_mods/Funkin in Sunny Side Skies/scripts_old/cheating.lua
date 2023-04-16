local cheatingPossible = false;
local pressedDebug = false;

function onCreate()
    if songName == 'Get Back Here!' or songName == 'Get Back Here! Unfair' then
        cheatingPossible = true;
        --setProperty('debugKeysChart', null);
        --setProperty('debugKeysChart', 'FlxKey.SIX');
        setProperty('debugKeysChart[0]', 54);
    end
end

function onUpdatePost()
    if keyboardJustPressed('SEVEN') and cheatingPossible and not pressedDebug then
        --loadSong('alacrity', 2);
		--setProperty('timeTxt.text', 'You should\'ve pressed 6.');
		--setProperty('scoreTxt.text', 'You should\'ve pressed 6.');
	    makeLuaSprite('black', 'blackvoid', 0, 0);
        setObjectCamera('black', 'other');
        setProperty('black.scale.x', 3);
        setProperty('black.scale.y', 3);
        addLuaSprite('black', true);

        makeLuaText('shadowRealm', 'You should\'ve pressed 6.', 2000, 0, 0);
        addLuaText('shadowRealm');
        setTextSize('shadowRealm', 50);
        setTextBorder('shadowRealm', 5, '0xFF880000');
        setObjectCamera('shadowRealm', 'other');
        screenCenter('shadowRealm');

        doTweenX('creepyTextScaleX', 'shadowRealm.scale', 2, 10, 'linear');
        doTweenY('creepyTextScaleY', 'shadowRealm.scale', 2, 10, 'linear');

        runTimer('shadowRealm', 5, 1);
        setProperty('debugKeysChart[0]', nil);

        soundFadeOut('', 0.25, 0);
        --soundFadeOut('vocals', 0.25, 0);
        --setProperty('vocals.volume', 0);
        --setProperty('vocals.endTime', 0);
        --setProperty('vocals.time', 0);

        pressedDebug = true;
    elseif pressedDebug then
        setProperty('vocals.volume', 0);
        setProperty('health', 1);
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'shadowRealm' then
        loadSong('alacrity', 2);
    end
end

function onPause()
    if pressedDebug then
        return Function_Stop;
    end
    return Function_Continue;
end