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
  public var direction:String;
  var _patchSprite:PatchChildSprite;

  public function new(X:Float=0, Y:Float=0, Direction:String="up")
  {
    super(X, Y, "grow");
    direction = Direction;

    // todo: add real sprite
    _patchSprite = new PatchChildSprite(X, Y, this);
    _patchSprite.makeGraphic(16, 16, FlxColor.BROWN);
    this.add(_patchSprite);
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
    if (direction == "up" || direction == "down")
    {
      segment.makeGraphic(16, 32, FlxColor.BROWN);
    }
    else
    {
      segment.makeGraphic(32, 16, FlxColor.BROWN);
    }
    segment.updateHitbox();
    return segment;
  }

  function activated():Bool
  {
    return this.length > 1;
  }

  function grow():Void
  {
    var root:PatchChildSprite = _patchSprite;
    var lastSegment:PatchChildSprite = this.members[this.length-1];
    var segment:PatchChildSprite = makeTreeSegment();
    segment.x = lastSegment.x;
    segment.y = lastSegment.y;

    if (direction == "up")
    {
      segment.y -= 32;
    }
    else if (direction == "down")
    {
      segment.flipX = true;
      segment.y += (root == lastSegment)? 16 : 32;
    }
    else if (direction == "right")
    {
      segment.x += (root == lastSegment)? 16 : 32;
    }
    else if (direction == "left")
    {
      segment.x -= 32;
    }

    this.add(segment);
  }

}
