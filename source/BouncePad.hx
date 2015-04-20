package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class BouncePad extends FlxSprite
{
  var _destPoint:FlxPoint;
  var _airTime:Float;

  public function new(X:Float, Y:Float, destX:Float, destY:Float, airTime:Float)
  {
    super(X, Y+2);
    _destPoint = new FlxPoint(destX, destY);
    _airTime = airTime;
    immovable = true;

    loadGraphic(AssetPaths.mushroom_sprite__png, true, 32, 16);
    setSize(32, 14);
    offset.set(0, 2);

    animation.add("bounce", [1, 2, 3, 0], 8, false);
  }

  override public function update():Void
  {
    super.update();
  }

  public function bounceObject(obj:FlxObject)
  {
    obj.drag.x = 0.0;
    BounceMovement.BounceTo(obj, _destPoint, obj.acceleration.y, _airTime);
    animation.play("bounce", true);
  }

}
