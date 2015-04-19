package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.weapon.FlxWeapon;
import flixel.addons.weapon.FlxBullet;

class SeedBullet extends FlxBullet
{
  public var isReturning:Bool = false;
  public static var SPEED:Int = 400;

  public function new(Weapon:FlxWeapon, WeaponID:Int)
  {
    super(Weapon, WeaponID);
  }

  override public function update():Void
  {
    super.update();
    if (isReturning)
    {
      fireAtTarget(this.x, this.y, Reg.player, SeedBullet.SPEED);
    }
  }

  override public function kill():Void
  {
    super.kill();
    isReturning = false;
  }

  public function touchPatch():Void
  {
    kill();
  }

  public function returnToPlayer():Void
  {
    isReturning = true;
  }

}
