package;

import flixel.FlxSprite;

class PatchChildSprite extends FlxSprite
{
  public var parent:Patch;

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

}
