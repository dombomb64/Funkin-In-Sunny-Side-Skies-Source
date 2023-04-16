function onCreatePost()
	setPropertyFromClass('openfl.lib', 'application.window.title', 'Funkin\' in Sunny Side Skies');
	--[[addHaxeLibrary('DiscordRpc', 'discord_rpc');
	runHaxeCode(
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "863222024192262206",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
		});
	);]]--
	--[[addHaxeLibrary('AttachedText');
	runHaxeCode(
		//var text = new Alphabet(0, 0, 'barney burger', false);
		var text = new AttachedText('barney burger', 500, 0, false, 1);
		//text.screenCenter();
		//text.cameras = [game.camHUD];
		text.sprTracker = PlayState.dadGroup;
		game.add(text);
		//PlayState.timeBar.numDivisions = 10;

		//popUpScore();
		//boyfriend.healthColorArray[0] = 0;
		//reloadHealthBarColors();
		//healthBar.createFilledBar(FlxColor.fromRGB(0, 255, 0),
		//FlxColor.fromRGB(0, 255, 0));
		
		//healthBar.updateBar();
	);

	doTweenX('dadNyoom', 'dadGroup', getProperty('dadGroup.x') + 500, 1, 'linear');]]--
	changePresence('test details', 'test state', 'small image test', true, 50);
end

function onResume()
	setPropertyFromClass('openfl.lib', 'application.window.title', 'Funkin\' in Sunny Side Skies');
end

function onPause()
	setPropertyFromClass('openfl.lib', 'application.window.title', 'Friday Night Funkin\': Psych Engine');
	changePresence('test details', 'test state', 'small image test', true, 50);
	return FUNCTION_CONTINUE;
end

function onGameOverConfirm(retry)
	if not retry then
		setPropertyFromClass('openfl.lib', 'application.window.title', 'Friday Night Funkin\': Psych Engine');
	end
end

function onSongEnd()
	setPropertyFromClass('openfl.lib', 'application.window.title', 'Friday Night Funkin\': Psych Engine');
end