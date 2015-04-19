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

  public var seedTrail:FlxTypedGroup<SeedPickup>;
  var seedTrailBounceTimer:Int;

  var GRAVITY:Int = 800;
  var JUMP_SPEED:Int = -240;

  public var seedShooter:FlxWeapon;

  public var speed:Int = 140;

  public var seedCount:Int = 0;

  var lastFiredTime:Int;
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

    animation.add("run", [0, 1, 2, 3, 4], 12, true);
    animation.add("shoot", [6, 7, 8, 9, 10, 11], 14, false);

    solid = true;
    collisonXDrag = false;

    drag.x = 2400;

    acceleration.y = GRAVITY;

    // Just makes 20 bullets for now
    seedShooter = new FlxWeapon("seed_shooter", this);
    seedShooter.makePixelBullet(20, 4, 4, FlxColor.LIME);
    seedShooter.setBulletSpeed(400);
    seedShooter.setFireRate(1000);
    seedShooter.setBulletOffset(12, 12);
    seedShooter.setBulletBounds(new FlxRect(0, 0, 2400, 2400));
    seedShooter.setBulletLifeSpan(4);

    seedTrail = new FlxTypedGroup<SeedPickup>();
    seedTrailBounceTimer = FlxG.game.ticks + 100;
  }

  function makeTestSeedTrail():Void
  {
    for (i in 0...20)
    {
      var seed = new SeedPickup(this.x, this.y);
      seed.acceleration.y = GRAVITY;
      seedTrail.add(seed);
    }
  }

  override public function update():Void
  {
    animateSeeds();
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

    seedTrail.callAll("destroy");
    seedTrail.clear();
    makeTestSeedTrail();
    seedTrailBounceTimer = FlxG.game.ticks + 100;
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
    var _pressed:Bool = FlxG.mouse.pressed;


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
      isShooting = true;
      lastFiredTime = FlxG.game.ticks;
      animation.play("shoot");
    }

    if (isShooting) {
      if (animation.finished)
      {
        isShooting = false;
        lastFiredTime = 0;
      }
      else if (FlxG.game.ticks - lastFiredTime > 240)
      {
        if (seedShooter.fireAtMouse()) {
          seedCount--;
        }

      }
    }
    else if (_left || _right)
    {
      animation.play("run");
    }
    else
    {
      // Standing still, so pause at first frame of "run" animation
      animation.play("run");
      animation.frameIndex = 0;
      animation.pause();
    }
  }

  private function outOfBounds():Bool
  {
    return this.y > 2400;
  }

  private function animateSeeds():Void
  {
    if (seedTrailBounceTimer < FlxG.game.ticks)
    {
      seedTrailBounceTimer += 100;
      FlxG.log.add('seedbounce');
      BounceMovement.BounceTo(seedTrail.getRandom(), this.getMidpoint(), GRAVITY, 1.0);
    }
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
