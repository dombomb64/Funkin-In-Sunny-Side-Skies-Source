import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class ShadowRealmSubState extends MusicBeatSubstate
{
    //var text = '';
    var song = 'tutorial';
    var difficulty = -1;

    public override function new(/*text:String,*/ song:String, ?difficulty:Int)
    {
        //this.text = text;
        this.song = song;
        this.difficulty = difficulty;
        super();
    }

    override function create()
    {
        super.create();

		/*var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		add(bg);

        var textSpr = new FlxText(0, 0, 2000, text, 50, false);
		textSpr.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF880000);
        textSpr.borderSize = 5;
        textSpr.screenCenter();
        add(textSpr);

        var textScale = FlxTween.tween(textSpr.scale, {x: 2, y: 2}, 10);
        new FlxTimer().start(5, function(tmr:FlxTimer) {
            textScale.cancel();
            PlayState.sourceLua.loadSong(song, difficulty);
        });*/

        //PlayState.instance.debugKeysChart[0] = null;

		//cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }
}