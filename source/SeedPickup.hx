package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class SeedPickup extends FlxSprite
{
  public function new(X:Float=0, Y:Float=0)
  {
    super(X+4, Y);
    makeGraphic(8, 8, FlxColor.LIME);
  }

  override public function update():Void
  {
    super.update();
  }

}
