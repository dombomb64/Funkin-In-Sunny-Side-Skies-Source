package;

import flixel.FlxG;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	public static var songVisited:Map<String, Bool> = new Map();
	public static var songFC:Map<String, Bool> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	public static var songVisited:Map<String, Bool> = new Map<String, Bool>();
	public static var songFC:Map<String, Bool> = new Map<String, Bool>();
	#end


	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setRating(daSong, 0);
		setSongFC(daSong, false);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, ?fc:Bool = false):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
			if (!getSongFC(song, diff))
				setSongFC(daSong, fc);
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
			if (!getSongFC(song, diff))
				setSongFC(daSong, fc);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		//trace(daWeek);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	public static function saveSongVisited(song:String, visited:Bool = false):Void
	{
		var daSong:String = Paths.formatToSongPath(song);

		//if (songVisited.exists(daSong)) {
			//if (songVisited.get(daSong) == false) {
				setSongVisited(daSong, visited);
			//}
		//}
		//else {
			//setSongVisited(daSong, score);
		//}
	}

	/*public static function saveSongFC(song:String, fc:Bool = false, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		if (!getSongFC(song, diff))
			setSongFC(daSong, fc);
	}*/

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	static function setSongVisited(song:String, visited:Bool):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songVisited.set(song, visited);
		FlxG.save.data.songVisited = songVisited;
		FlxG.save.flush(); // pist 8=D-=::#%
	}

	static function setSongFC(song:String, fc:Bool):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songFC.set(song, fc);
		FlxG.save.data.songFC = songFC;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		//trace('score for song ' + daSong + ' is ' + songScores.get(daSong));
		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		//trace(daWeek);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function getSongVisited(song:String):Bool
	{
		var daSong:String = Paths.formatToSongPath(song);
		if (!songVisited.exists(daSong))
			setSongVisited(daSong, false);

		return songVisited.get(daSong);
	}

	public static function getSongFC(song:String, diff:Int):Bool
	{
		var daSong:String = formatSong(song, diff);
		if (!songFC.exists(daSong))
			setSongFC(daSong, false);

		return songFC.get(daSong);
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songVisited != null)
		{
			songVisited = FlxG.save.data.songVisited;
		}
		if (FlxG.save.data.songFC != null)
		{
			songFC = FlxG.save.data.songFC;
		}
	}
}