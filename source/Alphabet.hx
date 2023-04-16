package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flash.media.Sound;

using StringTools;

enum Alignment
{
	LEFT;
	CENTERED;
	INTROTEXT;
	RIGHT;
}

class Alphabet extends FlxSpriteGroup
{
	public var text(default, set):String;

	public var bold:Bool = false;
	public var letters:Array<AlphaCharacter> = [];

	public var isMenuItem:Bool = false;
	public var targetY:Int = 0;
	public var changeX:Bool = true;
	public var changeY:Bool = true;
	public var isWebtoonMenu(default, set):Bool = false;

	public var alignment(default, set):Alignment = LEFT;
	public var scaleX(default, set):Float = 1;
	public var scaleY(default, set):Float = 1;
	public var rows:Int = 0;

	public var distancePerItem:FlxPoint = new FlxPoint(20, 120);
	//public var distancePerItem:FlxPoint = new FlxPoint(0, 154);
	public var startPosition:FlxPoint = new FlxPoint(0, 0); //for the calculations

	public var kerning:Float = 0; // Smush it together for the title screen
	public var kerningScale:Bool = false; // If true, scale the letters to accomodate for kerning
	public var markdown(default, set):String = '';
	public var markdownTimer:Float = 0;

	public var image(default, set):String = 'alphabet'; // To swap out the graphic
	public var boldOffset(default, set):Float = -110;
	//public var nonBoldOffset(default, set):Float = 0;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = true, ?image:String = 'alphabet', preventNullScale:Bool = false)
	{
		super(x, y);

		this.startPosition.x = x;
		this.startPosition.y = y;
		this.bold = bold;
		this.image = image; // Before text so it gets set in time for writing
		this.text = text;
		if (preventNullScale) scale = new FlxPoint(); // For some reason I was getting a null object reference error when trying to set the scale
	}

	private function set_isWebtoonMenu(weebtown:Bool)
	{
		if (weebtown)
			distancePerItem.set(0, 154);
		else
			distancePerItem.set(20, 120);
		isWebtoonMenu = weebtown;
		return weebtown;
	}

	private function set_image(img:String)
	{
		if (text != null)
			for (i in 0...letters.length)
			{
				letters[i].image = img;
			}
		image = img;
		text = text; // F5
		return img;
	}

	private function set_boldOffset(offset:Float)
	{
		boldOffset = offset;
		if (text != null)
			/*for (i in 0...letters.length)
			{
				letters[i].updateLetterOffset();
			}*/
			text = text; // Refresh
		return offset;
	}

	/*private function set_nonBoldOffset(offset:Float)
	{
		nonBoldOffset = offset;
		if (text != null)
			*for (i in 0...letters.length)
			{
				letters[i].updateLetterOffset();
			}*
			text = text; // Ice Water
		return offset;
	}*/

	private function set_markdown(markdown:String)
	{
		this.markdown = markdown;
		markdownTimer = 0;
		return markdown;
	}

	public function setAlignmentFromString(align:String)
	{
		switch(align.toLowerCase().trim())
		{
			case 'right':
				alignment = RIGHT;
			case 'center' | 'centered':
				alignment = CENTERED;
			case 'introtext':
				alignment = INTROTEXT;
			default:
				alignment = LEFT;
		}
	}

	private function set_alignment(align:Alignment)
	{
		alignment = align;
		updateAlignment();
		return align;
	}

	private function updateAlignment()
	{
		for (letter in letters)
		{
			var newOffset:Float = 0;
			switch(alignment)
			{
				case CENTERED:
					newOffset = letter.rowWidth / 2;
				case INTROTEXT:
					newOffset = (letter.rowWidth / 2) + ((x - findMaxX()) / 2);
				case RIGHT:
					newOffset = letter.rowWidth;
				default:
					newOffset = 0;
			}
	
			//newOffset *= scale.x;
			//newOffset += kerning * (letters.length - 1) / 2;
			letter.offset.x -= letter.alignOffset;
			letter.offset.x += newOffset;
			//letter.offset.x += kerning * letters.length / 2;
			letter.alignOffset = newOffset;
		}
	}

	private function set_text(newText:String)
	{
		newText = newText.replace('\\n', '\n');
		clearLetters();
		createLetters(newText);
		updateAlignment();
		this.text = newText;
		return newText;
	}

