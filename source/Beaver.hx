package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;

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

    setSize(20, 24);
    offset.set(6, 6);

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
    function completeDeath(tween: FlxTween):Void {
      exists = false;
    }
    FlxTween.tween(this, {alpha: 0}, 0.3, {complete: completeDeath, startDelay: 0.7});
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

    if (isTouching(FlxObject.FLOOR) &&
        this.velocity.y >= 0.0)
        // only jump if they are on the way down
        // aka not on a bouncer
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
