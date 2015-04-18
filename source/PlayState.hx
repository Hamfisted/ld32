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
  private var _levelEnd:LevelEnd;
  private var _grpSpikes:FlxTypedGroup<Spike>;
  private var _grpBullets:FlxTypedGroup<FlxBullet>;
  private var _grpSeedPickups:FlxTypedGroup<SeedPickup>;
  private var _grpBeavers:FlxTypedGroup<Beaver>;

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

    _grpBeavers = new FlxTypedGroup<Beaver>();

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
    FlxG.collide(_mWalls, _grpBullets, CollisionLogic.WallBullet);
    FlxG.collide(_mWalls, _grpBeavers, CollisionLogic.WallBeaver);
    FlxG.collide(_player, _grpSpikes, CollisionLogic.PlayerSpike);
    FlxG.overlap(_player, _grpSeedPickups, CollisionLogic.PlayerSeed);
    FlxG.collide(_player, _levelEnd, winLevel);

    FlxG.collide(_player, _grpBeavers, CollisionLogic.PlayerBeaver);
    FlxG.overlap(_grpBullets, _grpBeavers, CollisionLogic.BulletBeaver);

    _hud.updateHUD(_player);

    if (!_player.alive) {
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
    _mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
    _mWalls.setTileProperties(1, FlxObject.ANY, null, 31);
    _mWalls.setTileProperties(32, FlxObject.NONE, null, 32);
    add(_mWalls);

    _map.loadEntities(placeEntities, "entities");

    add(_grpSpikes);
    add(_grpSeedPickups);
    add(_levelEnd);
    add(_player);
    add(_grpBullets);
    add(_grpBeavers);

    FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
  }

  private function cleanupStage():Void
  {
    // Remove objects from state
    remove(_mWalls);
    remove(_grpSpikes);
    remove(_grpSeedPickups);
    remove(_player);
    remove(_grpBullets);
    remove(_levelEnd);
    remove(_grpBeavers);
    // Destroy objects as necessary
    FlxDestroyUtil.destroy(_mWalls);
    _grpSpikes.callAll("destroy");
    _grpSpikes.clear();
    _grpSeedPickups.callAll("destroy");
    _grpSeedPickups.clear();
    _grpBeavers.callAll("destroy");
    _grpBeavers.clear();
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
      _grpBeavers.add(new Beaver(x, y));
    }
  }

}
