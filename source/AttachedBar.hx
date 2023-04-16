import flixel.FlxSprite;
import flixel.ui.FlxBar;

class AttachedBar extends FlxBar
{
	public var sprTracker:FlxSprite;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var angleAdd:Float = 0;
	public var alphaMult:Float = 1;

	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;
	public var copyVisible:Bool = false;
	public var copyX:Bool = true;
	public var copyY:Bool = true;
    
	public function new(x:Float = 0, y:Float = 0, ?direction:Null<FlxBarFillDirection>, width:Int = 100, height:Int = 10, ?parentRef:Null<Dynamic>, variable:String = "", min:Float = 0, max:Float = 100, showBorder:Bool = false)
	{
		super(x, y, direction, width, height, parentRef, variable, min, max, showBorder);
		antialiasing = ClientPrefs.globalAntialiasing;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			var newX:Float = sprTracker.x + xAdd;
			if (!copyX)
				newX = x;
			var newY:Float = sprTracker.y + yAdd;
			if (!copyY)
				newY = y;

			//x = newX; y = newY;
			setPosition(newX, newY);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);

			if(copyAngle)
				angle = sprTracker.angle + angleAdd;

			if(copyAlpha)
				alpha = sprTracker.alpha * alphaMult;

			if(copyVisible) 
				visible = sprTracker.visible;
		}
	}
}