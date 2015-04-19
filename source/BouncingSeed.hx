package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxMath;

/**
 * ...
 * @author
 */
class BouncingSeed extends FlxSprite
{
  var _groundDrag:GroundDragHelper;
  var inAirLastFrame:Bool = true;
  var _target:FlxObject;
  var _updateRate:Int;
  var _nextUpdateMilli:Int;

  public function new(X:Float=0, Y:Float=0, target:FlxObject, gravity:Int)
  {
    super(X+4, Y);
    makeGraphic(8, 8, FlxColor.LIME);

    _groundDrag = new GroundDragHelper(this);
    _target = target;
    _updateRate = Std.random(200) + 600;
    _nextUpdateMilli = FlxG.game.ticks + _updateRate;
    this.acceleration.y = gravity;
  }

  override public function update():Void
  {
    _groundDrag.update();

    if (_nextUpdateMilli < FlxG.game.ticks)
    {
      var targetPos = _target.getMidpoint();
      var distanceToTarget = FlxMath.getDistance(this.getMidpoint(), targetPos);

      this.drag.x = 0;
      if (distanceToTarget < 16.0)
      {
        _nextUpdateMilli = FlxG.game.ticks + 500;
        BounceMovement.BounceTo(this, _target.getMidpoint(), this.acceleration.y, 0.2);
      }
      else
      {
        _nextUpdateMilli = FlxG.game.ticks + _updateRate;
        BounceMovement.BounceTo(this, _target.getMidpoint(), this.acceleration.y, 0.4);
      }
    }

    super.update();
  }
}
