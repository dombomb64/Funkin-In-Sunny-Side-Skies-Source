-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)

--local songName = '';
--local songCredits = '';

function onCreate()
    --[[runHaxeCode(
        var songTitle = new Alphabet(0, 0, 'barney burger', true);
		songTitle.screenCenter();
		songTitle.cameras = [game.camHUD];
		game.add(songTitle);
		songTitle.changeText(FlxG.state.SONG.swagSong);
    );]]--

    -- The credits need to be checked for if they're empty in which all the text will be hidden (Used for the secret image viewer)
    local creditsText = makeCredits();

    -- Make flavor text
    makeLuaText('nowPlaying', 'Now Playing:', 1000, 0, 50);
    setTextSize('nowPlaying', 30);
    setTextAlignment('nowPlaying', 'center');
    screenCenter('nowPlaying', 'x');
    setObjectCamera('nowPlaying', 'other');
    if creditsText == '' then
        setTextString('nowPlaying', '');
    end
    addLuaText('nowPlaying', true);
    
    -- Put brackets around the difficulty if it's in the song name
    local songTitle = string.gsub(songName, 'Unfair', '[Unfair]');

    -- Make title
    makeLuaText('songTitle', 'a string that is so long you would not believe hhhhhhhhhhhhhhhhhhhhhhhh', 1000, 0, 75);
    setProperty('songTitle.autoSize', true);
    setProperty('songTitle.wordWrap', false);
    setTextAlignment('songTitle', 'center');
    setTextString('songTitle', songTitle);
    resizeText();
    screenCenter('songTitle', 'x');
    setObjectCamera('songTitle', 'other');
    if creditsText == '' then
        setTextString('songTitle', '');
    end
    addLuaText('songTitle', true);

    -- Make credits
    makeLuaText('creditsTitle', '[CREDITS MISSING]', 1000, 0, 150);
    setTextSize('creditsTitle', 30);
    setTextAlignment('creditsTitle', 'center');
    setTextString('creditsTitle', creditsText);
    screenCenter('creditsTitle', 'x');
    setObjectCamera('creditsTitle', 'other');
    addLuaText('creditsTitle', true);

    -- Reposition for downscroll
    if downscroll then
        local downscrollOffset = 530 - getProperty('creditsTitle.height');
        setProperty('nowPlaying.y', 50 + downscrollOffset);
        setProperty('songTitle.y', 75 + downscrollOffset);
        setProperty('creditsTitle.y', 150 + downscrollOffset);
    end

    -- Fade out
    doTweenAlpha('nowPlayingFade', 'nowPlaying', 0, 3, 'circInOut');
    doTweenAlpha('songTitleFade', 'songTitle', 0, 3, 'circInOut');
    doTweenAlpha('creditsTitleFade', 'creditsTitle', 0, 3, 'circInOut');

    -- Close the script
    close(true);
    --debugPrint('test');
end

--[[function onUpdate(elapsed)
    resizeText();
end]]--

function resizeText()
    --setTextSize('songTitle', 75);
    local textSize = 75;
    if getProperty('songTitle.fieldWidth') > 1000 then
        textSize = 75 / (getProperty('songTitle.fieldWidth') / 1000);
    end
    --local textSize = math.min(75, 10 / getProperty('songTitle.fieldWidth'));
    --debugPrint(textSize);
    --debugPrint(textSize, ', ', 10 / getProperty('songTitle.fieldWidth'));
    setTextSize('songTitle', textSize);
    --setProperty('songTitle.fieldWidth', 100);
    --debugPrint(getProperty('songTitle.width'));
end

function makeCredits()
    local credits = '[CREDITS MISSING]';
    if ((songName == 'Best Friend' or songName == 'Blitz' or songName == 'Polar Opposite') or (songName == 'Rematch' or songName == 'Get Back Here!' or songName == 'Free Time') or (songName == 'Unfamiliar' or songName == 'Raveyard') or (songName == 'Dude' or songName == 'Toasty') or (songName == 'Cafe Mocha' or songName == 'Extra Whip' or songName == '$5.87' or songName == 'Infected' or songName == 'Eye Spy' or songName == 'Cinnamon Roll')) or (songName == 'Best Friend Unfair' or songName == 'Blitz Unfair' or songName == 'Polar Opposite Unfair') or (songName == 'Rematch Unfair' or songName == 'Get Back Here! Unfair' or songName == 'Free Time Unfair') or (songName == 'Haybot' or songName == 'Haybot Unfair' or songName == 'Giraffe') then
        credits = 'By dombomb64';
    elseif songName == 'Defeat' or songName == 'Defeat Unfair' then
        credits = 'Original by Rareblin\nCover and chart by dombomb64';
    elseif songName == 'Game Over' then
        credits = 'Original by Saster and kiwiquest\nCover and chart by dombomb64';
    elseif songName == 'Zanta' or songName == 'Toyboy' then
        credits = 'Original by bb-panzu\nCover and chart by dombomb64';
    elseif songName == 'Monochrome' then
        credits = 'Original by Adam McHummus\nCover and chart by dombomb64';
    elseif songName == 'Wahaha!' then
        credits = 'Original (Nyeh Heh Heh!) by Toby Fox\nAdaptation and chart by dombomb64';
    elseif songName == 'Cross-Comic Clash' then
        credits = 'Original (Cross-Console Clash) by B.O. Eszett\nCover and chart by dombomb64';
    elseif songName == 'Challeng-Edd' or songName == 'Challeng-Edd Unfair' then
        credits = 'Original by philiplol\nCover and chart by dombomb64';
    elseif songName == 'Stuck?' then
        credits = 'By dombomb64\nWith Leitmotifs from Plants vs Zombies and Super Stickman Golf 2';
    elseif songName == 'Abuse' then
        credits = 'Original by car\nCover and chart by dombomb64';
    elseif songName == 'Fatality' then
        credits = 'Original by Saster\nCover and chart by dombomb64';
    elseif songName == '~' then
        credits = '';
    elseif songName == 'Drippy' then
        credits = 'Original (Defeat) by Rareblin\nAdaptation and chart by dombomb64';
    elseif songName == 'Similarities' then
        credits = 'Original (Defeat) by Rareblin\nAdaptation 1 (Defeat, But I Remade It... sorta.) by JomJom412\nAdaptation 2 (Defeat but it\'s the Angry Birds Theme), mashup, and chart by dombomb64';
    elseif songName == 'Alacrity' then
        credits = 'Composed by dombomb64\nCharted by somebaconguy\nChart modified by dombomb64';
    end
    return credits;
end