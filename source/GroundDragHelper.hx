package;
import flixel.FlxObject;

/**
 * ...
 * @author
 */
class GroundDragHelper
{
  var _inAirLastFrame:Bool = true;
  var _object:FlxObject;

  public function new(obj:FlxObject)
  {
    _inAirLastFrame = true;
    _object = obj;
  }

  public function update()
  {
    var onGround = _object.isTouching(FlxObject.FLOOR);
    if (_inAirLastFrame && onGround)
    {
      _object.drag.x = 2400;
      _inAirLastFrame = false;
    }

    if (!_inAirLastFrame && !onGround)
    {
      _inAirLastFrame = true;
    }
  }

}
