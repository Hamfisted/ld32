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

  public var seedTrail:FlxTypedGroup<BouncingSeed>;

  var GRAVITY:Int = 800;
  var JUMP_SPEED:Int = -240;

  public var seedShooter:FlxWeapon;

  public var speed:Int = 140;

  var seedCount:Int = 0;

  // god help me
  var isShooting:Bool;
  var isPreparingJump:Bool;
  var isJumping:Bool;
  var isWinning:Bool;

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
    function frames(row:Int, start:Int, end:Int):Array<Int>
    {
      return [for (i in (row*c + start)...(row*c + end + 1)) i];
    }
    animation.add("walk",  frames(0, 1, 7), 10, true);
    animation.add("jump",  frames(1, 1, 5), 8, false);
    animation.add("die",   frames(2, 1, 7), 12, false);
    animation.add("shoot", frames(3, 1, 5), 16, false);
    animation.add("idle",  frames(4, 0, 3), 8, true);
    animation.add("win",   frames(5, 0, 3), 8, true);

    solid = true;
    collisonXDrag = false;

    drag.x = 2400;

    acceleration.y = GRAVITY;

    // Just makes 20 bullets for now
    seedShooter = new FlxWeapon("seed_shooter", this, SeedBullet);
    seedShooter.makePixelBullet(20, 4, 4, FlxColor.LIME);
    seedShooter.setBulletSpeed(SeedBullet.SPEED);
    seedShooter.setFireRate(200);
    seedShooter.setBulletOffset(12, 8);
    seedShooter.setBulletBounds(new FlxRect(0, 0, 2400, 2400));
    seedShooter.setBulletLifeSpan(10);

    seedTrail = new FlxTypedGroup<BouncingSeed>();
  }

  function makeTestSeedTrail():Void
  {
    for (i in 0...20)
    {
      seedTrail.add(new BouncingSeed(this.x, this.y, this, GRAVITY));
    }
    // kill all seeds initially, but keep the container alive...?
    seedTrail.kill();
    seedTrail.revive();
    //FlxG.log.add('${seedTrail.countDead()}');
  }

  override public function update():Void
  {
    if (alive)
    {
      if (shouldBeDead())
      {
        kill();
      }
      else if (!isWinning)
      {
        movement();
      }
    }
    super.update();
  }

  override public function kill():Void
  {
    this.alive = false;
    animation.play("die");
    haxe.Timer.delay(function() {
      exists = false;
    }, 1500);
  }

  override public function reset(X:Float, Y:Float):Void
  {
    super.reset(X, Y);
    velocity.set(0, 0);
    seedCount = 0;
    isShooting = false;
    isPreparingJump = false;
    isJumping = false;
    isWinning = false;
    lastVelocity.copyFrom(velocity);
    seedShooter.group.callAll("kill");

    seedTrail.callAll("destroy");
    seedTrail.clear();
    makeTestSeedTrail();
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


    if (isTouching(FlxObject.FLOOR))
    {
      if (justTouched(FlxObject.FLOOR))
      {
        isPreparingJump = false;
        isJumping = false;
      }

      if (_up && !isPreparingJump)
      {
        isPreparingJump = true;
        animation.play("jump");
        haxe.Timer.delay(jumpUp, 50);
      }
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
          useSeed();
        }
      }, 250);
    }

    // Order matters -- animation priorities.
    if (isShooting) {
      if (animation.finished)
      {
        isShooting = false;
      }
    }
    else if (isJumping)
    {
      // just chill
    }
    else if (isPreparingJump)
    {
      // just chill
    }
    else if (_left || _right)
    {
      animation.play("walk");
    }
    else
    {
      animation.play("idle");
    }
  }

  private function outOfBounds():Bool
  {
    return this.y > 2400;
  }

  private function useSeed()
  {
    // assert seedCount > 0
    --seedCount;
    seedTrail.getFirstAlive().kill();
  }

  public function giveSeeds(count:Int)
  {
    seedCount += count;
    for (i in 0...count)
    {
      var seed = seedTrail.getFirstDead();
      seed.revive();
      seed.set_x(this.x);
      seed.set_y(this.y);
    }
  }

  public function getNumSeeds():Int
  {
    return seedCount;
  }

  public function jumpUp():Void
  {
    this.velocity.y = JUMP_SPEED;
    isJumping = true;
    isPreparingJump = false;
  }

  public function win():Void
  {
    isWinning = true;
    animation.play("win");
  }
}
