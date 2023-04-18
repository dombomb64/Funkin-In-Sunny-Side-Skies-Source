package;

import flixel.FlxCamera;
import Achievements.AchievementObject;
import HealthIcon.CoolIcon;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import haxe.Json;
import TitleState.TitleData;
import haxe.macro.Type.AbstractType;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import openfl.display.BlendMode;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	static var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreBG2:FlxSprite;
	var scoreText:FlxText;
	var scoreTextScrolling:AttachedFlxText;
	var diffText:FlxText;
	//var diffTextScrolling:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var weebtownGrp1:FlxTypedGroup<AttachedSprite>;
	private var weebtownGrp2:FlxTypedGroup<AttachedSprite>;
	//private var weebtownGrp1:Array<AttachedSprite>;
	//private var weebtownGrp2:Array<AttachedSprite>;

	private var iconArray:Array<HealthIcon> = [];
	//private var iconPosArr:Array<FlxPoint> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var jokeSongsStart:Int = -1;
	//var jokeSongsEnd:Int = -1;

	var charGrp:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	var legsGrp:FlxSpriteGroup = new FlxSpriteGroup();
	var debugKeys:Array<FlxKey>;

	var resetScoreScreen:ResetScoreSubState;

	var noControls:Bool = false;

	var initialObfuscation:Bool = false;
	
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);
		songs = [];

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		//trace(curBeat);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Freeplay Menu", null);
		#end

		//trace(StoryMenuState.weekCompleted);
		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		bg.makeGraphic(Std.int(bg.width), Std.int(bg.height), 0xFF9AB710);

		weebtownGrp1 = new FlxTypedGroup<AttachedSprite>();
		add(weebtownGrp1);
		weebtownGrp2 = new FlxTypedGroup<AttachedSprite>();
		add(weebtownGrp2);
		//weebtownGrp1 = [];
		//weebtownGrp2 = [];

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			// Song name
			var songText:Alphabet = new Alphabet(20 + 150, 320, songs[i].songName, false, 'alphabetWhite', true);
			songText.isMenuItem = true;
			songText.isWebtoonMenu = true;
			songText.targetY = i - curSelected;
			songText.boldOffset = -70;
			//songText.color = songs[i].color;
			//songText.blend = BlendMode.INVERT;
			//songText.makeGraphic();
			grpSongs.add(songText);
			
			// For long names
			if (songText.text.length > 20)
			{
				songText.scaleX = 0.7;
				//songText.color = songs[curSelected].color;
				for (letter in songText.letters)
				{
					letter.offset.y = letter.height - 70;
					letter.scale.x = 0.7;
				}
				songText.x += 40;
			}

			// Colored BG
			var weebtown:AttachedSprite = new AttachedSprite('webtoonFreeplay1');
			//weebtown.sprTracker = songText;
			weebtown.copyAlpha = false;
			weebtown.xAdd = -20 - 150;
			weebtown.yAdd = -33 - 2;
			weebtown.color = songs[i].color;
			weebtownGrp1.add(weebtown);
			if (songs[i].songName == '~')
			{
				weebtown.alpha = 0;
				songText.alpha = 0;
			}
			//add(weebtown);

			// Box for text
			var weebtown:AttachedSprite = new AttachedSprite('webtoonFreeplay2');
			//weebtown.sprTracker = songText;
			weebtown.copyAlpha = false;
			weebtown.xAdd = -20 - 150;
			weebtown.yAdd = -33 - 2;
			weebtownGrp2.add(weebtown);
			if (songs[i].songName == '~')
				weebtown.alpha = 0;
			//add(weebtown);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();
			//trace('Y value of menu item ' + i + ': ' + songText.y);

			Paths.currentModDirectory = songs[i].folder;

			var iconName = songs[i].songCharacter;
			/*var iconHasShader = false;
			if (ClientPrefs.shaders && (iconName.endsWith('FlipnoteRed') || iconName.endsWith('FlipnoteBlue')))
			{
				iconName = PlayState.getFlipnoteShaderString(iconName);
				iconHasShader = true;
			}
			else if (!ClientPrefs.shaders && (iconName.endsWith('FlipnoteShader')))
				iconName = PlayState.getFlipnoteRedString(iconName);*/

			var icon:HealthIcon;
			if (!HealthIcon.hasWinningIcon(iconName))
				icon = new HealthIcon(iconName);
			else
				icon = new CoolIcon(iconName);
			icon.sprTracker = songText;
			//if (iconHasShader)
				//icon.shader = new FlipnoteDither.FlipnoteDitherShader();
			//trace(icon.x + ', ' + icon.y);
			//icon.forceUpdate();
			//trace(icon.x + ', ' + icon.y);
			//icon.clipRect = new FlxRect(0, 0, icon.width, icon.height);

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			//iconPosArr.push(new FlxPoint(icon.x, icon.y));
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);

			if (songs[i].songName == 'Drippy')
				jokeSongsStart = i;
			//else if (songs[i].songName == 'Alacrity')
				//jokeSongsEnd = i;
		}
		//trace('drippy position is ' + jokeSongsStart + ', alacrity postion is ' + jokeSongsEnd);
		WeekData.setDirectoryFromWeek();

		//trace(Highscore.songScores.toString());

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.BLACK, RIGHT);
		//scoreText.color = 0xFF000000;
		
		scoreTextScrolling = new AttachedFlxText(FlxG.width * 0.7, 5, FlxG.width, "h\nh", 32);
		scoreTextScrolling.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.BLACK, RIGHT);
		//scoreTextScrolling.xAdd = FlxG.width - scoreTextScrolling.fieldWidth - 20;
		scoreTextScrolling.yAdd = (154 - scoreTextScrolling.height) / 2;
		scoreTextScrolling.copyAlpha = false;
		add(scoreTextScrolling);

		scoreBG = new FlxSprite(scoreText.x - 10, 0).makeGraphic(1, 70, 0xFFE0E0E0);
		//scoreBG.alpha = 0.6;
		//add(scoreBG);
		scoreBG.offset.x = 4;
		scoreBG.offset.y = 4;
		scoreBG2 = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFFFFFFFF);
		//scoreBG2.alpha = 0.6;
		//add(scoreBG2);
		
		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.color = 0xFF000000;
		//add(diffText);

		//add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		//bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		/*var i:Int = 0;
		for (item in grpSongs) // For some reason it only realizes if you've visited a song after it first spits out the initial garbage and then never forgets
		{
			var fetchMeTheirMemories:Bool = Highscore.getSongVisited(Paths.formatToSongPath(songs[i].songName));
			i++;
		}*/

		updateObfuscation();

		//changeSelection(0, false);
		//persistentUpdate = true;
		//updateObfuscation();

		//var swag:Alphabet = new Alphabet(1, 0, "swag"); // Why? This serves no purpose

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 30).makeGraphic(FlxG.width, 30, 0xFFE0E0E0);
		//textBG.alpha = 0.6;
		add(textBG);

		var textBG2:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFFFFFFFF);
		//textBG2.alpha = 0.6;
		add(textBG2);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG2.x, textBG2.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.BLACK, CENTER);
		text.scrollFactor.set();
		add(text);

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		add(legsGrp);
		add(charGrp);
		super.create();
	}

	public function updateObfuscation()
	{
		var i = 0;
		for (item in grpSongs.members) {
			//trace('Song Name: ' + songs[i].songName + ', Is Freeplay: ' + (WeekData.weeksList[songs[i].week].indexOf('freeplay') != -1) + ', Has Not Beat: ' + !hasBeatSong(songs[i]));
			//if (WeekData.weeksList[songs[i].week].indexOf('freeplay') != -1 && (Highscore.getScore(songs[i].songName, 0) == 0 && Highscore.getScore(songs[i].songName, 1) == 0 && Highscore.getScore(songs[i].songName, 2) == 0 && Highscore.getScore(songs[i].songName, 3) == 0))
			if (WeekData.weeksList[songs[i].week].indexOf('freeplay') != -1 && !Highscore.getSongVisited(Paths.formatToSongPath(songs[i].songName)))
			{
				/*for (letter in item.members)
				{
					iconArray[i].xAdd -= letter.width; // Sliiide to the left
					//iconArray[i].xAdd += 44; // Sliiide to the right (Question mark width in alphabet.xml)
					iconArray[i].xAdd += 39; // Never mind, it's not bold
				}*/
				item.text = obfuscateString(songs[i].songName); // &kYou cannot read this >:)
				//item.updateHitbox();
				iconArray[i].color = 0x50202020;
				weebtownGrp1.members[i].color = FlxColor.multiply(songs[i].color, 0xFF808080);
			}
			else
			{
				item.text = songs[i].songName;
				iconArray[i].color = 0xFFFFFFFF;
				weebtownGrp1.members[i].color = songs[i].color;
				//trace(item.text + ', ' + item.x);
			}
			item.color = FlxColor.LIME; // test windows // Edit: WHY DOES THIS MAKE IT WORK
			item.color = songs[i].color;
			if (item.color == FlxColor.WHITE)
				item.color = FlxColor.BLACK;
			i++;
		}
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		/*if (resetScoreScreen != null)
			updateObfuscation();*/
		super.closeSubState();
	}

	public static function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	public static function weekIsLocked(name:String):Bool {
		//trace(WeekData.weeksLoaded);
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		var isFinale:Bool = leWeek.finale;
		var finaleSatisfied:Bool = true;
		if (isFinale) {
			var finaleSongs:Array<String> = getFinaleSongs();
			//trace(getFinaleSongs());
			for (i in finaleSongs) {
				//var song:SongMetadata = null;
				for (j in songs)
				{
					if (j.songName == i)
					{
						//trace(j.songName);
						//song = j;
						if (j != null && !hasBeatSong(j))
						{
							//trace('^ beat that ^');
							finaleSatisfied = false;
						}
						break;
					}
				}
				/*if (song != null && !hasBeatSong(song))
				{
					finaleSatisfied = false;
					break;
				}*/
			}
			//trace(finaleSatisfied);
		}
		//trace(leWeek.fileName + ' locked? ' + ((!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore))) && ((isFinale && !finaleSatisfied) || !isFinale)) + ', ' + !StoryMenuState.weekCompleted.exists(leWeek.weekBefore) + ', ' + !StoryMenuState.weekCompleted.get(leWeek.weekBefore) + ', ' + ((isFinale && !finaleSatisfied) || !isFinale));
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore))) && ((isFinale && !finaleSatisfied) || !isFinale);
	}

	public static function getFinaleSongs():Array<String>
	{
		var fullText:String = Assets.getText(Paths.txt('finaleSongs'));

		var firstArray:Array<String> = fullText.replace('\x0d', '').split('\n'); // Carriage Return??
		var finaleSongs:Array<String> = [];

		for (i in firstArray) {
			//trace(tempText[0].length);
			if (i != null && i.length > 0) {
				//trace(tempText[0].charCodeAt(0));
				finaleSongs.push(i);
			}
		}

		return finaleSongs;
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	var diffPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
		{
			var titleJSON:TitleData = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));
			Conductor.songPosition = FlxG.sound.music.time; // YOU HAVE TO UPDATE IT YOURSELF AAAAAA
			Conductor.changeBPM(titleJSON.bpm);
			
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		//var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		/*var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(intendedRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}*/

		//scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		//positionHighscore();

		var upP = controls.UI_UP_P && !noControls;
		var downP = controls.UI_DOWN_P && !noControls;
		var accepted = controls.ACCEPT && !noControls;
		var space = FlxG.keys.justPressed.SPACE && !noControls;
		var ctrl = FlxG.keys.justPressed.CONTROL && !noControls;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT && !noControls) shiftMult = 3;

		var justEntered:Bool = false;
		if (accepted && songs[curSelected].songName == 'Cinnamon Roll')
		{
			justEntered = true;
			noControls = true;
		}
		else if (accepted)
		{
			justEntered = true;
		}

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if((controls.UI_DOWN || controls.UI_UP) && !noControls)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix), 0.4);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P && !noControls)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P && !noControls)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK && !noControls)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu' + ClientPrefs.menuSoundSuffix));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected && diffPlaying != curDifficulty)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				diffPlaying = curDifficulty;
				#end
			}
		}

		else if (accepted && justEntered)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			FlxG.sound.music.volume = 0;
			FlxG.sound.play(Paths.sound('playFreeplay' + ClientPrefs.menuSoundSuffix));
			FlxG.sound.music.stop();
					
			destroyFreeplayVocals();

			if (FlxG.keys.pressed.SHIFT && !noControls) {
				PlayState.chartingMode = true; // Bro why did I have to add this -Dom
				LoadingState.loadAndSwitchState(new ChartingState());
			}
			else {
				if (songs[curSelected].songName == 'Cinnamon Roll') {
					var i = 0;
					for (song in grpSongs)
					{
						//trace(songs[i].songName);
						if (i == curSelected)
						{
							/*var oldX = song.x;
							song.text = 'Chase X Adam Shipping Cute';
							song.scaleX = 0.7;
							song.x = oldX;
							song.color = songs[curSelected].color;*/
							var funnyText:Alphabet = new Alphabet(song.x, song.y, 'Chase X Adam Shipping Cute', false, 'alphabetWhite');
							funnyText.scaleX = 0.7;
							funnyText.color = songs[curSelected].color;
							for (letter in funnyText.letters)
							{
								letter.offset.y = letter.height - 70;
								letter.scale.x = 0.7;
							}
							funnyText.x += 52;
							add(funnyText);
							song.visible = false;
							break;
							//trace('i want chase to pinch my face like he did to adam');
						}
						i++;
					}
					noControls = true;
					new FlxTimer().start(1, function(tmr:FlxTimer) {
						LoadingState.loadAndSwitchState(new PlayState());
					});
				}
				else
					LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			resetScoreScreen = new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter, -1, WeekData.weeksList[songs[curSelected].week]);
			openSubState(resetScoreScreen);
			FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
		}

		if (FlxG.keys.anyJustPressed(debugKeys) && !noControls)
		{
			if (charGrp.length < 10)
			{
				var charX = FlxG.random.float(0, FlxG.width);
				var charY = FlxG.random.float(0, FlxG.height);
				var isPlayer = FlxG.random.bool(50);
				var char = new Character(charX, charY, 'alexRun', isPlayer, false);
				char.addLegs(legsGrp);
				charGrp.add(char);
			}
			else
			{
				for (item in charGrp)
				{
					item.destroy();
					charGrp.remove(item, true);
				}
				for (item in legsGrp)
				{
					item.destroy();
					legsGrp.remove(item, true);
				}
				//charGrp = new FlxTypedGroup<Character>();
				//legsGrp = new FlxSpriteGroup();
			}
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...iconArray.length) {
			var mult:Float = FlxMath.lerp(1 * iconArray[i].freeplayScale, iconArray[i].scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			//var mult:Float = iconArray[i].scale.x * 0.99;
			iconArray[i].scale.set(mult, mult);
			//cropIcon(iconArray[i], new FlxPoint(FlxMath.lerp(1, iconArray[i].scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)), FlxMath.lerp(1, iconArray[i].scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1)))); // Apparently it's a frame late??
			cropIcon(iconArray[i]); // Never mind, I'm just stupid
			
			/*var nextFrameTime = Conductor.songPosition + elapsed;
			var lastChange = Conductor.getBPMFromSeconds(nextFrameTime);
			var shit = ((nextFrameTime - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet; // I stole this from MusicBeatState.hx so the swear jar is still empty
			var beatNextFrame = Math.floor((lastChange.stepTime + Math.floor(shit)) / 4);

			if (beatNextFrame != curBeat)
				cropIcon(iconArray[i], new FlxPoint());*/
			// I'M AN IDIOT I FORGOT TO CROP THE SELECTED ICON DIFFERENTLY THAT'S WHY IT WASN'T WORKING

			//weebtownGrp1.members[i].y = grpSongs.members[i].y + weebtownGrp1.members[i].yAdd;
			weebtownGrp1.members[i].y = FlxMath.lerp(grpSongs.members[i].y, (grpSongs.members[i].targetY * grpSongs.members[i].distancePerItem.y) + grpSongs.members[i].startPosition.y, lerpVal) + weebtownGrp1.members[i].yAdd;
			weebtownGrp2.members[i].y = weebtownGrp1.members[i].y;
		}
		scoreTextScrolling.y = weebtownGrp1.members[curSelected].y + scoreTextScrolling.yAdd;

		//if (!initialObfuscation)
		//{
			//updateObfuscation(); // Okay so the for loop with the garbage variable didn't work I guess I'll just run it twice then
			// Get the first bonus song // Edit: Get the first song that works UGHHH
			/*var bonusSong:Int = -1;
			for (i in 0...songs.length)
			{
				//if (WeekData.weeksList[songs[i].week].indexOf('freeplay') != -1)
				if (songs[i].songName == 'Zanta')
				{
					bonusSong = i;
					break;
				}
			}

			if (bonusSong != -1)
			{
				// Scroll to the song
				//changeSelection(bonusSong - curSelected, false);
				//changeDiff();

				// Open reset score screen
				persistentUpdate = false;
				resetScoreScreen = new ResetScoreSubState(songs[bonusSong].songName, 0, songs[bonusSong].songCharacter);
				openSubState(resetScoreScreen);

				// Then unfold everything (why)
				resetScoreScreen.close();
				//changeSelection(-(bonusSong - curSelected), false);
				//changeDiff();
			}*/
			
			/*// Open reset score screen
			persistentUpdate = false;
			resetScoreScreen = new ResetScoreSubState('Zanta', 0, 'senpaiNutshell');
			openSubState(resetScoreScreen);
			
			// Then unfold everything (why)
			resetScoreScreen.close();*/

			//initialObfuscation = true;
		//}
		// This was to make the obfuscation behave but it's fixed now c:
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy(); // The true worst minority
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		//trace(curDifficulty);

		if (change != 0)
			FlxG.sound.play(Paths.sound('tickMenu' + ClientPrefs.menuSoundSuffix));

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end
		var fc:Bool = Highscore.getSongFC(songs[curSelected].songName, curDifficulty);
		//trace('FC: ' + fc);

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
		
		//var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(intendedRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		//scoreTextScrolling.text = 'PB: ' + intendedScore + ' (' + ratingSplit.join('.') + '%) - ' + diffText.text;
		scoreTextScrolling.text = 'PB: ' + intendedScore + ' (' + ratingSplit.join('.') + '%)\n' + (fc ? 'FC ' : '') + diffText.text;

		for (item in grpSongs)
		{
			if (item.targetY == 0)
			{
				/*var oldHeight = scoreTextScrolling.height;
				scoreTextScrolling.fieldWidth = FlxG.width - (item.letters[item.letters.length - 1].x + item.letters[item.letters.length - 1].width + 20);
				if (scoreTextScrolling.height > oldHeight)
					//scoreTextScrolling.text = scoreTextScrolling.text.replace(' - ', '\n');
					scoreTextScrolling.text = 'PB: ' + intendedScore + ' (' + ratingSplit.join('.') + '%)\n' + diffText.text;
				trace(scoreTextScrolling.width);*/
				if (item.text == '~')
					scoreTextScrolling.text = diffText.text;
				break;
			}
		}

		//scoreTextScrolling.xAdd = FlxG.width - scoreTextScrolling.width - 20;
		scoreTextScrolling.yAdd = (154 - scoreTextScrolling.height) / 2;
		scoreTextScrolling.x = FlxG.width - scoreTextScrolling.width - 20;
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		//trace(ClientPrefs.menuSoundSuffix);
		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		/*var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}*/

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		/*for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;*/

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;

			if (item.targetY == 0) {
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
				iconArray[bullShit].scale.x /= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].scale.y /= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].freeplayScale = 1.25;
				iconArray[bullShit].scale.x *= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].scale.y *= iconArray[bullShit].freeplayScale;
			}
			else {
				item.alpha = 0.6;
				// item.setGraphicSize(Std.int(item.width * 0.8));
				iconArray[bullShit].scale.x /= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].scale.y /= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].freeplayScale = 1;
				iconArray[bullShit].scale.x *= iconArray[bullShit].freeplayScale;
				iconArray[bullShit].scale.y *= iconArray[bullShit].freeplayScale;
			}
			
			if (item.text == '~') {
				item.alpha = 0;

				if (bullShit == curSelected)
				{
					scoreTextScrolling.text = diffText.text;
					scoreTextScrolling.yAdd = (154 - scoreTextScrolling.height) / 2;
					scoreTextScrolling.color = FlxColor.WHITE;
				}
			}
			else if (bullShit == curSelected)
				scoreTextScrolling.color = FlxColor.BLACK;
			
			bullShit++;
		}

		/*for (bearPoop in 0...weebtownGrp1.members.length) // Why did I do this????? What kinda drugs was I on?????????
		{
			if (bearPoop == curSelected)
			{
				scoreTextScrolling.sprTracker = weebtownGrp1.members[bearPoop];
				break;
			}
		}*/
		//scoreTextScrolling.sprTracker = weebtownGrp1.members[curSelected]; // Crack // Edit: Manually moving it because it lags behind
		//scoreTextScrolling.y = weebtownGrp1.members[curSelected].y + scoreTextScrolling.yAdd;
		//var lerpVal:Float = CoolUtil.boundTo(FlxG.elapsed * 9.6, 0, 1);
		//scoreTextScrolling.y = FlxMath.lerp(grpSongs.members[curSelected].y, (grpSongs.members[curSelected].targetY * grpSongs.members[curSelected].distancePerItem.y) + grpSongs.members[curSelected].startPosition.y, lerpVal) + scoreTextScrolling.yAdd;
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if (diffStr != null && diffStr.length > 0) {
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		
		#if ACHIEVEMENTS_ALLOWED
		//if (jokeSongsStart != -1 && jokeSongsEnd != -1 && (iconArray[jokeSongsStart].isOnScreen(FlxG.camera) || iconArray[jokeSongsEnd].isOnScreen(FlxG.camera)))
		if (jokeSongsStart != -1 && curSelected >= jokeSongsStart - 2 && !Achievements.isAchievementUnlocked('joke_songs'))
		{
			trace('unlocking joke song achievement');
			Achievements.unlockAchievement('joke_songs');
			
			var achievementObj = new AchievementObject('joke_songs', camAchievement);
			//achievementObj.onFinish = achievementEnd;
			add(achievementObj);
			//trace('Giving achievement ' + achieve);
		}
		#end
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG2.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG2.x = FlxG.width - (scoreBG2.scale.x / 2);
		diffText.x = Std.int(scoreBG2.x + (scoreBG2.width / 2));
		diffText.x -= diffText.width / 2;
		//scoreBG.scale.x = scoreBG2.scale.x + 0.1;
		//scoreBG.scale.y = scoreBG2.scale.y + 0.1;
		scoreBG.scale.set(scoreBG2.scale.x + 20, scoreBG2.scale.y + 0.1);
		scoreBG.x = scoreBG2.x + 10;
	}

	/**
		Cool Lullaby thing that I recreated

		Takes a String `str` and returns a version of it with question marks instead of letters, exclamation points, dollar signs, commas, and periods.
	**/
	private function obfuscateString(str:String):String { // Cool Lullaby thing that I recreated
		//var temp = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!?$,.'; // We don't tell anybody about the question mark
		var temp = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890'; // Never mind! I have an idea.
		var bannedChars:Array<String> = temp.split('');
		var newStr:Array<String> = [];
		var strArr:Array<String> = str.split(''); // Round all the suspects up

		for (i in strArr) { // Original string
			var isBanned:Bool = false;
			for (j in bannedChars) { // Banned character list
				if (i == j) // Caught a banned character
				{
					newStr.push('?'); // Eviction notice
					isBanned = true;
					break;
				}
			}
			if (!isBanned) // Free to go
			{
				newStr.push(i);
			}
		}

		return newStr.join('');
		// Found a better way
		// Nvm can't get it to work
		//var imBanned = ~/[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890!\?\$,\.]/;
		//var str = imBanned.split(str).join('?');
		//return str;
	}

	/**
		Returns `true` if the player has beat the song `song`, and `false` if they haven't.
	**/
	private static function hasBeatSong(song:SongMetadata):Bool {
		var weekName:String = WeekData.weeksList[song.week];
		var leWeek:WeekData = WeekData.weeksLoaded.get(weekName); // Stole this from weekIsLocked lol
		
		var coolDiffs:Array<String> = CoolUtil.difficulties;
		CoolUtil.difficulties = leWeek.difficulties.split(',');
		//trace(CoolUtil.difficulties);
		if (CoolUtil.difficulties == null || CoolUtil.difficulties.toString() == '[]') {
			CoolUtil.difficulties = ['Easy', 'Normal', 'Hard'];
		}
		for (i in 0...CoolUtil.difficulties.length)
		{
			CoolUtil.difficulties[i] = StringTools.trim(CoolUtil.difficulties[i]);
		}

		var diffList:String = CoolUtil.difficulties.join(',');
		var diffCount:Int = CoolUtil.difficulties.length;
		//trace(CoolUtil.difficulties + ', ' + diffList);
		//var diffList:String = leWeek.difficulties;
		//var diffCount:Int = 1; // 1 extra because there shouldn't be a trailing comma
		/*if (diffList == null || diffList == '')
			diffList = 'Easy, Normal, Hard';

		for (i in 0...diffList.length)
		{
			if (diffList.charAt(i) == ',')
				diffCount++;
		}*/

		//var totalScore:Int = 0;
		var isChallenge:Bool = (StringTools.trim(diffList.toLowerCase()) == 'hard'); // They're called challenge songs now, I guess
		//trace('weekName: ' + weekName + ', diffList: ' + diffList + ', diffCount: ' + diffCount + ', song.songName: ' + song.songName);
		if (isChallenge)
		{
			//trace('Song Name: ' + Highscore.formatSong(song.songName, 0));
			//trace('^ Challenge song ^ (Score: ' + Highscore.getScore(song.songName, 2) + ')');
			CoolUtil.difficulties = coolDiffs;
			return Highscore.getScore(song.songName, 2) != 0;
		}
		else
		{
			for (i in 0...diffCount)
			{
				if (Highscore.getScore(song.songName, i) != 0)
				{
					//trace('^ They beat that one ^ (Score: ' + Highscore.getScore(song.songName, i) + ')');
					CoolUtil.difficulties = coolDiffs;
					return true;
				}
			}
		}
		//(Highscore.getScore(songs[i].songName, 0) == 0 && Highscore.getScore(songs[i].songName, 1) == 0 && Highscore.getScore(songs[i].songName, 2) == 0 && Highscore.getScore(songs[i].songName, 3) == 0)
		//return totalScore != 0;
		CoolUtil.difficulties = coolDiffs;
		return false;
	}

	override function beatHit()
	{
		super.beatHit();
		
		if (FlxG.sound.music != null && FlxG.sound.music.volume != 0)
		{
			for (i in 0...iconArray.length)
			{
				iconArray[i].scale.set(1.2 * iconArray[i].freeplayScale, 1.2 * iconArray[i].freeplayScale);
				cropIcon(iconArray[i]);
			}
			//iconArray[curSelected].scale.set(1.7 * iconArray[curSelected].freeplayScale, 1.7 * iconArray[curSelected].freeplayScale);
			//cropIcon(iconArray[curSelected]); // i forgor *Majora's Mask bell* (Polygon Donut reference!!)
			//trace('beat ' + curBeat);

			for (char in charGrp) // lolmao
			{
				if (curBeat % char.danceEveryNumBeats == 0)
				{
					if (char.legs != null)
						char.legs.dance(true);
					if (char.animation.curAnim != null && !char.animation.curAnim.name.startsWith('sing'))
						char.dance();
				}
			}
		}
	}

	function cropIcon(icon:FlxSprite, ?scale:FlxPoint = null)
	{
		if (scale == null)
			scale = icon.scale; // Bruh just let me set it in the parameters
		var initSize:FlxPoint = new FlxPoint(150 / scale.x, 150 / scale.y);
		var offsetScale:FlxPoint = new FlxPoint(icon.offset.x / scale.x, icon.offset.y / scale.y);
		var clipOffset:FlxPoint = new FlxPoint(((150 - initSize.x) / 2) + offsetScale.x, ((150 - initSize.y) / 2) + offsetScale.y);
		icon.clipRect = new FlxRect(clipOffset.x, clipOffset.y, initSize.x, initSize.y); // Crop it like it's an image in that box
	}

	public static function loadSongs(isStoryMode:Bool = false)
	{
		WeekData.reloadWeekFiles(isStoryMode);
		//trace(WeekData.weeksLoaded);
		songs = [];
		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}