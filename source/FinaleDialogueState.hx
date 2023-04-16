import flixel.util.FlxColor;
import DialogueBoxPsych.DialogueFile;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxG;
using StringTools;

class FinaleDialogueState extends MusicBeatState {
	var dialogueJson:DialogueFile = null;

    override function create()
    {
		var file:String = Paths.json('finaleDialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
            for (line in dialogueJson.dialogue) {
                line.text = line.text.replace('%username%', getUsername());
            }
		}
        startDialogue(dialogueJson, 'confrontingElliot');
    }
    
	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			//inCutscene = true;
			Paths.sound('dialogue');
			Paths.sound('dialogueClose');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set(1, 1);
			/*if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}*/
			psychDialogue.finishThing = function() {
				psychDialogue = null;
				//MusicBeatState.switchState(new TitleState());
				TitleState.initialized = false;
				TitleState.closedState = false;
				//FlxG.sound.music.fadeOut(0.1);
				if(FreeplayState.vocals != null)
				{
					FreeplayState.vocals.fadeOut(0.1);
					FreeplayState.vocals = null;
				}
                //FlxG.save.data.finaleActive = true;
				FlxG.camera.fade(FlxColor.BLACK, 0.25, false, FlxG.resetGame, false);
			}
			//psychDialogue.nextDialogueThing = startNextDialogue;
			//psychDialogue.skipDialogueThing = skipDialogue;
			//psychDialogue.cameras = [camHUD];
			psychDialogue.nextDialogueThing = function() {
                psychDialogue.daText.y += 75;
            };
            psychDialogue.box.alpha = 0.5;
            psychDialogue.offsetPos = 0;
            psychDialogue.scrollSpeed = 900000;
            psychDialogue.box.y += 75;
            psychDialogue.daText.y += 75;
			add(psychDialogue);

            FlxG.save.data.finaleActive = true;
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			/*if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}*/
			MusicBeatState.switchState(new TitleState());
		}
	}

    function getUsername() // Thanks, Reddit
    {
        #if sys
        var envs = Sys.environment();
        if (envs.exists('USERNAME'))
            return envs['USERNAME'];
        if (envs.exists('USER'))
            return envs['USER'];
        #end
        return 'Yes. Yes, that sounds right';
    }
}