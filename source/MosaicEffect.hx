package;

// STOLEN FROM HAXEFLIXEL DEMO LOL
import flixel.system.FlxAssets.FlxShader;

/*#if (openfl >= "8.0.0")
import openfl8.MosaicShader;
#else
import openfl3.MosaicShader;
#end*/

class MosaicEffect
{
	/**
	 * The effect's "start-value" on the x/y-axes (the effect is not visible with this value).
	 */
	public static inline var DEFAULT_STRENGTH:Float = 1;

	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):MosaicShader;

	/**
	 * The effect's strength on the x-axis.
	 */
	public var strengthX(default, null):Float = DEFAULT_STRENGTH;

	/**
	 * The effect's strength on the y-axis.
	 */
	public var strengthY(default, null):Float = DEFAULT_STRENGTH;

	public function new():Void
	{
		shader = new MosaicShader();
		#if (openfl >= "8.0.0")
		shader.data.uBlocksize.value = [strengthX, strengthY];
		#else
		shader.uBlocksize = [strengthX, strengthY];
		#end
	}

	public function setStrength(strengthX:Float, strengthY:Float):Void
	{
		this.strengthX = strengthX;
		this.strengthY = strengthY;
		#if (openfl >= "8.0.0")
		shader.uBlocksize.value[0] = strengthX;
		shader.uBlocksize.value[1] = strengthY;
		#else
		shader.uBlocksize[0] = strengthX;
		shader.uBlocksize[1] = strengthY;
		#end
	}
}

/**
 * A classic mosaic effect, just like in the old days!
 *
 * Usage notes:
 * - The effect will be applied to the whole screen.
 * - Set the x/y-values on the 'uBlocksize' vector to the desired size (setting this to 0 will make the screen go black)
 */
class MosaicShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform vec2 uBlocksize;
		uniform vec2 objScale;

		void main()
		{
			vec2 blocks = openfl_TextureSize / uBlocksize / objScale;
			vec2 coord = floor(openfl_TextureCoordv * blocks) / blocks;
			//coord = floor((coord * (openfl_TextureSize + 3)) + 0.5) / (openfl_TextureSize + 3);
			gl_FragColor = flixel_texture2D(bitmap, coord);
		}
	')
	public function new(?strengthX:Float = 1, ?strengthY:Float = 1, ?scaleX:Float = 1, ?scaleY:Float = 1)
	{
		super();
		data.uBlocksize.value = [strengthX, strengthY];
		data.objScale.value = [scaleX, scaleY];
		//var gl = __context.gl;
		//gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
	}
}