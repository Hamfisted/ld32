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
    trace("bullet wall?");
    bullet.kill();
  }

  public static function WallPlayer(wall:FlxTilemap, player:Player)
  {
    player.setCanJump(player.isTouching(flixel.FlxObject.FLOOR) ||
                      FlxMath.isDistanceToPointWithin(player, wall.getMidpoint(), 5.0));
    // TODO: fix the distance check, cause it doesn't work
    //FlxG.log.add('distance: ${FlxMath.distanceToPoint(player, wall.getMidpoint())}');
  }

  public static function BulletPatch(bullet:FlxBullet, patch:Patch)
  {
    trace("bulletpatch");
    bullet.kill();
    patch.touchSeed(bullet);
  }
}
