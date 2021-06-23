import flixel.FlxG;

class Ratings
{
    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "N/A";
		if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "BotPlay";

        if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods == 0) // Marvelous (SICK) Full Combo
            ranking = "(PERFECT)";
        else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods < 10) // SDG
            ranking = "(SDG)";
        else if (PlayState.misses == 0 && PlayState.bads == 0 && PlayState.shits == 0 && PlayState.goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
            ranking = "(GFC)";
        else if (PlayState.misses == 0) // Regular FC
            ranking = "(FC)";
        else if (PlayState.misses < 10) // Single Digit Combo Breaks
            ranking = "(SDCB)";
        else
            ranking = "";

        // WIFE TIME :)))) (based on Wife3)

        var wifeConditions:Array<Bool> = [
            accuracy >= 99.999,
            accuracy >= 97.5,
            accuracy >= 95,
            accuracy >= 90,
            accuracy >= 80,
            accuracy >= 70,
            accuracy >= 60,
            accuracy < 60
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " SSSS";
                    case 1:
                        ranking += " SSS";
                    case 2:
                        ranking += " SS";
                    case 3:
                        ranking += " S";
                    case 4:
                        ranking += " A";
                    case 5:
                        ranking += " B";
                    case 6:
                        ranking += " C";
                    case 7:
                        ranking += " D";
                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "N/A";
		else if(FlxG.save.data.botplay && !PlayState.loadRep)
			ranking = "UNRANKED";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;

        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

        if (FlxG.save.data.botplay && !PlayState.loadRep)
            return "sick"; // FUNNY
	

        var rating = checkRating(noteDiff,customTimeScale);


        return rating;
    }

    public static function checkRating(ms:Float, ts:Float)
    {
        var rating = "sick";
        if (ms <= 166 * ts && ms >= 135 * ts)
            rating = "shit";
        if (ms < 135 * ts && ms >= 90 * ts) 
            rating = "bad";
        if (ms < 90 * ts && ms >= 45 * ts)
            rating = "good";
        if (ms < 45 * ts && ms >= -45 * ts)
            rating = "sick";
        if (ms > -90 * ts && ms <= -45 * ts)
            rating = "good";
        if (ms > -135 * ts && ms <= -90 * ts)
            rating = "bad";
        if (ms > -166 * ts && ms <= -135 * ts)
            rating = "shit";
        return rating;
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,nps:Int,maxNPS:Int,accuracy:Float):String
    {
        return
         (FlxG.save.data.npsDisplay ?																							// NPS Toggle
         "NPS: " + nps + " (Max " + maxNPS + ")" + (!PlayStateChangeables.botPlay || PlayState.loadRep ? " | " : "") : "") +								// 	NPS
         (!PlayStateChangeables.botPlay || PlayState.loadRep ? "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 		// Score
         (FlxG.save.data.accuracyDisplay ?																						// Accuracy Toggle
         " | Combo Breaks:" + PlayState.misses + 																				// 	Misses/Combo Breaks
         " | Accuracy:" + (PlayStateChangeables.botPlay && !PlayState.loadRep ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %") +  				// 	Accuracy
         " | " + GenerateLetterRank(accuracy) : "") : ""); 																		// 	Letter Rank
    }
}
