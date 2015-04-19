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

  public static function BulletBeaver(bullet:FlxBullet, beaver:Beaver)
  {
    bullet.kill();
    beaver.kill();
  }

  public static function WallBeaver(wall:FlxTilemap, beaver:Beaver)
  {
    if (beaver.isTouching(FlxObject.WALL))
    {
      beaver.changeDirection();
    }
  }

  public static function WallBullet(wall:FlxTilemap, bullet:FlxBullet)
  {
    bullet.kill();
  }

  public static function BulletPatch(bullet:FlxBullet, child:PatchChildSprite)
  {
    //   A bullet can hit multiple things during the same frame,
    // so let's check if it already got killed this frame.
    if (bullet.exists)
    {
      child.parent.touchSeed(bullet);
      bullet.kill();
    }
  }
}
