package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxBullet;

class Patch extends FlxTypedGroup<PatchChildSprite>
{
  public var ptype:String;

  var x:Float;
  var y:Float;

  public function new(X:Float=0, Y:Float=0, PType:String)
  {
    super();
    x = X;
    y = Y;

    ptype = PType;
  }

  override public function update():Void
  {
    super.update();
  }

  public function touchSeed(seed:FlxBullet):Void
  {
    throw "not implemented";
  }

}
