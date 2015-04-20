package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;

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
  var _warpingToPlayer:Bool = false;

  public function new(X:Float=0, Y:Float=0, target:FlxObject, gravity:Int)
  {
    super(X, Y);
    loadGraphic(AssetPaths.seed__png, false);

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
      if (_warpingToPlayer || distanceToTarget > 128.0)
      {
        FlxVelocity.moveTowardsPoint(this, _target.getMidpoint(), 10);
        this.allowCollisions = FlxObject.NONE;
      }
      if (distanceToTarget < 32.0)
      {
        _warpingToPlayer = false;
        this.allowCollisions = FlxObject.ANY;
        _nextUpdateMilli = FlxG.game.ticks + 500;
        BounceMovement.BounceTo(this, _target.getMidpoint(), this.acceleration.y, 0.2);
      }
      else
      {
        _nextUpdateMilli = FlxG.game.ticks + _updateRate;
        BounceMovement.BounceTo(this, _target.getMidpoint(), this.acceleration.y, 0.5);
      }
    }

    super.update();
  }
}
