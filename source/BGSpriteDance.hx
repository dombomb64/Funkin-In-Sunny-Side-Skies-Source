package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BGSpriteDance extends BGSprite
{
	public var leftIdle(default, set):String;
	public var rightIdle(default, set):String;

	public var danced:Bool = false;

	private var created:Bool = false;

	private function set_leftIdle(left:String) {
		leftIdle = left;
		if (created)
			animation.addByPrefix(left, left, 24, false);
		return left;
	}

	private function set_rightIdle(right:String) {
		rightIdle = right;
		if (created)
			animation.addByPrefix(right, right, 24, false);
		return right;
	}

	public function new(image:String, x:Float = 0, y:Float = 0, ?scrollX:Float = 1, ?scrollY:Float = 1, ?animArray:Array<String> = null, ?loop:Bool = false) {
		//super(x, y);
		super(image, x, y, scrollX, scrollY, animArray, loop);
		animation.destroyAnimations();
		
		if (animArray != null) {
			//loadGraphic(Paths.image(image), true);
			frames = Paths.getSparrowAtlas(image);
			//trace(frames.toString());
			for (i in 0...animArray.length) {
				var anim:String = animArray[i];
				animation.addByPrefix(anim, anim, 24, loop);
				if (leftIdle == null) {
					leftIdle = anim;
					animation.play(anim);
					//animation.addByPrefix('danceLeft', anim, 24, loop);
				}
				else if (rightIdle == null) {
					rightIdle = anim;
					//animation.addByPrefix('danceRight', anim, 24, loop);
				}
				//else
					//animation.addByPrefix(anim, anim, 24, loop);
			}
			//trace(Std.string(animation));
		} else {
			if(image != null) {
				loadGraphic(Paths.image(image));
			}
			active = false;
		}
		scrollFactor.set(scrollX, scrollY);
		antialiasing = ClientPrefs.globalAntialiasing;
		created = true;
		//trace(animation);
	}

	public override function dance(?forceplay:Bool = false) {
		//trace('last animation finished? ' + animation.curAnim.finished + ', last animation paused? ' + animation.curAnim.paused + ', last animation frame? ' + animation.curAnim.curFrame);
		danced = !danced;
		if (danced && rightIdle != null) {
			animation.play(rightIdle, forceplay);
			//trace('sliiide to the left');
			//trace(animation.curAnim);
		}
		else if (!danced && leftIdle != null) {
			animation.play(leftIdle, forceplay);
			//trace('sliiide to the right');
			//trace(animation.curAnim);
		}
		//else if (idleAnim != null) {
			//animation.play(idleAnim, forceplay);
		//}
		if (animation.curAnim != null)
		{
			//trace(danced + leftIdle + rightIdle + animation.curAnim.name + animation.curAnim.numFrames + animation.finished + animation.curAnim.frameRate);
			//animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {trace(animation.curAnim.curFrame);}
			//trace('among us could you repeat that simulator');
			//trace(animation.curAnim.name);
		}
	}
}