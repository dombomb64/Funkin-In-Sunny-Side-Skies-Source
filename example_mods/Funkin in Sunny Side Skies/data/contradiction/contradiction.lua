function onBeatHit()
    if curBeat == 68 or curBeat == 428 or curBeat == 588 then
        addLuaSprite('contradictionBg2', false);
        setProperty('defaultCamZoom', 0.6);
    elseif curBeat == 360 or curBeat == 556 or curBeat == 716 then
        removeLuaSprite('contradictionBg2', false);
        setProperty('defaultCamZoom', 0.75);
    end
end