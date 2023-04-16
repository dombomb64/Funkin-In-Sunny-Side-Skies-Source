package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxBasic;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrail;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import Section.SwagSection;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef CharacterFile = {
	var animations:Array<AnimArray>;
	var image:String;
	var scale:Float;
	var sing_duration:Float;
	var healthicon:String;

	var position:Array<Float>;
	var camera_position:Array<Float>;

	var flip_x:Bool;
	var no_antialiasing:Bool;
	var healthbar_colors:Array<Int>;

	var legs_image:String;
	var legs_x:Float;
	var legs_y:Float;
	var legs_flipped_x:Float;
	var legs_flip_x:Bool;
	var legs_flip_y:Bool;
	var legs_left:AnimArray;
	var legs_right:AnimArray;
	var legs_type:String;

	var overlay_image:String;
}

typedef AnimArray = {
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = DEFAULT_CHARACTER;

	public var colorTween:FlxTween;
	public var holdTimer:Float = 0;
	public var heyTimer:Float = 0;
	public var specialAnim:Bool = false;
	public var animationNotes:Array<Dynamic> = [];
	public var stunned:Bool = false;
	public var singDuration:Float = 4; // Multiplier of how long a character holds the sing pose
	public var idleSuffix:String = '';
	public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"
	public var skipDance:Bool = false;
	public var singDisabled:Bool = false; // For playing special animations (specifically in Free Time)
	public var dodgeTimer:Float = 0; // For the snowball gimmick in Free Time

	public var healthIcon:String = 'face';
	public var animationsArray:Array<AnimArray> = [];

	public var positionArray:Array<Float> = [0, 0];
	public var cameraPosition:Array<Float> = [0, 0];

	public var hasMissAnimations:Bool = false;

	//public var colorSwap:ColorSwap; // Just for fun lol
	public var legs:CharLegsRun; // Run. (Not used for adamStuck)
	public var overlay:CharOverlay; // Used for the "shush" animation for chaseImpostorRun (Also should copy all animation data from this character)
	//public var legsDanced:Bool = false;
	public var legsOffset:FlxPoint;
	public var legType:String = '';
	public var runOffset:FlxPoint = new FlxPoint(0, 0);

	//public var groupParent:FlxSpriteGroup;

	//public var flipnote:FlipnoteDither;

	//Used on Character Editor
	public var imageFile:String = '';
	public var jsonScale:Float = 1;
	public var noAntialiasing:Bool = false;
	public var originalFlipX:Bool = false;
	public var healthColorArray:Array<Int> = [255, 0, 0];
	public var legsImage:String = '';

	public static var DEFAULT_CHARACTER:String = 'bf'; //In case a character is missing, it will use BF on its place
	public function new(x:Float, y:Float, ?character:String = 'bf', ?isPlayer:Bool = false, ?isBackup:Bool = false/*, ?group:FlxSpriteGroup*/)
	{
		super(x, y);

		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Dynamic>>();
		#end
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = ClientPrefs.globalAntialiasing;
		var library:String = null;
		switch (curCharacter)
		{
			//case 'your character name in case you want to hardcode them instead':

			default:
				var characterPath:String = 'characters/' + curCharacter + '.json';

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path))
				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path))
				#end
				{
					path = Paths.getPreloadPath('characters/' + DEFAULT_CHARACTER + '.json'); //If a character couldn't be found, change him to BF just to prevent a crash
				}

				#if MODS_ALLOWED
				var rawJson = File.getContent(path);
				#else
				var rawJson = Assets.getText(path);
				#end

				var json:CharacterFile = cast Json.parse(rawJson);
				var spriteType = "sparrow";
				//sparrow
				//packer
				//texture
				#if MODS_ALLOWED
				var modTxtToFind:String = Paths.modsTxt(json.image);
				var txtToFind:String = Paths.getPath('images/' + json.image + '.txt', TEXT);
				
				//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
				
				if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '.txt', TEXT)))
				#end
				{
					spriteType = "packer";
				}
				
				#if MODS_ALLOWED
				var modAnimToFind:String = Paths.modFolders('images/' + json.image + '/Animation.json');
				var animToFind:String = Paths.getPath('images/' + json.image + '/Animation.json', TEXT);
				
				//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
				//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
				
				if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
				#else
				if (Assets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT)))
				#end
				{
					spriteType = "texture";
				}

				switch (spriteType){
					
					case "packer":
						frames = Paths.getPackerAtlas(json.image);
					
					case "sparrow":
						frames = Paths.getSparrowAtlas(json.image);
					
					case "texture":
						frames = AtlasFrameMaker.construct(json.image);
				}
				imageFile = json.image;

				if(json.scale != 1) {
					jsonScale = json.scale;
					setGraphicSize(Std.int(width * jsonScale));
					updateHitbox();
				}

				positionArray = json.position;
				cameraPosition = json.camera_position;

				healthIcon = json.healthicon;
				singDuration = json.sing_duration;
				flipX = !!json.flip_x;
				if(json.no_antialiasing) {
					antialiasing = false;
					noAntialiasing = true;
				}

				if(json.healthbar_colors != null && json.healthbar_colors.length > 2)
					healthColorArray = json.healthbar_colors;

				antialiasing = !noAntialiasing;
				if(!ClientPrefs.globalAntialiasing) antialiasing = false;

				animationsArray = json.animations;
				if(animationsArray != null && animationsArray.length > 0) {
					for (anim in animationsArray) {
						var animAnim:String = '' + anim.anim;
						var animName:String = '' + anim.name;
						var animFps:Int = anim.fps;
						var animLoop:Bool = !!anim.loop; //Bruh
						var animIndices:Array<Int> = anim.indices;
						if(animIndices != null && animIndices.length > 0) {
							animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
						} else {
							animation.addByPrefix(animAnim, animName, animFps, animLoop);
						}

						if(anim.offsets != null && anim.offsets.length > 1) {
							addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
						}
					}
				} else {
					quickAnimAdd('idle', 'BF idle dance');
				}
				//if (group != null) {
					//groupParent = group;
					//if (json.legs_image != null && json.legs_x != null && json.legs_y != null && json.legs_flip_x != null && json.legs_flip_y != null && json.legs_left != null && json.legs_right != null)
					if (json.legs_image != null && json.legs_left != null && json.legs_right != null)
						makeLegs(json);
					if (json.overlay_image != null)
						makeOverlay(json);
				//}
				//trace('Loaded file to character ' + curCharacter);
		}
		originalFlipX = flipX;

		if(animOffsets.exists('singLEFTmiss') || animOffsets.exists('singDOWNmiss') || animOffsets.exists('singUPmiss') || animOffsets.exists('singRIGHTmiss')) hasMissAnimations = true;
		recalculateDanceIdle();
		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			/*// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				if(animation.getByName('singLEFT') != null && animation.getByName('singRIGHT') != null)
				{
					var oldRight = animation.getByName('singRIGHT').frames;
					animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
					animation.getByName('singLEFT').frames = oldRight;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singLEFTmiss') != null && animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}*/
		}

		switch(curCharacter)
		{
			case 'pico-speaker':
				skipDance = true;
				loadMappedAnims();
				playAnim("shoot1");
		}

		/*colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		colorSwap.hue = 0.1;
		colorSwap.saturation = 0.5;
		colorSwap.brightness = 0.75;*/

		//flipnote = new FlipnoteDither();
		//shader = flipnote.shader;
	}

	override function update(elapsed:Float)
	{
		if(!debugMode && animation.curAnim != null)
		{
			if(heyTimer > 0)
			{
				heyTimer -= elapsed * PlayState.instance.playbackRate;
				if(heyTimer <= 0)
				{
					if(specialAnim && animation.curAnim.name == 'hey' || animation.curAnim.name == 'cheer')
					{
						specialAnim = false;
						dance();
					}
					heyTimer = 0;
				}
			} else if(specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}
			
			switch(curCharacter)
			{
				case 'pico-speaker':
					if(animationNotes.length > 0 && Conductor.songPosition > animationNotes[0][0])
					{
						var noteData:Int = 1;
						if(animationNotes[0][1] > 2) noteData = 3;

						noteData += FlxG.random.int(0, 1);
						playAnim('shoot' + noteData, true);
						animationNotes.shift();
					}
					if(animation.curAnim.finished) playAnim(animation.curAnim.name, false, false, animation.curAnim.frames.length - 3);
			}

			if (!isPlayer)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * (0.0011 / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1)) * singDuration)
				{
					dance();
					holdTimer = 0;
				}
			}

			if(animation.curAnim.finished && animation.getByName(animation.curAnim.name + '-loop') != null)
			{
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		if (legs != null) // No need to check for if the offset exists because it's created in the same frame
		{
			//if (legs.flipX)
				legs.x = x - legsOffset.x;
			//else
				//legs.x = x - legsOffset.x + 170; // Arbitrary number idk man (FIX LATER??)
			legs.y = y - legsOffset.y;
			legs.alpha = alpha;
		}
		if (overlay != null)
			overlay.copyParent();
		dodgeTimer -= elapsed;
		if (dodgeTimer < 0)
			dodgeTimer = 0;
		//updateRunAnim(legs.animation.curAnim.name, legs.animation.curAnim.curFrame, legs.animation.frameIndex);
		super.update(elapsed);
	}

	public var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && !skipDance && !specialAnim)
		{
			if(danceIdle)
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight' + idleSuffix);
				else
					playAnim('danceLeft' + idleSuffix);
			}
			else if(animation.getByName('idle' + idleSuffix) != null) {
					playAnim('idle' + idleSuffix);
			}
		}
		if (!debugMode && legs != null)
		{
			//trace('dancey dance ' + legs.danced);
			//legsDanced = !legsDanced;
			/*legs.danced = !legs.danced;

			if (legs.danced)
				//legs.animation.play('danceRight' + idleSuffix);
				legs.animation.play(legs.leftIdle, true);
			else
				//legs.animation.play('danceLeft' + idleSuffix);
				legs.animation.play(legs.rightIdle, true);*/
			
			//legs.dance(true); // Actually this whole function doesn't call when singing
			//trace(legs.animation.curAnim + ', ' + legs.x + ', ' + legs.y);
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (!AnimName.contains('sing') || !singDisabled) {
			specialAnim = false;
			animation.play(AnimName, Force, Reversed, Frame);

			var daOffset = animOffsets.get(AnimName);
			if (animOffsets.exists(AnimName))
			{
				offset.set(daOffset[0], daOffset[1]);
			}
			else
				offset.set(0, 0);

			if (curCharacter.startsWith('gf'))
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}

				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}
	}
	
	function loadMappedAnims():Void
	{
		var noteData:Array<SwagSection> = Song.loadFromJson('picospeaker', Paths.formatToSongPath(PlayState.SONG.song)).notes;
		for (section in noteData) {
			for (songNotes in section.sectionNotes) {
				animationNotes.push(songNotes);
			}
		}
		TankmenBG.animationNotes = animationNotes;
		animationNotes.sort(sortAnims);
	}

	function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	public var danceEveryNumBeats:Int = 2;
	private var settingCharacterUp:Bool = true;
	public function recalculateDanceIdle() {
		var lastDanceIdle:Bool = danceIdle;
		danceIdle = (animation.getByName('danceLeft' + idleSuffix) != null && animation.getByName('danceRight' + idleSuffix) != null);

		if(settingCharacterUp)
		{
			danceEveryNumBeats = (danceIdle ? 1 : 2);
		}
		else if(lastDanceIdle != danceIdle)
		{
			var calc:Float = danceEveryNumBeats;
			if(danceIdle)
				calc /= 2;
			else
				calc *= 2;

			danceEveryNumBeats = Math.round(Math.max(calc, 1));
		}
		settingCharacterUp = false;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
		//if (overlay != null)
			//overlay.animOffsets[name] = [x, y];
	}

	public function quickAnimAdd(name:String, anim:String)
	{
		animation.addByPrefix(name, anim, 24, false);
	}

	public override function destroy()
	{
		if (legs != null)
			legs.destroy(); // The legs? DESTROYED.
		if (overlay != null)
			overlay.destroy(); // The overlay? DESTROYED.
		super.destroy(); // The character? DESTROYED.
		// The fourth beat? DESTROYED.
	}

	public function makeLegs(json:CharacterFile)
	{
		// Definition
		//trace(json.legs_left.name + ', ' + json.legs_right.name);
		//legs = new BGSpriteDance(json.legs_image, x, y, 1, 1, [json.legs_left.name, json.legs_right.name]);
		legs = new CharLegsRun(x, y);
		//legs.loadGraphic(Paths.image(json.legs_image));
		//legs.animation.addByPrefix(json.legs_left.anim, json.legs_left.name, json.legs_left.fps, json.legs_left.loop);
		//legs.animation.addByPrefix(json.legs_right.anim, json.legs_right.name, json.legs_right.fps, json.legs_right.loop);

		// Image
		var spriteType = "sparrow";
		//sparrow
		//packer
		//texture
		#if MODS_ALLOWED
		var modTxtToFind:String = Paths.modsTxt(json.legs_image);
		var txtToFind:String = Paths.getPath('images/' + json.legs_image + '.txt', TEXT);
		
		//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
		//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
		
		if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + json.legs_image + '.txt', TEXT)))
		#end
		{
			spriteType = "packer";
		}
		
		#if MODS_ALLOWED
		var modAnimToFind:String = Paths.modFolders('images/' + json.legs_image + '/Animation.json');
		var animToFind:String = Paths.getPath('images/' + json.legs_image + '/Animation.json', TEXT);
		
		//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
		//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
		
		if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + json.legs_image + '/Animation.json', TEXT)))
		#end
		{
			spriteType = "texture";
		}

		switch (spriteType){
			case "packer":
				legs.frames = Paths.getPackerAtlas(json.legs_image);
			
			case "sparrow":
				legs.frames = Paths.getSparrowAtlas(json.legs_image);
			
			case "texture":
				legs.frames = AtlasFrameMaker.construct(json.legs_image);
			
		}
		imageFile = json.image;

		// Offset
		legsOffset = new FlxPoint(json.legs_x, json.legs_y);

		// Flip
		legs.flipX = json.legs_flip_x;
		if (isPlayer)
			legs.flipX = !legs.flipX;
		legs.flipY = json.legs_flip_y;
		if (legs.flipX)
			legsOffset.x = json.legs_flipped_x;

		// Scale
		legs.scale.set(json.scale, json.scale);

		// Anti-Aliasing
		if (json.no_antialiasing)
			legs.antialiasing = false;

		// Animations
		legs.leftIdle = json.legs_left.name;
		if (json.legs_left.indices != null && json.legs_left.indices.length > 0) {
			legs.animation.addByIndices('danceLeft', json.legs_left.name, json.legs_left.indices, "", json.legs_left.fps, json.legs_left.loop);
		} else {
			legs.animation.addByPrefix('danceLeft', json.legs_left.name, json.legs_left.fps, json.legs_left.loop);
		}

		legs.rightIdle = json.legs_right.name;
		if (json.legs_right.indices != null && json.legs_right.indices.length > 0) {
			legs.animation.addByIndices('danceRight', json.legs_right.name, json.legs_right.indices, "", json.legs_right.fps, json.legs_right.loop);
		} else {
			legs.animation.addByPrefix('danceRight', json.legs_right.name, json.legs_right.fps, json.legs_right.loop);
		}

		//legs.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) { updateRunAnim(name, frameNumber, frameIndex); };

		// Type
		var type:String = json.legs_type;
		if (type == null)
			type == 'human';
		legType = type;

		// Update Postion if Flipped
		//legs.updateHitbox();
		//legs.setSize(width, height);
		/*if (legs.flipX) {
			//legs.x -= width / 2;
			//legs.x += legs.width / 2;
			var oldX = legs.x;
			var pos = new FlxPoint(x + groupParent.x, y + groupParent.y);
			var distFromRight = (pos.x - width) - (legs.x - legs.width);
			trace(pos.x + ', ' + legs.x);
			trace(distFromRight);
			legs.x = pos.x + distFromRight;
			trace(pos.x + ', ' + legs.x);
			legsOffset.x += -oldX + legs.x;
			//legsOffset.x += (legs.width * legsOffset.x);
		}*/

		//trace(legs.leftIdle + ', ' + legs.rightIdle + ', ' + legs.animation.curAnim);
	}

	public function makeOverlay(json:CharacterFile)
	{
		// Definition
		overlay = new CharOverlay(this);

		// Image
		var spriteType = "sparrow";
		//sparrow
		//packer
		//texture
		#if MODS_ALLOWED
		var modTxtToFind:String = Paths.modsTxt(json.overlay_image);
		var txtToFind:String = Paths.getPath('images/' + json.overlay_image + '.txt', TEXT);
		
		//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
		//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
		
		if (FileSystem.exists(modTxtToFind) || FileSystem.exists(txtToFind) || Assets.exists(txtToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + json.overlay_image + '.txt', TEXT)))
		#end
		{
			spriteType = "packer";
		}
		
		#if MODS_ALLOWED
		var modAnimToFind:String = Paths.modFolders('images/' + json.overlay_image + '/Animation.json');
		var animToFind:String = Paths.getPath('images/' + json.overlay_image + '/Animation.json', TEXT);
		
		//var modTextureToFind:String = Paths.modFolders("images/"+json.image);
		//var textureToFind:String = Paths.getPath('images/' + json.image, new AssetType();
		
		if (FileSystem.exists(modAnimToFind) || FileSystem.exists(animToFind) || Assets.exists(animToFind))
		#else
		if (Assets.exists(Paths.getPath('images/' + json.overlay_image + '/Animation.json', TEXT)))
		#end
		{
			spriteType = "texture";
		}

		switch (spriteType){
			case "packer":
				overlay.frames = Paths.getPackerAtlas(json.overlay_image);
			
			case "sparrow":
				overlay.frames = Paths.getSparrowAtlas(json.overlay_image);
			
			case "texture":
				overlay.frames = AtlasFrameMaker.construct(json.overlay_image);
			
		}
		imageFile = json.image;

		// Flip
		if (isPlayer)
			overlay.flipX = !overlay.flipX;

		// Scale
		overlay.scale.set(json.scale, json.scale);
		
		// Anti-Aliasing
		if (json.no_antialiasing)
			overlay.antialiasing = false;
	}

	/**
		- Put `this` for the instance.
		- Run this *after* adding a character.
	**/
	/*public function addExtras(instance:MusicBeatState)
	{
		if (legs != null)
		{
			instance.add(legs);
			//FunkinLua.setObjectOrder('boyfriend.legs', FunkinLua.getObjectOrder('boyfriend'));
			//setObjectOrder('boyfriend.legs', getObjectOrder('boyfriend', instance), instance);
		}
		if (overlay != null)
		{
			//new FlxTimer().start(0.1, function(tmr:FlxTimer)
			//{
				instance.add(overlay);
				//setObjectOrder('boyfriend.overlay', getObjectOrder('boyfriend', instance) + 1, instance);
			//});
		}
	}*/

	public function addLegs(group:FlxSpriteGroup)
	{
		if (legs != null)
		{
			/*group.forEachAlive(function(spr:FlxSprite) {
				if (spr == legs)
				{
					group.remove(legs);
				}
			});*/
			group.remove(legs, true);
			group.add(legs);
			//FunkinLua.setObjectOrder('boyfriend.legs', FunkinLua.getObjectOrder('boyfriend'));
			//setObjectOrder('boyfriend.legs', getObjectOrder('boyfriend', instance), instance);
		}
	}
	
	public function addOverlay(group:FlxSpriteGroup)
	{
		if (overlay != null)
		{
			//new FlxTimer().start(0.1, function(tmr:FlxTimer)
			//{
				group.remove(overlay);
				group.add(overlay);
				//setObjectOrder('boyfriend.overlay', getObjectOrder('boyfriend', instance) + 1, instance);
			//});
		}
	}
	
	public function getObjectOrder(obj:String, instance:MusicBeatState) {
		var killMe:Array<String> = obj.split('.');
		var leObj:FlxBasic = FunkinLua.getObjectDirectly(killMe[0]);
		if(killMe.length > 1) {
			leObj = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		}

		if(leObj != null)
		{
			return instance.members.indexOf(leObj);
		}
		//luaTrace("getObjectOrder: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
		return -1;
	}

	public function setObjectOrder(obj:String, position:Int, instance:MusicBeatState) {
		var killMe:Array<String> = obj.split('.');
		var leObj:FlxBasic = FunkinLua.getObjectDirectly(killMe[0]);
		if(killMe.length > 1) {
			leObj = FunkinLua.getVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe), killMe[killMe.length-1]);
		}

		if(leObj != null) {
			instance.remove(leObj, true);
			instance.insert(position, leObj);
			return;
		}
		//luaTrace("setObjectOrder: Object " + obj + " doesn't exist!", false, false, FlxColor.RED);
	}

	public function updateRunAnim()
	{
		if (legs != null && legs.animation.curAnim != null)
		{
			var name = legs.animation.curAnim.name;
			var frameNumber = legs.animation.curAnim.curFrame;
			var frameIndex = legs.animation.frameIndex;
			offset.x -= runOffset.x;
			offset.y -= runOffset.y;
			legs.offset.x -= legs.runOffset.x;
			legs.offset.y -= legs.runOffset.y;
			switch (legType)
			{
				case 'human':
					if (animation.curAnim != null && animation.curAnim.name != 'idle' && animation.curAnim.name != 'danceLeft' && animation.curAnim.name != 'danceRight')
						//switch(legs.animation.curAnim.curFrame)
						switch(frameNumber)
						{
							case 0 | 1: runOffset.y = 0;
							case 2 | 3: runOffset.y = -18;
							case 4 | 5: runOffset.y = 6;
							default: runOffset.y = 12;
						}
				case 'amongUs':
					var dumOffset:Float = -18;
					switch(frameNumber)
					{
						/*case 0: legs.runOffset.y = 0; runOffset.y = 0;
						case 1: legs.runOffset.y = 0; runOffset.y = -9;
						case 2: legs.runOffset.y = 30; runOffset.y = 30;
						case 3: legs.runOffset.y = 39; runOffset.y = 39;
						case 4: legs.runOffset.y = 42; runOffset.y = 42;
						case 6: legs.runOffset.y = 39; runOffset.y = 39;*/
						
						case 0: legs.runOffset.y = 0; runOffset.y = 0 + dumOffset;
						case 1: legs.runOffset.y = 0; runOffset.y = -3 + dumOffset;
						case 2: legs.runOffset.y = 30; runOffset.y = 30 + dumOffset;
						case 3: legs.runOffset.y = 39; runOffset.y = 39 + dumOffset;
						case 4 | 5: legs.runOffset.y = 42; runOffset.y = 42 + dumOffset;
						default: legs.runOffset.y = 39; runOffset.y = 39 + dumOffset;
					}
				//default:
					//legs.runOffset.set(0, 0); runOffset.set(0, 0);
			}
			offset.x += runOffset.x;
			offset.y += runOffset.y;
			legs.offset.x += legs.runOffset.x;
			legs.offset.y += legs.runOffset.y;
		}
	}
}

