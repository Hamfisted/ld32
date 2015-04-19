package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class Beaver extends FlxSprite
{
  var GRAVITY:Int = 800;
  var SPEED:Int = 50;

  var _jumpAirTime:Float;
  var _jumpDist:Float;

  public function new(X:Float, Y:Float, jumpAirTime:Float, jumpDist:Float)
  {
    super(X, Y);
    makeGraphic(16, 16, FlxColor.CRIMSON);
    solid = true;

    acceleration.y = GRAVITY;

    set_facing(FlxObject.LEFT);
    velocity.x = -SPEED;

    _jumpAirTime = jumpAirTime;
    _jumpDist = jumpDist;
  }

  override public function update():Void
  {
    movement();
    super.update();
  }

  public function changeDirection()
  {
    if (facing == FlxObject.RIGHT)
    {
      moveLeft();
    }
    else
    {
      moveRight();
    }
  }

  private function moveLeft():Void
  {
    set_facing(FlxObject.LEFT);
    velocity.x = -SPEED;
  }

  private function moveRight():Void
  {
    set_facing(FlxObject.RIGHT);
    velocity.x = SPEED;
  }

  private function movement():Void
  {
    if (isTouching(FlxObject.WALL))
    {
      changeDirection();
    }

    if (isTouching(FlxObject.FLOOR))
    {
      var dest = this.getMidpoint();
      if (facing == FlxObject.RIGHT)
      {
        dest.x += _jumpDist;
      }
      else
      {
        dest.x -= _jumpDist;
      }
      BounceMovement.BounceTo(this, dest, this.acceleration.y, _jumpAirTime);
    }
  }

}
