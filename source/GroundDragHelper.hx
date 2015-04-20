package;
import flixel.FlxObject;

/**
 * ...
 * @author
 */
class GroundDragHelper
{
  var _object:FlxObject;

  public function new(obj:FlxObject)
  {
    _object = obj;
  }

  public function update()
  {
    if (_object.justTouched(FlxObject.FLOOR) &&
        _object.velocity.y >= 0.0) // has no up velocity
    {
      _object.drag.x = 2400;
    }
  }

}