class CharLegsRun extends FlxSprite
{
	public var leftIdle(default, set):String;
	public var rightIdle(default, set):String;

	public var danced:Bool = false;
	
	public var runOffset:FlxPoint = new FlxPoint(0, 0);

	private function set_leftIdle(left:String) {
		leftIdle = left;
		//if (created)
			//animation.addByPrefix('danceLeft', left, 24, false);
		return left;
	}

	private function set_rightIdle(right:String) {
		rightIdle = right;
		//if (created)
			//animation.addByPrefix('danceRight', right, 24, false);
		return right;
	}
	
	public function dance(?forceplay:Bool = false) {
		//trace('last animation finished? ' + animation.curAnim.finished + ', last animation paused? ' + animation.curAnim.paused + ', last animation frame? ' + animation.curAnim.curFrame);
		danced = !danced;
		if (danced && rightIdle != null) {
			animation.play('danceRight', forceplay);
			//trace('sliiide to the left');
			//trace('danceLeft animation is ' + leftIdle);
			//trace(animation.curAnim);
			//animation.update(1);
		}
		else if (!danced && leftIdle != null) {
			animation.play('danceLeft', forceplay);
			//trace('sliiide to the right');
			//trace('danceRight animation is ' + rightIdle);
			//trace(animation.curAnim);
			//animation.update(1);
		}
		//else if (idleAnim != null) {
			//animation.play(idleAnim, forceplay);
		//}
		if (animation.curAnim != null)
		{
			//trace(danced + leftIdle + rightIdle + animation.curAnim.name + animation.curAnim.numFrames + animation.finished + animation.curAnim.frameRate);
			//animation.callback = function(name:String, frameNumber:Int, frameIndex:Int) {trace(animation.curAnim.curFrame);}
			//trace('among us could you repeat that simulator');
			//trace(animation.curAnim.name + ', ' + animation.frameIndex);
		}
	}
}

