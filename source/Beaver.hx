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
    loadGraphic(AssetPaths.beaver__png, true, 32, 32);
    setFacingFlip(FlxObject.LEFT, false, false);
    setFacingFlip(FlxObject.RIGHT, true, false);

    setSize(16, 16);
    offset.set(8, 15);

    // define animations
    var c:Int = 4; // Num of columns in sheet
    function frames(row:Int, length:Int):Array<Int>
    {
      return [for (i in (row*c)...(row*c+length)) i];
    }
    animation.add("walk",  frames(0, 4), 10, true);
    animation.add("jump",  frames(1, 4), 12, false);
    animation.add("die",   frames(2, 2), 8, false);

    solid = true;

    acceleration.y = GRAVITY;

    set_facing(FlxObject.LEFT);
    velocity.x = -SPEED;

    _jumpAirTime = jumpAirTime;
    _jumpDist = jumpDist;
  }

  override public function update():Void
  {
    if (alive)
    {
      movement();
    }
    else
    {
      if (isTouching(FlxObject.FLOOR))
      {
        velocity.x = 0;
      }
    }
    super.update();
  }

  override public function kill():Void
  {
    alive = false;
    animation.play("die");
    allowCollisions = FlxObject.FLOOR;
    haxe.Timer.delay(function() {
      exists = false;
    }, 1400);
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
      animation.play("jump");
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
