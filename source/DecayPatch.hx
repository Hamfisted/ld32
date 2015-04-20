package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxBullet;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxRandom;

class DecayPatch extends Patch
{
  var width:Int;
  var height:Int;
  var rows:Int;
  var cols:Int;
  var startedDecaying:Bool = false;

  public function new(X:Float=0, Y:Float=0, W:Int=16, H:Int=16)
  {
    super(X, Y, "decay");
    width = W;
    height = H;
    rows = Math.floor(height/16);
    cols = Math.floor(width/16);
    populate();
  }

  override public function update():Void
  {
    super.update();
  }

  function populate():Void
  {
    for (m in 0...rows)
    {
      for (n in 0...cols)
      {
        this.add(makeDecaySprite(n*16 + this.x, m*16 + this.y));
      }
    }
  }

  function makeDecaySprite(X:Float, Y:Float):PatchChildSprite
  {
    var decaySprite = new PatchChildSprite(X, Y, this);
    decaySprite.loadGraphic(AssetPaths.stone16__png, false, 16, 16);
    return decaySprite;
  }

  override public function touchSeed(seed:FlxBullet, child:PatchChildSprite):Void
  {
    var m:Int = Math.floor((child.y - this.y)/16);
    var n:Int = Math.floor((child.x - this.x)/16);
    decay(m, n);
  }

  function indexOf(m:Int, n:Int):Int
  {
    return m*cols + n;
  }

  function activated():Bool
  {
    return this.length > 1;
  }

  function decay(m:Int, n:Int):Void
  {
    var index:Int = indexOf(m, n);
    var block:PatchChildSprite = members[index];
    if (!block.alive)
    {
      return;
    }

    if (!startedDecaying)
    {
      startedDecaying = true;
    }

    // block.kill();
    block.alive = false;
    // blockDecayFX(block);
    haxe.Timer.delay(function() { blockDecayFX(block); }, Math.floor(FlxRandom.float()*50));

    var neighbors:Array<Array<Int>> = [
      [m, n+1],
      [m, n-1],
      [m+1, n],
      [m+1, n+1],
      [m+1, n-1],
      [m-1, n],
      [m-1, n+1],
      [m-1, n-1],
    ];

    // this is probably horrible
    for (nb in neighbors)
    {
      // out of bounds check
      if (nb[0] < 0 || nb[0] >= rows || nb[1] < 0 || nb[1] >= cols)
      {
        continue;
      }
      // make the neighbors start shaking
      members[indexOf(nb[0], nb[1])].shake();
      // trigger decay on neighbors after a while
      haxe.Timer.delay(function() { decay(nb[0], nb[1]); }, 300);
    }

  }

  function blockDecayFX(block:PatchChildSprite):Void
  {
    var fadeTween:FlxTween;

    function completeTween(tween: FlxTween):Void {
      block.kill();
    }
    // fadeout
    fadeTween = FlxTween.tween(block, {alpha: 0}, 0.3, {complete: completeTween, startDelay: 0.3, ease: FlxEase.quadIn});

    // stop shaking after a while
    haxe.Timer.delay(function() {
      block.shakeTween.cancel();
    }, 100);

    // fall
    block.velocity.x = FlxRandom.floatRanged(-80, 80);
    block.acceleration.y = Reg.GRAVITY;
    block.solid = false;
  }

}
