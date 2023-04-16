import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		["Chadam on a Friday Night",		"God, you're pathetic.",										'friday_night_play',	 true],
		/*["She Calls Me Daddy Too",		"Beat Week 1 on Hard with no misses.",							'week1_nomiss',			false],
		["No More Tricks",					"Beat Week 2 on Hard with no misses.",							'week2_nomiss',			false],
		["Call Me The Hitman",				"Beat Week 3 on Hard with no misses.",							'week3_nomiss',			false],
		["Lady Killer",						"Beat Week 4 on Hard with no misses.",							'week4_nomiss',			false],
		["Missless Christmas",				"Beat Week 5 on Hard with no misses.",							'week5_nomiss',			false],
		["Highscore!!",						"Beat Week 6 on Hard with no misses.",							'week6_nomiss',			false],
		["God Effing Damn It!",				"Beat Week 7 on Hard with no misses.",							'week7_nomiss',			false],*/
		["Get Destroyed Boyeee!",			"Beat Week 1 on Hard or Unfair with no misses.",				'sss1_nomiss',			false],
		["A Rematch She Got",				"Beat Week 2 on Hard or Unfair with no misses.",				'sss2_nomiss',			false],
		["What Are the Chances?",			"Beat Week 3 on Hard with no misses.",							'sss3_nomiss',			false], // The *chance*s that I GUESSED HIS NAME OH MY GOD-
		["Toasted Dudes",					"Beat Week 4 on Hard with no misses.",							'sss4_nomiss',			false],
		["Basically All of It",				"Beat Week 5 on Hard with no misses.",							'sss5_nomiss',			false],
		["Overcast is Overrated",			"Beat Overcast Overview on Hard with no misses.",				'wwwfinale_nomiss',		false], // It's not actually overrated
		["Visible Concern",					"Complete a song with a rating lower than 20%.",				'ur_bad',				false],
		["Surprisingly Competitive",		"Complete a song with a rating of 100%.",						'ur_good',				false],
		//["Tragic Events in History",		"Watch Sonic die over 100 times.",								'roadkill_enthusiast',	false],
		["Fixation",						"Hold down a note for 10 seconds.",								'oversinging',			false],
		["Well First-",						"Finish a song without going idle.",							'hype',					false],
		["You Two Can Goof Off",			"Finish a song using only two keys.",							'two_keys',				false],
		["Toaster, Dude.",					"Have you tried to run the game on a toaster?",					'toastie',				false],
		//["Debugger",						"Beat the \"Test\" Stage from the Chart Editor.",				'debugger',				 true],
		["Weebtown",						"Discover the joke songs.",										'joke_songs',			false],
		["Cheated Victory Smells Awful",	"Skip a song in story mode after you've already beaten it.",	'cheated_victory',		 true]
	];
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var henchmenDeath:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('confirmMenu' + ClientPrefs.menuSoundSuffix), 0.7);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(henchmenDeath == 0 && FlxG.save.data.henchmenDeath != null) {
				henchmenDeath = FlxG.save.data.henchmenDeath;
			}
		}
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('achievements/' + name));
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		//var cam:Array<FlxCamera> = FlxG.cameras.getDefaultDrawTarget();
		//var cam:Array<FlxCamera> = [new FlxCamera(0, 0, 0, 0, 1)];
		//FlxG.cameras.setDefaultDrawTarget(cam[0], true);
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}