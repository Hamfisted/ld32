package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class SeedPickup extends FlxSprite
{
  var _nextJumpMilli:Int;

  public function new(X:Float=0, Y:Float=0)
  {
    super(X+2, Y);
    loadGraphic(AssetPaths.seed__png, false);
    this.acceleration.y = Reg.GRAVITY;

    _nextJumpMilli = FlxG.game.ticks + Std.random(1000);
  }

  override public function update():Void
  {
    if (_nextJumpMilli < FlxG.game.ticks && isTouching(FlxObject.FLOOR))
    {
      _nextJumpMilli = FlxG.game.ticks + Std.random(1000) + 500;
      var jumpTime:Float = (Std.random(2) == 0) ? 0.15 : 0.25;
      BounceMovement.BounceTo(this, this.getMidpoint(), this.acceleration.y, jumpTime);
      this.velocity.x = 0.0;
    }
    super.update();
  }

}
