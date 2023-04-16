package;

import flixel.effects.FlxFlicker;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var leftArrowWeek:FlxSprite;
	var rightArrowWeek:FlxSprite;
	var sprWeek:FlxSprite;

	var loadedWeeks:Array<WeekData> = [];

	var isDiffSelected:Bool = false; // True for weeks, false for difficulties

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "Score: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'Rank: PINBES';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		//var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		var bgYellow:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 386, 0xFFD8BD9F);
		bgSprite = new FlxSprite(0, 56);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Story Mode Menu", null);
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[i]);
				weekThing.x += ((weekThing.height + 20) * num) * 0.1;
				weekThing.targetY = num;
				weekThing.visible = false;
				grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				weekThing.antialiasing = ClientPrefs.globalAntialiasing;
				// weekThing.updateHitbox();

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.frames = ui_tex;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					lock.antialiasing = ClientPrefs.globalAntialiasing;
					grpLocks.add(lock);
				}
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		sprWeek = new FlxSprite(0, grpWeekText.members[0].y + 10 + 15);
		sprWeek.antialiasing = ClientPrefs.globalAntialiasing;
		//sprWeek.alpha = 0.6;
		sprWeek.loadGraphic(Paths.image('theHungerNutshell'));
		sprWeek.screenCenter(X);
		sprWeek.x += FlxG.width / 6;
		sprWeek.offset.y = 15;
		difficultySelectors.add(sprWeek);
		
		sprDifficulty = new FlxSprite(0, grpWeekText.members[0].y + 10 + 135);
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		sprDifficulty.alpha = 0.6;
		sprDifficulty.loadGraphic(Paths.image('theHungerNutshell'));
		sprDifficulty.screenCenter(X);
		sprDifficulty.x += FlxG.width / 6;
		difficultySelectors.add(sprDifficulty);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, sprDifficulty.y);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		leftArrow.alpha = 0.2;
		difficultySelectors.add(leftArrow);

		leftArrowWeek = new FlxSprite(grpWeekText.members[0].x, sprWeek.y);
		leftArrowWeek.frames = ui_tex;
		leftArrowWeek.animation.addByPrefix('idle', "arrow left");
		leftArrowWeek.animation.addByPrefix('press', "arrow push left");
		leftArrowWeek.animation.play('idle');
		leftArrowWeek.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(leftArrowWeek);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.alpha = 0.2;
		difficultySelectors.add(rightArrow);

		rightArrowWeek = new FlxSprite(leftArrowWeek.x + 376, leftArrowWeek.y);
		rightArrowWeek.frames = ui_tex;
		rightArrowWeek.animation.addByPrefix('idle', 'arrow right');
		rightArrowWeek.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrowWeek.animation.play('idle');
		rightArrowWeek.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(rightArrowWeek);

		add(bgYellow);
		add(bgSprite);
		add(grpWeekCharacters);

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 425).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
		tracksSprite.screenCenter(X);
		tracksSprite.x -= FlxG.width / 6;
		add(tracksSprite);

		txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		changeWeek();
		changeDifficulty();
		
		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "Week Score: " + lerpScore;

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			var upP = controls.UI_LEFT_P && !isDiffSelected; // trololol *waves le noodle arms*
			var downP = controls.UI_RIGHT_P && !isDiffSelected;
			var up = controls.UI_LEFT && !isDiffSelected;
			var down = controls.UI_RIGHT && !isDiffSelected;

			if (upP)
			{
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
			}

			if (downP)
			{
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
			}
			
			if (up)
				leftArrowWeek.animation.play('press');
			else
				leftArrowWeek.animation.play('idle');

			if (down)
				rightArrowWeek.animation.play('press');
			else
				rightArrowWeek.animation.play('idle');

			if(FlxG.mouse.wheel != 0)
			{
				//FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix), 0.4);
				FlxG.sound.play(Paths.sound('tickMenu' + ClientPrefs.menuSoundSuffix));
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}

			var leftP = controls.UI_LEFT_P && isDiffSelected;
			var rightP = controls.UI_RIGHT_P && isDiffSelected;
			var left = controls.UI_LEFT && isDiffSelected;
			var right = controls.UI_RIGHT && isDiffSelected;

			if (right)
				rightArrow.animation.play('press');
			else
				rightArrow.animation.play('idle');

			if (left)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (rightP)
			{
				changeDifficulty(1);
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
			}
			else if (leftP)
			{
				changeDifficulty(-1);
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
			}
			else if (upP || downP)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
			}
			else if (controls.ACCEPT)
			{
				selectWeek();
			}

			if (controls.UI_DOWN_P || controls.UI_UP_P)
			{
				isDiffSelected = !isDiffSelected;
				FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix));
				if (isDiffSelected)
				{
					leftArrowWeek.alpha = 0.2;
					rightArrowWeek.alpha = 0.2;
					/*for (week in grpWeekText)
					{
						week.alpha = 0.6;
					}*/
					leftArrow.alpha = 1;
					rightArrow.alpha = 1;
					sprDifficulty.alpha = 1;
				}
				else
				{
					leftArrowWeek.alpha = 1;
					rightArrowWeek.alpha = 1;
					/*for (week in grpWeekText)
					{
						week.alpha = 1;
					}*/
					leftArrow.alpha = 0.2;
					rightArrow.alpha = 0.2;
					sprDifficulty.alpha = 0.6;
				}
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu' + ClientPrefs.menuSoundSuffix));
			movedBack = true;
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			lock.visible = (lock.y > FlxG.height / 2);
		});
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu' + ClientPrefs.menuSoundSuffix));

				//grpWeekText.members[curWeek].startFlashing();
				var flickerTime = FlxG.elapsed * 4;
				var tapebotWeek = new FlxSprite(sprWeek.x, sprWeek.y, sprWeek.graphic);
				tapebotWeek.offset.y = sprWeek.offset.y;
				tapebotWeek.color = 0xFF33FFFF;
				add(tapebotWeek);
				sprWeek.visible = false;

				if(ClientPrefs.flashing) {
					FlxFlicker.flicker(tapebotWeek, 10, flickerTime, false); // 10 seconds just to be safe
					FlxFlicker.flicker(sprWeek, 10, flickerTime, true);
				}

				for (char in grpWeekCharacters.members)
				{
					if (char.character != '' && char.hasConfirmAnimation)
					{
						char.animation.play('confirm');
					}
				}
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
				FreeplayState.destroyFreeplayVocals();
			});
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu' + ClientPrefs.menuSoundSuffix));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Paths.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.x += sprDifficulty.width / 2;
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x -= sprDifficulty.width / 2;
			//sprDifficulty.x = leftArrow.x + 60;
			//sprDifficulty.x += (308 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 15;
			leftArrow.x = sprDifficulty.x - 60;
			rightArrow.x = sprDifficulty.x + sprDifficulty.width + 20;

			if (tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var tweenWeek:FlxTween;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		//txtWeekTitle.text = leName.toUpperCase();
		txtWeekTitle.text = leName;
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		/*for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				//item.alpha = 1;
				item.visible = true;
			else
				//item.alpha = 0.6;
				item.visible = false;
			bullShit++;
		}*/

		var newImage:FlxGraphic = Paths.image('storymenu/' + leWeek.fileName);
		sprWeek.x += sprWeek.width / 2;
		sprWeek.loadGraphic(newImage);
		sprWeek.x -= sprWeek.width / 2;
		//sprWeek.x = leftArrowWeek.x + 60;
		//prWeek.x += (308 - sprWeek.width) / 3;
		leftArrowWeek.x = sprWeek.x - 60;
		rightArrowWeek.x = sprWeek.x + sprWeek.width + 20;

		if (tweenWeek != null) tweenWeek.cancel();
		if (change != 0) // This is for when it decides to play the animation for no reason
		{
			sprWeek.y = leftArrowWeek.y - 15;
			sprWeek.alpha = 0;
			tweenWeek = FlxTween.tween(sprWeek, {y: leftArrowWeek.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenWeek = null;
			}});
		}
		else
		{
			sprWeek.y = leftArrowWeek.y + 15;
			//sprWeek.alpha = 1;
		}

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5
		difficultySelectors.visible = unlocked;

		if(diffStr != null && diffStr.length > 0)
		{
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
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		/*var finaleSatisfied:Bool = true;
		if (leWeek.finale) {
			var finaleSongs:Array<String> = FreeplayState.getFinaleSongs();
			for (i in finaleSongs) {
				var song:SongMetadata;
				for (j in songs)
				{
					if (j.songName == i)
					{
						song = j;
						break;
					}
				}
				if (song != null && !hasBeatSong(song))
				{
					finaleSatisfied = false;
					break;
				}
			}
		}*/
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)))/* && finaleSatisfied*/;
	}

	function updateText()
	{
		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		//txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width / 6;
		//txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}
