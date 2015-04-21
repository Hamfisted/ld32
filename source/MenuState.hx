package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
  private var _btnPlay:FlxButton;
  var _title:FlxSprite;

  /**
   * Function that is called up when to state is created to set it up.
   */
  override public function create():Void
  {
    _title = new FlxSprite();
    _title.loadGraphic(AssetPaths.sir_sprout_title__png, false, 432, 243);
    add(_title);

    _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
    _btnPlay.screenCenter();
    _btnPlay.y = 200;
    add(_btnPlay);

    super.create();
  }

  /**
   * Function that is called when this state is destroyed - you might want to
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void
  {
    super.destroy();
    _btnPlay = FlxDestroyUtil.destroy(_btnPlay);
    _title = FlxDestroyUtil.destroy(_title);
  }

  /**
   * Function that is called once every frame.
   */
  override public function update():Void
  {
    super.update();
  }

  private function clickPlay():Void
  {
    FlxG.switchState(new PlayState());
  }
}
