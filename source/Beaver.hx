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

  public function new(X:Float=0, Y:Float=0)
  {
    super(X, Y);
    makeGraphic(16, 16, FlxColor.CRIMSON);
    solid = true;

    acceleration.y = GRAVITY;

    set_facing(FlxObject.LEFT);
    velocity.x = -SPEED;
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
        dest.x += 16.0;
      }
      else
      {
        dest.x -= 16.0;
      }
      BounceMovement.BounceTo(this, dest, this.acceleration.y, 0.5);
    }
  }

}
