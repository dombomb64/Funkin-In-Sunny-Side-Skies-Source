package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	public function new(duration:Float, isTransIn:Bool, ?color:FlxColor = FlxColor.BLACK, ?gradientFile:String = 'transitionDither', ?coverFile:String = null) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);
		//var transColor:FlxColor = 0xFFFFFFFF;
		if (gradientFile == null)
			transGradient = FlxGradient.createGradientFlxSprite(width, height, (isTransIn ? [0x0, color] : [color, 0x0]));
		else
			transGradient = new TransitionSprite(width, height, color, gradientFile);
		if (isTransIn)
			transGradient.flipY = true;
		transGradient.scrollFactor.set();
		add(transGradient);

		//transBlack = new FlxSprite().makeGraphic(width, height + 400, transColor);
		transBlack = new TransitionCover(width, height + 400, color, coverFile);
		transBlack.scrollFactor.set();
		add(transBlack);

		transGradient.x -= (width - FlxG.width) / 2;
		transBlack.x = transGradient.x;

		if(isTransIn) {
			transGradient.y = transBlack.y - transBlack.height;
			FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.linear});
		} else {
			transGradient.y = -transGradient.height;
			transBlack.y = transGradient.y - transBlack.height + 50;
			leTween = FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.linear});
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
			transGradient.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
		super.update(elapsed);
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}

class TransitionSprite extends FlxSprite
{
	public override function new(width:Int, height:Int, color:FlxColor, ?image:String)
	{
		super(0, 0);
		this.color = color;
		loadGraphic(Paths.image(image));
		setGraphicSize(width, height);
		updateHitbox();
	}
}

class TransitionCover extends FlxSprite
{
	public override function new(width:Int, height:Int, color:FlxColor, ?image:String)
	{
		super(0, 0);
		//this.color = color;
		if (image != null)
		{
			loadGraphic(Paths.image(image));
			setGraphicSize(width, height);
		}
		else
		{
			makeGraphic(width, height, color);
		}
		updateHitbox();
	}
}