package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{

  private var _sprBack:FlxSprite;
  private var _txtSeedCount:FlxText;

  public function new()
  {
    super();
    _sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
    _sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);

    _txtSeedCount = new FlxText(0, 2, 0, "0", 8);
    _txtSeedCount.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
    _txtSeedCount.x = FlxG.width - 50;

    add(_sprBack);
    add(_txtSeedCount);

    forEach(function(spr:FlxSprite) {
      spr.scrollFactor.set();
    });
  }

  public override function update():Void
  {
    super.update();
  }

  public function updateHUD(P:Player):Void
  {
    _txtSeedCount.text = "Seeds: " + Std.string(P.getNumSeeds());
  }
}
