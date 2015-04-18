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
    var fallTime = 0.0;
    if (sourceWorld.y > destWorld.y)
    { // dropping down
      fallTime = FallTimeAfterPeak(sourceWorld.y + yOvershoot - destWorld.y, yAccel);
    }
    else
    {
      fallTime = FallTimeAfterPeak(yOvershoot, yAccel);
    }

    if (airTime - fallTime < 0.0)
    {
      airTime = fallTime + fallTime;
    }

    var riseTime = airTime - fallTime;
    var initYVelocity = -yAccel * riseTime;
    var initXVelocity = (destWorld.x - sourceWorld.x) / airTime;

    obj.velocity.x = initXVelocity;
    obj.velocity.y = initYVelocity;
  }

  private static function FallTimeAfterPeak(yDist:Float, yAccel:Float):Float
  {
    return (2 * yDist) / Math.sqrt(2 * yAccel * yDist);
  }
}
