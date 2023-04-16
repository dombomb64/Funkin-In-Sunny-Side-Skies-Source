package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import lime.utils.Assets;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;

	public var sprTracker:FlxSprite;
	public var isOldIcon:Bool = false;
	public var isPlayer:Bool = false;
	public var char:String = '';

	public var playOffsets:FlxPoint = new FlxPoint();
	public var hasXml:Bool = false;
	public var status:Int = 0; // THIS MAY BE DIFFERENT THAN THE CURRENT FRAME EVEN IF THERE ISN'T AN XML

	public var freeplayScale:Float = 1;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		//trace(hasXml);
		scrollFactor.set(1, 1);
		scale = new FlxPoint(1, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		forceUpdate();
	}

	public function forceUpdate()
	{
		if (sprTracker != null)
			//setPosition(sprTracker.x + sprTracker.width + 12 + xAdd, sprTracker.y - 30 + yAdd);
			//setPosition(FlxG.width - width + xAdd, sprTracker.y - 30 + yAdd);
			setPosition(xAdd, sprTracker.y - 30 + yAdd);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			hasXml = false;
			var name:String = 'icons/' + char;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; // Older versions of psych engine's support
			if (!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; // Prevents crash from missing icon
			if (Paths.fileExists('images/' + name + '.xml', TEXT)) hasXml = true;
			var file:Dynamic = Paths.image(name);

			if (hasXml) {
				loadGraphic(file, true);
				frames = Paths.getSparrowAtlas(name);
				//trace(frames.toString());

				//animation.addByPrefix('winning', 'Winning', 24, true, isPlayer);
				animation.addByPrefix('neutral', 'Neutral', 24, true, isPlayer);
				animation.addByPrefix('losing', 'Losing', 24, true, isPlayer);
				animation.play('neutral');
				//status = 1;
				//losingAnim();
			}
			else {
				loadGraphic(file); // Load stupidly first for getting the file size
				loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); // Then load it fr

				animation.add(char, [0, 1], 0, false, isPlayer);
				animation.play(char);
			}
			//losingAnim();
			
			var customOffsets = HealthIcon.getOffsets(char);
			//trace(customOffsets.toString());
			if (isPlayer) customOffsets.x *= -1;
			iconOffsets[0] = ((width - 150) / 2) - customOffsets.x - playOffsets.x;
			iconOffsets[1] = ((height - 150) / 2) + customOffsets.y + playOffsets.y;
			updateHitbox();

			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			/*var charLowarcar = char.toLowerCase(); // Pfffff, heheh.
			if(char.endsWith('-pixel') || charLowarcar.contains('nutshell')) {
				antialiasing = false;
			}*/
			if (HealthIcon.isPixel(char)) antialiasing = false;
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	/*public function isPixel():Bool
	{
		var charLowarcar = char.toLowerCase(); // Pfffff, heheh.
		return (char.endsWith('-pixel') || charLowarcar.contains('nutshell')
		|| charLowarcar.contains('adam') || charLowarcar.contains('adiel')
		|| charLowarcar.contains('alex')
		|| charLowarcar.contains('chase') || charLowarcar.contains('chance')
		|| charLowarcar.contains('kristen')
		|| charLowarcar.contains('matt')
		|| charLowarcar.contains('seth') || charLowarcar.contains('sett')
		|| charLowarcar.contains('dude') || charLowarcar.contains('jim')
		|| charLowarcar.contains('dandy') || charLowarcar.contains('pj')
		|| charLowarcar.contains('dom') || charLowarcar.contains('jom'));
	}*/

	public function getCharacter():String {
		return char;
	}

	public static function getOffsets(char:String):FlxPoint
	{
		/*var fileExists = false;
		//var textFile = Paths.txt('iconOffsets');
		var textFile = 'assets/data/iconOffsets';
		#if MODS_ALLOWED
		if (!Paths.fileExists(textFile, TEXT))
			textFile = Paths.modFolders('data/iconOffsets');
		if (!Paths.fileExists(textFile, TEXT))
			textFile = Paths.mods('data/iconOffsets');
		#end
		//if (Paths.fileExists(textFile, TEXT))
			//fileExists = true;
		fileExists = Paths.fileExists(textFile, TEXT);*/
		/*var fileExists:Bool = false;
		var textFile:String = 'data/iconOffsets.txt';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(textFile))) {
			textFile = Paths.modFolders(textFile);
			fileExists = true;
		} else {
			textFile = Paths.getPreloadPath(textFile);
			if(FileSystem.exists(textFile)) {
				fileExists = true;
			}
		}
		#else
		textFile = Paths.getPreloadPath(textFile);
		if(Assets.exists(textFile, TEXT)) {
			fileExists = true;
		}
		#end*/
		var textFile = '';
		var fileExists = false;
		#if MODS_ALLOWED
		textFile = Paths.modFolders('data/iconOffsets.txt');
		if(FileSystem.exists(textFile))
		{
			fileExists = true;
		}
		else
		{
			textFile = Paths.getPreloadPath('data/iconOffsets.txt');
			if(FileSystem.exists(textFile))
			{
				fileExists = true;
			}
		}
		#elseif sys
		textFile = Paths.getPreloadPath('data/iconOffsets.txt');
		if(OpenFlAssets.exists(textFile))
		{
			fileExists = true;
		}
		#end
		//var textFile = Paths.txt('iconOffsets');
		//trace(textFile + ', ' + fileExists);
		#if sys
		if (fileExists) {
			//var fullText:String = Assets.getText(textFile);
			var fullText:String = File.getContent(textFile);
			var firstArray:Array<String> = fullText.split('\n');

			for (i in firstArray) {
				var line = i.replace('\x0d', '').split(','); // Icon Name, Offset X, Offset Y
				if (line.length == 3 && line[0] == char)
				{
					return new FlxPoint(Std.parseFloat(line[1]), Std.parseFloat(line[2]));
				}
			}
		}
		#end
		
		return new FlxPoint();
	}

	/*public function getOffsets()
	{
		HealthIcon.getOffsets(char);
	}*/
	

	public static function isPixel(char:String):Bool
	{
		var textFile = '';
		var fileExists = false;
		#if MODS_ALLOWED
		textFile = Paths.modFolders('data/pixelIcons.txt');
		if(FileSystem.exists(textFile))
		{
			fileExists = true;
		}
		else
		{
			textFile = Paths.getPreloadPath('data/pixelIcons.txt');
			if(FileSystem.exists(textFile))
			{
				fileExists = true;
			}
		}
		#elseif sys
		textFile = Paths.getPreloadPath('data/pixelIcons.txt');
		if(OpenFlAssets.exists(textFile))
		{
			fileExists = true;
		}
		#end
		//var textFile = Paths.txt('iconOffsets');
		//trace(textFile + ', ' + fileExists);
		#if sys
		if (fileExists) {
			//var fullText:String = Assets.getText(textFile);
			var fullText:String = File.getContent(textFile);
			var firstArray:Array<String> = fullText.split('\n');

			for (i in firstArray) {
				var line = i.replace('\x0d', '');
				if (line == char)
				{
					return true;
				}
			}
		}
		#end
		
		return false;
	}

	public static function hasWinningIcon(icon:String)
	{
		var iconFile:String = 'winningIcons/' + icon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'winningIcons/icon-' + icon;
		if (!Paths.fileExists('images/' + iconFile + '.png', IMAGE)) iconFile = 'Qw33goorpps'; // Nobody would put this guy in a mod
		return !(iconFile == 'Qw33goorpps'); // False = Given up on loading a winning icon
	}

	public function losingAnim()
	{
		//trace('boo you stink');
		var tempStatus = 1;
		if (status != 1) {
			if (hasXml) //{
				animation.play('losing');
				//trace(animation.curAnim.name);
				//trace('help');
				//trace('lousy');
			//}
			else
				animation.curAnim.curFrame = tempStatus;
		}
		status = tempStatus;
	}
	
	public function neutralAnim()
	{
		var tempStatus = 0;
		if (status != 0 && status != 2) {
			if (hasXml)
				animation.play('neutral');
			else
				animation.curAnim.curFrame = tempStatus;
		}
		status = tempStatus;
	}
	
	public function winningAnim()
	{
		var tempStatus = 2;
		if (status != 0 && status != 2) {
			if (hasXml)
				animation.play('neutral');
			else
				animation.curAnim.curFrame = 0; // Shh, PlayState, the icon doesn't know...
		}
		status = tempStatus;
	}
}

