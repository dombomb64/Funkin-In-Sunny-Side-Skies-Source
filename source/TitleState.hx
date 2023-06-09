package;

import lime.system.System;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];
	var introMarkdown:Array<String> = ['', ''];
	var usingSplash:Bool = false;
	var creepyBorder:FlxSprite = new FlxSprite();
	var creepyTween:FlxTween;

	var wackyImage:FlxSprite;

	#if TITLE_SCREEN_EASTER_EGG
	var easterEggKeys:Array<String> = [
		/*'SHADOW', 'RIVER', 'SHUBS', 'BBPANZU',*/ 'GASTER', 'FINALE', 'BALL', 'OVERCAST'
	];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	var easterEggString:String = null;
	#end

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	public static var updateVersion:String = '';

	var finaleActive:Bool = false;
	var finaleText:Alphabet;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Title Screen", null);
		#end

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		//trace(path, FileSystem.exists(path));

		/*#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end*/

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		// DEBUG BULLSHIT

		creepyBorder.loadGraphic(Paths.image('creepyBorder'));
		creepyBorder.scale.set(3, 3);
		//trace('creepy border x: ' + creepyBorder.x + ', creepy border y: ' + creepyBorder.y);
		creepyBorder.updateHitbox();
		creepyBorder.alpha = 0;
		swagShader = new ColorSwap();

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		ClientPrefs.loadPrefs();

		finaleActive = FlxG.save.data.finaleActive;
		if (FlxG.save.data.finaleActive == null) {
			finaleActive = false;
			FlxG.save.data.finaleActive = false;
		}

		if (finaleActive)
			curWacky = ['get ready', 'for the end'];
		else {
			//curWacky = FlxG.random.getObject(getIntroTextShit());
			generateIntroText();
		}

		#if CHECK_FOR_UPDATES
		if(ClientPrefs.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		#end

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		#if TITLE_SCREEN_EASTER_EGG
		if (FlxG.save.data.psychDevsEasterEgg == null) FlxG.save.data.psychDevsEasterEgg = ''; //Crash prevention
		switch(FlxG.save.data.psychDevsEasterEgg.toUpperCase())
		{
			case 'SHADOW':
				titleJSON.gfx += 210;
				titleJSON.gfy += 40;
			case 'RIVER':
				titleJSON.gfx += 100;
				titleJSON.gfy += 20;
			case 'SHUBS':
				titleJSON.gfx += 160;
				titleJSON.gfy -= 10;
			case 'BBPANZU':
				titleJSON.gfx += 45;
				titleJSON.gfy += 100;
		}
		#end

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			if (!DiscordClient.isInitialized)
			{
				DiscordClient.initialize();
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				});
			}
			#end

			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite; // I mean fan-suggested illustration
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// //music.loadStream(Paths.music('sunnySide'));
			// VisualsUISubState.playMenuMusic();
			// FlxG.sound.list.add(music);
			// music.play();
			
			if(FlxG.sound.music == null) {
				if (finaleActive) {
					FlxG.sound.playMusic(Paths.music('shadySide'), 0);
				}
				else {
					//FlxG.sound.playMusic(Paths.music('sunnySide'), 0);
					ClientPrefs.playMenuMusic(ClientPrefs.menuMusic, 0);
					//if (FlxG.sound.music != null)
						//FlxG.sound.music.volume == 0;
				}
			}
		}

		if (finaleActive)
			Conductor.changeBPM(80);
		else
			Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();

		if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.length > 0 && titleJSON.backgroundSprite != "none"){
			bg.loadGraphic(Paths.image(titleJSON.backgroundSprite));
		}else{
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}

		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');

		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);

		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		if(easterEgg == null) easterEgg = ''; //html5 fix

		switch(easterEgg.toUpperCase())
		{
			#if TITLE_SCREEN_EASTER_EGG
			case 'SHADOW':
				gfDance.frames = Paths.getSparrowAtlas('ShadowBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shadow Title Bump', 24);
				gfDance.animation.addByPrefix('danceRight', 'Shadow Title Bump', 24);
			case 'RIVER':
				gfDance.frames = Paths.getSparrowAtlas('RiverBump');
				gfDance.animation.addByIndices('danceLeft', 'River Title Bump', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'River Title Bump', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			case 'SHUBS':
				gfDance.frames = Paths.getSparrowAtlas('ShubBump');
				gfDance.animation.addByPrefix('danceLeft', 'Shub Title Bump', 24, false);
				gfDance.animation.addByPrefix('danceRight', 'Shub Title Bump', 24, false);
			case 'BBPANZU':
				gfDance.frames = Paths.getSparrowAtlas('BBBump');
				gfDance.animation.addByIndices('danceLeft', 'BB Title Bump', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'BB Title Bump', [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], "", 24, false);
			#end

			default:
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
			//EDIT THIS ONE IF YOU'RE MAKING A SOURCE CODE MOD!!!!
				gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
				gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		}
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;

		add(gfDance);
		gfDance.shader = swagShader.shader;
		add(logoBl);
		logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "assets/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else

		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			newTitle = false;
			
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		finaleText = new Alphabet(0, 0, 'Press Enter\nfor an\nOvercast Overview', false, 'alphabetWhite');
		//finaleText.scaleX = 0.8;
		finaleText.setAlignmentFromString('CENTER');
		finaleText.screenCenter(Y);
		finaleText.x += FlxG.width / 2;
		finaleText.y -= 60;
		add(finaleText);

		if (finaleActive) {
			gfDance.visible = false;
			logoBl.visible = false;
			titleText.visible = false;
		}
		else
			finaleText.visible = false;

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52 - 35).loadGraphic(Paths.image('chaseWink'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8 * 3));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		//ngSpr.antialiasing = ClientPrefs.globalAntialiasing;
		ngSpr.antialiasing = false;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		add(creepyBorder);

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			var tempText = i.replace('\x0d', '').split('--'); // Carriage Return??
			//trace(tempText[0].length);
			if (tempText.length > 1 || tempText[0].length > 0)
			{
				//trace(tempText[0].charCodeAt(0));
				swagGoodArray.push(tempText);
			}
				
		}

		return swagGoodArray;
	}

	/**
		Generates new text for `curWacky` and `introMarkdown`.
	**/
	function generateIntroText():Void
	{
		curWacky = FlxG.random.getObject(getIntroTextShit());
		for (i in 0...curWacky.length)
		{
			introMarkdown[i] = '';
			var tempMarkdown = curWacky[i].substr(0, curWacky[i].indexOf('-', 1) + 1);
			//trace('tempMarkdown: ' + tempMarkdown);
			switch (tempMarkdown)
			{
				case '-=-' | '-==-' | '-===-' | '-====-' | '-=====-' | '-======-' | '-=======-' | '-========-' | '-=========-':
					//trace('curWacky[' + i + '] attempted markdown for string ' + curWacky[i] + ' is ' + tempMarkdown);
					introMarkdown[i] = tempMarkdown;
					curWacky[i] = curWacky[i].substr(tempMarkdown.length);
			}
		}
	}

	/**
		Check if the provided markdown is either '-===-' (Mute Music) or '-====-' (Mute Music With Red Border) and follows their corresponding instructions.
		Used one beat before the text shows up for proper timing as well as right before the title shows up so that it goes back to normal.
	**/
	function checkMuteMarkdown(markdown:String)
	{
		if (markdown == '-===-' || markdown == '-====-') {
			FlxG.sound.music.volume = 0;
			if (markdown == '-====-') {
				creepyTween = FlxTween.tween(creepyBorder, {alpha: 0.25}, 2);
			}
			else if (creepyTween != null) {
				creepyTween.cancel();
				creepyBorder.alpha = 0;
			}
		}
		else {
			FlxG.sound.music.volume = 1;
			if (creepyTween != null) {
				creepyTween.cancel();
				creepyBorder.alpha = 0;
			}
		}
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				if (!finaleActive)
					FlxG.sound.play(Paths.sound('confirmMenu' + ClientPrefs.menuSoundSuffix), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate) {
						MusicBeatState.switchState(new OutdatedState());
					} 
					else if (finaleActive) {
						persistentUpdate = false;
						var songLowercase:String = 'overcast-overview';
						CoolUtil.difficulties = ['Hard'];
						var poop:String = Highscore.formatSong(songLowercase, 0);
						/*#if MODS_ALLOWED
						if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
						#else
						if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
						#end
							poop = songLowercase;
							curDifficulty = 1;
							trace('Couldnt find file');
						}*/
						//trace(poop);

						PlayState.SONG = Song.loadFromJson(poop, songLowercase);
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 0;

						trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
						
						FlxG.sound.music.volume = 0;
						//FlxG.sound.play(Paths.sound('playFreeplay' + ClientPrefs.menuSoundSuffix));
						FlxG.sound.music.stop();
						
						LoadingState.loadAndSwitchState(new PlayState());
					}
					else {
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			#if TITLE_SCREEN_EASTER_EGG
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE) {
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if (keyPressed == FlxKey.BACKSPACE) { // Lol
					easterEggKeysBuffer = easterEggKeysBuffer.substring(0, easterEggKeysBuffer.length - 1);
				}
				else if (allowedKeys.contains(keyName)) {
					easterEggKeysBuffer += keyName;
					if(easterEggKeysBuffer.length >= 32) easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					//trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys) {
						var word:String = wordRaw.toUpperCase(); // just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word)) {
							//trace('YOOO! ' + word);
							if (word == 'GASTER')
								System.exit(0);
							else if (word == 'BALL') {
								FlxG.sound.music.fadeOut(0.25);
								if(FreeplayState.vocals != null)
								{
									FreeplayState.vocals.fadeOut(0.25);
								}
								FlxG.sound.play(Paths.sound('ballJingle'), 1, false, null, true, function() {
									FlxG.sound.music.fadeIn();
									if(FreeplayState.vocals != null)
									{
										FreeplayState.vocals.fadeIn();
									}
								});
							}
							else if (word == 'OVERCAST') { // retrigger prologue
								FlxG.save.data.finaleCompleted = false;
							}

							if (FlxG.save.data.psychDevsEasterEgg == word) {
								FlxG.save.data.psychDevsEasterEgg = '';
								easterEggString = '';
							}
							else {
								if (word != 'FINALE' && word != 'GASTER' && word != 'BALL' && word != 'OVERCAST')
									FlxG.save.data.psychDevsEasterEgg = word;
								easterEggString = word;
							}
							FlxG.save.flush();

							if (word != 'GASTER' && word != 'BALL')
								FlxG.sound.play(Paths.sound('ToggleJingle'));

							if (word != 'FINALE' && word != 'GASTER' && word != 'BALL' && word != 'OVERCAST') {
								
								var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
								black.alpha = 0;
								add(black);

								FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
									function(twn:FlxTween) {
										FlxTransitionableState.skipNextTransIn = true;
										FlxTransitionableState.skipNextTransOut = true;
										MusicBeatState.switchState(new TitleState());
									}
								});
								FlxG.sound.music.fadeOut();
								if(FreeplayState.vocals != null)
								{
									FreeplayState.vocals.fadeOut();
								}
								closedState = true;
								transitioning = true;
								playJingle = true;
							}
							else if (word == 'FINALE') {
								/*var finaleActive = FlxG.save.data.finaleActive;
								if (finaleActive == null) {
									finaleActive = false;
									FlxG.save.data.finaleActive = false;
								}*/
								if (finaleActive) {
									FlxG.save.data.finaleActive = false;
									//FlxG.resetGame();
									initialized = false;
									closedState = false;
									FlxG.sound.music.fadeOut(0.3);
									if(FreeplayState.vocals != null)
									{
										FreeplayState.vocals.fadeOut(0.3);
										FreeplayState.vocals = null;
									}
									//FlxG.save.data.finaleActive = true;
									FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
								}
								else {
									MusicBeatState.switchState(new FinaleDialogueState());
									FlxG.sound.music.fadeOut();
									if(FreeplayState.vocals != null)
									{
										FreeplayState.vocals.fadeOut();
									}
									closedState = true;
								}
							}
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
			sickBeats = 18;
		}
		
		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}
		if(controls.RESET && FlxG.keys.pressed.SHIFT && initialized) // Pressing this key will show a new splash
		{
			remove(credGroup);
			remove(textGroup);
			sickBeats = 9;
			skippedIntro = false;
			//initialized = false;
			closedState = false;
			deleteCoolText();
			if (ClientPrefs.flashing) FlxG.camera.flash(FlxColor.WHITE, 0.25, null, true);
			//credGroup.kill();
			//credGroup = new FlxGroup();
			add(credGroup);
			add(textGroup);
			//curWacky = FlxG.random.getObject(getIntroTextShit());
			generateIntroText();
			checkMuteMarkdown(introMarkdown[0]);
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0, ?markdown:String = '')
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, 'alphabet', true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
				money.markdown = markdown;
				
				//if (textArray[i].length > 20) {
				if (money.width > FlxG.camera.width - 100) { // IDK WHAT I DID BUT IT WORKS
					//trace(money.x + ', ' + money.y);
					//money.scale.set(1 / ((textArray[i].length - 20) * 0.1), 1 / ((textArray[i].length - 20) * 0.1));
					//money.scaleX = 1 / ((textArray[i].length - 20) * 0.1);
					//money.scaleY = 1 / ((textArray[i].length - 20) * 0.1);
					var tempScale = 1 / (((money.width - (FlxG.camera.width - 100)) * 0.005 + 6) * 0.17);
					money.scaleX = tempScale;
					money.scaleY = tempScale;
					//money.scaleX = 0.5;
					//money.kerning = (textArray[i].length - 20) * -0.9;
					//money.kerning = (money.width / (FlxG.width - 100 - 50)) * -13;
					/*money.kerning = (money.width - FlxG.width - 100) * -0.04;
					money.kerning = Math.max(money.kerning, -40);
					money.kerningScale = true;
					money.text = money.text; // Refresh the spacing*/
					//money.offset.x = -money.kerning / 2;
					money.setAlignmentFromString('introText');
					//money.setAlignmentFromString('left');
					money.updateHitbox();
					money.text = money.text; // Refresh the spacing
					money.screenCenter(X);
					//money.y = (i * 60) + 200 + offset;
					//trace(money.x + ', ' + money.y);
					//trace(money.kerning);
					//trace(money.x + ', ' + (money.x + money.width) + ', ' + money.findMaxX());
					money.x += money.width / 200;
					
					/*var tempScale = 1 / (((money.width - (FlxG.camera.width - 100)) * 0.005 + 6) * 0.17);
					//var tempScale = 0.8;
					money.scaleX = tempScale;
					money.scaleY = tempScale;
					//money.updateHitbox();
					//money.updateHitboxNoCenter();
					//money.centerOrigin();
					//money.screenCenter(X);
					money.x -= money.origin.x;*/
				}
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0, ?markdown:String = '')
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, 'alphabet', true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
			coolText.markdown = markdown;

			//if (text.length > 20) {
			if (coolText.width > FlxG.camera.width - 100) { // IDK WHAT I DID BUT IT WORKS
				//trace(coolText.x + ', ' + coolText.y);
				//coolText.scale.set(1 / ((text.length - 20) * 0.1), 1 / ((text.length - 20) * 0.1));
				//coolText.scaleX = 1 / ((text.length - 20) * 0.1);
				//coolText.scaleY = 1 / ((text.length - 20) * 0.1);
				var tempScale = 1 / (((coolText.width - (FlxG.camera.width - 100)) * 0.005 + 6) * 0.17);
				coolText.scaleX = tempScale;
				coolText.scaleY = tempScale;
				//coolText.scaleX = 0.5;
				//coolText.kerning = (text.length - 20) * -0.9;
				//coolText.kerning = (coolText.width / (FlxG.width - 100 - 50)) * -13;
				/*coolText.kerning = (coolText.width - FlxG.width - 100) * -0.04;
				coolText.kerning = Math.max(coolText.kerning, -40);
				coolText.kerningScale = true;
				coolText.text = coolText.text; // Refresh the spacing*/
				//coolText.offset.x = -coolText.kerning / 2;
				coolText.setAlignmentFromString('introText');
				//coolText.setAlignmentFromString('left');
				coolText.updateHitbox();
				coolText.text = coolText.text; // Refresh the spacing
				coolText.screenCenter(X);
				//coolText.y = (textGroup.length * 60) + 200 + offset;
				//trace(coolText.x + ', ' + coolText.y);
				//trace(coolText.kerning);
				//trace(coolText.x + ', ' + (coolText.x + coolText.width) + ', ' + coolText.findMaxX());
				coolText.x += coolText.width / 200;
				
				/*var tempScale = 1 / (((coolText.width - (FlxG.camera.width - 100)) * 0.005 + 6) * 0.17);
				//var tempScale = 0.8;
				coolText.scaleX = tempScale;
				coolText.scaleY = tempScale;
				//coolText.updateHitbox();
				//coolText.updateHitboxNoCenter();
				//coolText.centerOrigin();
				//coolText.screenCenter(X);
				coolText.x -= coolText.origin.x;*/
			}
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();
		//trace('Beat: ' + curBeat);

		if(logoBl != null)
			logoBl.animation.play('bump', true);

		if(gfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if(!closedState) {
			//sickBeats++;
			switch (sickBeats)
			{
				case 0:
					//FlxG.sound.music.stop();
					//FlxG.sound.playMusic(Paths.music('sunnySide'), 0);
					if (finaleActive) {
						FlxG.sound.playMusic(Paths.music('shadySide'), 0);
					}
					else {
						ClientPrefs.playMenuMusic(ClientPrefs.menuMusic, 0);
					}
					if (FlxG.sound.music != null)
					{
						//FlxG.sound.music.volume == 0;
						FlxG.sound.music.fadeIn(4, 0, 0.7);
					}
				case 2:
					/*#if PSYCH_WATERMARKS
					createCoolText(['Psych Engine by'], 15);
					#else
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
					#end*/
					createCoolText(['Presenting']);
				// credTextShit.visible = true;
				case 4:
					/*#if PSYCH_WATERMARKS
					addMoreText('Shadow Mario', 15);
					addMoreText('RiverOaken', 15);
					addMoreText('shubs', 15);
					#else
					addMoreText('present');
					#end*/
					addMoreText('A mod about');
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 5:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 6:
					/*#if PSYCH_WATERMARKS
					createCoolText(['Not associated', 'with'], -40);
					#else
					createCoolText(['In association', 'with'], -40);
					#end*/
					createCoolText(['Sunny Side Skies']);
				case 8:
					//addMoreText('newgrounds', -40);
					addMoreText('And more');
					if (!finaleActive)
						ngSpr.visible = true;
				// credTextShit.text += '\nNewgrounds';
				case 9:
					checkMuteMarkdown(introMarkdown[0]);
					deleteCoolText();
					if (!finaleActive)
						ngSpr.visible = false;
				// credTextShit.visible = false;

				// credTextShit.text = 'Shoutouts Tom Fulp';
				// credTextShit.screenCenter();
				case 10:
					usingSplash = true;
					createCoolText([curWacky[0]], 0, introMarkdown[0]);
				// credTextShit.visible = true;
				case 11:
					checkMuteMarkdown(introMarkdown[1]);
				case 12:
					addMoreText(curWacky[1], 0, introMarkdown[1]);
				// credTextShit.text += '\nlmao';
				case 13:
					checkMuteMarkdown('');
					usingSplash = false;
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();
				case 14:
					addMoreText('Funkin\'');
				// credTextShit.visible = true;
				case 15:
					addMoreText('in');
				// credTextShit.text += '\nNight';
				case 16:
					addMoreText('Sunny Side Skies');
				// credTextShit.text += '\nFunkin';
				case 17:
					skipIntro();
			}
			sickBeats++; // Moved to after because of a weird bug
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			#if desktop
			// This is so that it doesn't say "Booting Game" when you reach the title screen
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Title Screen", null);
			#end
			deleteCoolText();
			if (playJingle) //Ignore deez
			{
				var easteregg:String = easterEggString;
				if (easteregg == null) easteregg = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();

				var sound:FlxSound = null;
				switch(easteregg)
				{
					case 'RIVER':
						sound = FlxG.sound.play(Paths.sound('JingleRiver'));
					case 'SHUBS':
						sound = FlxG.sound.play(Paths.sound('JingleShubs'));
					case 'SHADOW':
						FlxG.sound.play(Paths.sound('JingleShadow'));
					case 'BBPANZU':
						sound = FlxG.sound.play(Paths.sound('JingleBB'));
					case 'GASTER':
						System.exit(0);
					case 'FINALE':
						MusicBeatState.switchState(new FinaleDialogueState());
						closedState = true;

					default: //Go back to normal ugly ass boring GF
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 2);
						skippedIntro = true;
						playJingle = false;

						if (finaleActive) {
							FlxG.sound.playMusic(Paths.music('shadySide'), 0);
						}
						else {
							//FlxG.sound.playMusic(Paths.music('sunnySide'), 0);
							ClientPrefs.playMenuMusic(ClientPrefs.menuMusic, 0); 
						}

						if (FlxG.sound.music != null)
						{
							FlxG.sound.music.volume == 0;
							FlxG.sound.music.fadeIn(4, 0, 0.7);
						}
						return;
				}

				transitioning = true;
				if (easteregg == 'SHADOW')
				{
					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 0.6);
						transitioning = false;
					});
				}
				else if (easteregg != 'FINALE')
				{
					remove(ngSpr);
					remove(credGroup);
					FlxG.camera.flash(FlxColor.WHITE, 3);
					sound.onComplete = function() {
						if (finaleActive) {
							FlxG.sound.playMusic(Paths.music('shadySide'), 0);
						}
						else {
							//FlxG.sound.playMusic(Paths.music('sunnySide'), 0);
							ClientPrefs.playMenuMusic(ClientPrefs.menuMusic, 0);
						}
						if (FlxG.sound.music != null)
						{
							FlxG.sound.music.volume == 0;
							FlxG.sound.music.fadeIn(4, 0, 0.7);
						}
						transitioning = false;
					};
				}
				playJingle = false;
			}
			else //Default! Edit this one!!
			{
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);

				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();
				#if TITLE_SCREEN_EASTER_EGG
				if(easteregg == 'SHADOW')
				{
					FlxG.sound.music.fadeOut();
					if(FreeplayState.vocals != null)
					{
						FreeplayState.vocals.fadeOut();
					}
				}
				#end
			}
			skippedIntro = true;
		}
	}
}