	public function clearLetters()
	{
		var i:Int = letters.length;
		while (i > 0)
		{
			--i;
			var letter:AlphaCharacter = letters[i];
			if(letter != null)
			{
				letter.kill();
				letters.remove(letter);
				letter.destroy();
			}
		}
		letters = [];
		rows = 0;
	}

	private function set_scaleX(value:Float)
	{
		if (value == scaleX) return value;

		scale.x = value;
		for (letter in letters)
		{
			if(letter != null)
			{
				letter.updateHitbox();
				//letter.updateLetterOffset();
				var ratio:Float = (value / letter.spawnScale.x);
				letter.x = letter.spawnPos.x * ratio;
			}
		}
		scaleX = value;
		return value;
	}

	private function set_scaleY(value:Float)
	{
		if (value == scaleY) return value;

		scale.y = value;
		for (letter in letters)
		{
			if(letter != null)
			{
				letter.updateHitbox();
				letter.updateLetterOffset();
				var ratio:Float = (value / letter.spawnScale.y);
				letter.y = letter.spawnPos.y * ratio;
			}
		}
		scaleY = value;
		return value;
	}

	public override function updateHitbox()
	{
		for (letter in letters)
		{
			if(letter != null)
			{
				letter.updateHitbox();
			}
		}
		super.updateHitbox();
	}

	public function updateHitboxNoCenter()
	{
		width = Math.abs(scale.x) * frameWidth;
		height = Math.abs(scale.y) * frameHeight;
		//offset.set(-0.5 * (width - frameWidth), -0.5 * (height - frameHeight));
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
			if(changeX && !isWebtoonMenu)
				x = FlxMath.lerp(x, (targetY * distancePerItem.x) + startPosition.x, lerpVal);
			if(changeY)
			{
				if (!isWebtoonMenu)
					y = FlxMath.lerp(y, (targetY * 1.3 * distancePerItem.y) + startPosition.y, lerpVal);
				else
					y = FlxMath.lerp(y, (targetY * distancePerItem.y) + startPosition.y, lerpVal);
			}
		}
		markdownTimer += elapsed;

		super.update(elapsed);
	}

	public function snapToPosition()
	{
		if (isMenuItem)
		{
			if(changeX)
				x = (targetY * distancePerItem.x) + startPosition.x;
			if(changeY)
			{
				if (!isWebtoonMenu)
					y = (targetY * 1.3 * distancePerItem.y) + startPosition.y;
				else
					y = (targetY * distancePerItem.y) + startPosition.y;
			}
		}
	}

	private static var Y_PER_ROW:Float = 85;

	private function createLetters(newText:String)
	{
		var consecutiveSpaces:Int = 0;

		var xPos:Float = 0;
		var rowData:Array<Float> = [];
		rows = 0;
		for (character in newText.split(''))
		{
			
			if(character != '\n')
			{
				var spaceChar:Bool = (character == " " || (bold && character == "_"));
				if (spaceChar) consecutiveSpaces++;

				var isAlphabet:Bool = AlphaCharacter.isTypeAlphabet(character.toLowerCase());
				if (AlphaCharacter.allLetters.exists(character.toLowerCase()) && (!bold || !spaceChar))
				{
					if (consecutiveSpaces > 0)
					{
						xPos += 28 * consecutiveSpaces * scaleX;
						if(!bold && xPos >= FlxG.width * 0.65)
						{
							xPos = 0;
							rows++;
						}
					}
					consecutiveSpaces = 0;

					var letter:AlphaCharacter = new AlphaCharacter(xPos, rows * Y_PER_ROW * scaleY, character, bold, this);
					letter.x += letter.letterOffset[0] * scaleX;
					letter.y -= letter.letterOffset[1] * scaleY;
					letter.row = rows;

					var off:Float = 0;
					if(!bold) off = 2;
					xPos += letter.width + (letter.letterOffset[0] + off) * scaleX;
					xPos += kerning;
					rowData[rows] = xPos;
					if (kerningScale) {
						letter.scale.set(letter.scale.x * (kerning + 50) / 50, letter.scale.y * (kerning + 50) / 50);
					}

					add(letter);
					letters.push(letter);
				}
			}
			else
			{
				xPos = 0;
				rows++;
			}
		}

		for (letter in letters)
		{
			letter.spawnPos.set(letter.x, letter.y);
			letter.spawnScale.set(scaleX, scaleY);
			letter.rowWidth = rowData[letter.row];
		}

		if(letters.length > 0) rows++;
	}

	/**
	 * Returns the left-most position of the left-most member.
	 * If there are no members, x is returned.
	 * 
	 * @since 5.0.0
	 */
	public function findMinX()  // Haven't updated HaxeFlixel yet lmao
	{
		return length == 0 ? x : findMinXHelper();
	}
	
	function findMinXHelper()
	{
		var value = Math.POSITIVE_INFINITY;
		for (member in _sprites)
		{
			if (member == null)
				continue;
			
			var minX:Float;
			if (member.flixelType == SPRITEGROUP)
				minX = (cast member:Alphabet).findMinX();
			else
				minX = member.x;
			
			if (minX < value)
				value = minX;
		}
		return value;
	}

	/**
	 * Returns the right-most position of the right-most member.
	 * If there are no members, x is returned.
	 * 
	 * @since 5.0.0
	 */
	public function findMaxX() // Haven't updated HaxeFlixel yet lmao
	{
		return length == 0 ? x : findMaxXHelper();
	}
		
	function findMaxXHelper()
	{
		var value = Math.NEGATIVE_INFINITY;
		for (member in _sprites)
		{
			if (member == null)
				continue;
			
			var maxX:Float;
			if (member.flixelType == SPRITEGROUP)
				maxX = (cast member:Alphabet).findMaxX();
			else
				maxX = member.x + member.width;
			
			if (maxX > value)
				value = maxX;
		}
		return value;
	}
}


