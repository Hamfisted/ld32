package;

import flixel.util.FlxSave;
import flixel.group.FlxTypedGroup;

/**
 * Handy, pre-built Registry class that can be used to store
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
  // Time is ticking. Fixme later
  public static var player:Player;
  public static var grpSeedPickups:FlxTypedGroup<SeedPickup>;
  public static var GRAVITY:Int = 800;
  /**
   * Generic levels Array that can be used for cross-state stuff.
   * Example usage: Storing the levels of a platformer.
   */
  // public static var levels:Array<Dynamic> = [];
  public static var levels:Array<Dynamic> = Utils.getLevelPaths();
  /**
   * Generic level variable that can be used for cross-state stuff.
   * Example usage: Storing the current level number.
   */
  public static var level:Int = 0;
  /**
   * Generic scores Array that can be used for cross-state stuff.
   * Example usage: Storing the scores for level.
   */
  public static var scores:Array<Dynamic> = [];
  /**
   * Generic score variable that can be used for cross-state stuff.
   * Example usage: Storing the current score.
   */
  public static var score:Int = 0;
  /**
   * Generic bucket for storing different FlxSaves.
   * Especially useful for setting up multiple save slots.
   */
  public static var saves:Array<FlxSave> = [];
}
