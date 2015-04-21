package;

import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.util.FlxDestroyUtil;

class PatchChildSprite extends FlxSprite
{
  public var parent:Patch;
  public var shakeTween:FlxTween;
  var isShaking:Bool = false;

  public function new(X:Float=0, Y:Float=0, Parent:Patch)
  {
    super(X, Y);
    parent = Parent;
    this.solid = true;
    this.immovable = true;
  }

  override public function update():Void
  {
    super.update();
  }

  override public function destroy():Void
  {
    super.destroy();
    if (shakeTween != null)
    {
      shakeTween.cancel();
    }
    FlxDestroyUtil.destroy(shakeTween);
  }

  // only used for decay sprite. fixme later
  public function shake():Void
  {
    if (isShaking)
    {
      return;
    }
    isShaking = true;
    solid = false;
    var shakeX = 0.5 + FlxRandom.float()*2;
    offset.x -= shakeX;
    shakeTween = FlxTween.tween(offset, {x: shakeX}, 0.04, {type: FlxTween.PINGPONG});
  }

}