///////////////////////////////////////////
// ALPHABET LETTERS, SYMBOLS AND NUMBERS //
///////////////////////////////////////////

/*enum LetterType
{
	ALPHABET;
	NUMBER_OR_SYMBOL;
}*/

typedef Letter = {
	?anim:Null<String>,
	?offsets:Array<Float>,
	?offsetsBold:Array<Float>
}

class AlphaCharacter extends FlxSprite
{
	//public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
	//public static var numbers:String = "1234567890";
	//public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";

	public var image(default, set):String;

	public static var allLetters:Map<String, Null<Letter>> = [
		//alphabet
		'a'  => null, 'b'  => null, 'c'  => null, 'd'  => null, 'e'  => null, 'f'  => null,
		'g'  => null, 'h'  => null, 'i'  => null, 'j'  => null, 'k'  => null, 'l'  => null,
		'm'  => null, 'n'  => null, 'o'  => null, 'p'  => null, 'q'  => null, 'r'  => null,
		's'  => null, 't'  => null, 'u'  => null, 'v'  => null, 'w'  => null, 'x'  => null,
		'y'  => null, 'z'  => null,
		
		//numbers
		'0'  => null, '1'  => null, '2'  => null, '3'  => null, '4'  => null,
		'5'  => null, '6'  => null, '7'  => null, '8'  => null, '9'  => null,

		//symbols
		'&'  => {offsetsBold: [0, 2]},
		'('  => {offsetsBold: [0, 5]},
		')'  => {offsetsBold: [0, 5]},
		'*'  => {offsets: [0, 28]},
		'+'  => {offsets: [0, 7], offsetsBold: [0, -12]},
		'-'  => {offsets: [0, 16], offsetsBold: [0, -30]},
		'<'  => {offsetsBold: [0, 4]},
		'>'  => {offsetsBold: [0, 4]},
		'\'' => {anim: 'apostrophe', offsets: [0, 32]},
		'"'  => {anim: 'quote', offsets: [0, 32], offsetsBold: [0, 0]},
		'!'  => {anim: 'exclamation', offsetsBold: [0, 10]},
		'?'  => {anim: 'question', offsetsBold: [0, 4]},			//also used for "unknown"
		'.'  => {anim: 'period', offsetsBold: [0, -44]},
		'❝'  => {anim: 'start quote', offsets: [0, 24], offsetsBold: [0, -5]},
		'❞'  => {anim: 'end quote', offsets: [0, 24], offsetsBold: [0, -5]},

		//symbols with no bold
		'_'  => null,
		'#'  => null,
		'$'  => null,
		'%'  => null,
		':'  => {offsets: [0, 2]},
		';'  => {offsets: [0, -2]},
		'@'  => null,
		'['  => null,
		']'  => {offsets: [0, -1]},
		'^'  => {offsets: [0, 28]},
		','  => {anim: 'comma', offsets: [0, -6], offsetsBold: [0, -40]}, // :troll:
		'\\' => {anim: 'back slash', offsets: [0, 0]},
		'/'  => {anim: 'forward slash', offsets: [0, 0]},
		'|'  => null,
		'~'  => {offsets: [0, 16]}
	];

