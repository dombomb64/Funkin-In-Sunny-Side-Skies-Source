--[[function onCreate()
    debugPrint('test');
end]]--

function onEvent(name, value1, value2)
    if name == 'Tween Zoom' then
        if tonumber(value1) > 0 and tonumber(value2) > 0 then
            doTweenZoom('camZoomTween', 'camGame', tonumber(value1), crochet / 1000 * tonumber(value2), 'quadInOut');
        end
    end
end