class CoolIcon extends HealthIcon
{
	public override function changeIcon(char:String) {
		if(this.char != char) {
			hasXml = false;
			var name:String = 'winningIcons/' + char;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'winningIcons/icon-' + char; // Older versions of psych engine's support
			if (!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; // Prevents crash from missing icon
			if (Paths.fileExists('images/' + name + '.xml', TEXT)) hasXml = true;
			var file:Dynamic = Paths.image(name);

			if (hasXml) {
				loadGraphic(file, true);
				frames = Paths.getSparrowAtlas(name);

				animation.addByPrefix('winning', 'Winning', 24, true, isPlayer);
				animation.addByPrefix('neutral', 'Neutral', 24, true, isPlayer);
				animation.addByPrefix('losing', 'Losing', 24, true, isPlayer);
				animation.play('neutral');
			}
			else {
				loadGraphic(file); // Load stupidly first for getting the file size
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); // Then load it fr

				animation.add(char, [2, 0, 1], 0, false, isPlayer);
				animation.play(char);
			}
			
			var customOffsets = HealthIcon.getOffsets(char);
			//trace(customOffsets.toString());
			iconOffsets[0] = ((width - 150) / 2) - customOffsets.x - playOffsets.x;
			iconOffsets[1] = ((height - 150) / 2) + customOffsets.y + playOffsets.y;
			updateHitbox();

			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			/*var charLowarcar = char.toLowerCase(); // Pfffff, heheh.
			if(char.endsWith('-pixel') || charLowarcar.contains('nutshell')) {
				antialiasing = false;
			}*/
			if (HealthIcon.isPixel(char)) antialiasing = false;
		}
	}

	/*public static override function getOffsets(char:String)
	{
		super.getOffsets(char);
	}*/
	
	public override function neutralAnim()
	{
		var tempStatus = 0;
		if (status != 0) {
			if (hasXml)
				animation.play('neutral');
			else
				animation.curAnim.curFrame = tempStatus;
		}
		status = tempStatus;
	}
	
	public override function winningAnim()
	{
		var tempStatus = 2;
		if (status != 2) {
			if (hasXml)
				animation.play('winning');
			else
				animation.curAnim.curFrame = tempStatus;
		}
		status = tempStatus;
	}
}