class CharOverlay extends FlxSprite
{
	public var parent:Character;
	//public var animOffsets:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();

	public function new(parent:Character)
	{
		super();
		this.parent = parent;
		//if (parent != null)
			//animOffsets = parent.animOffsets;
	}
	
	/*public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}*/

	/*public override function update(elapsed:Float)
	{
		//if (parent != null && parent.animation.curAnim != null && animation.curAnim != null && parent.animation.curAnim.name != animation.curAnim.name)
		if (parent != null)
		{
			//playAnim(parent.animation.curAnim.name);
			animation.frameIndex = parent.animation.frameIndex;
			if (parent.animation.curAnim != null)
				offset.set(animOffsets.get(parent.animation.curAnim.name)[0], animOffsets.get(parent.animation.curAnim.name)[1]);
		}
		super.update(elapsed);
	}*/

	public function copyParent()
	{
		if (parent != null)
		{
			animation.frameIndex = parent.animation.frameIndex;
			//if (parent.animation.curAnim != null)
				//offset.set(animOffsets.get(parent.animation.curAnim.name)[0], animOffsets.get(parent.animation.curAnim.name)[1]);
			offset.set(parent.offset.x, parent.offset.y);
			x = parent.x;
			y = parent.y;
			alpha = parent.alpha;
		}
	}
}