package;

import openfl.utils.Assets;
#if MODS_ALLOWED
import sys.io.File;
#end
import haxe.Json;
import flixel.util.FlxTimer;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Exit to Menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;

	public static var songName:String = '';

	var theTrickster:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();
		if (CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!
		if (Highscore.getScore(PlayState.songNameNoDiff, PlayState.storyDifficulty) > 0 && !PlayState.chartingMode && PlayState.isStoryMode) menuItemsOG.insert(3, 'Skip Song');

		if (FlxG.save.data.finaleActive) menuItemsOG = ['Resume', 'Restart Song'];
		if (PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.songNameNoDiff;
		if (PlayState.instance.inGallery)
			levelInfo.text = 'Gallery'; // Meme... approved!
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		if (PlayState.instance.inGallery)
			levelDifficulty.text = PlayState.instance.galleryImageName + '.png';
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		if (!PlayState.instance.inGallery)
			FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P && !theTrickster;
		var downP = controls.UI_DOWN_P && !theTrickster;
		var accepted = controls.ACCEPT && !theTrickster;

		var justEntered:Bool = false;
		if (accepted && menuItems[curSelected] == 'End Song')
		{
			justEntered = true;
			theTrickster = true;
		}
		else if (accepted)
		{
			justEntered = true;
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P && !theTrickster)
				{
					FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P && !theTrickster)
				{
					FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if((controls.UI_LEFT || controls.UI_RIGHT) && !theTrickster)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted && (cantUnpause <= 0 || !ClientPrefs.controllerMode) && justEntered)
		{
			if (menuItems == difficultyChoices)
			{
				if (menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.songNameNoDiff;
					/*if (CoolUtil.difficulties[PlayState.storyDifficulty] == PlayState.remixDiffName)
						name = name.substr(0, name.length - (PlayState.remixDiffName.length + 1)); // Yeah let's try switching to data/defeat-unfair/defeat-unfair-easy.json and see how that goes*/
					
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case 'Resume':
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					deleteSkipTimeText();
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case 'Restart Song':
					restartSong();
				case 'Leave Charting Mode':
					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case 'End Song':
					// Will the player actually die?
					var tempHealth:Float = PlayState.instance.health;
					PlayState.instance.notes.forEach(function(daNote:Note) {
						@:privateAccess
						if(daNote.strumTime < PlayState.instance.songLength - Conductor.safeZoneOffset) {
							tempHealth -= 0.05 * PlayState.instance.healthLoss;
						}
					});
					for (daNote in PlayState.instance.unspawnNotes) {
						@:privateAccess
						if(daNote.strumTime < PlayState.instance.songLength - Conductor.safeZoneOffset) {
							tempHealth -= 0.05 * PlayState.instance.healthLoss;
						}
					}

					if (tempHealth <= 0)
					{
						// Prank 'em, John
						grpMenuShit.forEachAlive(function(text:Alphabet) {
							if (text.text == 'End Song') text.text = 'End Life';
						});
						theTrickster = true;

						// Okay bye-bye *anime wave gif*
						new FlxTimer().start(1, function(tmr:FlxTimer) {
							close();
							PlayState.instance.finishSong(true);
						});
					}
					else { // Bruh. Bruh. Bruh. Bruh. Bruh. Bruh. Bruh. Bruh.
						close();
						PlayState.instance.finishSong(true);
					}
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case 'Exit to Menu':
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;

					var exitDelay:Float = 0;
					var bellSoundPath = Paths.sound('tomodachiBell');
					var bellSound:FlxSound = null;
					if (PlayState.instance.boyfriend.curCharacter == 'bf') {
						exitDelay = 5;
						if (bellSoundPath != null)
						{
							bellSound = FlxG.sound.play(bellSoundPath);
							exitDelay = bellSound.length / 1000;
						}

						var bfFrame = PlayState.instance.boyfriend.animation.frameIndex;
						#if MODS_ALLOWED
						var rawJson = File.getContent(Paths.getPreloadPath('characters/bfInterrupted.json'));
						#else
						var rawJson = Assets.getText(Paths.getPreloadPath('characters/bfInterrupted.json'));
						#end
						PlayState.instance.boyfriend.frames = Paths.getSparrowAtlas(Json.parse(rawJson).image);
						//PlayState.instance.boyfriend.frames = Paths.getSparrowAtlas('characters/bfInterrupted');
						PlayState.instance.boyfriend.animation.frameIndex = bfFrame;
						
						if (FlxG.sound.music != null) {
							FlxG.sound.music.volume = 0;
							if (PlayState.instance.vocals != null)
								PlayState.instance.vocals.volume = 0;
						}

						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
							PlayState.instance.persistentUpdate = false;
							PlayState.instance.persistentDraw = true;
							PlayState.instance.paused = true;
							PlayState.instance.achievementsAndDelay = new BlankSubState();
							PlayState.instance.openSubState(PlayState.instance.achievementsAndDelay);
						});
						close();
					}

					new FlxTimer().start(exitDelay, function(tmr:FlxTimer) {
						//FlxG.fullscreen = false;
						//Main.fpsVar.visible = PlayState.instance.fpsVisible;
						PlayState.setStuffOnExit();

						WeekData.loadTheFirstEnabledMod();
						if(PlayState.isStoryMode) {
							MusicBeatState.switchState(new StoryMenuState());
						} else {
							MusicBeatState.switchState(new FreeplayState());
						}
						PlayState.cancelMusicFadeTween();
						//FlxG.sound.playMusic(Paths.music('sunnySide'));
						ClientPrefs.playMenuMusic();
						PlayState.changedDifficulty = false;
						PlayState.chartingMode = false;
					});
				case 'Skip Song':
					//close(); // Actually let PlayState handle the closing because you might get an achievement
					PlayState.instance.skippingSong = true;
					PlayState.instance.endSong();
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu' + ClientPrefs.menuSoundSuffix), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
