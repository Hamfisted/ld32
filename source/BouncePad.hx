package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author
 */
class BouncePad extends FlxSprite
{
  var _destPoint:FlxPoint;
  var _airTime:Float;
  var _yOvershoot:Float;

  public function new(X:Float, Y:Float, destX:Float, destY:Float,
                      airTime:Float, yOvershoot:Float)
  {
    super(X, Y);
    _destPoint = new FlxPoint(destX, destY);
    _airTime = airTime;
    _yOvershoot = yOvershoot;
    immovable = true;
  }

  public function bounceObject(obj:FlxObject)
  {
    BounceMovement.BounceTo(obj, _destPoint, obj.acceleration.y,
                            _yOvershoot, _airTime);
  }

}
