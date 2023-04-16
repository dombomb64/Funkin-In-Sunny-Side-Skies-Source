function onCreatePost()
    if botPlay then
        setProperty('botplayTxt.text', makeBotplayText());
    end
end

function makeBotplayText()
    local botplayText = 'BOTPLAY';
    if songName == 'Defeat' then
        botplayText = 'You realize this difficulty doesn\'t have the mechanic right';
    elseif songName == 'Defeat Unfair' then
        botplayText = 'Baby.';
    elseif songName == 'Get Back Here!' or songName == 'Get Back Here! Unfair' then
        botplayText = 'Y\'know what I\'ll give you a pass for this one';
    elseif songName == 'Zanta' then
        botplayText = 'Why does Elliot want Senpai dead anyway';
    elseif songName == 'Unfamiliar' then
        botplayText = 'You\'re using botplay. There aren\'t any mechanics. Why are you listening to this??';
    elseif songName == 'Monochrome' then
        botplayText = 'Dead song\n\n\n\nTake a bath in the lava';
    elseif songName == 'Wahaha!' then
        botplayText = 'Atistale is long dead';
    elseif songName == 'Toyboy' then
        botplayText = 'Toby';
    elseif songName == 'Dude' then
        botplayText = 'eheheh eheheheheh\nI just said Sans in Dialogueboxese';
    elseif songName == 'Toasty' then
        botplayText = 'your balls are toasty hot :flushed:';
    elseif songName == 'Challeng-Edd' or songName == 'Challeng-Edd Unfair' then
        botplayText = 'Hello fellow mentally Challeng-Edd individual';
    elseif songName == 'Stuck?' then
        botplayText = 'Fun Fact: This song was meant for v3.0 but i forgor :skull:';
    elseif songName == 'Cafe Mocha' then
        botplayText = 'Um, excuse me, what the actual funk do you think you\'re doing using botplay on this song? This is easier than Dad Battle.';
    elseif songName == 'Abuse' then
        botplayText = 'I will abuse you';
    elseif songName == 'Infected' then
        botplayText = 'among us!!';
    elseif songName == 'Eye Spy' then
        botplayText = 'I spy with my little eye something that\'s gonna be red all over';
    elseif songName == 'Cinnamon Roll' then
        botplayText = 'Do you ship Chadam';
    elseif songName == '~' then
        botplayText = 'I- I- You- ??????';
    elseif songName == 'Drippy' then
        botplayText = 'Your blood be really drippy rn :face_with_sunglasses:';
    elseif songName == 'Haybot' then
        botplayText = 'Worst chromatic scale ever';
    elseif songName == 'Haybot Unfair' then
        botplayText = 'Did you notice the icons';
    elseif songName == 'Giraffe' then
        botplayText = 'oh my god i am going to fc a giraffe';
    elseif songName == 'Alacrity' then
        botplayText = 'Did you get here from Get Back Here or freeplay';
    end
    return botplayText;
end