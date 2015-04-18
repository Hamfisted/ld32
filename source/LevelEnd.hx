package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class LevelEnd extends FlxSprite
{
  public function new(X:Float=0, Y:Float=0)
  {
    super(X, Y);

    makeGraphic(16, 16, FlxColor.YELLOW);
    solid = true;
    immovable = true;
  }

  override public function update():Void
  {
    super.update();
  }

}
