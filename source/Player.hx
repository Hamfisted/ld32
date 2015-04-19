package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxRect;
import flixel.group.FlxTypedGroup;
import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;

class Player extends FlxSprite
{
  var initX:Float;
  var initY:Float;

  var lastVelocity:FlxPoint;

  var GRAVITY:Int = 800;
  var JUMP_SPEED:Int = -240;

  public var seedShooter:FlxWeapon;

  public var speed:Int = 140;

  public var seedCount:Int = 0;

  var isShooting:Bool = false;

  public function new(X:Float=0, Y:Float=0)
  {
    super(X, Y);
    initX = X;
    initY = Y;

    lastVelocity = new FlxPoint(0, 0);

    loadGraphic(AssetPaths.sapling__png, true, 32, 32);
    setFacingFlip(FlxObject.RIGHT, false, false);
    setFacingFlip(FlxObject.LEFT, true, false);

    setSize(24, 28);
    offset.set(4, 4);

    // define animations
    var c:Int = 8; // Num of columns in sheet
    function frames(row:Int, length:Int):Array<Int>
    {
      return [for (i in (row*c)...(row*c+length)) i];
    }
    animation.add("walk",  frames(0, 8), 10, true);
    animation.add("jump",  frames(1, 6), 12, true);
    animation.add("die",   frames(2, 8), 12, true);
    animation.add("shoot", frames(3, 6), 16, false);

    solid = true;
    collisonXDrag = false;

    drag.x = 2400;

    acceleration.y = GRAVITY;

    // Just makes 20 bullets for now
    seedShooter = new FlxWeapon("seed_shooter", this);
    seedShooter.makePixelBullet(20, 4, 4, FlxColor.LIME);
    seedShooter.setBulletSpeed(400);
    seedShooter.setFireRate(200);
    seedShooter.setBulletOffset(12, 12);
    seedShooter.setBulletBounds(new FlxRect(0, 0, 2400, 2400));
    seedShooter.setBulletLifeSpan(4);
  }

  override public function update():Void
  {
    animateCollision();
    movement();
    if (alive)
    {
      if (shouldBeDead())
      {
        kill();
      }
      else
      {
        Reg.score += 1;
      }
    }
    super.update();
  }

  override public function kill():Void
  {
    this.alive = false;
  }

  override public function reset(X:Float, Y:Float):Void
  {
    super.reset(X, Y);
    velocity.set(0, 0);
    seedCount = 0;
    isShooting = false;
    lastVelocity.copyFrom(velocity);
  }

  private function shouldBeDead():Bool
  {
    return outOfBounds();
  }

  private function movement():Void
  {
    var _up:Bool = FlxG.keys.anyJustPressed(["UP", "W", "SPACE"]);
    var _left:Bool = FlxG.keys.anyPressed(["LEFT", "A"]);
    var _right:Bool = FlxG.keys.anyPressed(["RIGHT", "D"]);
    var _down:Bool = FlxG.keys.anyPressed(["DOWN", "S"]);
    var _pressed:Bool = FlxG.mouse.justPressed;


    if (_up && isTouching(FlxObject.FLOOR))
    {
      jumpUp();
    }

    if (_left)
    {
      this.velocity.x = -this.speed;
      facing = FlxObject.LEFT;
    }
    else if (_right)
    {
      this.velocity.x = this.speed;
      facing = FlxObject.RIGHT;
    }

    lastVelocity.copyFrom(velocity);

    //   Horrible mess that plays the shooting animation but delays the
    // bullet until a certain time. And prevents other animations from
    // interrupting the shooting animation.
    if (!isShooting && seedCount > 0 && _pressed)
    {
      isShooting = true; // This should be the only place where this var becomes true
      animation.play("shoot");
      haxe.Timer.delay(function() {
        if (seedShooter.fireAtMouse()) {
          seedCount--;
        }
      }, 250);
    }

    if (isShooting) {
      if (animation.finished)
      {
        isShooting = false;
      }
    }
    else if (_left || _right)
    {
      animation.play("walk");
    }
    else
    {
      // Standing still, so pause at first frame of "walk" animation
      animation.play("walk");
      animation.frameIndex = 0;
      animation.pause();
    }
  }

  private function outOfBounds():Bool
  {
    return this.y > 2400;
  }

  private function animateCollision():Void
  {
    var shakeY = Math.abs(lastVelocity.y - velocity.y)/30000;
    var shakeAmount = shakeY + Math.abs(lastVelocity.x - velocity.x)/30000;

    /* Let's disable shake for now. It's annoying! */

    // if (shakeAmount > 0.01 && justTouched(FlxObject.FLOOR))
    // {
    //   FlxG.camera.shake(shakeAmount, 0.1);
    // }
  }

  public function giveSeeds(count:Int)
  {
    seedCount += count;
  }

  public function jumpUp():Void
  {
    this.velocity.y = JUMP_SPEED;
  }
}
