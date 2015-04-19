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

  public function new(X:Float=0, Y:Float=0, W:Int=16, H:Int=16)
  {
    super(X, Y, "decay");
    width = W;
    height = H;

    populate();
  }

  override public function update():Void
  {
    super.update();
  }

  function populate():Void
  {
    var rows:Int = Math.floor(height/16);
    var cols:Int = Math.floor(width/16);
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
    decaySprite.makeGraphic(16, 16, FlxColor.GRAY);
    return decaySprite;
  }

  override public function touchSeed(seed:FlxBullet):Void
  {
    decay();
  }

  function activated():Bool
  {
    return this.length > 1;
  }

  function decay():Void
  {
    // TODO: do something
    this.callAll("kill");
  }

}
