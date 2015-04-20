package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxBullet;

class DecayPatch extends Patch
{
  var width:Int;
  var height:Int;
  var rows:Int;
  var cols:Int;

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
    // out of bounds check
    if (m < 0 || m >= rows || n < 0 || n >= cols)
    {
      return;
    }
    var index:Int = indexOf(m, n);
    var block:PatchChildSprite = members[index];
    if (!block.alive)
    {
      return;
    }

    block.kill();

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
    for (n in neighbors)
    {
      haxe.Timer.delay(function() { decay(n[0], n[1]); }, 300);
    }

  }

}
