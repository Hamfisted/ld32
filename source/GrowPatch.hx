package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxBullet;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;

class GrowPatch extends Patch
{
  public var direction:String;
  var _patchSprite:PatchChildSprite;

  // defaults for up/down
  var patch_width:Int = 32;
  var patch_height:Int = 16;
  var segment_width:Int = 18;
  var segment_height:Int = 32;

  public function new(X:Float=0, Y:Float=0, Direction:String="up")
  {
    super(X, Y, "grow");
    direction = Direction;

    // Sanity check. TODO: use enum instead
    if (direction != "up" && direction != "down" && direction != "left" && direction != "right")
    {
      trace("grow patch direction is invalid");
    }

    if (direction == "left" || direction == "right")
    {
      // swap heights and widths
      var t:Int;
      t = patch_width;
      patch_width = patch_height;
      patch_height = t;
      t = segment_width;
      segment_width = segment_height;
      segment_height = t;
    }
    // todo: add real sprite
    _patchSprite = new PatchChildSprite(X, Y, this);
    _patchSprite.makeGraphic(patch_width, patch_height, FlxColor.MAROON);
    this.add(_patchSprite);
  }

  override public function update():Void
  {
    super.update();
    // Test if any children were right-clicked
    // If so, call shrink();
    if (FlxG.mouse.justPressedRight)
    {
      var mPos:FlxPoint = FlxG.mouse.getWorldPosition();
      var rightClicked:Bool = false;
      this.forEach(function(child:PatchChildSprite):Void {
        if (child.pixelsOverlapPoint(mPos))
        {
          rightClicked = true;
        }
      });
      if (rightClicked)
      {
        shrink();
      }
    }
  }

  override public function touchSeed(seed:FlxBullet, child:PatchChildSprite):Void
  {
    grow();
  }

  function makeTreeSegment():PatchChildSprite
  {
    var segment = new PatchChildSprite(x, y, this);
    segment.makeGraphic(segment_width, segment_height, FlxColor.BROWN);
    // segment.updateHitbox();
    return segment;
  }

  function activated():Bool
  {
    return this.members.length > 1;
  }

  function grow():Void
  {
    var root:PatchChildSprite = _patchSprite;
    var lastSegment:PatchChildSprite = this.members[this.members.length-1];
    var segment:PatchChildSprite = makeTreeSegment();
    segment.x = lastSegment.x;
    segment.y = lastSegment.y;

    if (direction == "up" || direction == "down")
    {
      segment.x = root.x + 0.5 * (patch_width - segment_width);
      if (direction == "up")
      {
        segment.y -= segment_height;
      }
      else if (direction == "down")
      {
        segment.flipX = true;
        segment.y += (root == lastSegment)? patch_height : segment_height;
      }
    }
    else
    {
      segment.y = root.y + 0.5 *(patch_height - segment_height);
      if (direction == "right")
      {
        segment.x += (root == lastSegment)? patch_width : segment_width;
      }
      else if (direction == "left")
      {
        segment.x -= segment_width;
      }
    }

    this.add(segment);
  }

  function shrink():Void
  {
    if (!activated())
    {
      return;
    }

    // remove the last segment
    var segment = this.members[this.members.length-1];
    remove(segment, true);
    segment.kill();
    segment.destroy();
    Reg.player.giveSeeds(1);
  }

}
