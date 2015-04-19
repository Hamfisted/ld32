package;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.util.FlxDestroyUtil;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.system.debug.LogStyle;
import flixel.addons.weapon.FlxBullet;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
  private var _hud:HUD;
  private var _player:Player;
  private var _map:FlxOgmoLoader;
  private var _mWalls:FlxTilemap;
  private var _mBackground1:FlxTilemap;
  private var _mBackground2:FlxTilemap;
  private var _levelEnd:LevelEnd;
  private var _grpSpikes:FlxTypedGroup<Spike>;
  private var _grpBullets:FlxTypedGroup<FlxBullet>;
  private var _grpSeedPickups:FlxTypedGroup<SeedPickup>;
  private var _grpBeavers:FlxTypedGroup<Beaver>;
  private var _grpPatches:FlxTypedGroup<Patch>;
  private var _grpBouncePads:FlxTypedGroup<BouncePad>;

  /**
   * Function that is called up when to state is created to set it up.
   */
  override public function create():Void
  {
    FlxG.console.addCommand(["map", "level", "changelevel"], loadLevel, "loadLevel", 1);
    FlxG.console.addCommand(["winlevel"], winLevel, "winLevel");

    _grpSpikes = new FlxTypedGroup<Spike>();
    _grpSeedPickups = new FlxTypedGroup<SeedPickup>();
    _levelEnd = new LevelEnd();
    _player = new Player();
    _grpBullets = _player.seedShooter.group;

    _grpBouncePads = new FlxTypedGroup<BouncePad>();
    _grpBeavers = new FlxTypedGroup<Beaver>();
    _grpPatches = new FlxTypedGroup<Patch>();

    loadLevel(Reg.level);

    _hud = new HUD();
    add(_hud);

    super.create();
  }

  /**
   * Function that is called when this state is destroyed - you might want to
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void
  {
    super.destroy();
  }

  /**
   * Function that is called once every frame.
   */
  override public function update():Void
  {
    super.update();
    /*
      "Always collide the map with objects, not the other way around."
      http://api.haxeflixel.com/flixel/addons/editors/ogmo/FlxOgmoLoader.html
    */
    FlxG.collide(_mWalls, _player);
    FlxG.collide(_mWalls, _player.seedTrail);
    FlxG.collide(_mWalls, _grpBullets, CollisionLogic.WallBullet);
    FlxG.collide(_mWalls, _grpBeavers);

    FlxG.collide(_player, _grpSpikes, CollisionLogic.PlayerSpike);
    FlxG.overlap(_player, _grpSeedPickups, CollisionLogic.PlayerSeed);
    FlxG.collide(_player, _levelEnd, winLevel);
    FlxG.collide(_player, _grpBeavers, CollisionLogic.PlayerBeaver);

    FlxG.overlap(_grpBullets, _grpBeavers, CollisionLogic.BulletBeaver);

    FlxG.collide(_grpBouncePads, _player, CollisionLogic.BounceObject);
    FlxG.collide(_grpBouncePads, _grpBeavers, CollisionLogic.BounceObject);
    FlxG.collide(_grpBouncePads, _player.seedTrail);

    // Patches
    FlxG.collide(_player, _grpPatches);
    FlxG.collide(_grpBeavers, _grpPatches);
    FlxG.overlap(_grpBullets, _grpPatches, CollisionLogic.BulletPatch);
    FlxG.collide(_grpPatches, _player.seedTrail);

    _hud.updateHUD(_player);

    if (!_player.alive || FlxG.keys.anyPressed(["R"])) {
      loadLevel(Reg.level);
    }
  }

  public function winLevel(?P:Player, ?W:LevelEnd):Void
  {
    Reg.level++;
    loadLevel(Reg.level);
  }

  public function loadLevel(i:Int):Void
  {
    var levelPath = Reg.levels[i];
    if (levelPath == null)
    {
      FlxG.log.error('Cannot load level index: ${i}');
      return;
    }
    else
    {
      FlxG.log.add('Loading level: ${levelPath}');
    }

    Reg.level = i;
    cleanupStage();

    _map = new FlxOgmoLoader(levelPath);
    // back-background
    _mBackground2 = _map.loadTilemap(AssetPaths.bg__png, 51, 51, "bg2");
    _mBackground2.setTileProperties(1, FlxObject.NONE, null, 3);
    _mBackground2.scrollFactor.set(0.2, 1);
    add(_mBackground2);
    // fore-background
    _mBackground1 = _map.loadTilemap(AssetPaths.bg__png, 51, 51, "bg1");
    _mBackground1.setTileProperties(1, FlxObject.NONE, null, 3);
    _mBackground1.scrollFactor.set(0.8, 1);
    add(_mBackground1);
    // walls
    _mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
    _mWalls.setTileProperties(1, FlxObject.ANY, null, 31);
    _mWalls.setTileProperties(32, FlxObject.NONE, null, 32);
    add(_mWalls);

    _map.loadEntities(placeEntities, "entities");

    // Order matters
    add(_grpSpikes);
    add(_grpSeedPickups);
    add(_levelEnd);
    add(_player);
    add(_player.seedTrail);
    add(_grpBeavers);
    add(_grpPatches);
    add(_grpBullets);
    add(_grpBouncePads);

    FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
  }

  private function cleanupStage():Void
  {
    var spriteGroups:Array<Dynamic> = [_grpSpikes, _grpSeedPickups, _grpBeavers, _grpPatches, _grpBouncePads];
    // Remove objects from state
    remove(_mBackground2);
    remove(_mBackground1);
    remove(_mWalls);
    remove(_player);
    remove(_player.seedTrail);
    // Bullets are managed by FlxWeapon, don't destroy them here.
    remove(_grpBullets);
    remove(_levelEnd);
    // Remove groups & destroy nested objects as necessary
    FlxDestroyUtil.destroy(_mBackground2);
    FlxDestroyUtil.destroy(_mBackground1);
    FlxDestroyUtil.destroy(_mWalls);
    for (group in spriteGroups)
    {
      remove(group);
      group.callAll("destroy");
      group.clear();
    }
  }

  private function placeEntities(entityName:String, entityData:Xml):Void
  {
    var x:Int = Std.parseInt(entityData.get("x"));
    var y:Int = Std.parseInt(entityData.get("y"));
    if (entityName == "player")
    {
      _player.reset(x, y);
    }
    else if (entityName == "spike")
    {
      _grpSpikes.add(new Spike(x, y));
    }
    else if (entityName == "level_end")
    {
      _levelEnd.reset(x, y);
    }
    else if (entityName == "seed_pickup")
    {
      _grpSeedPickups.add(new SeedPickup(x, y));
    }
    else if (entityName == "beaver")
    {
      _grpBeavers.add(new Beaver(x, y,
        Std.parseFloat(entityData.get("jumpAirTime")),
        Std.parseFloat(entityData.get("jumpDist"))));
    }
    else if (entityName == "grow_patch" || entityName == "grow_patch_horizontal")
    {
      _grpPatches.add(new GrowPatch(x, y, entityData.get("direction")));
    }
    else if (entityName == "bounce_pad")
    {
      _grpBouncePads.add(new BouncePad(x, y,
        Std.parseFloat(entityData.get("dest_x")),
        Std.parseFloat(entityData.get("dest_y")),
        Std.parseFloat(entityData.get("air_time"))));
    }
    else if (entityName == "decay_patch")
    {
      _grpPatches.add(
        new DecayPatch(x, y,
          Std.parseInt(entityData.get("width")), Std.parseInt(entityData.get("height"))
        )
      );
    }
  }

}
