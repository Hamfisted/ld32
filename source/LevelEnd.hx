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

    solid = true;
    immovable = true;

    loadGraphic(AssetPaths.warp_portal__png, false, 32, 32);
    setSize(16, 24);
    offset.set(8, 8);
  }

  override public function update():Void
  {
    super.update();
  }

}
