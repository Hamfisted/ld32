package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.weapon.FlxBullet;
import flixel.tile.FlxTilemap;
import flixel.util.FlxMath;

/**
 * ...
 * @author ...
 */
class CollisionLogic
{
  public static function PlayerBeaver(player:Player, beaver:Beaver)
  {
    if (beaver.isTouching(FlxObject.UP))
    {
      beaver.kill();
      player.jumpUp();
    }
    else
    {
      player.kill();
    }
  }

  public static function BounceObject(bouncePad:BouncePad, obj:FlxObject)
  {
    if (bouncePad.isTouching(FlxObject.UP))
    {
      bouncePad.bounceObject(obj);
    }
  }

  public static function PlayerSeed(player:Player, seed:SeedPickup)
  {
    seed.kill();
    player.giveSeeds(1);
  }

  public static function PlayerSpike(player:Player, spike:Spike)
  {
    player.kill();
  }

  public static function BulletBeaver(bullet:SeedBullet, beaver:Beaver)
  {
    if (bullet.exists && !bullet.isReturning)
    {
      beaver.kill();
      bullet.returnToPlayer();
    }
  }

  public static function WallBullet(wall:FlxTilemap, bullet:SeedBullet)
  {
    if (bullet.exists && !bullet.isReturning)
    {
      bullet.returnToPlayer();
    }
  }

  public static function PlayerBullet(player:Player, bullet:SeedBullet)
  {
    if (bullet.isReturning)
    {
      bullet.kill();
      player.giveSeeds(1);
    }
  }

  public static function BulletPatch(bullet:SeedBullet, child:PatchChildSprite)
  {
    //   A bullet can hit multiple things during the same frame,
    // so let's check if it already got killed this frame.
    if (bullet.exists && !bullet.isReturning)
    {
      child.parent.touchSeed(bullet, child);
      bullet.touchPatch();
    }
  }
}
