function onCreate()
    addCharacterToList('noGf', 'boyfriend');
end

function onSongStart()
    --debugPrint(getProperty('songLength'));
    setProperty('songLength', 77714); -- To put it in the words of Mario, "Lucky!"
end

function onBeatHit()
    if curBeat == 168 then
        setProperty('oceanBgNutshell3a.alpha', 0);
        setProperty('oceanBgNutshell4a.alpha', 0);
        triggerEvent('Change Character', 'boyfriend', 'noGf');
    elseif curBeat >= 172 then
        runHaxeCode([[
            if (game.dad.animation.curAnim != null)
                game.dad.animation.curAnim.finish();
        ]]);
    end
end