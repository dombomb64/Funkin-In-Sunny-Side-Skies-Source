package;

import FlipnoteDither.FlipnoteDitherShader;
import flixel.effects.FlxFlicker;
import openfl.display.BitmapData;
import flixel.system.FlxAssets.FlxShader;
import MosaicEffect.MosaicShader;
import HealthIcon.CoolIcon;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import flixel.animation.FlxAnimationController;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
import vlc.MP4Handler;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	/*public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];*/
	public static var ratingStuff:Array<Dynamic> = [
		['Boo, You Stink!', 0.2], //From 0% to 19%
		['Garbage', 0.4], //From 20% to 39%
		['=_= ...', 0.5], //From 40% to 49%
		['Black Coffee', 0.6], //From 50% to 59%
		['Eh.', 0.69], //From 60% to 68%
		//['Chapter 6 ᓂ‿ᓂ', 0.7], //69%
		['Chapter 6 :lenny:', 0.7], //69%
		['Chase Approved', 0.8], //From 70% to 79%
		['Surprisingly Competitive', 0.9], //From 80% to 89%
		['Amazing!! :D', 1], //From 90% to 99%
		['Basically All of It', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	// event variables
	private var isCameraOnForcedPos:Bool = false; // "More like event VARIABLE!! HAHA GOTY!" -SMM2 players who complained about the empty game style slot, probably

	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var boyfriend2Map:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var dad2Map:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	public var infoTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var infoTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var boyfriend2Map:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var dad2Map:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	public var modchartTexts:Map<String, ModchartText> = new Map();
	public var modchartSaves:Map<String, FlxSave> = new Map();
	public var infoTweens:Map<String, FlxTween> = new Map();
	public var infoTimers:Map<String, FlxTimer> = new Map();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var BF2_X:Float = 770;
	public var BF2_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var DAD2_X:Float = 100;
	public var DAD2_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var playbackRate(default, set):Float = 1;

	public var boyfriendGroup:FlxSpriteGroup;
	public var boyfriend2Group:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var dad2Group:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	//public static var SONG:SwagSong = Song.loadFromJson('tutorial');
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var spawnTime:Float = 2000;

	public var vocals:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;

	public var dad2:Character = null;
	public var boyfriend2:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;
	public var camHUDPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	public var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	public var healthBarDither:AttachedBar;
	public var healthBarOverlay:AttachedSprite;
	var songPercent:Float = 0;

	public var isNutshell:Bool = false;
	public var isFlipnote:Bool = false;
	public var handDrawn:Bool = false;
	public var isStepmania:Bool = false;
	public var stepmaniaBg:FlxSprite;

	public var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	public var timeBarOverlay:AttachedSprite;

	public var ratingsData:Array<Rating> = [];
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;
	public var skippingSong:Bool = false;
	public var skipAchShown:Bool = true;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;
	public var dadHealthGain:Float = 0; // Actually a multiplier

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP1b:HealthIcon;
	public var iconP2:HealthIcon;
	public var iconP2b:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['i LOVE cum!!', 'nom nom nom'];
	var dialogueJson:DialogueFile = null;

	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleSmokes:FlxSpriteGroup;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:FlxSprite;
	var phillyWindowEvent:BGSprite;
	var trainSound:FlxSound;

	var phillyGlowGradient:PhillyGlow.PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlow.PhillyGlowParticle>;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	var tankWatchtower:BGSprite;
	var tankGround:BGSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>(); // Is now pre-initialized

	// Custom Stuff

	/*var bopSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>(); // Bop every 2 beats
	var danceSprites:FlxTypedGroup<BGSpriteDance> = new FlxTypedGroup<BGSpriteDance>(); // Dance every beat
	var breatheSprites:FlxTypedGroup<BGSpriteDance> = new FlxTypedGroup<BGSpriteDance>(); // Dance every 2 beats*/
	var fidgetSprites:Map<String, BGSprite> = new Map<String, BGSprite>(); // Dance every 2 steps
	var danceSprites:Map<String, BGSprite> = new Map<String, BGSprite>(); // Dance every beat
	var bopSprites:Map<String, BGSprite> = new Map<String, BGSprite>(); // Dance every 2 beats
	var breatheSprites:Map<String, BGSprite> = new Map<String, BGSprite>(); // Dance every 4 beats

	/*var amongUsBg:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var darkAmongUsBg:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var amongUsWhiteVoid:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();*/
	var amongUsBg1:BGSprite;
	var amongUsBg2:BGSprite;
	var darkAmongUsBg1:BGSprite;
	var darkAmongUsBg2:BGSprite;
	var darkAmongUsBg3:BGSprite;
	var whiteVoid:BGSprite;

	var autumnLeafCafeBg3:BGSprite;

	var autumnLeafCafeSketchBg3:BGSprite;

	var chaseCouchBg3:BGSpriteDance;
	var chaseCouchBg5:BGSprite;
	var adamStuckLegs:BGSprite;

	var oceanBgNutshell3a:BGSprite;
	var oceanBgNutshell3b:BGSprite;
	var oceanBgNutshell4a:BGSprite;
	var oceanBgNutshell4b:BGSprite;

	var sandLandBg2a:BGSprite;
	var sandLandBg2b:BGSprite;
	var sandLandBg3a:BGSprite;
	var sandLandBg3b:BGSprite;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;
	public var missLimit(default, set):Int = -1; // For Defeat
	public var missLimitMult:Int = 1; // So that the icons stay in place

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var boyfriend2CameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var opponent2CameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	// I'd put these in the desktop check but PauseSubState uses remixDiffName soo :shrug:
	public var songNameNoDiff:String = 'This message should not appear. It\'ll be a pain if it does...';
	public static var remixDiffName:String = 'Unfair';

	public var galleryImageName:String = '';
	public var inGallery:Bool = false;

	// Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// For using lua in PlayState
	//public static var sourceLua:FunkinLua = new FunkinLua('mods/scripts/sourceLua.lua');
	public static var sourceLua:FunkinLua = null;

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;
	private var controlArray:Array<String>;

	// Public because of note splash precaching
	public var precacheList:Map<String, String> = new Map<String, String>();
	
	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo sprite object
	public static var lastCombo:FlxSprite;
	// stores the last combo score objects in an array
	public static var lastScore:Array<FlxSprite> = [];

	public var ranUpdate:Bool = false;

	public var bsodSpr:FlxSprite;
	public var fpsVisible:Bool = Main.fpsVar.visible;

	public static final stageDir:String = 'stages/';
	public static final songSpriteDir:String = 'songSprites/';

	var flipnoteShader:FlipnoteDitherShader;
	var youreBlueNow:Bool;

	var pauseScreen:PauseSubState;
	public var achievementsAndDelay:BlankSubState;

	public var fogOverlay:FlxSpriteGroup = new FlxSpriteGroup();
	public var fogAlpha:Float = 1;
	public var fog1:ModchartSprite;
	public var fog2:ModchartSprite;
	public var fog3:ModchartSprite;

	public var flipHealthBar(default, set):Bool = false;

	public var songInfoGroup:FlxSpriteGroup = new FlxSpriteGroup();

	public var cheatingPossible = false; // Do you want do you want phone phone phone phone
	public var pressedDebug = false;

	public var mouseKeys:Array<Bool> = [false, false, false, false]; // Somebody I know asked for an Android port so I'm making it so that you can play with your mouse

	override public function create()
	{
		//trace('Playback Rate: ' + playbackRate);
		Paths.clearStoredMemory();

		if (SONG != null)
		{
			if (SONG.arrowSkin == 'noteAssetsNutshell')
			{
				isNutshell = true;
				isFlipnote = false;
				handDrawn = true;
				isStepmania = false;
			}
			else if (SONG.arrowSkin == 'noteAssetsFlipnoteRed' || SONG.arrowSkin == 'noteAssetsFlipnoteBlue' || SONG.arrowSkin == 'noteAssetsFlipnoteShader')
			{
				isNutshell = false;
				isFlipnote = true;
				handDrawn = true;
				isStepmania = false;
				/*if (ClientPrefs.shaders)
				{
					SONG.arrowSkin = 'noteAssetsFlipnoteShader';
					SONG.player2 = SONG.player2.replace('FlipnoteRed', 'FlipnoteShader').replace('FlipnoteBlue', 'FlipnoteShader');
					SONG.gfVersion = SONG.gfVersion.replace('FlipnoteRed', 'FlipnoteShader').replace('FlipnoteBlue', 'FlipnoteShader');
					SONG.player1 = SONG.player1.replace('FlipnoteRed', 'FlipnoteShader').replace('FlipnoteBlue', 'FlipnoteShader');
				}*/
			}
			else if (SONG.arrowSkin == 'noteAssetsStepmania')
			{
				isNutshell = true;
				isFlipnote = false;
				handDrawn = true;
				isStepmania = true;
			}
			else
			{
				isNutshell = false;
				isFlipnote = false;
				handDrawn = false;
				isStepmania = false;
			}
		}

		if (handDrawn)
			daPixelZoom = 1;
		else
			daPixelZoom = 6;

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default
		playbackRate = ClientPrefs.getGameplaySetting('songspeed', 1);

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		controlArray = [
			'NOTE_LEFT',
			'NOTE_DOWN',
			'NOTE_UP',
			'NOTE_RIGHT'
		];

		//Ratings
		ratingsData.push(new Rating('sick')); //default rating

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera(Std.int(FlxG.width / -2), Std.int(FlxG.height / -2), FlxG.width * 2, FlxG.height * 2); // Goes off the screen as to not cut off notes
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		//camGame.pixelSize = 3;
		//camHUD.pixelSize = 3;
		//camOther.pixelSize = 3;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end
		
		songNameNoDiff = SONG.song;
		//remixDiffName = 'Unfair';
		if (songNameNoDiff == '~')
			inGallery = true;
		if (StringTools.endsWith(songNameNoDiff, ' ' + remixDiffName))
			songNameNoDiff = songNameNoDiff.substr(0, songNameNoDiff.length - (remixDiffName.length + 1));

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = SONG.stage;
		//trace('stage is: ' + curStage);
		if(SONG.stage == null || SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				case 'ugh' | 'guns' | 'stress':
					curStage = 'tank';
				default:
					curStage = 'stage';
			}
		}
		SONG.stage = curStage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				boyfriend2: [970, 0],
				girlfriend: [400, 130],
				opponent: [100, 100],
				opponent2: [-100, 0],
				hide_girlfriend: false,

				camera_boyfriend: [0, 0],
				camera_boyfriend2: [0, 0],
				camera_opponent: [0, 0],
				camera_opponent2: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		if (stageData.boyfriend2 == null) {
			BF2_X = BF_X + 200;
			BF2_Y = BF_Y - 100;
		}
		else {
			BF2_X = stageData.boyfriend2[0];
			BF2_Y = stageData.boyfriend2[1];
		}
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];
		if (stageData.opponent2 == null) {
			DAD2_X = DAD_X - 200;
			DAD2_Y = DAD_Y - 100;
		}
		else {
			DAD2_X = stageData.opponent2[0];
			DAD2_Y = stageData.opponent2[1];
		}

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		boyfriend2CameraOffset = stageData.camera_boyfriend2;
		if(boyfriend2CameraOffset == null)
			boyfriend2CameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		opponent2CameraOffset = stageData.camera_opponent2;
		if(opponent2CameraOffset == null)
			opponent2CameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		boyfriend2Group = new FlxSpriteGroup(BF2_X, BF2_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		dad2Group = new FlxSpriteGroup(DAD2_X, DAD2_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		sourceLua = new FunkinLua('mods/scripts/sourceLua.lua'); // Sorry for hardcoding the directory :(
		luaArray.push(sourceLua);
		
		//mosaicZoomPre();
		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}
				dadbattleSmokes = new FlxSpriteGroup(); //troll'd

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -800, -400, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				precacheList.set('thunder_1', 'sound');
				precacheList.set('thunder_2', 'sound');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}

				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyLightsColors = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
				phillyWindow = new BGSprite('philly/window', city.x, city.y, 0.3, 0.3);
				phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 0.85));
				phillyWindow.updateHitbox();
				add(phillyWindow);
				phillyWindow.alpha = 0;

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				phillyStreet = new BGSprite('philly/street', -40, 50);
				add(phillyStreet);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 170, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					precacheList.set('dancerdeath', 'sound');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				precacheList.set('Lights_Shut_off', 'sound');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

			case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				/*if(!ClientPrefs.lowQuality) { //Does this even do something?
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
				}*/
				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}

			case 'tank': //Week 7 - Ugh, Guns, Stress
				var sky:BGSprite = new BGSprite('tankSky', -400, -400, 0, 0);
				add(sky);

				if(!ClientPrefs.lowQuality)
				{
					var clouds:BGSprite = new BGSprite('tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
					clouds.active = true;
					clouds.velocity.x = FlxG.random.float(5, 15);
					add(clouds);

					var mountains:BGSprite = new BGSprite('tankMountains', -300, -20, 0.2, 0.2);
					mountains.setGraphicSize(Std.int(1.2 * mountains.width));
					mountains.updateHitbox();
					add(mountains);

					var buildings:BGSprite = new BGSprite('tankBuildings', -200, 0, 0.3, 0.3);
					buildings.setGraphicSize(Std.int(1.1 * buildings.width));
					buildings.updateHitbox();
					add(buildings);
				}

				var ruins:BGSprite = new BGSprite('tankRuins',-200,0,.35,.35);
				ruins.setGraphicSize(Std.int(1.1 * ruins.width));
				ruins.updateHitbox();
				add(ruins);

				if(!ClientPrefs.lowQuality)
				{
					var smokeLeft:BGSprite = new BGSprite('smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
					add(smokeLeft);
					var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
					add(smokeRight);

					tankWatchtower = new BGSprite('tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
					add(tankWatchtower);
				}

				tankGround = new BGSprite('tankRolling', 300, 300, 0.5, 0.5,['BG tank w lighting'], true);
				add(tankGround);

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var ground:BGSprite = new BGSprite('tankGround', -420, -150);
				ground.setGraphicSize(Std.int(1.15 * ground.width));
				ground.updateHitbox();
				add(ground);
				moveTank();

				//foregroundSprites = new FlxTypedGroup<BGSprite>();
				foregroundSprites.add(new BGSprite('tank0', -500, 650, 1.7, 1.5, ['fg']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank1', -300, 750, 2, 0.2, ['fg']));
				foregroundSprites.add(new BGSprite('tank2', 450, 940, 1.5, 1.5, ['foreground']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank4', 1300, 900, 1.5, 1.5, ['fg']));
				foregroundSprites.add(new BGSprite('tank5', 1620, 700, 1.5, 1.5, ['fg']));
				if(!ClientPrefs.lowQuality) foregroundSprites.add(new BGSprite('tank3', 1300, 1200, 3.5, 2.5, ['fg']));

			case 'adielHouseBg': // Unfamilar, Raveyard
				var adielHouseBg1:BGSprite = new BGSprite(stageDir + 'adielHouseBg1', -1050, -1600, 1, 1);
				//adielHouseBg1.setGraphicSize(3, 3);
				adielHouseBg1.scale.set(3, 3);
				adielHouseBg1.updateHitbox();
				adielHouseBg1.antialiasing = false;

				var adielHouseBg2:BGSprite = new BGSprite(stageDir + 'adielHouseBg2', -1050, -1600, 1, 1);
				//adielHouseBg2.setGraphicSize(3, 3);
				adielHouseBg2.scale.set(3, 3);
				adielHouseBg2.updateHitbox();
				adielHouseBg2.antialiasing = false;

				add(adielHouseBg1);
				add(adielHouseBg2);

				//defaultCamZoom = 0.75;

				/*boyfriendGroup.x = 870;
				boyfriendGroup.y = 300;
				gfGroup.x = 432;
				gfGroup.y = -240;
				dadGroup.x = 0;
				dadGroup.y = 300;*/
				
			case 'alacrityBg': // Alacrity
				var bgX:Float = -1050;
				var bgScrollSpeed:Float = 0.25;

				var alacrityBg1:BGSprite = new BGSprite(stageDir + 'alacrityBg1', bgX, -1600, 0, 0);
				alacrityBg1.scale.set(3, 3);
				alacrityBg1.updateHitbox();
				alacrityBg1.antialiasing = false;

				var alacrityBg3a:BGSprite = new BGSprite(stageDir + 'alacrityBg3', bgX, -1600, bgScrollSpeed, bgScrollSpeed);
				alacrityBg3a.scale.set(3, 3);
				alacrityBg3a.updateHitbox();
				alacrityBg3a.antialiasing = false;
				var bgWidth:Float = alacrityBg3a.width;

				var alacrityBg3b:BGSprite = new BGSprite(stageDir + 'alacrityBg3', bgX - bgWidth, -1600, bgScrollSpeed, bgScrollSpeed); // A copy for seamless scrolling
				alacrityBg3b.scale.set(3, 3);
				alacrityBg3b.updateHitbox();
				alacrityBg3b.antialiasing = false;

				var alacrityBg4a:BGSprite = new BGSprite(stageDir + 'alacrityBg4', bgX, -1600, bgScrollSpeed, bgScrollSpeed);
				alacrityBg4a.scale.set(3, 3);
				alacrityBg4a.updateHitbox();
				alacrityBg4a.antialiasing = false;

				var alacrityBg4b:BGSprite = new BGSprite(stageDir + 'alacrityBg4', bgX + bgWidth, -1600, bgScrollSpeed, bgScrollSpeed); // A copy for seamless scrolling
				alacrityBg4b.scale.set(3, 3);
				alacrityBg4b.updateHitbox();
				alacrityBg4b.antialiasing = false;

				add(alacrityBg1);
				add(alacrityBg3a);
				add(alacrityBg3b);
				add(alacrityBg4a);
				add(alacrityBg4b);

				//defaultCamZoom = 0.5;

				/*boyfriendGroup.x = 870;
				boyfriendGroup.y = 300;
				gfGroup.x = 432;
				gfGroup.y = -240;
				dadGroup.x = 0;
				dadGroup.y = 300;*/

				var scrollTime:Float = Conductor.crochet / 1000 * 32;

				modchartTweens.set('alacrityBg3a', FlxTween.tween(alacrityBg3a, {x: bgX + bgWidth}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
					onComplete: function(twn:FlxTween) {
						alacrityBg3a.x = bgX;
						alacrityBg3b.x = bgX - bgWidth;
						alacrityBg4a.x = bgX;
						alacrityBg4b.x = bgX + bgWidth;
					}
				}));
				modchartTweens.set('alacrityBg3b', FlxTween.tween(alacrityBg3b, {x: bgX}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));
				modchartTweens.set('alacrityBg4a', FlxTween.tween(alacrityBg4a, {x: bgX - bgWidth}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));
				modchartTweens.set('alacrityBg4b', FlxTween.tween(alacrityBg4b, {x: bgX}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));
				
			case 'amongUsBg': // Defeat, Similarities
				amongUsBg1 = new BGSprite(stageDir + 'amongUsBg1', -500, -500, 1, 1);
				//amongUsBg1.scale.set(3, 3);
				//amongUsBg1.updateHitbox();
				amongUsBg1.antialiasing = false;

				amongUsBg2 = new BGSprite(stageDir + 'amongUsBg2', -500, -500, 1, 1);
				//amongUsBg2.scale.set(3, 3);
				//amongUsBg2.updateHitbox();
				amongUsBg2.antialiasing = false;
				
				darkAmongUsBg1 = new BGSprite(stageDir + 'darkAmongUsBg1', -800, -800, 1, 1);
				darkAmongUsBg1.scale.set(3, 3);
				darkAmongUsBg1.updateHitbox();
				darkAmongUsBg1.antialiasing = false;
				darkAmongUsBg1.alpha = 0;

				darkAmongUsBg2 = new BGSprite(stageDir + 'darkAmongUsBg2', -800, -800, 1, 1, ['Idle'], true);
				//darkAmongUsBg2.frames = Paths.getSparrowAtlas('darkAmongUsBg2');
				//darkAmongUsBg2.animation.addByPrefix('idle', 'Idle', 24, true);
				//darkAmongUsBg2.animation.play('idle', true);
				darkAmongUsBg2.dance();
				darkAmongUsBg2.scale.set(3, 3);
				darkAmongUsBg2.updateHitbox();
				darkAmongUsBg2.antialiasing = false;
				darkAmongUsBg2.alpha = 0;

				darkAmongUsBg3 = new BGSprite(stageDir + 'darkAmongUsBg3', -800, -800, 1, 1);
				darkAmongUsBg3.scale.set(3, 3);
				darkAmongUsBg3.updateHitbox();
				darkAmongUsBg3.antialiasing = false;
				darkAmongUsBg3.alpha = 0;
				
				whiteVoid = new BGSprite(stageDir + 'whiteVoid', -500, -500, 0, 0);
				whiteVoid.scale.set(3, 3);
				whiteVoid.updateHitbox();
				whiteVoid.antialiasing = false;
				whiteVoid.alpha = 0;

				add(amongUsBg1);
				add(darkAmongUsBg1);
				add(darkAmongUsBg2);
				add(whiteVoid);

				//foregroundSprites = new FlxTypedGroup<BGSprite>();
				foregroundSprites.add(amongUsBg2);
				foregroundSprites.add(darkAmongUsBg3);

				//amongUsBg.add(amongUsBg1);
				//amongUsBg.add(amongUsBg2);
				
				//darkAmongUsBg.add(darkAmongUsBg1);
				//darkAmongUsBg.add(darkAmongUsBg2);
				//darkAmongUsBg.add(darkAmongUsBg3);

				//amongUsWhiteVoid.add(whiteVoid);

				//defaultCamZoom = 0.75;

			case 'arcadeBlitzNutshell': // Best Friend, Blitz, Polar Opposite, Rematch
				var arcadeBlitzNutshell1:BGSprite = new BGSprite(stageDir + 'arcadeBlitzNutshell1', -1050, -1600, 1, 1);
				arcadeBlitzNutshell1.antialiasing = false;

				var arcadeBlitzNutshell2:BGSprite = new BGSprite(stageDir + 'arcadeBlitzNutshell2', -1050, -1600, 1, 1);
				arcadeBlitzNutshell2.antialiasing = false;

				var arcadeBlitzNutshell3:BGSprite = new BGSprite(stageDir + 'arcadeBlitzNutshell3', -1050, -1600, 1, 1);
				arcadeBlitzNutshell3.antialiasing = false;

				add(arcadeBlitzNutshell1);
				add(arcadeBlitzNutshell2);
				add(arcadeBlitzNutshell3);

				//defaultCamZoom = 0.75;

				/*boyfriendGroup.x = 870;
				boyfriendGroup.y = 102;
				gfGroup.x = 400;
				gfGroup.y = 0;
				dadGroup.x = 0;
				dadGroup.y = 102;*/
				
			case 'autumnLeafCafeBg': // Cafe Mocha, Extra Whip, $5.87
				var autumnLeafCafeBg1:BGSprite = new BGSprite(stageDir + 'autumnLeafCafeBg1', -1050, -1600, 1, 1);
				autumnLeafCafeBg1.scale.set(3, 3);
				autumnLeafCafeBg1.updateHitbox();
				autumnLeafCafeBg1.antialiasing = false;
				
				var autumnLeafCafeBg2:BGSprite = new BGSprite(stageDir + 'autumnLeafCafeBg2', -1050, -1600, 1, 1);
				autumnLeafCafeBg2.scale.set(3, 3);
				autumnLeafCafeBg2.updateHitbox();
				autumnLeafCafeBg2.antialiasing = false;
				
				autumnLeafCafeBg3 = new BGSprite(stageDir + 'autumnLeafCafeBg3', -1050, -1600, 1, 1);
				autumnLeafCafeBg3.scale.set(3, 3);
				autumnLeafCafeBg3.updateHitbox();
				autumnLeafCafeBg3.antialiasing = false;
				
				add(autumnLeafCafeBg1);
				add(autumnLeafCafeBg2);
				add(autumnLeafCafeBg3);

				//FunkinLua.setObjectOrder('boyfriendGroup', FunkinLua.getObjectOrder('autumnLeafCafeBg3')); // B)
				
				//defaultCamZoom = 0.75;

			case 'autumnLeafCafeSketchBg': // Abuse
				var autumnLeafCafeSketchBg1:BGSprite = new BGSprite(stageDir + 'autumnLeafCafeSketchBg1', -1050, -1600, 1, 1);
				autumnLeafCafeSketchBg1.scale.set(3, 3);
				autumnLeafCafeSketchBg1.updateHitbox();
				autumnLeafCafeSketchBg1.antialiasing = false;
				
				var autumnLeafCafeSketchBg2:BGSprite = new BGSprite(stageDir + 'autumnLeafCafeSketchBg2', -1050, -1600, 1, 1);
				autumnLeafCafeSketchBg2.scale.set(3, 3);
				autumnLeafCafeSketchBg2.updateHitbox();
				autumnLeafCafeSketchBg2.antialiasing = false;
				
				autumnLeafCafeSketchBg3 = new BGSprite(stageDir + 'autumnLeafCafeSketchBg3', -1050, -1600, 1, 1);
				autumnLeafCafeSketchBg3.scale.set(3, 3);
				autumnLeafCafeSketchBg3.updateHitbox();
				autumnLeafCafeSketchBg3.antialiasing = false;
				
				add(autumnLeafCafeSketchBg1);
				add(autumnLeafCafeSketchBg2);
				add(autumnLeafCafeSketchBg3);

				//FunkinLua.setObjectOrder('dadGroup', FunkinLua.getObjectOrder('autumnLeafCafeSketchBg3')); // B)
				
				//defaultCamZoom = 0.75;

			case 'chaseApartmentBg': // Zanta
				//var chaseApartmentBg1:BGSprite = new BGSprite('chaseApartmentBg1', -1050, -1600, 1, 1);
				var chaseApartmentBg1:ModchartSprite = makeLuaSprite('chaseApartmentBg1', stageDir + 'chaseApartmentBg1', -600, -900);
				//var chaseApartmentBg1:ModchartSprite = modchartSprites.get('chaseApartmentBg1');
				chaseApartmentBg1.scale.set(2, 2);
				chaseApartmentBg1.updateHitbox();
				chaseApartmentBg1.antialiasing = false;
				chaseApartmentBg1.scrollFactor.set(0.5, 0.5);

				//var chaseApartmentBg2:BGSprite = new BGSprite('chaseApartmentBg2', -1050, -1600, 1, 1);
				var chaseApartmentBg2:ModchartSprite = makeLuaSprite('chaseApartmentBg2', stageDir + 'chaseApartmentBg2', -600, -900);
				//var chaseApartmentBg2:ModchartSprite = modchartSprites.get('chaseApartmentBg2');
				chaseApartmentBg2.scale.set(2, 2);
				chaseApartmentBg2.updateHitbox();
				chaseApartmentBg2.antialiasing = false;
				chaseApartmentBg2.scrollFactor.set(0.5, 0.5);

				//var chaseApartmentBg3:BGSprite = new BGSprite('chaseApartmentBg3', -1050, -1600, 1, 1);
				var chaseApartmentBg3:ModchartSprite = makeLuaSprite('chaseApartmentBg3', stageDir + 'chaseApartmentBg3', -600, -900);
				//var chaseApartmentBg3:ModchartSprite = modchartSprites.get('chaseApartmentBg3');
				chaseApartmentBg3.scale.set(2, 2);
				chaseApartmentBg3.updateHitbox();
				chaseApartmentBg3.antialiasing = false;
				chaseApartmentBg3.scrollFactor.set(0.5, 0.5);
				//chaseApartmentBg3.alpha = 0;

				//var chaseApartmentBg4:BGSprite = new BGSprite('chaseApartmentBg4', -1050, -1600, 1, 1);
				var chaseApartmentBg4:ModchartSprite = makeLuaSprite('chaseApartmentBg4', stageDir + 'chaseApartmentBg4', -600, -900);
				//var chaseApartmentBg4:ModchartSprite = modchartSprites.get('chaseApartmentBg4');
				chaseApartmentBg4.scale.set(2, 2);
				chaseApartmentBg4.updateHitbox();
				chaseApartmentBg4.antialiasing = false;
				chaseApartmentBg4.scrollFactor.set(0.5, 0.5);
				//chaseApartmentBg4.alpha = 0;

				add(chaseApartmentBg1);
				add(chaseApartmentBg2);
				//add(chaseApartmentBg3);
				//add(chaseApartmentBg4);
				//addLuaSprite('chaseApartmentBg1');
				//addLuaSprite('chaseApartmentBg2');
				//addLuaSprite('chaseApartmentBg3');
				//addLuaSprite('chaseApartmentBg4');
				//trace('Bg X Pos: ' + chaseApartmentBg1.x + ', Dad X Pos: ' + dadGroup.x);
				
				//defaultCamZoom = 0.75;

			case 'chaseCouchBg': // Stuck?
				var chaseCouchBg1:BGSprite = new BGSprite(stageDir + 'chaseCouchBg1', -1050, -1600, 1, 1);
				chaseCouchBg1.scale.set(3, 3);
				chaseCouchBg1.updateHitbox();
				chaseCouchBg1.antialiasing = false;
				
				var chaseCouchBg2:BGSprite = new BGSprite(stageDir + 'chaseCouchBg2', -1050, -1600, 1, 1);
				chaseCouchBg2.scale.set(3, 3);
				chaseCouchBg2.updateHitbox();
				chaseCouchBg2.antialiasing = false;
				
				chaseCouchBg3 = new BGSpriteDance(stageDir + 'chaseCouchBg3', -1110, -1600, 1, 1, ['Dance Left', 'Dance Right'], false); // Cool new class
				chaseCouchBg3.scale.set(3, 3);
				chaseCouchBg3.updateHitbox();
				chaseCouchBg3.antialiasing = false;
				@:privateAccess
				for (anim in chaseCouchBg3.animation._animations)
				{
					anim.frameRate = 12;
				}
				chaseCouchBg3.dance(true);
				//trace('Chase danceLeft animation is ' + chaseCouchBg3.leftIdle);
				//trace('Chase danceRight animation is ' + chaseCouchBg3.rightIdle);
				
				var chaseCouchBg4:BGSprite = new BGSprite(stageDir + 'chaseCouchBg4', -1050, -1600, 1, 1);
				chaseCouchBg4.scale.set(3, 3);
				chaseCouchBg4.updateHitbox();
				chaseCouchBg4.antialiasing = false;

				adamStuckLegs = new BGSprite('characters/adamStuck', 75, -300, 1, 1, ['Legs Idle'], true); // I honestly have no clue why I couldn't just use the BF position
				adamStuckLegs.scale.set(3, 3);
				adamStuckLegs.updateHitbox();
				adamStuckLegs.antialiasing = false;
				
				chaseCouchBg5 = new BGSprite(stageDir + 'chaseCouchBg5', -1110, -1600, 1, 1, ['Idle'], true);
				chaseCouchBg5.scale.set(3, 3);
				chaseCouchBg5.updateHitbox();
				chaseCouchBg5.antialiasing = false;

				add(chaseCouchBg1);
				add(chaseCouchBg2);
				foregroundSprites.add(chaseCouchBg3);
				foregroundSprites.add(chaseCouchBg4);
				foregroundSprites.add(adamStuckLegs);
				foregroundSprites.add(chaseCouchBg5);

				breatheSprites.set('chaseCouchBg3', chaseCouchBg3);
				fidgetSprites.set('adamStuckLegs', adamStuckLegs);
				//trace('Bg X Pos: ' + chaseCouchBg3.x + ', Dad X Pos: ' + dadGroup.x);
				
				//defaultCamZoom = 0.75;

			case 'chaseDeskBg': // Monochrome
				var chaseDeskBg1:BGSprite = new BGSprite(stageDir + 'chaseDeskBg1', -1050, -1600, 1, 1);
				chaseDeskBg1.scale.set(3, 3);
				chaseDeskBg1.updateHitbox();
				chaseDeskBg1.antialiasing = false;
				
				var chaseDeskBg2:BGSprite = new BGSprite(stageDir + 'chaseDeskBg2', -1050, -1600, 1, 1);
				chaseDeskBg2.scale.set(3, 3);
				chaseDeskBg2.updateHitbox();
				chaseDeskBg2.antialiasing = false;
				
				var chaseDeskBg3 = new BGSprite(stageDir + 'chaseDeskBg3', -1050, -1600, 1, 1);
				chaseDeskBg3.scale.set(3, 3);
				chaseDeskBg3.updateHitbox();
				chaseDeskBg3.antialiasing = false;
				
				var darkFg = new BGSprite(stageDir + 'darkFg', -1050, -1600, 1, 1);
				darkFg.scale.set(3, 3);
				darkFg.updateHitbox();
				darkFg.antialiasing = false;
				darkFg.blend = MULTIPLY;
				
				add(chaseDeskBg1);
				add(chaseDeskBg2);
				add(chaseDeskBg3);
				foregroundSprites.add(darkFg);
				
				//defaultCamZoom = 0.75;
				
			case 'cinnamonRollBg': // Cinnamon Roll
				var cinnamonRollBg1:BGSprite = new BGSprite(stageDir + 'cinnamonRollBg', -1050, -1600, 0.5, 0.5);
				cinnamonRollBg1.scale.set(3, 3);
				cinnamonRollBg1.updateHitbox();
				cinnamonRollBg1.antialiasing = false;
				
				add(cinnamonRollBg1);
				
				//defaultCamZoom = 0.75;
				
			case 'collegeFairBg': // Toyboy, Light Gray Stained Glass Pane
				var collegeFairBg1:BGSprite = new BGSprite(stageDir + 'collegeFairBg1', -1050, -1600, 1, 1);
				collegeFairBg1.scale.set(3, 3);
				collegeFairBg1.updateHitbox();
				collegeFairBg1.antialiasing = false;

				var collegeFairBg2:BGSprite = new BGSprite(stageDir + 'collegeFairBg2', -1050, -1600, 1, 1);
				collegeFairBg2.scale.set(3, 3);
				collegeFairBg2.updateHitbox();
				collegeFairBg2.antialiasing = false;

				var collegeFairBg3:BGSprite = new BGSprite(stageDir + 'collegeFairBg3', -1050, -1600, 1, 1, ['Idle']);
				collegeFairBg3.scale.set(3, 3);
				collegeFairBg3.updateHitbox();
				collegeFairBg3.antialiasing = false;

				var collegeFairBg4:BGSprite = new BGSprite(stageDir + 'collegeFairBg4', -1050, -1600, 1, 1);
				collegeFairBg4.scale.set(3, 3);
				collegeFairBg4.updateHitbox();
				collegeFairBg4.antialiasing = false;
				
				add(collegeFairBg1);
				add(collegeFairBg2);
				add(collegeFairBg3);
				add(collegeFairBg4);
				bopSprites.set('collegeFairBg3', collegeFairBg3);
				
				//defaultCamZoom = 0.75;
				
			case 'collegeFairRunBg': // Final Round
				var bgX:Float = -1050;
			
				var collegeFairRunBg1:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg1', -1050, -1600, 1, 1);
				collegeFairRunBg1.scale.set(3, 3);
				collegeFairRunBg1.updateHitbox();
				collegeFairRunBg1.antialiasing = false;
				
				var collegeFairRunBg2a:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg2', bgX, -1600, 1, 1);
				collegeFairRunBg2a.scale.set(3, 3);
				collegeFairRunBg2a.updateHitbox();
				collegeFairRunBg2a.antialiasing = false;
				var bgWidth:Float = collegeFairRunBg2a.width;
				
				var collegeFairRunBg2b:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg2', bgX + bgWidth, -1600, 1, 1);
				collegeFairRunBg2b.scale.set(3, 3);
				collegeFairRunBg2b.updateHitbox();
				collegeFairRunBg2b.antialiasing = false;

				var collegeFairRunBg3a:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg3', bgX, -1600, 1, 1);
				collegeFairRunBg3a.scale.set(3, 3);
				collegeFairRunBg3a.updateHitbox();
				collegeFairRunBg3a.antialiasing = false;

				var collegeFairRunBg3b:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg3', bgX + bgWidth, -1600, 1, 1);
				collegeFairRunBg3b.scale.set(3, 3);
				collegeFairRunBg3b.updateHitbox();
				collegeFairRunBg3b.antialiasing = false;

				var collegeFairRunBg4a:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg4', bgX, -1600, 1, 1);
				collegeFairRunBg4a.scale.set(3, 3);
				collegeFairRunBg4a.updateHitbox();
				collegeFairRunBg4a.antialiasing = false;

				var collegeFairRunBg4b:BGSprite = new BGSprite(stageDir + 'collegeFairRunBg4', bgX + bgWidth, -1600, 1, 1);
				collegeFairRunBg4b.scale.set(3, 3);
				collegeFairRunBg4b.updateHitbox();
				collegeFairRunBg4b.antialiasing = false;

				add(collegeFairRunBg1);
				add(collegeFairRunBg2a);
				add(collegeFairRunBg2b);
				add(collegeFairRunBg3a);
				add(collegeFairRunBg3b);
				add(collegeFairRunBg4a);
				add(collegeFairRunBg4b);

				//defaultCamZoom = 0.75;

				var scrollTime:Float = Conductor.crochet / 1000 * 3;
				
				modchartTweens.set('collegeFairRunBg2a', FlxTween.tween(collegeFairRunBg2a, {x: bgX - bgWidth}, scrollTime * 8, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
					onComplete: function(twn:FlxTween) {
						collegeFairRunBg2a.x = bgX;
						collegeFairRunBg2b.x = bgX + bgWidth;
					}
				}));
				modchartTweens.set('collegeFairRunBg2b', FlxTween.tween(collegeFairRunBg2b, {x: bgX}, scrollTime * 8, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING
				}));
				
				modchartTweens.set('collegeFairRunBg3a', FlxTween.tween(collegeFairRunBg3a, {x: bgX - bgWidth}, scrollTime * 4, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
					onComplete: function(twn:FlxTween) {
						collegeFairRunBg3a.x = bgX;
						collegeFairRunBg3b.x = bgX + bgWidth;
					}
				}));
				modchartTweens.set('collegeFairRunBg3b', FlxTween.tween(collegeFairRunBg3b, {x: bgX}, scrollTime * 4, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING
				}));
				
				modchartTweens.set('collegeFairRunBg4a', FlxTween.tween(collegeFairRunBg4a, {x: bgX - bgWidth}, scrollTime * 2, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
					onComplete: function(twn:FlxTween) {
						collegeFairRunBg4a.x = bgX;
						collegeFairRunBg4b.x = bgX + bgWidth;
					}
				}));
				modchartTweens.set('collegeFairRunBg4b', FlxTween.tween(collegeFairRunBg4b, {x: bgX}, scrollTime * 2, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING
				}));

			case 'contradictionBg': // Contradiction
				var contradictionBg1:ModchartSprite = makeLuaSprite('contradictionBg1', stageDir + 'contradictionBg1', -1050, -1000);
				contradictionBg1.scale.set(3, 3);
				contradictionBg1.updateHitbox();
				contradictionBg1.antialiasing = false;
				contradictionBg1.scrollFactor.set(1, 1);

				var contradictionBg2:ModchartSprite = makeLuaSprite('contradictionBg2', stageDir + 'contradictionBg2', -1050, -2000);
				contradictionBg2.scale.set(3, 3);
				contradictionBg2.updateHitbox();
				contradictionBg2.antialiasing = false;
				contradictionBg2.scrollFactor.set(1, 1);

				//addLuaSprite('contradictionBg1', false);
				add(contradictionBg1);

			case 'crossComicClashBg': // Cross-Comic Clash
				var crossComicClashBg1:BGSprite = new BGSprite(stageDir + 'crossComicClashBg1', -1050, -1600, 1, 1);
				crossComicClashBg1.scale.set(3, 3);
				crossComicClashBg1.updateHitbox();
				crossComicClashBg1.antialiasing = false;

				var crossComicClashBg2:BGSprite = new BGSprite(stageDir + 'crossComicClashBg2', -1050, -1600, 1, 1, ['Idle'], true);
				crossComicClashBg2.scale.set(3, 3);
				crossComicClashBg2.updateHitbox();
				crossComicClashBg2.antialiasing = false;

				add(crossComicClashBg1);
				foregroundSprites.add(crossComicClashBg2);

				//defaultCamZoom = 0.75;

			case 'drippy': // Drippy
				amongUsBg1 = new BGSprite(stageDir + 'amongUsBg1', -500, -500, 1, 1);
				//amongUsBg1.scale.set(3, 3);
				//amongUsBg1.updateHitbox();
				amongUsBg1.antialiasing = false;

				amongUsBg2 = new BGSprite(stageDir + 'amongUsBg2', -500, -500, 1, 1);
				//amongUsBg2.scale.set(3, 3);
				//amongUsBg2.updateHitbox();
				amongUsBg2.antialiasing = false;

				add(amongUsBg1);
				foregroundSprites.add(amongUsBg2);
				
				//defaultCamZoom = 0.75;

			/*case 'dudeHouseBg': // Dude, Toasty, Challeng-Edd
				precacheList.set(stageDir + 'dudeHouseSkewBg1', 'image');
				precacheList.set(stageDir + 'dudeHouseSkewBg2', 'image');
				precacheList.set(stageDir + 'dudeHouseSkewBg3', 'image');
				precacheList.set(stageDir + 'dudeHouseSkewBg4', 'image');
				precacheList.set(stageDir + 'dudeHouseSkewBg5', 'image');

				boyfriendGroup.x = 870;
				boyfriendGroup.y = 102;
				gfGroup.x = 400;
				gfGroup.y = 0;
				dadGroup.x = 0;
				dadGroup.y = 102;

				var dudeHouseBg1:ModchartSprite = makeLuaSprite('dudeHouseBg1', stageDir + 'dudeHouseBg1', -600, 600);
				dudeHouseBg1.scale.set(3, 3);
				dudeHouseBg1.updateHitbox();
				dudeHouseBg1.antialiasing = false;
				dudeHouseBg1.scrollFactor.set(0.2, 0.2);
				
				var dudeHouseBg2:ModchartSprite = makeLuaSprite('dudeHouseBg2', stageDir + 'dudeHouseBg2', -600, -1900);
				dudeHouseBg2.scale.set(3, 3);
				dudeHouseBg2.updateHitbox();
				dudeHouseBg2.antialiasing = false;
				dudeHouseBg2.scrollFactor.set(0.6, 0.6);

				var dudeHouseBg3:ModchartSprite = makeLuaSprite('dudeHouseBg3', stageDir + 'dudeHouseBg3', -600, -1900);
				dudeHouseBg3.scale.set(3, 3);
				dudeHouseBg3.updateHitbox();
				dudeHouseBg3.antialiasing = false;
				dudeHouseBg3.scrollFactor.set(1, 1);

				var dudeHouseBg4:ModchartSprite = makeLuaSprite('dudeHouseBg4', stageDir + 'dudeHouseBg4', -600, -1900);
				dudeHouseBg4.scale.set(3, 3);
				dudeHouseBg4.updateHitbox();
				dudeHouseBg4.antialiasing = false;
				dudeHouseBg4.scrollFactor.set(1, 1);

				var dudeHouseBg5:ModchartSprite = makeLuaSprite('dudeHouseBg5', stageDir + 'dudeHouseBg5', -600, -1900);
				dudeHouseBg5.scale.set(3, 3);
				dudeHouseBg5.updateHitbox();
				dudeHouseBg5.antialiasing = false;
				dudeHouseBg5.scrollFactor.set(1, 1);

				add(dudeHouseBg1);
				add(dudeHouseBg2);
				add(dudeHouseBg3);
				add(dudeHouseBg4);
				add(dudeHouseBg5);

				//defaultCamZoom = 0.75;*/

			case 'finaleBg': // Overcast Overview
				var finaleBgKristen:ModchartSprite = makeLuaSprite('finaleBgKristen', stageDir + 'finale/kristen', -1050, -1600);
				finaleBgKristen.scale.set(3, 3);
				finaleBgKristen.updateHitbox();
				finaleBgKristen.antialiasing = false;
				finaleBgKristen.scrollFactor.set(1, 1);

				var finaleBgChase:ModchartSprite = makeLuaSprite('finaleBgChase', stageDir + 'finale/chase', -1050, -1600);
				finaleBgChase.scale.set(3, 3);
				finaleBgChase.updateHitbox();
				finaleBgChase.antialiasing = false;
				finaleBgChase.scrollFactor.set(1, 1);

				var finaleBgAdam1:ModchartSprite = makeLuaSprite('finaleBgAdam1', stageDir + 'finale/adam1', -1050, -1600);
				finaleBgAdam1.scale.set(3, 3);
				finaleBgAdam1.updateHitbox();
				finaleBgAdam1.antialiasing = false;
				finaleBgAdam1.scrollFactor.set(1, 1);

				var finaleBgAdam2:ModchartSprite = makeLuaSprite('finaleBgAdam2', stageDir + 'finale/adam2', -1050, -1600);
				finaleBgAdam2.scale.set(3, 3);
				finaleBgAdam2.updateHitbox();
				finaleBgAdam2.antialiasing = false;
				finaleBgAdam2.scrollFactor.set(1, 1);

				var finaleBgDude:ModchartSprite = makeLuaSprite('finaleBgDude', stageDir + 'finale/dude', -1050, -1600);
				finaleBgDude.scale.set(3, 3);
				finaleBgDude.updateHitbox();
				finaleBgDude.antialiasing = false;
				finaleBgDude.scrollFactor.set(1, 1);

				var finaleBgElliot:ModchartSprite = makeLuaSprite('finaleBgElliot', stageDir + 'finale/elliot', -1050, -1810);
				finaleBgElliot.scale.set(3, 3);
				finaleBgElliot.updateHitbox();
				finaleBgElliot.antialiasing = false;
				finaleBgElliot.scrollFactor.set(1, 1);

				var darkFg:ModchartSprite = makeLuaSprite('darkFg', stageDir + 'darkFg', -1050, -1600);
				darkFg.scale.set(3, 3);
				darkFg.updateHitbox();
				darkFg.antialiasing = false;
				darkFg.scrollFactor.set(1, 1);
				darkFg.blend = MULTIPLY;

				var fog1:ModchartSprite = makeLuaSprite('fog1', stageDir + 'finale/fog1', -1050, -1600);
				fog1.scale.set(3, 3);
				fog1.updateHitbox();
				fog1.antialiasing = false;
				fog1.scrollFactor.set(1, 1);
				//fog1.alpha = 0.5;

				var fog2:ModchartSprite = makeLuaSprite('fog2', stageDir + 'finale/fog2', -1050, -1600);
				fog2.scale.set(3, 3);
				fog2.updateHitbox();
				fog2.antialiasing = false;
				fog2.scrollFactor.set(1, 1);
				//fog2.alpha = 0.5;

				var fog3:ModchartSprite = makeLuaSprite('fog3', stageDir + 'finale/fog3', -1050, -1600);
				fog3.scale.set(3, 3);
				fog3.updateHitbox();
				fog3.antialiasing = false;
				fog3.scrollFactor.set(1, 1);
				//fog3.alpha = 0.5;

				//addLuaSprite('finaleBgKristen');
				fogOverlay.add(darkFg);
				fogOverlay.add(fog1);
				fogOverlay.add(fog2);
				fogOverlay.add(fog3);

				//defaultCamZoom = 0.75;

				var fog2X = fog2.x - 50;
				fog2.x = fog2X;
				var fog2Tween:FlxTween = FlxTween.tween(fog2, {x: fog2X + 100}, Conductor.crochet / 1000 * 4,
				{
					ease: FlxEase.sineInOut,
					type: PINGPONG
				});
				modchartTweens.set('fog2Tween', fog2Tween);

				var fog3X = fog3.x + 50;
				fog3.x = fog3X;
				var fog3Tween:FlxTween = FlxTween.tween(fog3, {x: fog3X - 100}, Conductor.crochet / 1000 * 4,
				{
					ease: FlxEase.sineInOut,
					type: PINGPONG
				});
				modchartTweens.set('fog3Tween', fog3Tween);

			//case 'gameOverBg': // Nah too Lua-based

			case 'oceanBgNutshell': // Eye Spy
				var oceanBgNutshell1:BGSprite = new BGSprite(stageDir + 'oceanBgNutshell1', -825, -900, 1, 1);
				oceanBgNutshell1.scale.set(3, 3);
				oceanBgNutshell1.updateHitbox();
				oceanBgNutshell1.antialiasing = false;

				var oceanBgNutshell2:BGSprite = new BGSprite(stageDir + 'oceanBgNutshell2', -825, -900, 1, 1);
				oceanBgNutshell2.scale.set(3, 3);
				oceanBgNutshell2.updateHitbox();
				oceanBgNutshell2.antialiasing = false;

				oceanBgNutshell3a = new BGSprite(stageDir + 'oceanBgNutshell3', -825, -900, 1, 1);
				oceanBgNutshell3a.scale.set(3, 3);
				oceanBgNutshell3a.updateHitbox();
				oceanBgNutshell3a.antialiasing = false;

				oceanBgNutshell3b = new BGSprite(stageDir + 'oceanBgNutshell3', -825, -900, 1, 1);
				oceanBgNutshell3b.scale.set(3, 3);
				oceanBgNutshell3b.updateHitbox();
				oceanBgNutshell3b.antialiasing = false;
				oceanBgNutshell3b.flipX = true;

				oceanBgNutshell4a = new BGSprite(stageDir + 'oceanBgNutshell4', -825, -900, 1, 1);
				oceanBgNutshell4a.scale.set(3, 3);
				oceanBgNutshell4a.updateHitbox();
				oceanBgNutshell4a.antialiasing = false;

				oceanBgNutshell4b = new BGSprite(stageDir + 'oceanBgNutshell4', -825, -900, 1, 1);
				oceanBgNutshell4b.scale.set(3, 3);
				oceanBgNutshell4b.updateHitbox();
				oceanBgNutshell4b.antialiasing = false;
				oceanBgNutshell4b.flipX = true;

				add(oceanBgNutshell1);
				add(oceanBgNutshell2);
				add(oceanBgNutshell3a);
				add(oceanBgNutshell3b);
				foregroundSprites.add(oceanBgNutshell4a);
				foregroundSprites.add(oceanBgNutshell4b);
				
				//defaultCamZoom = 0.75;

			case 'runBg': // Get Back Here!
				var runBg1:BGSprite = new BGSprite(stageDir + 'runBg1', -500, -500, 1, 1, ['Scroll'], true);
				runBg1.scale.set(3, 3);
				runBg1.updateHitbox();
				runBg1.antialiasing = false;

				var runBg2:BGSprite = new BGSprite(stageDir + 'runBg2', -500, -500, 1, 1);
				runBg2.scale.set(3, 3);
				runBg2.updateHitbox();
				runBg2.antialiasing = false;

				add(runBg1);
				add(runBg2);

				//defaultCamZoom = 0.5;
				
			case 'sandLandBg': // Sand Land
				var bgScrollSpeed:Float = 1;
				var shaderStr:String = (ClientPrefs.shaders ? 'Shader' : '');

				var whiteVoid:BGSprite = new BGSprite(stageDir + 'whiteVoid', -1050, -1600, 0, 0);
				whiteVoid.scale.set(3, 3);
				whiteVoid.updateHitbox();
				whiteVoid.antialiasing = false;

				sandLandBg2a = new BGSprite(stageDir + 'sandLandBg' + shaderStr + '2', -1050, -1600, bgScrollSpeed, bgScrollSpeed);
				sandLandBg2a.scale.set(5, 5);
				sandLandBg2a.updateHitbox();
				sandLandBg2a.antialiasing = false;
				sandLandBg2a.alpha = 0;

				sandLandBg2a.x = sandLandBg2a.width / -2; // Center on 0, 0
				sandLandBg2a.y = sandLandBg2a.height / -2;
				sandLandBg2a.x += 690; // The same coordinates as in the Camera Follow Pos event in the Lua file
				sandLandBg2a.y += 300;
				var bgX:Float = sandLandBg2a.x;
				var bgY:Float = sandLandBg2a.y;
				var bgHeight:Float = sandLandBg2a.height;

				sandLandBg2b = new BGSprite(stageDir + 'sandLandBg' + shaderStr + '2', bgX, bgY - bgHeight, bgScrollSpeed, bgScrollSpeed); // A copy for seamless scrolling
				sandLandBg2b.scale.set(5, 5);
				sandLandBg2b.updateHitbox();
				sandLandBg2b.antialiasing = false;
				sandLandBg2b.alpha = 0;

				sandLandBg3a = new BGSprite(stageDir + 'sandLandBg' + shaderStr + '3', bgX, bgY, bgScrollSpeed, bgScrollSpeed);
				sandLandBg3a.scale.set(5, 5);
				sandLandBg3a.updateHitbox();
				sandLandBg3a.antialiasing = false;
				sandLandBg3a.alpha = 0;

				sandLandBg3b = new BGSprite(stageDir + 'sandLandBg' + shaderStr + '3', bgX, bgY + bgHeight, bgScrollSpeed, bgScrollSpeed); // A copy for seamless scrolling
				sandLandBg3b.scale.set(5, 5);
				sandLandBg3b.updateHitbox();
				sandLandBg3b.antialiasing = false;
				sandLandBg3b.alpha = 0;

				add(whiteVoid);
				add(sandLandBg2a);
				add(sandLandBg2b);
				add(sandLandBg3a);
				add(sandLandBg3b);

				//defaultCamZoom = 0.75;

				/*boyfriendGroup.x = 870;
				boyfriendGroup.y = 300;
				gfGroup.x = 432;
				gfGroup.y = -240;
				dadGroup.x = 0;
				dadGroup.y = 300;*/

				var scrollTime:Float = Conductor.crochet / 1000 * 32;

				modchartTweens.set('sandLandBg2a', FlxTween.tween(sandLandBg2a, {y: bgY + bgHeight}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
					onComplete: function(twn:FlxTween) {
						sandLandBg2a.y = bgY;
						sandLandBg2b.y = bgY - bgHeight;
						sandLandBg3a.y = bgY;
						sandLandBg3b.y = bgY + bgHeight;
					}
				}));
				modchartTweens.set('sandLandBg2b', FlxTween.tween(sandLandBg2b, {y: bgY}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));
				modchartTweens.set('sandLandBg3a', FlxTween.tween(sandLandBg3a, {y: bgY - bgHeight}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));
				modchartTweens.set('sandLandBg3b', FlxTween.tween(sandLandBg3b, {y: bgY}, scrollTime, {
					ease: FlxEase.linear,
					type: FlxTweenType.LOOPING,
				}));

			case 'whiteVoid': // Infected, Haybot, Giraffe
				var whiteVoid:BGSprite = new BGSprite(stageDir + 'whiteVoid', -1050, -1600, 0, 0);
				whiteVoid.scale.set(3, 3);
				whiteVoid.updateHitbox();
				whiteVoid.antialiasing = false;

				add(whiteVoid);

				//defaultCamZoom = 0.75;

			case 'winterBgNutshell': // Free Time
				var winterBgNutshell1:BGSprite = new BGSprite(stageDir + 'winterBgNutshell1', -1050, -1600, 1, 1);
				winterBgNutshell1.scale.set(3, 3);
				winterBgNutshell1.updateHitbox();
				winterBgNutshell1.antialiasing = false;

				var winterBgNutshell2:BGSprite = new BGSprite(stageDir + 'winterBgNutshell2', -1050, -1600, 1, 1);
				winterBgNutshell2.scale.set(3, 3);
				winterBgNutshell2.updateHitbox();
				winterBgNutshell2.antialiasing = false;

				var winterBgNutshell3:BGSprite = new BGSprite(stageDir + 'winterBgNutshell3', -1050, -1600, 1, 1);
				winterBgNutshell3.scale.set(3, 3);
				winterBgNutshell3.updateHitbox();
				winterBgNutshell3.antialiasing = false;

				var winterBgNutshell4:BGSprite = new BGSprite(stageDir + 'winterBgNutshell4', -1050, -1600, 1, 1);
				winterBgNutshell4.scale.set(3, 3);
				winterBgNutshell4.updateHitbox();
				winterBgNutshell4.antialiasing = false;

				add(winterBgNutshell1);
				add(winterBgNutshell2);
				add(winterBgNutshell3);
				add(winterBgNutshell4);

				//defaultCamZoom = 0.75;

		}
		//mosaicZoomPost();

		switch(Paths.formatToSongPath(SONG.song))
		{
			case 'stress':
				GameOverSubstate.characterName = 'bf-holding-gf-dead';
		}

		if (isPixelStage) {
			introSoundsSuffix = '-pixel';
		}
		else if (isFlipnote) {
			introSoundsSuffix = 'Flipnote';
		}

		add(gfGroup); //Needed for blammed lights

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad2Group);
		add(dadGroup);
		add(boyfriend2Group);
		add(boyfriendGroup);

		if (curStage == 'autumnLeafCafeBg') {
			setObjectOrder('boyfriendGroup', getObjectOrder('autumnLeafCafeBg3')); // B)
			setObjectOrder('boyfriend2Group', getObjectOrder('boyfriendGroup')); // B)
		}
		else if (curStage == 'autumnLeafCafeSketchBg') {
			setObjectOrder('dadGroup', getObjectOrder('autumnLeafCafeSketchBg3')); // B)
			setObjectOrder('dad2Group', getObjectOrder('dadGroup')); // B)
		}
		/*else if (curStage == 'chaseCouchBg') {
			add(chaseCouchBg3);
		}*/

		switch(curStage)
		{
			case 'spooky':
				add(halloweenWhite);
			//case 'tank':
				//add(foregroundSprites);
			//default:
				//add(foregroundSprites);
		}
		add(foregroundSprites);

		//luaArray.push(new FunkinLua('mods/scripts/sourceLua.lua'));

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file) && file != 'sourceLua.lua')
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end


		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		var p1Char:String = SONG.player1;
		var p2Char:String = SONG.player2;
		var gfVersion:String = SONG.gfVersion;
		var p1bChar:String = SONG.player1b;
		var p2bChar:String = SONG.player2b;
		if (isFlipnote) {
			if (ClientPrefs.shaders) {
				/*p1Char = p1Char.replace('Red', 'Shader');
				p2Char = p2Char.replace('Red', 'Shader');
				gfVersion = gfVersion.replace('Red', 'Shader');
				p1bChar = p1bChar.replace('Red', 'Shader');
				p2bChar = p2bChar.replace('Red', 'Shader');*/
				p1Char = getFlipnoteShaderString(p1Char);
				p2Char = getFlipnoteShaderString(p2Char);
				gfVersion = getFlipnoteShaderString(gfVersion);
				p1bChar = getFlipnoteShaderString(p1bChar);
				p2bChar = getFlipnoteShaderString(p2bChar);
			}
			else {
				p1Char = getFlipnoteNoShaderString(p1Char);
				p2Char = getFlipnoteNoShaderString(p2Char);
				gfVersion = getFlipnoteNoShaderString(gfVersion);
				p1bChar = getFlipnoteNoShaderString(p1bChar);
				p2bChar = getFlipnoteNoShaderString(p2bChar);
			}
		}
		if (gfVersion == null || gfVersion.length < 1) {
			switch (curStage) {
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
				default:
					gfVersion = 'gf';
			}

			switch(Paths.formatToSongPath(SONG.song)) {
				case 'stress':
					gfVersion = 'pico-speaker';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			if (!handDrawn)
				gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);

			if(gfVersion == 'pico-speaker')
			{
				if(!ClientPrefs.lowQuality)
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 600, true);
					firstTank.strumTime = 10;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
				}
			}
		}
		
		dad = new Character(0, 0, p2Char, false, false);
		startCharacterPos(dad, true);
		//if (dad.legType != 'amongUs')
			dad.addLegs(dadGroup);
		dadGroup.add(dad);
		if (dad.legType == 'amongUs')
		{
			dadGroup.remove(dad.legs, true);
			dad.addLegs(dadGroup);
			//setObjectOrder('dad.legs', getObjectOrder('dad') + 1);
		}
		dad.addOverlay(dadGroup);
		//dad.addExtras(this);
		startCharacterLua(dad.curCharacter);
		
		dad2 = new Character(0, 0, p2bChar, false, true);
		startCharacterPos(dad2, true);
		//if (dad2.legType != 'amongUs')
			dad2.addLegs(dad2Group);
		dad2Group.add(dad2);
		if (dad2.legType == 'amongUs')
		{
			dad2Group.remove(dad2.legs, true);
			dad2.addLegs(dad2Group);
		}
		dad2.addOverlay(dad2Group);
		//dad2.addExtras(this);
		startCharacterLua(dad2.curCharacter);

		boyfriend = new Boyfriend(0, 0, p1Char, false);
		startCharacterPos(boyfriend);
		//if (boyfriend.legType != 'amongUs')
			boyfriend.addLegs(boyfriendGroup);
		boyfriendGroup.add(boyfriend);
		if (boyfriend.legType == 'amongUs')
		{
			boyfriendGroup.remove(boyfriend.legs, true);
			boyfriend.addLegs(boyfriendGroup);
		}
		boyfriend.addOverlay(boyfriendGroup);
		//boyfriend.addExtras(this);
		/*if (curStage == 'chaseCouchBg') {
			adamStuckLegs.x = boyfriend.x;
			adamStuckLegs.y = boyfriend.y;
		}*/
		startCharacterLua(boyfriend.curCharacter);
		
		boyfriend2 = new Boyfriend(0, 0, p1bChar, true);
		startCharacterPos(boyfriend2);
		//if (boyfriend2.legType != 'amongUs')
			boyfriend2.addLegs(boyfriend2Group);
		boyfriend2Group.add(boyfriend2);
		if (boyfriend2.legType == 'amongUs')
		{
			boyfriend2Group.remove(boyfriend2.legs, true);
			boyfriend2.addLegs(boyfriend2Group);
		}
		boyfriend2.addOverlay(boyfriend2Group);
		//boyfriend2.addExtras(this);
		startCharacterLua(boyfriend2.curCharacter);

		// Game over screen assets
		if (boyfriend.curCharacter == 'bf-pixel') {
			GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
			GameOverSubstate.loopSoundName = 'gameOver-pixel';
			GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
			GameOverSubstate.characterName = 'bf-pixel-dead';
		}
		else if (boyfriend.curCharacter == 'bfOffDay') {
			//GameOverSubstate.deathSoundName = 'fnf_loss_sfx';
			//GameOverSubstate.loopSoundName = 'gameOver';
			//GameOverSubstate.endSoundName = 'gameOverEnd';
			GameOverSubstate.characterName = 'bfOffDay';
		}
		else if (boyfriend.curCharacter != 'bf' && boyfriend.curCharacter != 'bfOpponent') {
			GameOverSubstate.deathSoundName = 'micDrop';
			//GameOverSubstate.loopSoundName = 'gameOver';
			//GameOverSubstate.endSoundName = 'gameOverEnd';
			GameOverSubstate.characterName = 'chaseGameOver';
		}
		
		if (curStage == 'chaseDeskBg') {
			boyfriend.alpha = 0;
					
			var camX = (dad.x + dad.width / 2) + 150;
			var camY = (dad.y + dad.height / 2) - 100;
			camX = camX + dad.cameraPosition[0] + opponentCameraOffset[0];
			camY = camY + dad.cameraPosition[1] + opponentCameraOffset[1];

			triggerEventNote('Camera Follow Pos', Std.string(camX), Std.string(camY));
		}
		else if (curStage == 'finaleBg') {
			add(fogOverlay);
		}

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				addBehindGF(fastCar);

			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				addBehindDad(evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set(1, 1);
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000 / Conductor.songPosition;

		strumLine = new FlxSprite((ClientPrefs.middleScroll || isStepmania) ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set(1, 1);

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set(1, 1);
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set(1, 1);
		timeBarBG.alpha = 0;
		if (handDrawn) timeBarBG.visible = false;
		else timeBarBG.copyVisible = true;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set(1, 1);
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; // How much lag does this cause?? Should i tone it down to, idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime; // SHOWWTIIME. *goofy ahh battle music plays*
		add(timeBar);
		timeBarBG.sprTracker = timeBar;

		timeBarOverlay = new AttachedSprite('timeBarOverlay');
		//timeBarOverlay.x = timeTxt.x;
		//timeBarOverlay.y = timeTxt.y + (timeTxt.height / 4);
		//timeBarOverlay.copyAlpha = false;
		timeBarOverlay.scrollFactor.set(1, 1);
		if (handDrawn)
		{
			timeBarOverlay.copyVisible = true;
			timeBar.setGraphicSize(Std.int(timeBarOverlay.width), Std.int(timeBarOverlay.height - 22 - 2)); // Trim off 11 from the top and 13 from the bottom
			timeBarOverlay.xAdd = -4;
			timeBarOverlay.yAdd = 1;
		}
		else timeBarOverlay.visible = false;
		timeBarOverlay.yAdd += -14;
		//timeBarOverlay.yAdd -= timeBarOverlay.y - timeBar.y;
		//timeBarOverlay.yAdd -= 100;
		timeBarOverlay.sprTracker = timeBar;
		timeBarOverlay.antialiasing = false;
		add(timeBarOverlay);
		add(timeTxt);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);

		// After all characters being loaded, it makes them invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camHUDPos = new FlxObject(FlxG.width * 0.5, FlxG.height * 0.5 - 1, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);
		camHUD.follow(camHUDPos, LOCKON, 1);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection();

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set(1, 1);
		if (handDrawn) healthBarBG.visible = false;
		else healthBarBG.copyVisible = true;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set(1, 1);
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		var donutBlock = new FlxSprite(healthBar.x, healthBar.y, Paths.image('healthBarDither'));
		healthBarDither = new AttachedBar(healthBar.x, healthBar.y - 10, RIGHT_TO_LEFT, Std.int(donutBlock.width), Std.int(donutBlock.height), this, 'health', 0, 2);
		//healthBarDither = new AttachedSprite('healthBarDither');
		healthBarDither.scrollFactor.set(1, 1);
		//healthBarDither.sprTracker = healthBar;
		if (!isFlipnote)
			healthBarDither.visible = false;
		healthBarDither.antialiasing = false;
		add(healthBarDither);
		//insert(members.indexOf(healthBar), healthBarDither);
		donutBlock.destroy();

		healthBarOverlay = new AttachedSprite('healthBarOverlay');
		healthBarOverlay.scrollFactor.set(1, 1);
		if (handDrawn)
		{
			healthBarOverlay.copyVisible = true;
			healthBar.setGraphicSize(Std.int(healthBarOverlay.width) - 2, Std.int(healthBarOverlay.height - 20 - 1)); // Trim off 10 from the top and 11 from the bottom
			healthBarOverlay.xAdd = -4;
			healthBarOverlay.yAdd = -1;
		}
		else healthBarOverlay.visible = false;
		healthBarOverlay.yAdd += -14;
		healthBarOverlay.sprTracker = healthBar;
		healthBarOverlay.antialiasing = false;
		add(healthBarOverlay);
		//healthBarDither.y = healthBarOverlay.y;
		//healthBarDither.clipRect = new FlxRect(4, 15, healthBarOverlay.width - 2, healthBarOverlay.height - 20 - 1);
		healthBarDither.sprTracker = healthBarOverlay;
		
		//changeIcon('boyfriend2', boyfriend2.healthIcon);
		if (!HealthIcon.hasWinningIcon(boyfriend2.healthIcon))
			iconP1b = new HealthIcon(boyfriend2.healthIcon, !flipHealthBar);
		else // Found it! :D
			iconP1b = new CoolIcon(boyfriend2.healthIcon, !flipHealthBar);
		iconP1b.y = healthBar.y - 75;
		iconP1b.visible = !ClientPrefs.hideHud;
		iconP1b.alpha = ClientPrefs.healthBarAlpha;
		//iconP1b.scrollFactor.set(1, 1);
		add(iconP1b);

		//changeIcon('dad2', dad2.healthIcon);
		if (!HealthIcon.hasWinningIcon(dad2.healthIcon))
			iconP2b = new HealthIcon(dad2.healthIcon, flipHealthBar);
		else // Found it! :D
			iconP2b = new CoolIcon(dad2.healthIcon, flipHealthBar);
		iconP2b.y = healthBar.y - 75;
		iconP2b.visible = !ClientPrefs.hideHud;
		iconP2b.alpha = ClientPrefs.healthBarAlpha;
		//iconP2b.scrollFactor.set(1, 1);
		add(iconP2b);

		/*var iconFile:String = 'winningIcons/' + boyfriend.healthIcon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'winningIcons/icon-' + boyfriend.healthIcon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'Qw33goorpps'; // Nobody would put this guy in a mod
		if (iconFile == 'Qw33goorpps') // Given up on loading a winning icon*/
		if (!HealthIcon.hasWinningIcon(boyfriend.healthIcon))
			iconP1 = new HealthIcon(boyfriend.healthIcon, !flipHealthBar);
		else // Found it! :D
			iconP1 = new CoolIcon(boyfriend.healthIcon, !flipHealthBar);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		//iconP1.scrollFactor.set(1, 1);
		add(iconP1);

		/*var iconFile:String = 'winningIcons/' + dad.healthIcon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'winningIcons/icon-' + dad.healthIcon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'Qw33goorpps'; // Nobody would put this guy in a mod
		if (iconFile == 'Qw33goorpps') // Given up on loading a winning icon*/
		if (!HealthIcon.hasWinningIcon(dad.healthIcon))
			iconP2 = new HealthIcon(dad.healthIcon, flipHealthBar);
		else // Found it! :D
			iconP2 = new CoolIcon(dad.healthIcon, flipHealthBar);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		//iconP2.scrollFactor.set(1, 1);
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set(1, 1);
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.text = getBotplayText(SONG.song);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set(1, 1);
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}
		
		stepmaniaBg = new FlxSprite(0, 0, Paths.image('menuDesat'));
		stepmaniaBg.color = 0xFF222222;
		if (isStepmania)
		{
			insert(members.indexOf(timeBarBG), stepmaniaBg);
			iconP1.alpha = 0;
			iconP1b.alpha = 0;
			iconP2.alpha = 0;
			iconP2b.alpha = 0;
		}
		
		//insert(members.indexOf(botplayTxt) + 1, songInfoGroup);
		add(songInfoGroup);

		//var chaseGameOver:ModchartSprite = new ModchartSprite(400 - (FlxG.width / 2), 100 - (FlxG.height / 2));
		var chaseGameOver:ModchartSprite = new ModchartSprite(-100, -400);
		modchartSprites.set('chaseGameOver', chaseGameOver);
		//sourceLua.loadFrames(chaseGameOver, 'characters/chaseGameOver', 'sparrow');
		chaseGameOver.frames = Paths.getSparrowAtlas('characters/chaseGameOver');
		chaseGameOver.scale.set(3, 3);
		chaseGameOver.updateHitbox();
		chaseGameOver.antialiasing = false;
		chaseGameOver.animation.addByPrefix('open', 'Mouth Open', 24, true);
		chaseGameOver.animation.addByPrefix('closed', 'Mouth Closed', 24, true);
		chaseGameOver.animation.play('open');
		//chaseGameOver.scrollFactor.set(0, 0);
		chaseGameOver.alpha = 0;
		
		stepmaniaBg.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarDither.cameras = [camHUD];
		healthBarOverlay.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP1b.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		iconP2b.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarOverlay.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		songInfoGroup.cameras = [camHUD];
		doof.cameras = [camHUD];
		chaseGameOver.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		for (event in eventPushedMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_events/' + event + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + Paths.formatToSongPath(SONG.song) + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		
		missLimit = -1;
		dadHealthGain = 0;
		if (SONG.song == 'Defeat Unfair')
			missLimit = 5;
		else if (SONG.song == 'Alacrity')
			missLimit = 100;
		else if (SONG.song == 'Overcast Overview')
			dadHealthGain = 0.33;
		else if (songNameNoDiff == 'Get Back Here!')
		{
			cheatingPossible = true;
			debugKeysChart[0] = FlxKey.SIX;
		}


		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					if(gf != null) gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);

				case 'ugh' | 'guns' | 'stress':
					tankIntro();

				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		precacheList.set('missnote1', 'sound');
		precacheList.set('missnote2', 'sound');
		precacheList.set('missnote3', 'sound');

		if (PauseSubState.songName != null) {
			precacheList.set(PauseSubState.songName, 'music');
		} else if(ClientPrefs.pauseMusic != 'None') {
			precacheList.set(Paths.formatToSongPath(ClientPrefs.pauseMusic), 'music');
		}

		precacheList.set('alphabet', 'image');
	
		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		callOnLuas('onCreatePost', []);

		#if desktop
		if (inGallery)
		{
			// Updating Discord Rich Presence (Gallery)
			DiscordClient.changePresence('Gallery', 'Currently Viewing: ' + galleryImageName + '.png', 'amongmongmongmongus', null, null, getLogoName(dad.curCharacter));
		}
		#end

		super.create();

		cacheCountdown();
		cachePopUpScore();
		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}
		Paths.clearUnusedMemory();
		
		CustomFadeTransition.nextCamera = camOther;
		
		/*var mosaicSprite = new FlxSprite(-3000, -3000).makeGraphic(6000, 6000, 0x88000000);
		add(mosaicSprite);

		var mosaic = new MosaicEffect();
		mosaicSprite.shader = mosaic.shader;
		mosaic.setStrength(1.5 * camGame.zoom, 1.5 * camGame.zoom);*/

		//var mosaic = new MosaicShader(3, 3);
		//mosaic.setStrength(1.5 * camGame.zoom, 1.5 * camGame.zoom);
		//camGame.setFilters([new ShaderFilter(mosaic)]);
		
		if (isFlipnote && ClientPrefs.shaders) {
			flipnoteShader = new FlipnoteDitherShader();
			flipnoteShader.hueShift.value = [0];
			flipnoteShader.ditheringSize.value = [3];

			camGame.setFilters([new ShaderFilter(flipnoteShader)]);
			camHUD.setFilters([new ShaderFilter(flipnoteShader)]);
			camOther.setFilters([new ShaderFilter(flipnoteShader)]);
			//dad.shader = flipnoteShader;
		}

		//Highscore.saveSongVisited(Paths.formatToSongPath(curSong.replace(' ' + remixDiffName, '')), true);
		Highscore.saveSongVisited(Paths.formatToSongPath(songNameNoDiff), true);

		//FlxG.mouse.visible = true;
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));
		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes) note.resizeByRatio(ratio);
			for (note in unspawnNotes) note.resizeByRatio(ratio);
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	function set_playbackRate(value:Float):Float
	{
		if(generatedMusic)
		{
			if(vocals != null) vocals.pitch = value;
			FlxG.sound.music.pitch = value;
		}
		playbackRate = value;
		FlxAnimationController.globalSpeed = value;
		trace('Anim speed: ' + FlxAnimationController.globalSpeed);
		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000 * value;
		setOnLuas('playbackRate', playbackRate);
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		//var noDitherGraphic:FlxGraphic = Paths.image('healthBarDitherEmpty');
		//var noDitherGraphic:FlxGraphic = null;
		//var p1Graphic:FlxGraphic = getDitherGraphic(SONG.player1, noDitherGraphic);
		//var p2Graphic:FlxGraphic = getDitherGraphic(SONG.player2, noDitherGraphic);
		/*var p1Dither:Bool = charUsesDither(SONG.player1);
		var p2Dither:Bool = charUsesDither(SONG.player2);
		//trace((p1Graphic != null) + ', ' + (p2Graphic != null));
		//if (p1Graphic != noDitherGraphic || p2Graphic != noDitherGraphic)
		if (p1Dither || p2Dither)
		{
			healthBarDither.copyVisible = true;
			//healthBarDither.color = 0xFF000000;
			healthBarDither.color = 0xFFFF0000;
			//healthBarDither.createImageBar(p2Graphic, p1Graphic, 0xFF00FF00, 0xFF0000FF);
		}
		else
		{
			healthBarDither.copyVisible = false;
			healthBarDither.visible = false;
		}*/

		//healthBarDither.updateBar();
		var p1Color:FlxColor;
		var p2Color:FlxColor;
		/*if (flipHealthBar)
		{
			p1Color = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
			p2Color = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
		}
		else
		{*/
			p1Color = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
			p2Color = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
		//}
		//if (p1Dither) p1Color == 0x00000000;
		//if (p2Dither) p2Color == 0x00000000;
		//trace(p1Dither + ', ' + p2Dither);
		
		if (isFlipnote)
		{
			//if (curBeat < 280)
			if (!youreBlueNow || ClientPrefs.shaders)
				healthBarDither.color = 0xFFFF0000;
			else
				healthBarDither.color = 0xFF0000FF;
			//healthBar.setGraphicSize(Std.int(healthBarOverlay.width), Std.int(healthBarOverlay.height));
			var ditherPath:String = 'healthBarDither';
			if (ClientPrefs.shaders) ditherPath = 'healthBarDitherShader';
			healthBarDither.createImageBar(Paths.image(ditherPath), Paths.image('healthBarFill'), 0xFFFFFFFF, 0xFFFFFFFF);
			healthBarDither.clipRect = new FlxRect(4, 15, healthBarOverlay.width - 2, healthBarOverlay.height - 20 - 1);
			healthBarDither.visible = true;
		}
		else
		{
			//healthBar.color = 0xFFFFFFFF;
			if (handDrawn)
				healthBar.setGraphicSize(Std.int(healthBarOverlay.width) - 2, Std.int(healthBarOverlay.height - 20 - 1));
			else
				healthBar.setGraphicSize(Std.int(healthBarBG.width) - 8, Std.int(healthBarBG.height - 8));
			//healthBar.createFilledBar(p2Color, p1Color);
			healthBarDither.visible = false;
		}

		//if (!p2Dither)
		//{
			//healthBar.fillDirection = RIGHT_TO_LEFT;
			healthBar.createFilledBar(p2Color, p1Color);
			/*@:privateAccess
			var fraction:Float = (healthBar.value - healthBar.min) / healthBar.range;
			//@:privateAccess
			//var percent:Float = fraction * healthBar._maxPercent;
			@:privateAccess
			var maxScale:Float = (healthBar._fillHorizontal) ? healthBar.barWidth : healthBar.barHeight;
			@:privateAccess
			var scaleInterval:Float = maxScale / healthBar.numDivisions;
			@:privateAccess
			var interval:Float = Math.round(Std.int(fraction * maxScale / scaleInterval) * scaleInterval);
			@:privateAccess
			healthBar._emptyBar = new BitmapData(healthBar.barWidth, healthBar.barHeight, true, 0x00000000);
			@:privateAccess
			healthBar._filledBarRect.width = Std.int(interval);
			@:privateAccess
			healthBar._filledBarRect.height = healthBar.barHeight;
			@:privateAccess
			healthBar.pixels.copyPixels(healthBar._filledBar, healthBar._filledBarRect, healthBar._filledBarPoint, null, null, true);
			healthBar.updateFilledBar();*/
		//}
		//else
		//{
			//healthBar.fillDirection = LEFT_TO_RIGHT;
			//healthBar.createFilledBar(p1Color, p2Color);
		//}

		healthBar.updateBar();
	}

	/*public function getDitherGraphic(?char:String = 'boyfriend', ?emptyGraphic:FlxGraphic = null)
	{
		//var ditherGraphic:FlxGraphic = Paths.image('healthBarDither');
		if (char == 'chaseFlipnoteRed' || char == 'chaseFlipnoteBlue')
		{
			//return ditherGraphic;
			return Paths.image('healthBarDither');
		}
		//return null;
		//return Paths.image('healthBarDitherEmpty');
		return emptyGraphic;
	}*/

	public function charUsesDither(?char:String = 'boyfriend')
	{
		return (char == 'chaseFlipnoteRed' || char == 'chaseFlipnoteBlue');
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					newBoyfriend.addLegs(boyfriendGroup);
					boyfriendGroup.add(newBoyfriend);
					if (newBoyfriend.legType == 'amongUs')
					{
						boyfriendGroup.remove(newBoyfriend.legs, true);
						newBoyfriend.addLegs(boyfriendGroup);
					}
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					newDad.addLegs(dadGroup);
					dadGroup.add(newDad);
					if (newDad.legType == 'amongUs')
					{
						dadGroup.remove(newDad.legs, true);
						newDad.addLegs(dadGroup);
					}
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}

			case 3:
				if(!boyfriend2Map.exists(newCharacter)) {
					var newBoyfriend2:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriend2Map.set(newCharacter, newBoyfriend2);
					newBoyfriend2.addLegs(boyfriend2Group);
					boyfriend2Group.add(newBoyfriend2);
					if (newBoyfriend2.legType == 'amongUs')
					{
						boyfriend2Group.remove(newBoyfriend2.legs, true);
						newBoyfriend2.addLegs(boyfriend2Group);
					}
					startCharacterPos(newBoyfriend2);
					newBoyfriend2.alpha = 0.00001;
					startCharacterLua(newBoyfriend2.curCharacter);
				}
				
			case 4:
				if(!dad2Map.exists(newCharacter)) {
					var newDad2:Character = new Character(0, 0, newCharacter);
					dad2Map.set(newCharacter, newDad2);
					newDad2.addLegs(dad2Group);
					dad2Group.add(newDad2);
					if (newDad2.legType == 'amongUs')
					{
						dad2Group.remove(newDad2.legs, true);
						newDad2.addLegs(dad2Group);
					}
					startCharacterPos(newDad2, true);
					newDad2.alpha = 0.00001;
					startCharacterLua(newDad2.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (script in luaArray)
			{
				if(script.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
		if(modchartSprites.exists(tag)) return modchartSprites.get(tag);
		if(text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
		if(variables.exists(tag)) return variables.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			startAndEnd();
			return;
		}

		var video:MP4Handler = new MP4Handler();
		//video.volume = FlxG.sound.volume + 0.4;
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			startAndEnd();
			//callOnLuas('onVideoEnd', [name]); // Last soap for the dialogue to work again I swear // Edit: You are not needed
			return;
		}
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set(1, 1);
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function tankIntro()
	{
		var cutsceneHandler:CutsceneHandler = new CutsceneHandler();

		var songName:String = Paths.formatToSongPath(SONG.song);
		dadGroup.alpha = 0.00001;
		camHUD.visible = false;
		//inCutscene = true; //this would stop the camera movement, oops

		var tankman:FlxSprite = new FlxSprite(-20, 320);
		tankman.frames = Paths.getSparrowAtlas('cutscenes/' + songName);
		tankman.antialiasing = ClientPrefs.globalAntialiasing;
		addBehindDad(tankman);
		cutsceneHandler.push(tankman);

		var tankman2:FlxSprite = new FlxSprite(16, 312);
		tankman2.antialiasing = ClientPrefs.globalAntialiasing;
		tankman2.alpha = 0.000001;
		cutsceneHandler.push(tankman2);
		var gfDance:FlxSprite = new FlxSprite(gf.x - 107, gf.y + 140);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(gfDance);
		var gfCutscene:FlxSprite = new FlxSprite(gf.x - 104, gf.y + 122);
		gfCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(gfCutscene);
		var picoCutscene:FlxSprite = new FlxSprite(gf.x - 849, gf.y - 264);
		picoCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(picoCutscene);
		var boyfriendCutscene:FlxSprite = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
		boyfriendCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		cutsceneHandler.push(boyfriendCutscene);

		cutsceneHandler.finishCallback = function()
		{
			var timeForStuff:Float = Conductor.crochet / 1000 * 4.5;
			FlxG.sound.music.fadeOut(timeForStuff);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
			moveCamera(true);
			startCountdown();

			dadGroup.alpha = 1;
			camHUD.visible = true;
			boyfriend.animation.finishCallback = null;
			gf.animation.finishCallback = null;
			gf.dance();
		};

		camFollow.set(dad.x + 280, dad.y + 170);
		switch(songName)
		{
			case 'ugh':
				cutsceneHandler.endTime = 12;
				cutsceneHandler.music = 'DISTORTO';
				precacheList.set('wellWellWell', 'sound');
				precacheList.set('killYou', 'sound');
				precacheList.set('bfBeep', 'sound');

				var wellWellWell:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wellWellWell'));
				FlxG.sound.list.add(wellWellWell);

				tankman.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
				tankman.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
				tankman.animation.play('wellWell', true);
				FlxG.camera.zoom *= 1.2;

				// Well well well, what do we got here?
				cutsceneHandler.timer(0.1, function()
				{
					wellWellWell.play(true);
				});

				// Move camera to BF
				cutsceneHandler.timer(3, function()
				{
					camFollow.x += 750;
					camFollow.y += 100;
				});

				// Beep!
				cutsceneHandler.timer(4.5, function()
				{
					boyfriend.playAnim('singUP', true);
					boyfriend.specialAnim = true;
					FlxG.sound.play(Paths.sound('bfBeep'));
				});

				// Move camera to Tankman
				cutsceneHandler.timer(6, function()
				{
					camFollow.x -= 750;
					camFollow.y -= 100;

					// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
					tankman.animation.play('killYou', true);
					FlxG.sound.play(Paths.sound('killYou'));
				});

			case 'guns':
				cutsceneHandler.endTime = 11.5;
				cutsceneHandler.music = 'DISTORTO';
				tankman.x += 40;
				tankman.y += 10;
				precacheList.set('tankSong2', 'sound');

				var tightBars:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tankSong2'));
				FlxG.sound.list.add(tightBars);

				tankman.animation.addByPrefix('tightBars', 'TANK TALK 2', 24, false);
				tankman.animation.play('tightBars', true);
				boyfriend.animation.curAnim.finish();

				cutsceneHandler.onStart = function()
				{
					tightBars.play(true);
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
				};

				cutsceneHandler.timer(4, function()
				{
					gf.playAnim('sad', true);
					gf.animation.finishCallback = function(name:String)
					{
						gf.playAnim('sad', true);
					};
				});

			case 'stress':
				cutsceneHandler.endTime = 35.5;
				tankman.x -= 54;
				tankman.y -= 14;
				gfGroup.alpha = 0.00001;
				boyfriendGroup.alpha = 0.00001;
				camFollow.set(dad.x + 400, dad.y + 170);
				FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2}, 1, {ease: FlxEase.quadInOut});
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.y += 100;
				});
				precacheList.set('stressCutscene', 'sound');

				tankman2.frames = Paths.getSparrowAtlas('cutscenes/stress2');
				addBehindDad(tankman2);

				if (!ClientPrefs.lowQuality)
				{
					gfDance.frames = Paths.getSparrowAtlas('characters/gfTankmen');
					gfDance.animation.addByPrefix('dance', 'GF Dancing at Gunpoint', 24, true);
					gfDance.animation.play('dance', true);
					addBehindGF(gfDance);
				}

				gfCutscene.frames = Paths.getSparrowAtlas('cutscenes/stressGF');
				gfCutscene.animation.addByPrefix('dieBitch', 'GF STARTS TO TURN PART 1', 24, false);
				gfCutscene.animation.addByPrefix('getRektLmao', 'GF STARTS TO TURN PART 2', 24, false);
				gfCutscene.animation.play('dieBitch', true);
				gfCutscene.animation.pause();
				addBehindGF(gfCutscene);
				if (!ClientPrefs.lowQuality)
				{
					gfCutscene.alpha = 0.00001;
				}

				picoCutscene.frames = AtlasFrameMaker.construct('cutscenes/stressPico');
				picoCutscene.animation.addByPrefix('anim', 'Pico Badass', 24, false);
				addBehindGF(picoCutscene);
				picoCutscene.alpha = 0.00001;

				boyfriendCutscene.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
				boyfriendCutscene.animation.addByPrefix('idle', 'BF idle dance', 24, false);
				boyfriendCutscene.animation.play('idle', true);
				boyfriendCutscene.animation.curAnim.finish();
				addBehindBF(boyfriendCutscene);

				var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('stressCutscene'));
				FlxG.sound.list.add(cutsceneSnd);

				tankman.animation.addByPrefix('godEffingDamnIt', 'TANK TALK 3', 24, false);
				tankman.animation.play('godEffingDamnIt', true);

				var calledTimes:Int = 0;
				var zoomBack:Void->Void = function()
				{
					var camPosX:Float = 630;
					var camPosY:Float = 425;
					camFollow.set(camPosX, camPosY);
					camFollowPos.setPosition(camPosX, camPosY);
					FlxG.camera.zoom = 0.8;
					cameraSpeed = 1;

					calledTimes++;
					if (calledTimes > 1)
					{
						foregroundSprites.forEach(function(spr:BGSprite)
						{
							spr.y -= 100;
						});
					}
				}

				cutsceneHandler.onStart = function()
				{
					cutsceneSnd.play(true);
				};

				cutsceneHandler.timer(15.2, function()
				{
					FlxTween.tween(camFollow, {x: 650, y: 300}, 1, {ease: FlxEase.sineOut});
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 2.25, {ease: FlxEase.quadInOut});

					gfDance.visible = false;
					gfCutscene.alpha = 1;
					gfCutscene.animation.play('dieBitch', true);
					gfCutscene.animation.finishCallback = function(name:String)
					{
						if(name == 'dieBitch') //Next part
						{
							gfCutscene.animation.play('getRektLmao', true);
							gfCutscene.offset.set(224, 445);
						}
						else
						{
							gfCutscene.visible = false;
							picoCutscene.alpha = 1;
							picoCutscene.animation.play('anim', true);

							boyfriendGroup.alpha = 1;
							boyfriendCutscene.visible = false;
							boyfriend.playAnim('bfCatch', true);
							boyfriend.animation.finishCallback = function(name:String)
							{
								if(name != 'idle')
								{
									boyfriend.playAnim('idle', true);
									boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
								}
							};

							picoCutscene.animation.finishCallback = function(name:String)
							{
								picoCutscene.visible = false;
								gfGroup.alpha = 1;
								picoCutscene.animation.finishCallback = null;
							};
							gfCutscene.animation.finishCallback = null;
						}
					};
				});

				cutsceneHandler.timer(17.5, function()
				{
					zoomBack();
				});

				cutsceneHandler.timer(19.5, function()
				{
					tankman2.animation.addByPrefix('lookWhoItIs', 'TANK TALK 3', 24, false);
					tankman2.animation.play('lookWhoItIs', true);
					tankman2.alpha = 1;
					tankman.visible = false;
				});

				cutsceneHandler.timer(20, function()
				{
					camFollow.set(dad.x + 500, dad.y + 170);
				});

				cutsceneHandler.timer(31.2, function()
				{
					boyfriend.playAnim('singUPmiss', true);
					boyfriend.animation.finishCallback = function(name:String)
					{
						if (name == 'singUPmiss')
						{
							boyfriend.playAnim('idle', true);
							boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
						}
					};

					camFollow.set(boyfriend.x + 280, boyfriend.y + 200);
					cameraSpeed = 12;
					FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 0.25, {ease: FlxEase.elasticOut});
				});

				cutsceneHandler.timer(32.2, function()
				{
					zoomBack();
				});
		}
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		if (handDrawn) {
			var prefix:String = 'nutshellUi/';
			if (isFlipnote)
				prefix = 'nutshellUi/flipnote/';
			introAssets.set('default', [prefix + 'ready', prefix + 'set', prefix + 'go']);
			introAssets.set('pixel', [prefix + 'ready', prefix + 'set', prefix + 'date']);
			
			Paths.sound('intro3' + introSoundsSuffix);
			Paths.sound('intro2' + introSoundsSuffix);
			Paths.sound('intro1' + introSoundsSuffix);
			if (isPixelStage)
				Paths.sound('introGo-why');
			else
				Paths.sound('introGo' + introSoundsSuffix);
		}
		else {
			introAssets.set('default', ['ready', 'set', 'go']);
			introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
			
			Paths.sound('intro3' + introSoundsSuffix);
			Paths.sound('intro2' + introSoundsSuffix);
			Paths.sound('intro1' + introSoundsSuffix);
			Paths.sound('introGo' + introSoundsSuffix);
		}

		var introAlts:Array<String> = introAssets.get('default');
		if (isPixelStage) introAlts = introAssets.get('pixel');
		
		for (asset in introAlts)
			Paths.image(asset);
	}

	public function startCountdown():Void
	{
		if (startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}
		
		/*if (inGallery) {
			return;
		}*/

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', [], false);
		if(ret != FunkinLua.Function_Stop) {
			/*if (missLimit >= 0)
			{
				//trace('Miss Limit: ' + missLimit);
				var missText = new FlxText(0, 0, 2000, 'Don\'t miss more than ' + missLimit + ' times!', 50);
				if (missLimit == 0)
					missText.text = 'Don\'t miss once!';
				else if (missLimit == 1)
					missText.text = 'Don\'t miss more than ' + missLimit + ' time!';
				missText.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				missText.scrollFactor.set(1, 1);
				missText.alignment = CENTER;
				missText.borderSize = 2;
				missText.screenCenter();
				missText.alpha = 0;
				missText.cameras = [camOther];
				infoTweens.set('missTextFadeIn', FlxTween.tween(missText, {alpha: 1}, 1, {
					ease: FlxEase.linear
				}));
				infoTweens.set('missTextScale', FlxTween.tween(missText.scale, {x: 1.5, y: 1.5}, 5, {
					ease: FlxEase.linear
				}));
				infoTimers.set('missTextTimer', new FlxTimer().start(4, function(tmr:FlxTimer) {
					infoTweens.set('missTextFadeOut', FlxTween.tween(missText, {alpha: 0}, 1, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							missText.destroy();
						}
					}));
				}));
				add(missText);
			}*/

			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = -Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000 / playbackRate, function(tmr:FlxTimer)
			{
				/*if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
				{
					boyfriend2.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}
				if (tmr.loopsLeft % dad2.danceEveryNumBeats == 0 && dad2.animation.curAnim != null && !dad2.animation.curAnim.name.startsWith('sing') && !dad2.stunned)
				{
					dad2.dance();
				}*/

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				if (handDrawn) {
					var prefix:String = 'nutshellUi/';
					if (isFlipnote)
						prefix = 'nutshellUi/flipnote/';
					introAssets.set('default', [prefix + 'ready', prefix + 'set', prefix + 'go']);
					introAssets.set('pixel', [prefix + 'ready', prefix + 'set', prefix + 'date']);
				}
				else {
					introAssets.set('default', ['ready', 'set', 'go']);
					introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
				}

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if (isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}
				else if (handDrawn) {
					antialias = false;
				}

				// head bopping for bg characters on Mall
				/*if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);

					bottomBoppers.dance(true);
					santa.dance(true);
				}*/

				dance(tmr.loopsLeft); // At first I thought the biggest EXE was probably Scorched or Fatal Error or something, but now I realize it's the FNF executable before this change

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						
						var creditsString = getSongCredits();

						if (creditsString != '') {
							var nowPlaying:FlxText = new FlxText(50, 0, 1000, 'Now Playing:', 30);
							//nowPlaying.alignment = CENTER;
							//nowPlaying.screenCenter(X);
							//nowPlaying.cameras = [camOther];

							var songName = (StringTools.endsWith(SONG.song, ' ' + remixDiffName)) ? (songNameNoDiff + ' [' + remixDiffName + ']') : songNameNoDiff;
							
							var songTitle:FlxText = new FlxText(50, nowPlaying.y + nowPlaying.height + 25, 1000, songName, 75);
							songTitle.autoSize = true;
							songTitle.wordWrap = false;
							//songTitle.alignment = CENTER;
							var textSize = 75;
							//var songHeightDifference:Float = 0;
							if (songTitle.width > 1000)
							{
								//trace('big text');
								//songHeightDifference = songTitle.height;
								textSize = Std.int(75 / (songTitle.width / 1000));
								//songHeightDifference -= songTitle.height;
								//trace(textSize);
							}
							songTitle.size = textSize;
							//songTitle.screenCenter(X);
							//songTitle.cameras = [camOther];
							
							var creditsText:FlxText = new FlxText(50, songTitle.y + songTitle.height + 25, 1000, creditsString, 30);
							//creditsText.alignment = CENTER;
							//creditsText.screenCenter(X);
							//creditsText.cameras = [camOther];

							var songInfoBg:FlxSprite = new FlxSprite(nowPlaying.x - 50, nowPlaying.y - 50);
							songInfoBg.makeGraphic(Std.int(Math.max(nowPlaying.textField.textWidth, Math.max(songTitle.textField.textWidth, creditsText.textField.textWidth)) + 100),
							Std.int(creditsText.y + creditsText.height - songInfoBg.y + 50), 0x80000000);

							songInfoGroup.scrollFactor.set(1, 1);
							songInfoGroup.add(songInfoBg);
							songInfoGroup.add(nowPlaying);
							songInfoGroup.add(songTitle);
							songInfoGroup.add(creditsText);

							songInfoGroup.screenCenter(Y);
							songInfoGroup.y += 50;
							//songInfoGroup.x += FlxG.width * 0.25;
							var onscreenX = songInfoGroup.x;
							songInfoGroup.x -= 1500;
							var offscreenX = songInfoGroup.x;
							
							modchartTweens.set('songInfoIn', FlxTween.tween(songInfoGroup, {x: onscreenX}, 1, {
								ease: FlxEase.sineIn,
								onComplete: function(twn:FlxTween) {
									PlayState.instance.callOnLuas('onTweenCompleted', ['songInfoIn']);
									PlayState.instance.modchartTweens.remove('songInfoIn');
									modchartTimers.set('songInfoWait', new FlxTimer().start(5, function(tmr:FlxTimer) {
										modchartTweens.set('songInfoOut', FlxTween.tween(songInfoGroup, {x: offscreenX}, 1, {
											ease: FlxEase.sineIn,
											//startDelay: 5,
											onComplete: function(twn:FlxTween) {
												PlayState.instance.callOnLuas('onTweenCompleted', ['songInfoOut']);
												PlayState.instance.modchartTweens.remove('songInfoOut');
												songInfoBg.destroy();
												nowPlaying.destroy();
												songTitle.destroy();
												creditsText.destroy();
												songInfoGroup.destroy();
											}
										}));
									}));
								}
							}));
						}
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.cameras = [camHUD];
						countdownReady.scrollFactor.set(1, 1);
						countdownReady.updateHitbox();

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						insert(members.indexOf(notes), countdownReady);
						FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.cameras = [camHUD];
						countdownSet.scrollFactor.set(1, 1);

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						insert(members.indexOf(notes), countdownSet);
						FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.cameras = [camHUD];
						countdownGo.scrollFactor.set(1, 1);

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						insert(members.indexOf(notes), countdownGo);
						FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						if (isPixelStage && handDrawn)
							FlxG.sound.play(Paths.sound('introGo-why'), 0.6);
						else
							FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
				}

				notes.forEachAlive(function(note:Note) {
					if(ClientPrefs.opponentStrums || note.mustPress)
					{
						note.copyAlpha = false;
						note.alpha = note.multAlpha;
						if (isStepmania && !note.mustPress)
							note.alpha = 0;
						else if (ClientPrefs.middleScroll && !note.mustPress) {
							note.alpha *= 0.35;
						}
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad (obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function updateScore(miss:Bool = false)
	{
		scoreTxt.text = 'Score: ' + songScore
		+ ' | Misses: ' + songMisses + (missLimit >= 0 ? ' / ' + missLimit : '')
		+ ' | Rating: ' + ratingName
		+ (ratingName != '?' ? ' (${Highscore.floorDecimal(ratingPercent * 100, 2)}%) - $ratingFC' : '');

		if(ClientPrefs.scoreZoom && !miss && !cpuControlled)
		{
			if(scoreTxtTween != null) {
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.075;
			scoreTxt.scale.y = 1.075;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});
		}
		callOnLuas('onUpdateScore', [miss]);
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.play();

		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = time;
			vocals.pitch = playbackRate;
		}
		vocals.play();
		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.onComplete = finishSong.bind();
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		switch(curStage)
		{
			case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		if (!inGallery)
			DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), true, songLength, getLogoName(dad.curCharacter));
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype', 'multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		vocals.pitch = playbackRate;
		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts

				swagNote.scrollFactor.set(1, 1);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set(1, 1);
						swagNote.tail.push(sustainNote);
						sustainNote.parent = swagNote;
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if (ClientPrefs.middleScroll || isStepmania)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll || isStepmania)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					case 'bf2' | 'boyfriend2' | '3':
						charType = 3;
					case 'dad2' | 'opponent2' | '4':
						charType = 4;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				if (isFlipnote && ClientPrefs.shaders)
					newCharacter = getFlipnoteShaderString(newCharacter);
				else if (isFlipnote)
					newCharacter = getFlipnoteNoShaderString(newCharacter);
				addCharacterToList(newCharacter, charType);

			case 'Dadbattle Spotlight':
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;

				dadbattleSmokes.alpha = 0.7;
				dadbattleSmokes.blend = ADD;
				dadbattleSmokes.visible = false;
				add(dadbattleLight);
				add(dadbattleSmokes);

				var offsetX = 200;
				var smoke:BGSprite = new BGSprite('smoke', -1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(15, 22);
				smoke.active = true;
				dadbattleSmokes.add(smoke);
				var smoke:BGSprite = new BGSprite('smoke', 1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(-15, -22);
				smoke.active = true;
				smoke.flipX = true;
				dadbattleSmokes.add(smoke);


			case 'Philly Glow':
				blammedLightsBlack = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blammedLightsBlack.visible = false;
				insert(members.indexOf(phillyStreet), blammedLightsBlack);

				phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
				phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 0.85));
				phillyWindowEvent.updateHitbox();
				phillyWindowEvent.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);


				phillyGlowGradient = new PhillyGlow.PhillyGlowGradient(-400, 225); //This shit was refusing to properly load FlxGradient so fuck it
				phillyGlowGradient.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);
				if(!ClientPrefs.flashing) phillyGlowGradient.intendedAlpha = 0.7;

				precacheList.set('philly/particle', 'image'); //precache particle image
				phillyGlowParticles = new FlxTypedGroup<PhillyGlow.PhillyGlowParticle>();
				phillyGlowParticles.visible = false;
				insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);

			case 'Throw Snowball' | 'Pack Snowball':
				/*dad.animation.finishCallback = function(name:String) {
					if (name == 'throw' || name == 'pack')
					{
						dad.specialAnim = false;
						dad.singDisabled = false;
					}
				};*/
				/*boyfriend.animation.finishCallback = function(name:String) {
					if (name == 'snowballImpact')
					{
						boyfriend.specialAnim = false;
						boyfriend.singDisabled = false;
						boyfriend.stunned = false;
					}
				};*/
				CoolUtil.precacheSound('snowPack');
				CoolUtil.precacheSound('swish');
				CoolUtil.precacheSound('snowballImpact');
			case 'Fake Bluescreen':
				precacheList.set(songSpriteDir + 'bsodNormal', 'image');
				precacheList.set(songSpriteDir + 'bsodHunger', 'image');
				precacheList.set(stageDir + 'blackVoid', 'image');
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.opponentStrums || isStepmania) targetAlpha = 0;
				else if(ClientPrefs.middleScroll) targetAlpha = 0.35;
			}

			var babyArrow:StrumNote = new StrumNote((ClientPrefs.middleScroll || isStepmania) ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll || isStepmania)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			for (tween in infoTweens) {
				tween.active = false;
			}
			for (timer in infoTimers) {
				timer.active = false;
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}
			
			for (tween in infoTweens) {
				tween.active = true;
			}
			for (timer in infoTimers) {
				timer.active = true;
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}

			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (!inGallery)
			{
				if (startTimer != null && startTimer.finished)
				{
					DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset, getLogoName(dad.curCharacter));
				}
				else
				{
					DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
				}
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused && !inGallery)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset, getLogoName(dad.curCharacter));
			}
			else
			{
				DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused && !inGallery)
		{
			DiscordClient.changePresence(detailsPausedText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		FlxG.sound.music.pitch = playbackRate;
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
			vocals.pitch = playbackRate;
		}
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		callOnLuas('onUpdate', [elapsed]);
		boyfriend.updateRunAnim();
		dad.updateRunAnim();
		if (gf != null)
			gf.updateRunAnim();
		boyfriend2.updateRunAnim();
		dad2.updateRunAnim();

		switch (curStage)
		{
			case 'tank':
				moveTank(elapsed);
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;

				if(phillyGlowParticles != null)
				{
					var i:Int = phillyGlowParticles.members.length-1;
					while (i > 0)
					{
						var particle = phillyGlowParticles.members[i];
						if(particle.alpha < 0)
						{
							particle.kill();
							phillyGlowParticles.remove(particle, true);
							particle.destroy();
						}
						--i;
					}
				}
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 170) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed * playbackRate, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		setOnLuas('curDecStep', curDecStep);
		setOnLuas('curDecBeat', curDecBeat);

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && (startedCountdown || inGallery) && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', [], false);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}

		if (cheatingPossible && !pressedDebug && FlxG.keys.anyJustPressed([FlxKey.SEVEN])) {
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			
			openSubState(new BlankSubState());
			
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.scrollFactor.set();
			add(bg);
			bg.cameras = [camOther];
	
			var textSpr = new FlxText(0, 0, 2000, 'You should\'ve pressed 6.', 50, false);
			textSpr.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF880000);
			textSpr.borderSize = 5;
			textSpr.screenCenter();
			add(textSpr);
			textSpr.cameras = [camOther];
	
			var textScale = FlxTween.tween(textSpr.scale, {x: 2, y: 2}, 10);
			new FlxTimer().start(5, function(tmr:FlxTimer) {
				textScale.cancel();
				PlayState.sourceLua.loadSong('alacrity', 2);
			});

			//debugKeysChart[0] = FlxKey.SIX;
		}
		else if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene) {
			openChartEditor();
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		
		//if (fogOverlay != null)
		fogOverlay.alpha = FlxMath.lerp(fogAlpha, fogOverlay.alpha, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		/*if (fog1 != null)
		{
			fog1.alpha = fogOverlay.alpha * 0.5;
			fog2.alpha = fogOverlay.alpha * 0.5;
			fog3.alpha = fogOverlay.alpha * 0.5;
		}*/

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP1b.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP1b.scale.set(mult, mult);
		iconP1b.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2b.scale.x, CoolUtil.boundTo(1 - (elapsed * 9 * playbackRate), 0, 1));
		iconP2b.scale.set(mult, mult);
		iconP2b.updateHitbox();

		var iconOffset:Int = 26;

		if (flipHealthBar) {
			iconP1.x = healthBar.x + (healthBar.width * (healthBar.percent * 0.01)) - (150 * iconP1.scale.x) / 2 - iconOffset * 2;
			iconP1b.x = iconP1.x - 100;
			iconP2.x = healthBar.x + (healthBar.width * (healthBar.percent * 0.01)) + (150 * iconP2.scale.x - 150) / 2 - iconOffset;
			iconP2b.x = iconP2.x + 100;
		}
		else {
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
			iconP1b.x = iconP1.x + 100;
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
			iconP2b.x = iconP2.x - 100;
		}

		if (health > 2)
			health = 2;

		// Dum stupid code does not support animated icons
		/*if (healthBar.percent < 20)
			//iconP1.animation.curAnim.curFrame = 1;
		else
			//iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			//iconP2.animation.curAnim.curFrame = 1;
		else
			//iconP2.animation.curAnim.curFrame = 0;*/

		if (healthBar.percent < 20) {
			iconP1.losingAnim();
			iconP1b.losingAnim();
			iconP2.winningAnim();
			iconP2b.winningAnim();
			//trace(iconP1.animation.curAnim.name + ', ' + iconP1.animation.curAnim.finished);
			//trace('lousy');
		}
		else if (healthBar.percent > 80) {
			iconP1.winningAnim();
			iconP1b.winningAnim();
			iconP2.losingAnim();
			iconP2b.losingAnim();
		}
		else {
			iconP1.neutralAnim();
			iconP1b.neutralAnim();
			iconP2.neutralAnim();
			iconP2b.neutralAnim();
		}

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));

			setStuffOnExit();
		}

		/*if (FlxG.keys.justPressed.P) {
			clearNotesBefore(songLength - 1);
			setSongTime(songLength - 1);
		}*/
		
		if (startedCountdown)
		{
			Conductor.songPosition += FlxG.elapsed * 1000 * playbackRate;
		}

		if (startingSong)
		{
			if (startedCountdown && Conductor.songPosition >= 0)
				startSong();
			else if(!startedCountdown)
				Conductor.songPosition = -Conductor.crochet * 5;
		}
		else
		{
			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			//mosaicZoomPre();
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			//mosaicZoomPost();
		}

		FlxG.watch.addQuick("secShit", curSection);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;
			if(songSpeed < 1) time /= songSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic && !inCutscene)
		{
			if(!cpuControlled) {
				keyShit();
			} else {
				if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
				if(boyfriend2.animation.curAnim != null && boyfriend2.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss')) {
					boyfriend2.dance();
					//boyfriend2.animation.curAnim.finish();
				}
			}

			if(startedCountdown)
			{
				var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
				notes.forEachAlive(function(daNote:Note) // "Recurse:Bool = false" ...fuckfuck
				{
					if ((daNote.noteType == 'Auto Sing' || daNote.noteType == 'Backup Auto Sing')
						&& (daNote.strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * daNote.lateHitMult)
						&& daNote.strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * daNote.earlyHitMult)))
					{
						if (daNote.mustPress)
							autoNoteHitBf(daNote);
						else
							autoNoteHitDad(daNote);
					}

					var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
					if(!daNote.mustPress) strumGroup = opponentStrums;

					var strumX:Float = strumGroup.members[daNote.noteData].x;
					var strumY:Float = strumGroup.members[daNote.noteData].y;
					var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
					var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
					var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
					var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

					strumX += daNote.offsetX;
					strumY += daNote.offsetY;
					strumAngle += daNote.offsetAngle;
					strumAlpha *= daNote.multAlpha;

					if (strumScroll) //Downscroll
					{
						//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
						daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
					}
					else //Upscroll
					{
						//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
						daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
					}

					var angleDir = strumDirection * Math.PI / 180;
					if (daNote.copyAngle)
						daNote.angle = strumDirection - 90 + strumAngle;

					if(daNote.copyAlpha)
						daNote.alpha = strumAlpha;

					if(daNote.copyX)
						daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

					if(daNote.copyY)
					{
						daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

						//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
						if(strumScroll && daNote.isSustainNote)
						{
							if (daNote.animation.curAnim.name.endsWith('end')) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
								} else {
									daNote.y -= 19;
								}
							}
							daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
							daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
						}
					}

					if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
					{
						opponentNoteHit(daNote);
					}

					if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
						if(daNote.isSustainNote) {
							if(daNote.canBeHit) {
								goodNoteHit(daNote);
							}
						} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
							goodNoteHit(daNote);
						}
					}

					var center:Float = strumY + Note.swagWidth / 2;
					if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
						(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						if (strumScroll)
						{
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}

					// Kill extremely late notes and cause misses
					if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
					{
						if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
							noteMiss(daNote);
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}
			else
			{
				notes.forEachAlive(function(daNote:Note)
				{
					daNote.canBeHit = false;
					daNote.wasGoodHit = false;
				});
			}
		}
		checkEventNote();

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end
		
		/*if (!ranUpdate)
		{
			timeBarOverlay.yAdd -= timeBarOverlay.y - timeBar.y;
			ranUpdate = true;
			//trace(timeBar.y + ', ' + timeBarOverlay.y);
		}*/

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function openPauseMenu()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		// 1 / 1000 chance for Gitaroo Man easter egg
		/*if (FlxG.random.bool(0.1))
		{
			// gitaroo man easter egg
			cancelMusicFadeTween();
			MusicBeatState.switchState(new GitarooPause());
		}
		else {*/
		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			vocals.pause();
		}
		pauseScreen = new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y);
		openSubState(pauseScreen);
		//}

		#if desktop
		if (!inGallery)
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
		#end
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		setStuffOnExit();

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true, null, getLogoName(dad.curCharacter));
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead && !inGallery)
		{
			var ret:Dynamic = callOnLuas('onGameOver', [], false);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Dadbattle Spotlight':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;

				switch(Std.parseInt(value1))
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleSmokes.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleSmokes, {alpha: 0}, 1, {onComplete: function(twn:FlxTween)
						{
							dadbattleSmokes.visible = false;
						}});
				}

			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Philly Glow':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var doFlash:Void->Void = function() {
					var color:FlxColor = FlxColor.WHITE;
					if(!ClientPrefs.flashing) color.alphaFloat = 0.5;

					FlxG.camera.flash(color, 0.15, null, true);
				};

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch(lightId)
				{
					case 0:
						if(phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
						}

					case 1: //turn on
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if(!phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if(ClientPrefs.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.25;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						var charColor:FlxColor = color;
						if(!ClientPrefs.flashing) charColor.saturation *= 0.5;
						else charColor.saturation *= 0.75;

						for (who in chars)
						{
							who.color = charColor;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlow.PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						color.brightness *= 0.5;
						phillyStreet.color = color;

					case 2: // spawn particles
						if(!ClientPrefs.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlow.PhillyGlowParticle = new PhillyGlow.PhillyGlowParticle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					case 'bf2' | 'boyfriend2':
						char = boyfriend2;
					case 'dad2' | 'opponent2':
						char = dad2;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				if(camFollow != null)
				{
					var val1:Float = Std.parseFloat(value1);
					var val2:Float = Std.parseFloat(value2);
					if(Math.isNaN(val1)) val1 = 0;
					if(Math.isNaN(val2)) val2 = 0;

					isCameraOnForcedPos = false;
					if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
						camFollow.x = val1;
						camFollow.y = val2;
						isCameraOnForcedPos = true;
					}
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					case 'boyfriend2' | 'bf2':
						char = boyfriend2;
					case 'opponent2' | 'dad2':
						char = dad2;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charName:String = value2;
				if (isFlipnote && ClientPrefs.shaders)
					charName = getFlipnoteShaderString(charName);
				else if (isFlipnote)
					charName = getFlipnoteNoShaderString(charName);

				var charType:Int = 0;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					case 'bf2' | 'boyfriend2':
						charType = 3;
					case 'dad2' | 'opponent2':
						charType = 4;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != charName) {
							if(!boyfriendMap.exists(charName)) {
								addCharacterToList(charName, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(charName);
							boyfriend.alpha = lastAlpha;
							changeIcon('boyfriend', boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != charName) {
							if(!dadMap.exists(charName)) {
								addCharacterToList(charName, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(charName);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							changeIcon('dad', dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != charName)
							{
								if(!gfMap.exists(charName))
								{
									addCharacterToList(charName, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(charName);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
						
					case 3:
						if(boyfriend2.curCharacter != charName) {
							if(!boyfriend2Map.exists(charName)) {
								addCharacterToList(charName, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend2.alpha = 0.00001;
							boyfriend2 = boyfriend2Map.get(charName);
							boyfriend2.alpha = lastAlpha;
							changeIcon('boyfriend2', boyfriend2.healthIcon);
						}
						setOnLuas('boyfriend2Name', boyfriend2.curCharacter);

					case 4:
						if(dad2.curCharacter != charName) {
							if(!dad2Map.exists(charName)) {
								addCharacterToList(charName, charType);
							}

							var wasGf:Bool = dad2.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad2.alpha = 0.00001;
							dad2 = dad2Map.get(charName);
							if(!dad2.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad2.alpha = lastAlpha;
							changeIcon('dad2', dad2.healthIcon);
						}
						setOnLuas('dad2Name', dad2.curCharacter);
				}
				reloadHealthBarColors();

			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2 / playbackRate, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					FunkinLua.setVarInArray(this, value1, value2);
				}

			case 'Pack Snowball':
				var anim = 'pack';
				if (value1 != null && value1.length > 0)
					anim = value1;
				if (dad.animation.getByName(anim) != null)
				{
					dad.playAnim(anim, true);
					dad.specialAnim = true;
					dad.singDisabled = true;
					FlxG.sound.play(Paths.sound('snowPack'), 5);
					var originalCharacter = dad; // Do not steal :nerd:
					dad.animation.finishCallback = function(name:String) {
						if (name == anim)
						{
							originalCharacter.specialAnim = false;
							originalCharacter.singDisabled = false;
						}
					};
				}

			case 'Throw Snowball':
				var anim = 'throw';
				if (value1 != null && value1.length > 0)
					anim = value1;
				var anim2 = 'snowballImpact';
				if (value2 != null && value2.length > 0)
					anim2 = value2;
				if (dad.animation.getByName(anim) != null)
				{
					dad.playAnim(anim, true);
					dad.specialAnim = true;
					dad.singDisabled = true;
					FlxG.sound.play(Paths.sound('swish'), 5);
					var originalCharacter = dad; // Oops! Dad turned into a tomato, he'll be back in like 5 seconds though but I gotta tell him to be ready
					dad.animation.finishCallback = function(name:String) {
						//if (name == anim)
						//{
							originalCharacter.specialAnim = false;
							originalCharacter.singDisabled = false;
							originalCharacter.animation.finishCallback = null;
						//}
					};
				}
				new FlxTimer().start(0.1, function(tmr:FlxTimer) {
					if (boyfriend.dodgeTimer == 0) // "The snowballs prevent you from singing" *they don't press them*
					{
						if (boyfriend.animation.getByName(anim2) != null)
						{
							boyfriend.playAnim(anim2, true);
							boyfriend.specialAnim = true;
							boyfriend.singDisabled = true;
							boyfriend.stunned = true;
							FlxG.sound.play(Paths.sound('snowballImpact'), 5);
							var originalCharacter = boyfriend;
							boyfriend.animation.finishCallback = function(name:String) {
								//if (name == anim2)
								//{
									originalCharacter.specialAnim = false;
									originalCharacter.singDisabled = false;
									originalCharacter.stunned = false;
									originalCharacter.animation.finishCallback = null;
								//}
							};
						}
					}
				});
			case 'Flash White':
				var color:FlxColor;
				if (ClientPrefs.flashing)
				{
					if (value2 != null && value2.length > 0)
					{
						color = FlxColor.fromString(value2);
					}
					else
						color = FlxColor.WHITE;
				}
				else
					color = 0x00000000;
				var camera:FlxCamera;
				switch(value1.toLowerCase()) {
					case 'camhud' | 'hud': camera = camHUD;
					case 'camother' | 'other': camera = camOther;
					default: camera = camGame;
				}
				camera.flash(color, Conductor.crochet / 1000, null, true);
			/*case 'Flash Black':
				var color:FlxColor;
				if (ClientPrefs.flashing)
				{
					if (value2 != null && value2.length > 0)
					{
						color = FlxColor.fromString(value2);
					}
					else
						color = FlxColor.BLACK;
				}
				else
					color = 0x00000000;
				var camera:FlxCamera;
				switch(value1.toLowerCase()) {
					case 'camhud' | 'hud': camera = camHUD;
					case 'camother' | 'other': camera = camOther;
					default: camera = camGame;
				}
				camera.flash(color, Conductor.crochet / 1000, null, true);*/
			case 'Cut to Black':
				camGame.flash(FlxColor.BLACK, 99999999, null, true);
			case 'Change Botplay Text':
				if (value1 != null && value1.length > 0)
					botplayTxt.text = value1;
				else
					botplayTxt.text = getBotplayText(SONG.song);
			case 'Fake Bluescreen':
				//var image:String = songSpriteDir + 'bsodNormal';
				var image:String = '';
				if (value1 != null && value1.length > 0)
					image = value1;
				if (image == '')
				{
					if (bsodSpr != null)
						bsodSpr.destroy();
					FlxG.fullscreen = false;
					camZooming = true;
					Main.fpsVar.visible = fpsVisible;
				}
				else
				{
					if (bsodSpr != null)
						bsodSpr.destroy();
					bsodSpr = new FlxSprite(0, 0, Paths.image(image));
					bsodSpr.setGraphicSize(FlxG.width, FlxG.height);
					bsodSpr.updateHitbox();
					bsodSpr.screenCenter();
					insert(99999, bsodSpr);
					bsodSpr.cameras = [camHUD];
					FlxG.fullscreen = true;
					camZooming = false;
					Main.fpsVar.visible = false;
				}
			case 'Turn Blue':
				if (value1 == '') {
					if (ClientPrefs.shaders) {
						if (flipnoteShader != null)
							flipnoteShader.hueShift.value = [0.66];

						youreBlueNow = true;
					}
					else {
						youreBlueNow = true;

						//triggerEventNote('Change Character', 'dad', dad.curCharacter.replace('FlipnoteRed', 'FlipnoteBlue'));
						triggerEventNote('Change Character', 'dad', getFlipnoteBlueString(dad.curCharacter));
						if (gf != null)
							//triggerEventNote('Change Character', 'gf', gf.curCharacter.replace('FlipnoteRed', 'FlipnoteBlue'));
							triggerEventNote('Change Character', 'gf', getFlipnoteBlueString(gf.curCharacter));
						//triggerEventNote('Change Character', 'boyfriend', boyfriend.curCharacter.replace('FlipnoteRed', 'FlipnoteBlue'));
						triggerEventNote('Change Character', 'boyfriend', getFlipnoteBlueString(boyfriend.curCharacter));

						for (note in notes) {
							//trace(note.texture);
							//note.texture = note.texture.replace('FlipnoteRed', 'FlipnoteBlue');
							//note.texture = getFlipnoteBlueString(note.texture);
							note.texture = 'noteAssetsFlipnoteBlue';
							//note.noteSplashTexture = note.noteSplashTexture.replace('FlipnoteRed', 'FlipnoteBlue');
							note.noteSplashTexture = getFlipnoteBlueString(note.noteSplashTexture);
							note.multSpeed = note.multSpeed;
						}
						for (note in unspawnNotes) {
							//note.texture = note.texture.replace('FlipnoteRed', 'FlipnoteBlue');
							//note.texture = getFlipnoteBlueString(note.texture);
							note.texture = 'noteAssetsFlipnoteBlue';
							//note.noteSplashTexture = note.noteSplashTexture.replace('FlipnoteRed', 'FlipnoteBlue');
							note.noteSplashTexture = getFlipnoteBlueString(note.noteSplashTexture);
							note.multSpeed = note.multSpeed;
						}
					}
				}
				else {
					if (ClientPrefs.shaders) {
						if (flipnoteShader != null)
							flipnoteShader.hueShift.value = [0.0];

						youreBlueNow = false;
					}
					else {
						youreBlueNow = false;

						triggerEventNote('Change Character', 'dad', getFlipnoteRedString(dad.curCharacter));
						if (gf != null)
							triggerEventNote('Change Character', 'gf', getFlipnoteRedString(gf.curCharacter));
						triggerEventNote('Change Character', 'boyfriend', getFlipnoteRedString(boyfriend.curCharacter));

						for (note in notes) {
							//note.texture = getFlipnoteRedString(note.texture);
							note.texture = 'noteAssetsFlipnoteRed';
							note.noteSplashTexture = getFlipnoteRedString(note.noteSplashTexture);
							note.multSpeed = note.multSpeed;
						}
						for (note in unspawnNotes) {
							//note.texture = getFlipnoteRedString(note.texture);
							note.texture = 'noteAssetsFlipnoteRed';
							note.noteSplashTexture = getFlipnoteRedString(note.noteSplashTexture);
							note.multSpeed = note.multSpeed;
						}
					}
				}
			case 'Change Window Title':
				if (value1 != null && value1.length > 0)
					lime.app.Application.current.window.title = value1;
				else
					//lime.app.Application.current.window.title = lime.app.Application.current.meta.get('title');
					lime.app.Application.current.window.title = "Funkin' in Sunny Side Skies";
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection():Void {
		if(SONG.notes[curSection] == null) return;

		if (gf != null && SONG.notes[curSection].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[curSection].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool, ?char:String = null) // Bruh why a boolean
	{
		if (char != null) {
			switch (char) {
				case 'girlfriend' | 'gf':
					camFollow.set(gf.getMidpoint().x + 150, gf.getMidpoint().y - 100);
					camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
					camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
					tweenCamIn();
				case 'boyfriend2' | 'bf2':
					camFollow.set(boyfriend2.getMidpoint().x + 150, boyfriend2.getMidpoint().y - 100);
					camFollow.x += boyfriend2.cameraPosition[0] - boyfriend2CameraOffset[0];
					camFollow.y += boyfriend2.cameraPosition[1] + boyfriend2CameraOffset[1];

					if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
						cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
							function (twn:FlxTween)
							{
								cameraTwn = null;
							}
						});
					}
				case 'opponent' | 'dad':
					camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
					camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
					tweenCamIn();
				case 'opponent2' | 'dad2':
					camFollow.set(dad2.getMidpoint().x + 150, dad2.getMidpoint().y - 100);
					camFollow.x += dad2.cameraPosition[0] + opponent2CameraOffset[0];
					camFollow.y += dad2.cameraPosition[1] + opponent2CameraOffset[1];
					tweenCamIn();
				default:
					camFollow.set(boyfriend.getMidpoint().x + 150, boyfriend.getMidpoint().y - 100);
					camFollow.x += boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
					camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

					if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
						cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
							function (twn:FlxTween)
							{
								cameraTwn = null;
							}
						});
					}
			}
		}
		else {
			if (isDad) {
				camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
				camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
				tweenCamIn();
			}
			else {
				camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
				camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

				if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1) {
					cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
						function (twn:FlxTween)
						{
							cameraTwn = null;
						}
					});
				}
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		if (!skipAchShown)
		{
			return;
		}

		// Should kill you if you tried to cheat
		if(!startingSong && !skippingSong) { // But why? Why would you do that?
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if (achievementObj != null) {
			return;
		}
		else if (!skippingSong) {
			//var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
			//	'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
			//	'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);
			var achieve:String = checkForAchievement(['sss1_nomiss', 'sss2_nomiss', 'sss3_nomiss', 'sss4_nomiss',
				'sss5_nomiss', 'wwwfinale_nomiss', 'ur_bad', 'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		else if (!Achievements.isAchievementUnlocked('cheated_victory')) {
			skipAchShown = false;
			Achievements.unlockAchievement('cheated_victory');
			startAchievement('cheated_victory');
			pauseScreen.close(); // Never mind what I said in FreeplayState.hx lol ...I'm keeping the pauseScreen variable tho-
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			if(FlxG.sound.music != null) {
				FlxG.sound.music.pause();
				vocals.pause();
			}
			achievementsAndDelay = new BlankSubState();
			openSubState(achievementsAndDelay);
			//playbackRate = 0;
			return;
		}
		#end
		/*if (skippingSong && skipAchShown/ && pauseScreen != null/)
		{
			//pauseScreen.close();
		}*/

		var ret:Dynamic = callOnLuas('onEndSong', [], false);
		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent, fullCombo);
				#end
			}
			playbackRate = 1;

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					WeekData.loadTheFirstEnabledMod();
					//FlxG.sound.playMusic(Paths.music('sunnySide'));
					ClientPrefs.playMenuMusic();

					cancelMusicFadeTween();
					//isStoryMode = false;
					FreeplayState.loadSongs(false);
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					if (FlxG.save.data.finaleCompleted != null && !FlxG.save.data.finaleCompleted && !FreeplayState.weekIsLocked('wwwfinale')) {
						MusicBeatState.switchState(new FinaleDialogueState());
					}
					else {
						MusicBeatState.switchState(new StoryMenuState());
						if (FlxG.save.data.finaleCompleted == null)
							FlxG.save.data.finaleCompleted = false;
					}
					//isStoryMode = true;

					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						WeekData.reloadWeekFiles(true);
						//trace(StoryMenuState.weekCompleted);
						//trace(WeekData.weeksList);
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);
						//trace(StoryMenuState.weekCompleted);

						if (SONG.validScore)
						{
							//trace('Saving Week Score');
							WeekData.reloadWeekFiles(true);
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				WeekData.loadTheFirstEnabledMod();
				cancelMusicFadeTween();
				FreeplayState.loadSongs();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				if (SONG.song == 'Overcast Overview' && ((FlxG.save.data.finaleCompleted != null && !FlxG.save.data.finaleCompleted) || FlxG.save.data.finaleCompleted == null)) {
					FlxG.save.data.finaleCompleted = true;
					FlxG.save.data.finaleActive = false;
					MusicBeatState.switchState(new CreditsState());
					ClientPrefs.playMenuMusic();
					MainMenuState.curSelected = MainMenuState.optionShit.indexOf('Credits');
				}
				else if (((FlxG.save.data.finaleCompleted != null && !FlxG.save.data.finaleCompleted) || FlxG.save.data.finaleCompleted == null) && !FreeplayState.weekIsLocked('wwwfinale')) {
					MusicBeatState.switchState(new FinaleDialogueState());
				}
				else {
					MusicBeatState.switchState(new FreeplayState());
					//FlxG.sound.playMusic(Paths.music('sunnySide'));
					ClientPrefs.playMenuMusic();
				}
				if (FlxG.save.data.finaleCompleted == null)
					FlxG.save.data.finaleCompleted = false;
				changedDifficulty = false;
			}
			transitioning = true;

			//if (FlxG.save.data.finaleActive != null && FlxG.save.data.finaleActive) FlxG.save.data.finaleActive = false;
		}
		setStuffOnExit();

		skippingSong = false;
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		skipAchShown = true;
		if (endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = false;
	public var showComboNum:Bool = true;
	public var showRating:Bool = true;

	private function cachePopUpScore()
	{
		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		if (isPixelStage) {
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (handDrawn) {
			if (isNutshell) {
				Paths.image("nutshellUi/sick");
				Paths.image("nutshellUi/good");
				Paths.image("nutshellUi/bad");
				Paths.image("nutshellUi/shit");
				Paths.image("nutshellUi/combo");
			}
			else if (isFlipnote) {
				Paths.image("nutshellUi/flipnote/sick");
				Paths.image("nutshellUi/flipnote/good");
				Paths.image("nutshellUi/flipnote/bad");
				Paths.image("nutshellUi/flipnote/shit");
				Paths.image("nutshellUi/flipnote/combo");
			}

			for (i in 0...10) {
				Paths.image('nutshellUi/num' + i);
			}
		}
		else {
			Paths.image(pixelShitPart1 + "sick" + pixelShitPart2);
			Paths.image(pixelShitPart1 + "good" + pixelShitPart2);
			Paths.image(pixelShitPart1 + "bad" + pixelShitPart2);
			Paths.image(pixelShitPart1 + "shit" + pixelShitPart2);
			Paths.image(pixelShitPart1 + "combo" + pixelShitPart2);

			for (i in 0...10) {
				Paths.image(pixelShitPart1 + 'num' + i + pixelShitPart2);
			}
		}
		
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, noteDiff / playbackRate);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		note.rating = daRating.name;
		score = daRating.score;

		if(daRating.noteSplash && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		}

		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		var flipnoteFolder:String = '';

		if (PlayState.isPixelStage && !handDrawn)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}
		else if (handDrawn)
		{
			pixelShitPart1 = 'nutshellUi/';
			if (isFlipnote)
				flipnoteFolder = 'flipnote/';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + flipnoteFolder + daRating.image + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550 * playbackRate * playbackRate;
		rating.velocity.y -= FlxG.random.int(140, 175) * playbackRate;
		rating.velocity.x -= FlxG.random.int(0, 10) * playbackRate;
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + flipnoteFolder + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = FlxG.random.int(200, 300) * playbackRate * playbackRate;
		comboSpr.velocity.y -= FlxG.random.int(140, 160) * playbackRate;
		comboSpr.visible = (!ClientPrefs.hideHud && showCombo);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];
		comboSpr.y += 60;
		comboSpr.velocity.x += FlxG.random.int(1, 10) * playbackRate;

		insert(members.indexOf(strumLineNotes), rating);
		
		if (!ClientPrefs.comboStacking)
		{
			if (lastRating != null) lastRating.kill();
			lastRating = rating;
		}

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		var xThing:Float = 0;
		if (showCombo)
		{
			insert(members.indexOf(strumLineNotes), comboSpr);
		}
		if (!ClientPrefs.comboStacking)
		{
			if (lastCombo != null) lastCombo.kill();
			lastCombo = comboSpr;
		}
		if (lastScore != null)
		{
			while (lastScore.length > 0)
			{
				lastScore[0].kill();
				lastScore.remove(lastScore[0]);
			}
		}
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];
			
			if (!ClientPrefs.comboStacking)
				lastScore.push(numScore);

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300) * playbackRate * playbackRate;
			numScore.velocity.y -= FlxG.random.int(140, 160) * playbackRate;
			numScore.velocity.x = FlxG.random.float(-5, 5) * playbackRate;
			numScore.visible = !ClientPrefs.hideHud;

			//if (combo >= 10 || combo == 0)
			if (showComboNum)
				insert(members.indexOf(strumLineNotes), numScore);

			if (!isFlipnote || ClientPrefs.shaders) { // Fade out
				FlxTween.tween(numScore, {alpha: 0}, 0.2 / playbackRate, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002 / playbackRate
				});
			}
			else if (!ClientPrefs.shaders && ClientPrefs.flashing) { // Flicker out
				new FlxTimer().start(Conductor.crochet * 0.002 / playbackRate, function(tmr:FlxTimer) {
					FlxFlicker.flicker(numScore, 0.2 / playbackRate, 0.0166, false, true, function(flicker:FlxFlicker) {
						numScore.destroy();
					});
				});
			}
			else { // Disappear
				FlxTween.tween(numScore, {alpha: 1}, 0.2 / playbackRate, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002 / playbackRate
				});
			}

			daLoop++;
			if(numScore.x > xThing) xThing = numScore.x;
		}
		comboSpr.x = xThing + 50;
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		if (!isFlipnote || ClientPrefs.shaders) { // Fade out
			FlxTween.tween(rating, {alpha: 0}, 0.2 / playbackRate, {
				startDelay: Conductor.crochet * 0.001 / playbackRate
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2 / playbackRate, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.002 / playbackRate
			});
		}
		else if (!ClientPrefs.shaders && ClientPrefs.flashing) { // Flicker out
			new FlxTimer().start(Conductor.crochet * 0.001 / playbackRate, function(tmr:FlxTimer) {
				FlxFlicker.flicker(rating, 0.2 / playbackRate, 0.0166, false, true, function(flicker:FlxFlicker) {
					rating.destroy();
				});
			});
			
			new FlxTimer().start(Conductor.crochet * 0.002 / playbackRate, function(tmr:FlxTimer) {
				FlxFlicker.flicker(comboSpr, 0.2 / playbackRate, 0.0166, false, true, function(flicker:FlxFlicker) {
					coolText.destroy();
					comboSpr.destroy();
				});
			});
		}
		else { // Disappear
			/*FlxTween.tween(rating, {alpha: 1}, 0.2 / playbackRate, {
				startDelay: Conductor.crochet * 0.001 / playbackRate
			});*/

			FlxTween.tween(comboSpr, {alpha: 1}, 0.2 / playbackRate, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.002 / playbackRate
			});
		}
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);
		pressKey(key, eventKey);
	}

	private function pressKey(key:Int, ?eventKey:FlxKey):Void
	{
		if (eventKey == null)
			eventKey = keysArray[key][0];
		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode || FlxG.mouse.justPressed))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);

		releaseKey(key);
	}

	private function releaseKey(key:Int)
	{
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if (key != NONE) {
			for (i in 0...keysArray.length) {
				for (j in 0...keysArray[i].length) {
					if(key == keysArray[i][j]) {
						return i;
					}
				}
			}
		}
		return -1;
	}

	// It got progressively less and less convoluted
	/*private function getEventFromKey(key:Int, ?altInput:Int = 0):FlxKey
	{
		return keysArray[key][altInput];
	}*/

	// Hold notes
	private function keyShit():Void
	{
		// Mouse controls for touchscreen
		var mouseKeysNow:Array<Bool> = [false, false, false, false];
		var mouseX:Float = FlxG.mouse.getScreenPosition(camOther).x;
		//if (FlxG.mouse.justPressed) {
		if (FlxG.mouse.pressed) {
			if (mouseX < FlxG.width * 0.25) {
				//pressKey(0);
				mouseKeys[0] = true;
				mouseKeysNow[0] = true;
			}
			else if (mouseX < FlxG.width * 0.5) {
				mouseKeys[1] = true;
				mouseKeysNow[1] = true;
			}
			else if (mouseX < FlxG.width * 0.75) {
				mouseKeys[2] = true;
				mouseKeysNow[2] = true;
			}
			else {
				mouseKeys[3] = true;
				mouseKeysNow[3] = true;
			}
			//trace('mouse clicked at position ' + mouseX + ' with these buttons pressed: ' + mouseKeys);
		}
		else /*if (FlxG.mouse.justReleased)*/ {
			mouseKeys = [false, false, false, false];
		}

		for (i in 0...mouseKeys.length) {
			if (mouseKeysNow[i]) {
				pressKey(i);
			}
			else if (FlxG.mouse.justReleased) {
				releaseKey(i);
			}
		}

		// HOLDING
		var parsedHoldArray:Array<Bool> = arrayOr(parseKeys(), mouseKeys);

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if (ClientPrefs.controllerMode)
		{
			var parsedArray:Array<Bool> = arrayOr(parseKeys('_P'), mouseKeysNow);
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] && strumsBlocked[i] != true)
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (startedCountdown && !boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && parsedHoldArray[daNote.noteData] && daNote.canBeHit
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
				}
			});

			if (parsedHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else {
				if (boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
				if (boyfriend2.animation.curAnim != null && boyfriend2.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend2.dance();
					//boyfriend2.animation.curAnim.finish();
				}
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if (ClientPrefs.controllerMode || strumsBlocked.contains(true))
		{
			var parsedArray:Array<Bool> = parseKeys('_R');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] || strumsBlocked[i] == true)
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
		/*if (FlxG.mouse.justReleased) {
			if (FlxG.mouse.x < FlxG.width * 0.25)
				releaseKey(0);
			else if (FlxG.mouse.x < FlxG.width * 0.5)
				releaseKey(1);
			else if (FlxG.mouse.x < FlxG.width * 0.75)
				releaseKey(2);
			else
				releaseKey(3);
		}*/
	}

	private function arrayOr(a:Array<Bool>, b:Array<Bool>)
	{
		var returnArray:Array<Bool> = []; // I was gonna shorten the variable name but noo of course it has to sound like an obsolete-medical-term-turned-slur
		for (i in 0...a.length) {
			returnArray[i] = (a[i] || b[i]); // Robot sexualities
		}
		return returnArray;
	}

	private function parseKeys(?suffix:String = ''):Array<Bool>
	{
		var ret:Array<Bool> = [];
		for (i in 0...controlArray.length)
		{
			ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
		}
		return ret;
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;
		health -= daNote.missHealth * healthLoss * missLimitMult;
		
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if (!practiceMode)
		{
			songScore -= 10;
			if (missLimit >= 0 && songMisses > missLimit)
				health = 0; // Defeat this
		}

		totalPlayed++;
		RecalculateRating(true);

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && !daNote.noMissAnimation && char.hasMissAnimations)
		{
			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daNote.animSuffix;
			char.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss * missLimitMult;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating(true);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
		callOnLuas('noteMissPress', [direction]);
	}

	function opponentNoteHit(note:Note):Void
	{
		if (dad.curCharacter == 'dandyRobot2' && (Math.abs(note.noteData) == 0 || Math.abs(note.noteData) == 1)) { // For giant characters
			triggerEventNote('Change Character', 'dad', 'dandyRobot1');
			dad.alpha = 0.75;
			dad.blend = MULTIPLY;
		}
		else if (dad.curCharacter == 'dandyRobot1' && (Math.abs(note.noteData) == 2 || Math.abs(note.noteData) == 3)) {
			triggerEventNote('Change Character', 'dad', 'dandyRobot2');
			dad.alpha = 0.75;
			dad.blend = MULTIPLY;
		}
		var tempChar = dad;
		if (note.noteType == 'Backup Sing' || note.noteType == 'Backup Auto Sing')
		{
			tempChar = dad2;
			//trace(note.noteType);
		}
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if (health > 0.1)
		{
			health -= note.hitHealth * dadHealthGain * missLimitMult; // YOO HEALTH DRAIN
			if (health < 0.1)
				health = 0.1;
		}

		if(note.noteType == 'Hey!') {
			if (dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
			}
			if (dad2.animOffsets.exists('hey')) {
			dad2.playAnim('hey', true);
			dad2.specialAnim = true;
			dad2.heyTimer = 0.6;
			}
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = tempChar;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if (char != null)
			{
				var shouldUseLoop:Bool = false;
				if (note.isSustainNote && char.animation.getByName(animToPlay + '-loop') != null && char.animation.curAnim != null && char.animation.curAnim.name != animToPlay + '-loop')
					shouldUseLoop = true;
				if (!shouldUseLoop)
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)), time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function autoNoteHitDad(note:Note):Void
	{
		if (dad.curCharacter == 'dandyRobot2' && (Math.abs(note.noteData) == 0 || Math.abs(note.noteData) == 1)) { // For giant characters
			triggerEventNote('Change Character', 'dad', 'dandyRobot1');
			dad.alpha = 0.75;
			dad.blend = MULTIPLY;
		}
		else if (dad.curCharacter == 'dandyRobot1' && (Math.abs(note.noteData) == 2 || Math.abs(note.noteData) == 3)) {
			triggerEventNote('Change Character', 'dad', 'dandyRobot2');
			dad.alpha = 0.75;
			dad.blend = MULTIPLY;
		}
		var tempChar = dad;
		if (note.noteType == 'Backup Auto Sing')
		{
			tempChar = dad2;
			trace(note.noteType);
		}
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		//if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = tempChar;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				var shouldUseLoop:Bool = false;
				if (note.isSustainNote && char.animation.getByName(animToPlay + '-loop') != null && char.animation.curAnim != null && char.animation.curAnim.name != animToPlay + '-loop')
					shouldUseLoop = true;
				if (!shouldUseLoop)
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		//}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		//StrumPlayAnim(true, Std.int(Math.abs(note.noteData)), time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		var tempChar = boyfriend;
		if (note.noteType == 'Backup Sing' || note.noteType == 'Backup Auto Sing')
			tempChar = boyfriend2;
		if (!note.wasGoodHit)
		{
			switch (note.noteType) {
				case 'Snowball Note':
					if(tempChar.animation.getByName('dodge') != null) {
						tempChar.playAnim('dodge', true);
						tempChar.specialAnim = true;
						tempChar.singDisabled = true;
						tempChar.animation.finishCallback = function(name:String) {
							tempChar.specialAnim = false;
							tempChar.singDisabled = false;
						};
					}
					tempChar.dodgeTimer = 1;
			}
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
							if(tempChar.animation.getByName('hurt') != null) {
								tempChar.playAnim('hurt', true);
								tempChar.specialAnim = true;
							}
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
			}
			health += note.hitHealth * healthGain * missLimitMult;

			if(!note.noAnimation) {
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote)
				{
					if(gf != null)
					{
						var shouldUseLoop:Bool = false;
						if (note.isSustainNote && gf.animation.getByName(animToPlay + '-loop') != null && gf.animation.curAnim != null && gf.animation.curAnim.name != animToPlay + '-loop')
							shouldUseLoop = true;
						if (!shouldUseLoop)
						gf.playAnim(animToPlay + note.animSuffix, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					var shouldUseLoop:Bool = false;
					if (note.isSustainNote && tempChar.animation.getByName(animToPlay + '-loop') != null && tempChar.animation.curAnim != null && tempChar.animation.curAnim.name != animToPlay + '-loop')
						shouldUseLoop = true;
					if (!shouldUseLoop)
					tempChar.playAnim(animToPlay + note.animSuffix, true);
					tempChar.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
					if(boyfriend2.animOffsets.exists('hey')) {
						boyfriend2.playAnim('hey', true);
						boyfriend2.specialAnim = true;
						boyfriend2.heyTimer = 0.6;
					}

					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}
	
	function autoNoteHitBf(note:Note):Void
	{
		var tempChar = boyfriend;
		if (note.noteType == 'Backup Auto Sing')
			tempChar = boyfriend2;
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			/*if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
			}
			health += note.hitHealth * healthGain * missLimitMult;*/

			//if(!note.noAnimation) {
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote)
				{
					if(gf != null)
					{
						var shouldUseLoop:Bool = false;
						if (note.isSustainNote && gf.animation.getByName(animToPlay + '-loop') != null && gf.animation.curAnim != null && gf.animation.curAnim.name != animToPlay + '-loop')
							shouldUseLoop = true;
						if (!shouldUseLoop)
						gf.playAnim(animToPlay + note.animSuffix, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					var shouldUseLoop:Bool = false;
					if (note.isSustainNote && tempChar.animation.getByName(animToPlay + '-loop') != null && tempChar.animation.curAnim != null && tempChar.animation.curAnim.name != animToPlay + '-loop')
						shouldUseLoop = true;
					if (!shouldUseLoop)
					tempChar.playAnim(animToPlay + note.animSuffix, true);
					tempChar.holdTimer = 0;
				}
			//}

			/*if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}*/
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		var hue:Float = 0;
		var sat:Float = 0;
		var brt:Float = 0;
		if (data > -1 && data < ClientPrefs.arrowHSV.length)
		{
			hue = ClientPrefs.arrowHSV[data][0] / 360;
			sat = ClientPrefs.arrowHSV[data][1] / 100;
			brt = ClientPrefs.arrowHSV[data][2] / 100;
			if(note != null) {
				skin = note.noteSplashTexture;
				if (isNutshell && !skin.endsWith('Nutshell'))
				//if (handDrawn)
					skin += 'Nutshell';
				/*else if (isFlipnote && !ClientPrefs.shaders)
					skin += getFlipnoteNoShaderString('FlipnoteShader');
				else if (isFlipnote)
					skin += 'FlipnoteShader';*/
				hue = note.noteSplashHue;
				sat = note.noteSplashSat;
				brt = note.noteSplashBrt;
			}
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf != null)
		{
			gf.danced = false; //Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				/*var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}*/
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	override function destroy() {
		for (lua in luaArray) {
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = [];

		#if hscript
		if(FunkinLua.hscript != null) FunkinLua.hscript = null;
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		FlxAnimationController.globalSpeed = 1;
		FlxG.sound.music.pitch = 1;
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		if (curStep % 2 == 0)
		{
			for (bread in fidgetSprites) {
				bread.dance(true);
			}
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		iconP1.scale.set(1.2, 1.2);
		iconP1b.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);
		iconP2b.scale.set(1.2, 1.2);
		//trace(iconP1b.x + ', ' + iconP1b.y + ', ' + iconP2b.x + ', ' + iconP2b.y);

		iconP1.updateHitbox();
		iconP1b.updateHitbox();
		iconP2.updateHitbox();
		iconP2b.updateHitbox();

		/*if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
		{
			boyfriend2.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}
		if (curBeat % dad2.danceEveryNumBeats == 0 && dad2.animation.curAnim != null && !dad2.animation.curAnim.name.startsWith('sing') && !dad2.stunned)
		{
			dad2.dance();
		}*/

		switch (curStage)
		{
			/*case 'tank':
				if(!ClientPrefs.lowQuality) tankWatchtower.dance();
				foregroundSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});

			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);*/

			case 'limo':
				/*if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}*/

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
					phillyWindow.color = phillyLightsColors[curLight];
					phillyWindow.alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "amongUsBg":
				if (SONG.song == "Defeat Unfair" || SONG.song == "Similarities") {
					if (curBeat == 292)	{
						/*amongUsBg.forEach(function(spr:BGSprite)
						{
							spr.alpha = 0;
						});
						darkAmongUsBg.forEach(function(spr:BGSprite)
						{
							spr.alpha = 1;
						});*/
						amongUsBg1.alpha = 0;
						amongUsBg2.alpha = 0;
						darkAmongUsBg1.alpha = 1;
						darkAmongUsBg2.alpha = 1;
						darkAmongUsBg3.alpha = 1;
						//whiteVoid.alpha = 0;
					}
					else if (curBeat == 360) {
						/*darkAmongUsBg.forEach(function(spr:BGSprite)
						{
							spr.alpha = 0;
						});
						amongUsWhiteVoid.forEach(function(spr:BGSprite)
						{
							spr.alpha = 1;
						});*/
						darkAmongUsBg1.alpha = 0;
						darkAmongUsBg2.alpha = 0;
						darkAmongUsBg3.alpha = 0;
						whiteVoid.alpha = 1;
						boyfriendGroup.x = 1020;
						boyfriendGroup.y = 600;
						dadGroup.x = 540;
						dadGroup.y = 480;
					}
					else if (curBeat == 488) {
						triggerEventNote('Cut to Black', '', '');
					}
					else if (curBeat == 490) {
						triggerEventNote('Flash White', '', '');
						addLuaSprite('emergencyMeeting1', false);
						addLuaSprite('emergencyMeeting2', false);
						modchartSprites.get('emergencyMeeting2').animation.play('idle', true);
					}
					else if (curBeat == 491) {
						addLuaSprite('emergencyMeeting3', false);
						modchartSprites.get('emergencyMeeting3').animation.play('idle', true);
					}
					else if (curBeat == 494) {
						remove(modchartSprites.get('emergencyMeeting1'), true);
						remove(modchartSprites.get('emergencyMeeting2'), true);
						remove(modchartSprites.get('emergencyMeeting3'), true);
						modchartSprites.get('emergencyMeeting1').destroy();
						modchartSprites.get('emergencyMeeting2').destroy();
						modchartSprites.get('emergencyMeeting3').destroy();
						triggerEventNote('Cut to Black', '', '');
					}
				}
			case "dudeHouseBg":
				if (SONG.song == 'Challeng-Edd Unfair') {
					if (curBeat == 232) {
						triggerEventNote('Flash White', '', '');
						triggerEventNote('Change Character', 'dad', 'dandyRobot1');
						triggerEventNote('Change Character', 'boyfriend', 'jimTopDown');
						triggerEventNote('Change Character', 'boyfriend2', 'dudeTopDown');
						dadGroup.x = 0;
						dadGroup.y = 2000;
						dad.alpha = 0.75;
						dad.blend = MULTIPLY;
						setObjectOrder('dadGroup', getObjectOrder('boyfriendGroup') + 1);
						modchartTweens.set('robotRise', FlxTween.tween(dadGroup, {y: 0}, Conductor.crochet / 1000 * 16));
					}
					else if (curBeat == 500) {
						triggerEventNote('Cut to Black', '', '');
					}
					else if (curBeat == 504) {
						triggerEventNote('Flash White', '', '');
						addLuaSprite('appleThrow1', false);
						addLuaSprite('appleThrow2', false);
					}
					else if (curBeat == 508) {
						triggerEventNote('Flash White', '', '');
						addLuaSprite('appleExplosion1', false);
						addLuaSprite('appleExplosion2', false);
						addLuaSprite('appleExplosion3', false);
						modchartSprites.get('appleExplosion2').animation.play('explode');
						modchartSprites.get('appleExplosion2').animation.finishCallback = function(name:String)
						{
							modchartSprites.get('appleExplosion2').animation.play('idle', true);
							modchartSprites.get('appleExplosion2').animation.finishCallback = null;
						};
					}
					else if (curBeat == 512) {
						camHUD.fade(FlxColor.WHITE, Conductor.crochet / 1000 * 4, false, null, true);
					}
					else if (curBeat == 520) {
						camHUD.fade(FlxColor.BLACK, 0.01, false, null, true);
						triggerEventNote('Cut to Black', '', '');
					}
				}
		}

		/*if (curBeat % 2 == 0)
		{
			/*bopSprites.forEach(function(spr:BGSprite)
			{
				spr.dance();
			});
			breatheSprites.forEach(function(spr:BGSpriteDance)
			{
				spr.dance();
			});//
			for (bread in bopSprites) {
				bread.dance(true);
			}
			if (curStage == 'chaseCouchBg') {
				//chaseCouchBg3.dance(true);
				//chaseCouchBg3.animation.play('Dance Left', true);
				if (chaseCouchBg3.animation.curAnim != null)
				{
					//trace('last animation finished? ' + chaseCouchBg3.animation.curAnim.finished + ', last animation paused? ' + chaseCouchBg3.animation.curAnim.paused);
					trace(chaseCouchBg3.animation.curAnim.name);
				}
			}
		}*/
		/*danceSprites.forEach(function(spr:BGSpriteDance)
		{
			spr.dance();
		});*/
		/*for (bread in danceSprites) {
			bread.dance(true);
		}*/

		dance(curBeat); // At first I thought the biggest EXE was probably Scorched or Fatal Error or something, but now I realize it's the FNF executable before this change

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (generatedMusic && !endingSong && !isCameraOnForcedPos)
			{
				moveCameraSection();
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms)
			{
				FlxG.camera.zoom += 0.015 * camZoomingMult;
				camHUD.zoom += 0.03 * camZoomingMult;
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnLuas('altAnim', SONG.notes[curSection].altAnim);
			setOnLuas('gfSection', SONG.notes[curSection].gfSection);
		}
		
		setOnLuas('curSection', curSection);
		callOnLuas('onSectionHit', []);
	}

	public function dance(beatThing:Int)
	{
		if (curBeat != 0 || beatThing != curBeat) {
			/*var beatThing:Int = curBeat;
			if (curBeat < 0) beatThing = */
			
			//trace(timeBar.y + ', ' + timeBarOverlay.y);
			
			/*iconP1.scale.set(1.2, 1.2);
			iconP2.scale.set(1.2, 1.2);

			iconP1.updateHitbox();
			iconP2.updateHitbox();*/

			if (gf != null && (beatThing % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0/* || (beatThing == 0 && beatThing != curBeat)*/) && !gf.stunned)
			{
				if (gf.legs != null)
					gf.legs.dance(true);
				if (gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing"))
					gf.dance();
			}
			if ((beatThing % boyfriend.danceEveryNumBeats == 0/* || (beatThing == 0 && beatThing != curBeat)*/) && !boyfriend.stunned)
			{
				if (boyfriend.legs != null)
					boyfriend.legs.dance(true);
				if (boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing'))
					boyfriend.dance();
			}
			if ((beatThing % boyfriend2.danceEveryNumBeats == 0/* || (beatThing == 0 && beatThing != curBeat)*/) && !boyfriend2.stunned)
			{
				if (boyfriend2.legs != null)
					boyfriend2.legs.dance(true);
				if (boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing'))
					boyfriend2.dance();
			}
			if ((beatThing % dad.danceEveryNumBeats == 0/* || (beatThing == 0 && beatThing != curBeat)*/) && !dad.stunned)
			{
				if (dad.legs != null)
					dad.legs.dance(true);
				if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing'))
					dad.dance();
			}
			if ((beatThing % dad2.danceEveryNumBeats == 0/* || (beatThing == 0 && beatThing != curBeat)*/) && !dad2.stunned)
			{
				if (dad2.legs != null)
					dad2.legs.dance(true);
				if (dad2.animation.curAnim != null && !dad2.animation.curAnim.name.startsWith('sing'))
					dad2.dance();
			}

			switch (curStage)
			{
				case 'tank':
					if(!ClientPrefs.lowQuality) tankWatchtower.dance();
					foregroundSprites.forEach(function(spr:BGSprite)
					{
						spr.dance();
					});

				case 'school':
					if(!ClientPrefs.lowQuality) {
						bgGirls.dance();
					}

				case 'mall':
					if(!ClientPrefs.lowQuality) {
						upperBoppers.dance(true);
					}

					if(heyTimer <= 0) bottomBoppers.dance(true);
					santa.dance(true);
			}

			if (beatThing % 2 == 0)
			{
				/*bopSprites.forEach(function(spr:BGSprite)
				{
					spr.dance();
				});
				breatheSprites.forEach(function(spr:BGSpriteDance)
				{
					spr.dance();
				});*/
				for (bread in bopSprites) {
					bread.dance(true);
				}
				/*if (curStage == 'chaseCouchBg') {
					//chaseCouchBg3.dance(true);
					//chaseCouchBg3.animation.play('Dance Left', true);
					if (chaseCouchBg3.animation.curAnim != null)
					{
						//trace('last animation finished? ' + chaseCouchBg3.animation.curAnim.finished + ', last animation paused? ' + chaseCouchBg3.animation.curAnim.paused);
						trace(chaseCouchBg3.animation.curAnim.name);
					}
				}*/
			}
			if (beatThing % 4 == 0)
			{
				for (bread in breatheSprites) {
					bread.dance(true);
				}
			}
			/*danceSprites.forEach(function(spr:BGSpriteDance)
			{
				spr.dance();
			});*/
			for (bread in danceSprites) {
				bread.dance(true);
			}
		}
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if(ret == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == FunkinLua.Function_Continue;
			if(!bool && ret != 0) {
				returnVal = cast ret;
			}
		}
		#end
		//trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public var fullCombo:Bool;
	public function RecalculateRating(badHit:Bool = false) {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', [], false);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			var dummyNote:Note = new Note(0, 0); // Your sole purpose is to get the health deducted for a miss
			ratingFC = "";
			fullCombo = false;
			if (songMisses == 0) fullCombo = true;
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= Std.int(1 / dummyNote.missHealth)/* && SONG.song != 'Alacrity'*/ && missLimit >= 0 && songHits == 0) ratingFC = "You're hopeless."; // To calculate the amount of misses required to lose minus one
			else if (songMisses >= 10) ratingFC = "Clear";
			dummyNote.destroy(); // L
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				
				if (achievementName.contains(WeekData.getWeekFileName()) && achievementName.endsWith('nomiss')) // any FC achievements, name should be "weekFileName_nomiss", e.g: "weekd_nomiss";
				{
					if(isStoryMode && campaignMisses + songMisses < 1 && (CoolUtil.difficultyString() == 'HARD' || CoolUtil.difficultyString() == 'UNFAIR')
						&& storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						unlock = true;
				}
				switch(achievementName)
				{
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					//case 'roadkill_enthusiast':
						//if(Achievements.henchmenDeath >= 100) {
							//unlock = true;
						//}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ !ClientPrefs.shaders && ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
					case 'wwwfinale_nomiss': // I put this here because it's not a week, but a freeplay song
						if(songMisses < 1 && CoolUtil.difficultyString() == 'HARD' && !changedDifficulty && !usedPractice && SONG.song == 'Overcast Overview')
							unlock = true;
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = -1;
	var curLightEvent:Int = -1;

	/*function getObjectOrder(obj:String) {
		var killMe:Array<String> = obj.split('.');
		var leObj:FlxBasic = getObjectDirectly(killMe[0]);
		if(killMe.length > 1) {
			leObj = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		}

		if(leObj != null)
		{
			return getInstance().members.indexOf(leObj);
		}
		//luaTrace("getObjectOrder: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
		return -1;
	}

	function setObjectOrder(obj:String, position:Int) {
		var killMe:Array<String> = obj.split('.');
		var leObj:FlxBasic = getObjectDirectly(killMe[0]);
		if(killMe.length > 1) {
			leObj = getVarInArray(getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		}

		if(leObj != null) {
			getInstance().remove(leObj, true);
			getInstance().insert(position, leObj);
			return;
		}
		//luaTrace("setObjectOrder: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
	}*/

	public function getObjectOrder(obj:String) {
		return sourceLua.getObjectOrder(obj);
	}
	
	public function setObjectOrder(obj:String, position:Int) {
		sourceLua.setObjectOrder(obj, position);
	}

	public function makeLuaSprite(tag:String, image:String, x:Float, y:Float) {
		sourceLua.makeLuaSprite(tag, image, x, y);
		return modchartSprites.get(tag);
	}

	public function makeAnimatedLuaSprite(tag:String, image:String, x:Float, y:Float, ?spriteType:String = "sparrow") {
		sourceLua.makeAnimatedLuaSprite(tag, image, x, y, spriteType);
		return modchartSprites.get(tag);
	}

	public function addLuaSprite(tag:String, front:Bool = false) {
		sourceLua.addLuaSprite(tag, front);
	}

	/*public override function add(object:FlxBasic):FlxBasic
	{
		//trace(object is FlxSprite);
		if (object is FlxSprite) { // *TomSka voice* Holy Among Us popsicle with a gumball visor that's so useful
			var obj:FlxSprite = cast object;
			var mosaic = new MosaicEffect();
			obj.shader = mosaic.shader;
			mosaic.setStrength(1.5 * camGame.zoom, 1.5 * camGame.zoom);
			//object = cast obj;
			trace('adding sprite with shader');
			super.add(obj);
		}
		else {
			super.add(object);
		}
		return object;
	}*/

	// Shader stuff
	/*public var mosaicAmount(default, set):Int = 8;
	public var mosaicArray:Array<FlxShader> = [];
	public var spriteArray:Array<FlxSprite> = [];

	public function addSprite(spr:FlxSprite):FlxSprite
	{
		add(addMosaic(spr));
		spriteArray.push(spr);
		return spr;
	}

	public function addMosaic(spr:FlxSprite):FlxSprite
	{
		spr.shader = new MosaicShader(mosaicAmount, mosaicAmount, spr.scale.x, spr.scale.y);
		mosaicArray.push(spr.shader);
		return spr;
	}

	private function set_mosaicAmount(pixelSize:Int):Int
	{
		mosaicAmount = pixelSize;
		for (shader in mosaicArray)
		{
			if (shader != null)
				shader.data.uBlockSize = [pixelSize, pixelSize];
		}
		return pixelSize;
	}

	public function mosaicZoomPre()
	{
		for (spr in spriteArray)
			if (spr != null && spr.shader != null)
			{
				for (camera in 0...spr.cameras.length)
				{
					spr.shader.data.uBlockSize.value[0] /= spr.cameras[camera].zoom;
					spr.shader.data.uBlockSize.value[1] /= spr.cameras[camera].zoom;
				}
			}
	}

	public function mosaicZoomPost()
	{
		for (spr in spriteArray)
			if (spr != null && spr.shader != null)
			{
				for (camera in 0...spr.cameras.length)
				{
					spr.shader.data.uBlockSize.value[0] *= spr.cameras[camera].zoom;
					spr.shader.data.uBlockSize.value[1] *= spr.cameras[camera].zoom;
				}
			}
	}*/

	private function set_missLimit(limit:Int)
	{
		if (limit >= 0) {
			missLimitMult = 0;
			healthBar.visible = false;
		}
		else {
			missLimitMult = 1;
			healthBar.visible = true;
		}
		missLimit = limit;
		return limit;
	}

	private function changeIcon(player:String, char:String)
	{
		//var iconVar:HealthIcon;
		//var charVar:Character; // lol
		var iconOffset:Int = 26;
		var yPos = iconP1.y;
		switch (player)
		{
			case 'girlfriend' | 'gf':
				return;
			case 'opponent' | 'dad':
				iconP2.destroy();
				if (!HealthIcon.hasWinningIcon(char))
					iconP2 = new HealthIcon(char, flipHealthBar);
				else // Found it! :D
					iconP2 = new CoolIcon(char, flipHealthBar);
				if (flipHealthBar)
					iconP2.x = healthBar.x + (healthBar.width * (healthBar.percent * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
				else
					iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
				iconP2.y = yPos;
				insert(members.indexOf(iconP1) + 1, iconP2);
				iconP2.cameras = [camHUD];
				
				#if desktop
				if (songNameNoDiff != '~')
				{
					if (!startingSong)
						// Updating Discord Rich Presence (with Time Left)
						DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), true, songLength, getLogoName(dad.curCharacter));
					else
						// Updating Discord Rich Presence.
						DiscordClient.changePresence(detailsText, songNameNoDiff + " (" + storyDifficultyText + ")", iconP2.getCharacter().toLowerCase(), null, null, getLogoName(dad.curCharacter));
				}
				#end
			case 'opponent2' | 'dad2':
				iconP2b.destroy();
				if (!HealthIcon.hasWinningIcon(char))
					iconP2b = new HealthIcon(char, flipHealthBar);
				else // Found it! :D
					iconP2b = new CoolIcon(char, flipHealthBar);
				if (flipHealthBar)
					iconP2b.x = iconP2.x + 100;
				else
					iconP2b.x = iconP2.x - 100;
				iconP2b.y = yPos;
				insert(members.indexOf(iconP1b) + 1, iconP2b);
				iconP2b.cameras = [camHUD];
			case 'boyfriend2' | 'bf2':
				iconP1b.destroy();
				if (!HealthIcon.hasWinningIcon(char))
					iconP1b = new HealthIcon(char, !flipHealthBar);
				else // Found it! :D
					iconP1b = new CoolIcon(char, !flipHealthBar);
				if (flipHealthBar)
					iconP1b.x = iconP1.x - 100;
				else
					iconP1b.x = iconP1.x + 100;
				iconP1b.y = yPos;
				insert(members.indexOf(iconP2b), iconP1b);
				iconP1b.cameras = [camHUD];
			default:
				iconP1.destroy();
				if (!HealthIcon.hasWinningIcon(char))
					iconP1 = new HealthIcon(char, !flipHealthBar);
				else // Found it! :D
					iconP1 = new CoolIcon(char, !flipHealthBar);
				if (flipHealthBar)
					iconP1.x = healthBar.x + (healthBar.width * (healthBar.percent * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
				else
					iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
				iconP1.y = yPos;
				insert(members.indexOf(iconP2), iconP1);
				iconP1.cameras = [camHUD];
		}
		/*if (!HealthIcon.hasWinningIcon(charVar.healthIcon))
			iconVar = new HealthIcon(charVar.healthIcon, true);
		else // Found it! :D
			iconVar = new CoolIcon(charVar.healthIcon, true);*/
	}

	public function getBotplayText(?song:String = null):String
	{
		if (song == null || song.length == 0)
			song = SONG.song;
		var text = 'BOTPLAY';
		switch (song)
		{
			case 'Polar Opposite' | 'Polar Opposite Unfair':
				text = 'Stop cheating or Chase will cook for you';
			case 'Defeat':
				text = 'You realize this difficulty doesn\'t have the mechanic right';
			case 'Defeat Unfair':
				text = 'Baby.';
			case 'Get Back Here!' | 'Get Back Here! Unfair':
				text = 'Y\'know what I\'ll give you a pass for this one';
			case 'Zanta':
				text = 'Why does Elliot want Senpai dead anyway';
			case 'Unfamiliar':
				text = 'You\'re using botplay. There aren\'t any mechanics. Why are you listening to this??';
			case 'Raveyard':
				text = 'When the G falls off the graveyard sign:';
			case 'Monochrome':
				text = 'Dead song\n\n\n\nTake a bath in the lava';
			case 'Wahaha!':
				text = 'Atistale is long dead';
			case 'Toyboy':
				text = 'Toby';
			case 'Dude':
				text = 'eheheh eheheheheh\nI just said Sans in Dialogueboxese';
			case 'Toasty':
				text = 'your balls are toasty hot :flushed:';
			case 'Cross-Comic Clash':
				text = 'Aight be right back Ima play Clash of Clans\n*silence*\n*Supercell jingle*';
			case 'Challeng-Edd' | 'Challeng-Edd Unfair':
				text = 'Hello fellow mentally Challeng-Edd individual';
			case 'Stuck?':
				//text = 'Fun Fact: This song was meant for v3.0 but i forgor :skull:';
				//text = 'He\'s sleeping you hellgraue buntglasscheibe';
				text = 'Let me help you\nYEET';
			case 'Final Round':
				//text = 'You vs. the guy he tells you not to worry about:\n\n\n\nHeh. Finally putting his name to use.';
				text = 'You vs. the guy he tells you not to worry about:';
			case 'Cafe Mocha':
				text = 'Um, excuse me, what the actual funk do you think you\'re doing using botplay on this song? This is easier than Dad Battle.';
			case 'Abuse':
				text = 'I will abuse you';
			//case 'Fatality':
				//text = 'Kid macht sich über Dhar Mann lustig, wird in die Hölle geschleppt';
			case 'Sand Land':
				//text = 'Fun Fact: These sprites were originally for a Fatality cover.';
				text = 'Kid macht sich über Dhar Mann lustig, wird in die Hölle geschleppt';
			case 'Infected':
				text = 'among us!!';
			case 'Eye Spy':
				text = 'I spy with my little eye something that\'s gonna be red all over';
			case 'Cinnamon Roll':
				text = 'Do you ship Chadam';
			case 'Overcast Overview':
				text = 'This is it.\nI\'d wish you good luck, but you\'re using botplay.';
			case '~':
				//text = 'I- I- You- ??????';
				text = 'I... Wh... I just..\nWhaat.';
			case 'Drippy':
				text = 'Your blood be really drippy rn :face_with_sunglasses:';
			case 'Haybot':
				text = 'Worst chromatic scale ever';
			case 'Haybot Unfair':
				text = 'Did you notice the icons';
			case 'Giraffe':
				text = 'oh my god i am going to fc a giraffe';
			case 'Similarities':
				text = 'Rosen sind rot,\nVeilchen sind blau,\nManche Gedichte reimen sich,\nAber dieser tut es nicht.';
			case 'Alacrity':
				text = 'Did you get here from Get Back Here or freeplay';
			case 'Contradiction':
				text = 'Dating Fight!';
		}
		return text;
	}

	private function set_flipHealthBar(value:Bool):Bool
	{
		//healthBar.fillDirection = (value ? RIGHT_TO_LEFT : LEFT_TO_RIGHT);
		healthBar.flipX = value;
		iconP1.flipX = value;
		iconP1b.flipX = value;
		iconP2.flipX = value;
		iconP2b.flipX = value;
		flipHealthBar = value;
		reloadHealthBarColors();
		return value;
	}

	public static function getFlipnoteShaderString(str:String):String
	{
		return str.replace('FlipnoteRed', 'FlipnoteShader').replace('FlipnoteBlue', 'FlipnoteShader');
	}

	public static function getFlipnoteNoShaderString(str:String):String
	{
		if (instance != null && instance.youreBlueNow)
			//return str.replace('FlipnoteRed', 'FlipnoteBlue').replace('FlipnoteShader', 'FlipnoteBlue');
			return getFlipnoteBlueString(str);
		//return str.replace('FlipnoteBlue', 'FlipnoteRed').replace('FlipnoteShader', 'FlipnoteRed');
		return getFlipnoteRedString(str);
	}

	public static function getFlipnoteRedString(str:String):String
	{
		return str.replace('FlipnoteBlue', 'FlipnoteRed').replace('FlipnoteShader', 'FlipnoteRed');
	}

	public static function getFlipnoteBlueString(str:String):String
	{
		return str.replace('FlipnoteRed', 'FlipnoteBlue').replace('FlipnoteShader', 'FlipnoteBlue');
	}

	public static function setStuffOnExit()
	{
		FlxG.fullscreen = false;
		//lime.app.Application.current.window.title = lime.app.Application.current.meta.get('title');
		lime.app.Application.current.window.title = "Funkin' in Sunny Side Skies";

		if (instance != null)
		{
			Main.fpsVar.visible = instance.fpsVisible;

			for (tween in instance.modchartTweens) { // For scrolling stages
				tween.active = false;
			}
			for (timer in instance.modchartTimers) { // Eh, why not, for consistency's sake
				timer.active = false;
			}
		}
	}

	public function getSongCredits():String
	{
		//var songName = SONG.song.replace(' ' + remixDiffName, '');
		var songName = songNameNoDiff;
		var credits = '[CREDITS MISSING]';

		if ((songName == 'Best Friend' || songName == 'Blitz' || songName == 'Polar Opposite') ||
			(songName == 'Rematch' || songName == 'Get Back Here!' || songName == 'Free Time') ||
			(songName == 'Unfamiliar' || songName == 'Raveyard') ||
			(songName == 'Dude' || songName == 'Toasty') ||
			(songName == 'Cafe Mocha' || songName == 'Extra Whip' || songName == '$5.87' || songName == 'Cinnamon Roll') ||
			(songName == 'Overcast Overview') ||
			(songName == 'Haybot' || songName == 'Giraffe' || songName == 'Light Gray Stained Glass Pane'))
			credits = 'By dombomb64';
		else if (songName == 'Infected' || songName == 'Eye Spy' || songName == 'Sand Land')
			credits = 'Original and cover by dombomb64';
		else if (songName == 'Defeat')
			credits = 'Original by Rareblin\nCover and chart by dombomb64';
		else if (songName == 'Game Over')
			credits = 'Original by Saster and kiwiquest\nCover and chart by dombomb64';
		else if (songName == 'Zanta' || songName == 'Toyboy')
			credits = 'Original by bb-panzu\nCover and chart by dombomb64';
		else if (songName == 'Monochrome')
			credits = 'Original by Adam McHummus\nCover and chart by dombomb64';
		else if (songName == 'Wahaha!')
			credits = 'Original (Nyeh Heh Heh!) by Toby Fox\nAdaptation and chart by dombomb64';
		else if (songName == 'Cross-Comic Clash')
			credits = 'Original (Cross-Console Clash) by B.O. Eszett\nCover and chart by dombomb64';
		else if (songName == 'Challeng-Edd')
			credits = 'Original by philiplol\nCover and chart by dombomb64';
		else if (songName == 'Stuck?')
			credits = 'By dombomb64\nWith Leitmotifs from Plants vs Zombies and Super Stickman Golf 2';
		else if (songName == 'Final Round')
			credits = 'Original by Punkett\nCover by dombomb64';
		else if (songName == 'Abuse')
			credits = 'Original by car\nCover and chart by dombomb64';
		/*else if (songName == 'Fatality')
			credits = 'Original by Saster\nCover and chart by dombomb64';*/
		else if (songName == '~')
			credits = '';
		else if (songName == 'Drippy')
			credits = 'Original (Defeat) by Rareblin\nAdaptation and chart by dombomb64';
		else if (songName == 'Similarities')
			credits = 'Original (Defeat) by Rareblin\nAdaptation 1 (Defeat, But I Remade It... sorta.) by JomJom412\nAdaptation 2 (Defeat but it\'s the Angry Birds Theme), mashup, and chart by dombomb64';
		else if (songName == 'Alacrity')
			credits = 'Composed by dombomb64\nCharted by deltuh\nChart modified by dombomb64';
		else if (songName == 'Contradiction')
			credits = 'Original (Racism) by LeonJD\nAdaptation and chart by dombomb64';
		
		return credits;
	}

	public function getLogoName(char:String):String
	{
		//var charLowercar = char.toLowerCase(); // Pfffff, heheh.
		if (char.contains('adam'))
			return 'logo-adam';
		else if (char.contains('chase'))
			return 'logo-chase';
		else if (char.contains('elliot'))
			return 'logo-elliot';
		else if (char.contains('kristen'))
			return 'logo-kristen';
		else if (char.contains('adiel'))
			return 'logo-adiel';
		else if (char.contains('chance'))
			return 'logo-chance';
		else if (char.contains('sett'))
			return 'logo-sett';
		else if (char.contains('dandy'))
			return 'logo-dandy';
		else if (char.contains('dude'))
			return 'logo-dude';
		else if (char.contains('jim'))
			return 'logo-jim';
		else if (char.contains('pj'))
			return 'logo-pj';
		return 'icon';
	}

	/*public function finaleUnlocked():Bool
	{
		var finaleSatisfied = true;
		var finaleSongs:Array<String> = FreeplayState.getFinaleSongs();
		for (i in finaleSongs) {
			var song:SongMetadata = null;
			for (j in songs)
			{
				if (j.songName == i)
				{
					song = j;
					break;
				}
			}
			if (song != null && !FreeplayState.hasBeatSong(song))
			{
				finaleSatisfied = false;
				break;
			}
		}
		return finaleSatisfied;
	}*/
}
