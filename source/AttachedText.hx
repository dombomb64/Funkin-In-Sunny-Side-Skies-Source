package;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class AttachedText extends Alphabet
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0, ?bold = false, ?scale:Float = 1, image:String = 'alphabet') {
		super(0, 0, text, bold, image);

		this.scaleX = scale;
		this.scaleY = scale;
		this.isMenuItem = false;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		super.update(elapsed);
	}
}

// Oops this already exists
/*class AttachedFlxText extends FlxText
{
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	
	public function new(?xAdd:Float = 0, ?yAdd:Float = 0, ?width:Float = 0, ?text:Null<String>, ?size:Int = 8, ?embeddedFont:Bool = true) {
		super(0, 0, width, text, size, embeddedFont);

		//this.scale.set(scale, scale);
		this.xAdd = xAdd;
		this.yAdd = yAdd;
	}
	
	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		super.update(elapsed);
	}
}*/