-- Insert laggy ahh code to get if the note skin changed here
--runStyleScripts();

function onEvent(name, arg1, arg2)
    if name == 'Change Character' then
        runCharacterScripts();
    end
end

function runCharacterScripts()
    addLuaScript('scripts/gfNoScroll');
    addLuaScript('scripts/pixelIcons');
end

function runStyleScripts()
    addLuaScript('scripts/hurtNoteSkin');
    addLuaScript('scripts/pixelArrows');
    addLuaScript('scripts/stepmania');
end