package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxBullet;

class GrowPatch extends Patch
{
  public var direction:String = "up";

  public function new(X:Float=0, Y:Float=0, Direction:String)
  {
    super(X, Y, "grow");

    // todo: add real sprite
    _patchSprite.makeGraphic(16, 16, FlxColor.BROWN);
  }

  override public function update():Void
  {
    super.update();
  }

  override public function touchSeed(seed:FlxBullet):Void
  {
    grow();
  }

  function makeTreeSegment():PatchChildSprite
  {
    var segment = new PatchChildSprite(x, y, this);
    segment.makeGraphic(16, 32, FlxColor.BROWN);
    segment.solid = true;
    segment.immovable = true;
    return segment;
  }

  function grow():Void
  {
    var segment:PatchChildSprite = makeTreeSegment();
    // TODO: do directional stuff
    segment.y = this.members[this.length-1].y - 32;
    this.add(segment);
  }

}