	var parent:Alphabet;
	public var alignOffset:Float = 0; // Don't change this
	public var letterOffset:Array<Float> = [0, 0];
	public var spawnPos:FlxPoint = new FlxPoint();
	public var spawnScale:FlxPoint = new FlxPoint();

	public var row:Int = 0;
	public var rowWidth:Float = 0;

	public var shakeOffset:FlxPoint = new FlxPoint(0, 0);
	public var shakeDist:Float = 0;
	public var shakeScale:Float = 0;

	//public var initX:Float = 0; // For markup

	public function new(x:Float, y:Float, character:String, bold:Bool, parent:Alphabet)
	{
		super(x, y);
		this.parent = parent;
		image = parent.image; // How convenient image existed already and was formatted correctly
		antialiasing = ClientPrefs.globalAntialiasing;

		var curLetter:Letter = allLetters.get('?');
		var lowercase = character.toLowerCase();
		if(allLetters.exists(lowercase)) curLetter = allLetters.get(lowercase);

		var suffix:String = '';
		if(!bold)
		{
			if(isTypeAlphabet(lowercase))
			{
				if(lowercase != character)
					suffix = ' uppercase';
				else
					suffix = ' lowercase';
			}
			else
			{
				suffix = ' normal';
				if(curLetter != null && curLetter.offsets != null)
				{
					letterOffset[0] = curLetter.offsets[0];
					letterOffset[1] = curLetter.offsets[1];
				}
			}
		}
		else
		{
			suffix = ' bold';
			if(curLetter != null && curLetter.offsetsBold != null)
			{
				letterOffset[0] = curLetter.offsetsBold[0];
				letterOffset[1] = curLetter.offsetsBold[1];
			}
		}

		var alphaAnim:String = lowercase;
		if(curLetter != null && curLetter.anim != null) alphaAnim = curLetter.anim;

		var anim:String = alphaAnim + suffix;
		animation.addByPrefix(anim, anim, 24);
		animation.play(anim, true);
		if(animation.curAnim == null)
		{
			if(suffix != ' bold') suffix = ' normal';
			anim = 'question' + suffix;
			animation.addByPrefix(anim, anim, 24);
			animation.play(anim, true);
		}
		updateHitbox();
		updateLetterOffset();

		//initX = x;
	}

	public static function isTypeAlphabet(c:String) // thanks kade
	{
		var ascii = StringTools.fastCodeAt(c, 0);
		return (ascii >= 65 && ascii <= 90) || (ascii >= 97 && ascii <= 122);
	}

	private function set_image(name:String)
	{
		var lastAnim:String = null;
		if (animation != null)
		{
			lastAnim = animation.name;
		}
		image = name;
		frames = Paths.getSparrowAtlas(name);
		this.scale.x = parent.scaleX;
		this.scale.y = parent.scaleY;
		alignOffset = 0;
		
		if (lastAnim != null)
		{
			animation.addByPrefix(lastAnim, lastAnim, 24);
			animation.play(lastAnim, true);
			
			updateHitbox();
			updateLetterOffset();
		}
		return name;
	}

