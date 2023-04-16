--[[function onCreate()
	setProperty('skipCountdown', true);
end]]--

function onCreatePost()
	--local images = {'18PlusMarioParty', 'adamZone', 'chaseGuitar', 'didYouJustInstalledFnaf', 'farted', 'faxDoe', 'findChase', 'garello', 'grandpaDemon', 'grassAtACheapPrice', 'martApproval', 'megaHotSmall', 'nothingsInside', 'notificationsOff', 'nucles', 'pee', 'profanityFilter', 'spamton', 'stopStaringItsRude', 'theTimeStartsNow', 'whyDoCatsPurr', 'yameteKudasai'};
	--local images = {'adamZone', 'didYouJustInstalledFnaf', 'findChase', 'grassAtACheapPrice', 'martApproval', 'megaHotSmall', 'pee', 'profanityFilter', 'theTimeStartsNow', 'whyDoCatsPurr', 'yameteKudasai'};
	--local test = {'hi'};

	--[[for k, v in ipairs(images)
		makeLuaSprite(v, v, 0, 0);
	end]]--

	--local random = math.randomseed()

	--[[runHaxeCode(
		var text = new Alphabet(0, 0, 'barney burger', false);
		//var text = new AttachedText('barney burger', 500, 0, true, 1);
		//text.screenCenter();
		text.cameras = [game.camHUD];
		//text.sprTracker = MusicBeatState.curState.dadGroup;

		text.changeText(Std.string(text.width));
		game.add(text);
		//PlayState.timeBar.numDivisions = 10;

		//popUpScore();
		//boyfriend.healthColorArray[0] = 0;
		//reloadHealthBarColors();
		//healthBar.createFilledBar(FlxColor.fromRGB(0, 255, 0),
		//FlxColor.fromRGB(0, 255, 0));
		
		//healthBar.updateBar();
	);]]--

	--debugPrint((getProperty('camHUD.width') - 100) / getProperty('text.frameWidth'));

	local name = 'adamKnockPlease';
	if difficulty == 0 then
		name = 'adamKnockPlease';
	elseif difficulty == 1 then
		name = 'didYouJustInstalledFnaf';
	elseif difficulty == 2 then
		name = 'findChase';
	elseif difficulty == 3 then
		name = 'grassAtACheapPrice';
	elseif difficulty == 4 then
		name = 'martApproval';
	elseif difficulty == 5 then
		name = 'megaHotSmall';
	elseif difficulty == 6 then
		name = 'pee';
	elseif difficulty == 7 then
		name = 'profanityFilter';
	elseif difficulty == 8 then
		name = 'theTimeStartsNow';
	elseif difficulty == 9 then
		name = 'whyDoCatsPurr';
	elseif difficulty == 10 then
		name = 'yameteKudasai';
	end

	setProperty('galleryImageName', name); -- For Discord Rich Presence

	--name = images[1];

	--debugPrint(name, images.length);
	--makeLuaSprite('image', name, 0, 0);
	--debugPrint(name, ' ', getProperty('image.frameHeight'));

	--debugPrint(getProperty('camOther.width'));

	--debugPrint(images);

	makeLuaSprite('black', 'stages/blackvoid', 0, 0);
	makeLuaSprite('image', name, 0, 0);

	--debugPrint(getProperty('image.frameWidth'));

	setProperty('image.x', getProperty('camOther.width') / 2 - getProperty('image.width') / 2);
	--setProperty('image.y', (getProperty('camOther.height') / 2 - getProperty('image.height') / 2) + 20);
	setProperty('image.y', getProperty('camOther.height') / 2 - getProperty('image.height') / 2);
	setProperty('black.x', getProperty('camOther.width') / 2 - getProperty('black.width') / 2);
	setProperty('black.y', getProperty('camOther.height') / 2 - getProperty('black.height') / 2);

	setProperty('black.scale.x', 3);
	setProperty('black.scale.y', 3);

	local scaleX = (getProperty('camOther.width') - 100) / getProperty('image.width');
	local scaleY = (getProperty('camOther.height') - 100) / getProperty('image.height');

	setProperty('image.scale.x', math.min(scaleX, scaleY));
	setProperty('image.scale.y', math.min(scaleX, scaleY));

	setObjectCamera('black', 'hud');
	setObjectCamera('image', 'hud');

	addLuaSprite('black', true);
	addLuaSprite('image', true);

	--setObjectOrder('timeBarBG', getObjectOrder('image') + 1);
	--setObjectOrder('timeBar', getObjectOrder('image') + 2);
	--setObjectOrder('timeTxt', getObjectOrder('image') + 3);

	if getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Song Name' then
		--setProperty('timeTxt.text', 'Comedic Bone');
		setProperty('timeTxt.text', name .. '.png');
	end
end

function onStartCountdown()
	--setProperty('startedCountdown', true);
	return Function_Stop;
end