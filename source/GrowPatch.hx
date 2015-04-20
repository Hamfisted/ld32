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
  var isHorizontal:Bool = false;

  public function new(X:Float=0, Y:Float=0, Direction:String="up")
  {
    super(X, Y, "grow");
    direction = Direction;

    // Sanity check. TODO: use enum instead
    if (direction != "up" && direction != "down" && direction != "left" && direction != "right")
    {
      trace("grow patch direction is invalid");
    }

    _patchSprite = new PatchChildSprite(X, Y, this);

    if (direction == "left" || direction == "right")
    {
      isHorizontal = true;
      // swap heights and widths
      var t:Int;
      t = patch_width;
      patch_width = patch_height;
      patch_height = t;
      t = segment_width;
      segment_width = segment_height;
      segment_height = t;

      _patchSprite.loadGraphic(AssetPaths.grow_patch_dirt_horizontal__png, false, patch_width, patch_height);
    }
    else
    {
      _patchSprite.loadGraphic(AssetPaths.grow_patch_dirt__png, false, patch_width, patch_height);
    }

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
    // our sprite extends down by 5px to look better
    if (isHorizontal)
    {
      segment.loadGraphic(AssetPaths.grow_patch_tree_extended_horizontal__png, true, segment_width + 5, segment_height);
      segment.setSize(segment_width, segment_height);
      if (direction == "right")
      {
        segment.offset.set(5, 0);
      }
    }
    else
    {
      segment.loadGraphic(AssetPaths.grow_patch_tree_extended__png, true, segment_width, segment_height + 5);
      segment.setSize(segment_width, segment_height);
    }
    segment.animation.add("grow", [0, 1, 2, 3, 4, 5, 6, 7], 14, false);
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
        segment.y += (root == lastSegment)? patch_height : segment_height;
        segment.flipY = true;
      }
    }
    else
    {
      segment.y = root.y + 0.5 *(patch_height - segment_height);
      if (direction == "right")
      {
        segment.x += (root == lastSegment)? patch_width : segment_width;
        segment.flipX = true;
      }
      else if (direction == "left")
      {
        segment.x -= segment_width;
      }
    }

    this.add(segment);

    segment.animation.play("grow");
  }

  function shrink():Void
  {
    if (!activated())
    {
      return;
    }

    // remove the last segment
    var segment = this.members[this.members.length-1];
    // Fixme
    // Drop a seedpickup in the segment's place
    var seed:SeedPickup = new SeedPickup(segment.x, segment.y);
    seed.acceleration.y = Reg.GRAVITY;

    remove(segment, true);
    segment.kill();
    segment.destroy();

    Reg.grpSeedPickups.add(seed);
  }

}
