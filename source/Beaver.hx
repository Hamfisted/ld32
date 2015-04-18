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

  public function touchWall(wall:FlxTilemap):Void
  {
    if (isTouching(FlxObject.WALL))
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
  }

}