	public function updateLetterOffset()
	{
		if (animation.curAnim == null) return;

		if(!animation.curAnim.name.endsWith('bold'))
		{
			offset.y = height + parent.boldOffset;
		}
		//else
			//offset.y = height + parent.nonBoldOffset;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		offset.x -= shakeOffset.x;
		offset.y -= shakeOffset.y;
		scale.x -= shakeScale;
		scale.y -= shakeScale;
		switch (parent.markdown)
		{
			case '-=-': // Light Shake
				shakeDist = 3;
			case '-==-': // Heavy Shake
				shakeDist = 10;
			case '-=====-': // Small Impact Shake
				if (parent.markdownTimer <= elapsed) {
					shakeDist = 5;
					shakeScale = 0.25;
				}
				else {
					var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					shakeDist = FlxMath.lerp(shakeDist, 0, lerpVal);
					shakeScale = FlxMath.lerp(shakeScale, 0, lerpVal);
				}
			case '-======-': // Large Impact Shake
				if (parent.markdownTimer <= elapsed) {
					shakeDist = 30;
					shakeScale = 0.5;
				}
				else {
					var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					shakeDist = FlxMath.lerp(shakeDist, 0, lerpVal);
					shakeScale = FlxMath.lerp(shakeScale, 0, lerpVal);
				}
			case '-=======-': // Thud (Not Vine)
				if (parent.markdownTimer <= elapsed) {
					var originalScale = scale.x;
					//shakeScale = 0.5;
					//scale.set(1.5, 1.5);
					scale.set(scale.x + 0.5, scale.y + 0.5);
					var tweenTime = 0.1;
					if (FlxG.sound.music != null)
						tweenTime = Conductor.stepCrochet / 1000;
					//FlxTween.tween(this, {shakeScale: 0}, 0.5,
					FlxTween.tween(scale, {x: originalScale, y: originalScale}, tweenTime,
					{
						ease: FlxEase.sineIn,
						onComplete: function(twn:FlxTween)
						{
							shakeDist = 10;
							//trace('tween end');
						}
					});
				}
				else {
					var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					shakeDist = FlxMath.lerp(shakeDist, 0, lerpVal);
					//updateHitbox();
					//trace(shakeScale + ', ' + scale.x);
				}
			case '-========-': // Quiplash Prompt
				if (parent.markdownTimer <= elapsed)
				{
					//scaleX *= 0.1;
					//scaleY *= 0.1;
					var originalX = x;
					var originalY = y;
					var originalScale = scale.x;

					x = (FlxG.width - width) / 2;
					FlxTween.tween(this, {x: originalX}, 0.15,
					{
						ease: FlxEase.backOut
					});

					y += 50;
					FlxTween.tween(this, {y: originalY}, 0.15,
					{
						ease: FlxEase.backOut
					});
					
					scale.set(scale.x * 0.1, scale.y * 0.1);
					FlxTween.tween(scale, {x: originalScale, y: originalScale}, 0.15,
					{
						ease: FlxEase.backOut
					});
				}
				/*else if (scale.x <= 1) {
					var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					//scaleX = FlxMath.lerp(scaleX, 1.25, lerpVal);
					//scaleY = FlxMath.lerp(parent.scaleY, 1.25, lerpVal);
					//alignment = RIGHT;
					//updateAlignment();
					//x = width;
				}
				else {
					var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					//scaleX = FlxMath.lerp(scaleX, 1, lerpVal);
					//scaleY = FlxMath.lerp(scaleY, 1, lerpVal);
					//alignment = RIGHT;
					//updateAlignment();
					//x = width;
				}*/
				
			case '-=========-': // Quiplash Answer
				if (parent.markdownTimer <= elapsed)
				{
					//scaleX *= 0.1;
					//scaleY *= 0.1;
					/*var originalScale = scale.x;
					scale.set(scale.x * 0.1, scale.y * 0.1);
					FlxTween.tween(scale, {x: originalScale, y: originalScale}, 0.35,
					{
						ease: FlxEase.sineIn
					});*/
					var originalX = x;
					var originalScale = scale.x;

					x = (FlxG.width - width) / 2;
					FlxTween.tween(this, {x: originalX}, 0.25,
					{
						ease: FlxEase.sineOut
					});

					scale.set(scale.x * 0.1, scale.y * 0.1);
					FlxTween.tween(scale, {x: originalScale, y: originalScale}, 0.25,
					{
						ease: FlxEase.sineOut
					});
				}
				/*else {
					//var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
					//scaleX = FlxMath.lerp(scaleX, 1, lerpVal);
					//scaleY = FlxMath.lerp(scaleY, 1, lerpVal);
					//alignment = RIGHT;
					//updateAlignment();
					//x = width;
				}*/
				
			default:
				shakeDist = 0;
				shakeScale = 0;
		}
		shakeOffset.set(FlxG.random.float(-shakeDist, shakeDist), FlxG.random.float(-shakeDist, shakeDist));
		offset.x += shakeOffset.x;
		offset.y += shakeOffset.y;
		scale.x += shakeScale;
		scale.y += shakeScale;
	}
}