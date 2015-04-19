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
                                  yAccel:Float, airTime:Float)
  {
    var sourceWorld = obj.getMidpoint();

    var initXVelocity = (destWorld.x - sourceWorld.x) / airTime;
    var initYVelocity = (sourceWorld.y + 0.5 * yAccel * airTime * airTime - sourceWorld.y) / airTime;

    obj.velocity.x = initXVelocity;
    obj.velocity.y = -initYVelocity;
  }
}

