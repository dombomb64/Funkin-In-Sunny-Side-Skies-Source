function onCreatePost()
    kristen();
end

function onBeatHit()
    if curBeat == 80 then
        setProperty('fogAlpha', 0);
    elseif curBeat == 176 then
        chase();
    elseif curBeat == 272 then
        adam();
    elseif curBeat == 448 then
        dude();
    elseif curBeat == 576 then
        elliot();
    elseif curBeat == 738 then
        setProperty('fogAlpha', 0.5);
        doTweenAlpha('bgFade', 'finaleBgElliot', 0, crochet / 1000, 'sineInOut');
        setProperty('finaleBgKristen.alpha', 0);
    elseif curBeat == 752 then
        doTweenAlpha('bgFade', 'finaleBgKristen', 1, crochet / 1000, 'sineInOut');
        setProperty('finaleBgElliot.alpha', 1);
        kristen();
    elseif curBeat == 784 then
        chase();
    elseif curBeat == 816 then
        adam();
    elseif curBeat == 848 then
        dude();
    elseif curBeat == 880 then
        elliot();
    elseif curBeat == 912 then
        kristen();
    elseif curBeat == 916 then
        chase(); -- And Adam
    elseif curBeat == 920 then
        elliot();
    elseif curBeat == 924 then
        dude();
    elseif curBeat == 928 then
        kristen();
    elseif curBeat == 932 then
        chase(); -- And Adam
    elseif curBeat == 936 then
        elliot();
    elseif curBeat == 940 then
        dude();
    elseif curBeat == 944 then
        kristen();
    elseif curBeat == 960 then
        elliot();
    elseif curBeat == 976 then
        chase(); -- And Adam
    elseif curBeat == 992 then
        dude();
    elseif curBeat == 1008 then
        kristen();
    elseif curBeat == 1009 then
        elliot();
    elseif curBeat == 1010 then
        chase(); -- And Adam
    elseif curBeat == 1011 then
        dude();
    elseif curBeat == 1012 then
        doTweenAlpha('bgFade', 'finaleBgDude', 0, crochet / 1000, 'sineInOut');
    end
end

function kristen()
    addLuaSprite('finaleBgKristen', false);
    removeLuaSprite('finaleBgChase', false);
    removeLuaSprite('finaleBgAdam1', false);
    removeLuaSprite('finaleBgAdam2', false);
    removeLuaSprite('finaleBgDude', false);
    removeLuaSprite('finaleBgElliot', false);

    setProperty('boyfriendGroup.x', 870);
    setProperty('boyfriendGroup.y', 102);
    setProperty('boyfriend.flipX', false);
    --setObjectOrder('boyfriendGroup', getObjectOrder('boyfriend2Group') + 1);
    setProperty('gfGroup.x', 400);
    setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', 0);
    setProperty('dadGroup.y', 102);
    setProperty('dad.flipX', true);
end

function chase()
    removeLuaSprite('finaleBgKristen', false);
    addLuaSprite('finaleBgChase', false);
    removeLuaSprite('finaleBgAdam1', false);
    removeLuaSprite('finaleBgAdam2', false);
    removeLuaSprite('finaleBgDude', false);
    removeLuaSprite('finaleBgElliot', false);

    setProperty('boyfriendGroup.x', 870);
    setProperty('boyfriendGroup.y', 100);
    setProperty('boyfriend.flipX', false);
    --setObjectOrder('boyfriendGroup', getObjectOrder('boyfriend2Group') + 1);
    setProperty('boyfriend2Group.x', 672);
    setProperty('boyfriend2Group.y', 60);
    setProperty('gfGroup.x', 400);
    setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', 0);
    setProperty('dadGroup.y', 100);
    setProperty('dad.flipX', true);
end

function adam()
    removeLuaSprite('finaleBgKristen', false);
    removeLuaSprite('finaleBgChase', false);
    addLuaSprite('finaleBgAdam1', false);
    addLuaSprite('finaleBgAdam2', false);
    setObjectOrder('finaleBgAdam2', getObjectOrder('dadGroup') + 1);
    removeLuaSprite('finaleBgDude', false);
    removeLuaSprite('finaleBgElliot', false);

    setProperty('boyfriendGroup.x', 120);
    setProperty('boyfriendGroup.y', 160);
    setProperty('boyfriend.flipX', true);
    --setObjectOrder('boyfriendGroup', getObjectOrder('finaleBgAdam2') + 1);
    setProperty('gfGroup.x', 300);
    setProperty('gfGroup.y', 60);
    setProperty('dadGroup.x', 1200);
    setProperty('dadGroup.y', 160);
    setProperty('dad.flipX', false);
end

function dude() -- And Jim!
    removeLuaSprite('finaleBgKristen', false);
    removeLuaSprite('finaleBgChase', false);
    removeLuaSprite('finaleBgAdam1', false);
    removeLuaSprite('finaleBgAdam2', false);
    addLuaSprite('finaleBgDude', false);
    removeLuaSprite('finaleBgElliot', false);

    setProperty('boyfriendGroup.x', 870);
    setProperty('boyfriendGroup.y', 102);
    setProperty('boyfriend.flipX', false);
    --setObjectOrder('boyfriendGroup', getObjectOrder('boyfriend2Group') + 1);
    setProperty('boyfriend2Group.x', 672);
    setProperty('boyfriend2Group.y', 60);
    setProperty('gfGroup.x', 400);
    setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', 0);
    setProperty('dadGroup.y', 102);
    setProperty('dad.flipX', true);
end

function elliot()
    removeLuaSprite('finaleBgKristen', false);
    removeLuaSprite('finaleBgChase', false);
    removeLuaSprite('finaleBgAdam1', false);
    removeLuaSprite('finaleBgAdam2', false);
    removeLuaSprite('finaleBgDude', false);
    addLuaSprite('finaleBgElliot', false);

    setProperty('boyfriendGroup.x', 870);
    setProperty('boyfriendGroup.y', 102);
    setProperty('boyfriend.flipX', false);
    --setObjectOrder('boyfriendGroup', getObjectOrder('boyfriend2Group') + 1);
    setProperty('gfGroup.x', 400);
    setProperty('gfGroup.y', 0);
    setProperty('dadGroup.x', 0);
    setProperty('dadGroup.y', 102);
    setProperty('dad.flipX', true);
end