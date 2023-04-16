function onCreate()
    setProperty('flipHealthBar', true);
end

function onCreatePost()
    luaDebugMode = true;

    setProperty('dadGroup.x', 600);
    setProperty('dadGroup.y', 300);
    setProperty('boyfriendGroup.x', -510);
    setProperty('boyfriendGroup.y', 300);
    setProperty('dad.flipX', true);
    setProperty('boyfriend.flipX', false);

    setProperty('defaultCamZoom', 0.55);
    setProperty('camGame.zoom', 0.55);
    triggerEvent('Camera Follow Pos', '200', '700');
    setProperty('camFollowPos.x', 200);
    setProperty('camFollowPos.y', 700);

    if not middlescroll then
        swapStrums();
    end

    --[[addHaxeLibrary('FlxColor');
    --addHaxeLibrary('FlxBarFillDirection');
    runHaxeCode([
        //game.changeIcon('boyfriend', 'chaseInfected');
        game.changeIcon('boyfriend', 'adamCrewmate');
        game.changeIcon('dad', 'chaseInfected');

        //var p1Color = FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]);
		//var p2Color = FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]);
        //var p1Color = 0xFF7A41C4; // Chase
		//var p2Color = 0xFF4E6B37; // Adam
        //game.healthBar.createFilledBar(p1Color, p2Color);
        //game.healthBar.fillDirection = FlxBarFillDirection.RIGHT_TO_LEFT;
        game.healthBar.flipX = true;
    ]);]]--
    --setProperty('flipHealthBar', true);
    
    setProperty('dadHealthGain', 0.5);

    --close();
end

function onBeatHit()
    if curBeat == 28 then
        setProperty('dadGroup.x', 700);
        setProperty('dadGroup.y', 100);
        setProperty('boyfriendGroup.x', -700);
        setProperty('boyfriendGroup.y', 100);
        close();
    end
end

function swapStrums()
    local temp0 = getPropertyFromGroup('opponentStrums', 0, 'x');
    local temp1 = getPropertyFromGroup('opponentStrums', 1, 'x');
    local temp2 = getPropertyFromGroup('opponentStrums', 2, 'x');
    local temp3 = getPropertyFromGroup('opponentStrums', 3, 'x');
    local temp4 = getPropertyFromGroup('playerStrums', 0, 'x');
    local temp5 = getPropertyFromGroup('playerStrums', 1, 'x');
    local temp6 = getPropertyFromGroup('playerStrums', 2, 'x');
    local temp7 = getPropertyFromGroup('playerStrums', 3, 'x');

    noteTweenX('noteX0', 0, temp4, 0.01, 'linear');
    noteTweenX('noteX1', 1, temp5, 0.01, 'linear');
    noteTweenX('noteX2', 2, temp6, 0.01, 'linear');
    noteTweenX('noteX3', 3, temp7, 0.01, 'linear');
    noteTweenX('noteX4', 4, temp0, 0.01, 'linear');
    noteTweenX('noteX5', 5, temp1, 0.01, 'linear');
    noteTweenX('noteX6', 6, temp2, 0.01, 'linear');
    noteTweenX('noteX7', 7, temp3, 0.01, 'linear');
end