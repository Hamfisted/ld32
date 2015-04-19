package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;

/**
 * ...
 * @author
 */
class BounceMovement
{
  public static function BounceTo(obj:FlxObject, destWorld:FlxPoint,
                                  yAccel:Float, yOvershoot:Float, airTime:Float)
  {
    var sourceWorld = obj.getMidpoint();
    var yDistAfterPeak = 0.0;
    var yDistBeforePeak = 0.0;
    if (sourceWorld.y < destWorld.y)
    { // dropping down
      yDistBeforePeak = yOvershoot;
      yDistAfterPeak = -(destWorld.y - sourceWorld.y);
    }
    else
    {
      yDistBeforePeak = -(destWorld.y - sourceWorld.y) - yOvershoot;
      yDistAfterPeak = yOvershoot;
    }
    var fallTime = FallTimeAfterPeak(yDistAfterPeak, yAccel);

    if ((airTime - fallTime) < 0.0)
    {
      airTime = fallTime + fallTime;
    }

    var riseTime = airTime - fallTime;

    var initXVelocity = (destWorld.x - sourceWorld.x) / airTime;
    var initYVelocity = -yDistBeforePeak / riseTime - 0.5 * yAccel * riseTime;

    //FlxG.log.add('${initXVelocity}, ${initYVelocity}, ${fallTime}, ${riseTime}');

    obj.velocity.x = initXVelocity;
    obj.velocity.y = initYVelocity;
  }

  private static function FallTimeAfterPeak(yDist:Float, yAccel:Float):Float
  {
    return (2 * yDist) / Math.sqrt(2 * yAccel * yDist);
  }
}
