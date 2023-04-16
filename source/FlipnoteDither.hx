package;

// I kinda just copy-pasted ColorSwap as a base for this then asked ChatGPT to make the fragment shader lmao
import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

class FlipnoteDither {
	public var shader(default, null):FlipnoteDitherShader = new FlipnoteDitherShader();
	/*public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 0;
	public var brightness(default, set):Float = 0;
	public var pixelSize(default, set):Int = 3;

	private function set_hue(value:Float) {
		hue = value;
		shader.uTime.value[0] = hue;
		return hue;
	}

	private function set_saturation(value:Float) {
		saturation = value;
		shader.uTime.value[1] = saturation;
		return saturation;
	}

	private function set_brightness(value:Float) {
		brightness = value;
		shader.uTime.value[2] = brightness;
		return brightness;
	}

	private function set_pixelSize(value:Int) {
		pixelSize = value;
		shader.pixelSize.value = [pixelSize];
		return pixelSize;
	}*/

	public var hueShift(default, set):Float = 0;
	public var ditheringSize(default, set):Float = 3;

	private function set_hueShift(value:Float) {
		hueShift = value;
		shader.hueShift.value = [hueShift];
		return hueShift;
	}
	
	private function set_ditheringSize(value:Float) {
		ditheringSize = value;
		shader.ditheringSize.value = [ditheringSize];
		return ditheringSize;
	}

	public function new()
	{
		//shader.uTime.value = [0, 0, 0];
		//shader.awesomeOutline.value = [false];
		//shader.pixelSize.value = [3];
		shader.hueShift.value = [0];
		shader.ditheringSize.value = [3];
	}
}

class FlipnoteDitherShader extends FlxShader {
	@:glFragmentSource('
		#pragma header

		uniform float hueShift;
		uniform float ditheringSize;

		vec3 hsv2rgb(vec3 c) {
			vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
			vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
			return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}

		vec3 rgb2hsv(vec3 c) {
			vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
			vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
			float d = q.x - min(q.w, q.y);
			float e = 1.0e-10;
			return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void main() {
			vec2 texcoord = openfl_TextureCoordv;
			vec2 pixel_texcoord = texcoord * openfl_TextureSize;
			vec2 dithering_texcoord = mod(pixel_texcoord, (ditheringSize * 2)) / (ditheringSize * 2); // Every (ditheringSize * 2) pixels, it loops
			vec4 color = texture2D(bitmap, texcoord);
			vec4 closest_color_hsv = vec4(0);
			vec4 second_closest_color_hsv = vec4(0);
			float closest_distance = 1000000;
			float second_closest_distance = 1000000;
			if (length(color.rgb - vec3(1, 0, 0)) < closest_distance) { // Red
				second_closest_color_hsv = closest_color_hsv;
				second_closest_distance = closest_distance;
				closest_distance = length(color.rgb - vec3(1, 0, 0));
				closest_color_hsv = vec4(0, 1, 1, 1);
			}
			if (length(color.rgb - vec3(0, 0, 0)) < closest_distance) { // Black
				second_closest_color_hsv = closest_color_hsv;
				second_closest_distance = closest_distance;
				closest_distance = length(color.rgb - vec3(0, 0, 0));
				closest_color_hsv = vec4(0, 0, 0, 1);
			}
			if (length(color.rgb - vec3(1, 1, 1)) < closest_distance) { // White
				second_closest_color_hsv = closest_color_hsv;
				second_closest_distance = closest_distance;
				closest_distance = length(color.rgb - vec3(1, 1, 1));
				closest_color_hsv = vec4(0, 0, 1, 1);
			}
			/*if (color.a < closest_distance) { // Transparent
				second_closest_color_hsv = closest_color_hsv;
				second_closest_distance = closest_distance;
				closest_distance = length(color - vec4(0, 0, 0, 0));
				closest_color_hsv = vec4(0, 0, 0, 0);
			}*/
			vec4 dithering_color = vec4(hsv2rgb(closest_color_hsv), closest_color_hsv.a);
			vec4 second_dithering_color = vec4(hsv2rgb(second_closest_color_hsv), second_closest_color_hsv.a);
			if (length(color - dithering_color) >= closest_distance * 1.1) {
				second_dithering_color = dithering_color;
			}
			if (rgb2hsv(color.rgb).g < 0.1 && dithering_color != second_dithering_color) { // Because it won\'t dither between black and white for some reason
				dithering_color = vec4(1, 1, 1, 1);
				second_dithering_color = vec4(0, 0, 0, 1);
			}
			if (color.r >= 0.48 && color.r <= 0.52 && (rgb2hsv(color.rgb).g > 0.9)) { // Same goes for black and red, apparently
				dithering_color = vec4(1, 0, 0, 1);
				second_dithering_color = vec4(0, 0, 0, 1);
			}
			if (color.a <= 0.75) // Stupid transparency
			{
				second_dithering_color = vec4(0, 0, 0, 0);
			}
			if (color.a <= 0.25)
			{
				dithering_color = vec4(0, 0, 0, 0);
			}
			dithering_texcoord = fract(dithering_texcoord);
			if(dithering_texcoord.x>0.5)
			{
				if(dithering_texcoord.y>0.5)
				{
					gl_FragColor = dithering_color;
				}
				else
				{
					gl_FragColor = second_dithering_color;
				}
			}
			else
			{
				if(dithering_texcoord.y>0.5)
				{
					gl_FragColor = second_dithering_color;
				}
				else
				{
					gl_FragColor = dithering_color;
				}
			}
			vec3 color_hsv = rgb2hsv(gl_FragColor.rgb);
			color_hsv.r += hueShift;
			gl_FragColor = vec4(hsv2rgb(color_hsv), gl_FragColor.a);
		}')
	@:glVertexSource('
		#pragma header

		/*attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;*/

		attribute float alpha;
		attribute vec4 colorMultiplier;
		attribute vec4 colorOffset;
		uniform bool hasColorTransform;
		
		void main(void)
		{
			openfl_Alphav = openfl_Alpha;
			openfl_TextureCoordv = openfl_TextureCoord;

			if (openfl_HasColorTransform) {
				openfl_ColorMultiplierv = openfl_ColorMultiplier;
				openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
			}

			gl_Position = openfl_Matrix * openfl_Position;

			openfl_Alphav = openfl_Alpha * alpha;
			if (hasColorTransform)
			{
				openfl_ColorOffsetv = colorOffset / 255.0;
				openfl_ColorMultiplierv = colorMultiplier;
			}
		}')

	public function new()
	{
		super();
		hueShift.value = [0];
		ditheringSize.value = [3];
	}
}