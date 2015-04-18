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

  var _patchSprite:PatchChildSprite;

  public function new(X:Float=0, Y:Float=0, PType:String)
  {
    // super(X, Y);
    super();

    ptype = PType;

    _patchSprite = new PatchChildSprite(X, Y, this);
    _patchSprite.solid = true;
    _patchSprite.immovable = true;

    this.add(_patchSprite);
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
