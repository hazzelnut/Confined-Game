/**
 * Advanced Weapon System
 * Main.fla Document Class
 * ---------------------
 * VERSION: 1.1.2
 * DATE: 9/15/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package  
{
	import com.freeactionscript.weaponsystem.WeaponManager;
	import com.freeactionscript.weaponsystem.weapons.LaserDual;
	import com.freeactionscript.weaponsystem.weapons.LaserSingle;
	import com.freeactionscript.weaponsystem.weapons.ProjectileQuad;
	import com.freeactionscript.weaponsystem.weapons.ProjectileSingle;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Main extends MovieClip
	{
		// vars
		private var _weaponManager:WeaponManager;
		
		/**
		 * Document Class
		 */
		public function Main() 
		{
			// add basic event listeners
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			
			// create new instance of WeaponManager, pass a reference to stage
			_weaponManager = new WeaponManager(this);
			
			// create weapons: AbstractWeapon(id_string, weapon_manager_instance, x, y, rotation)
			var singleTurret:ProjectileSingle = new ProjectileSingle("gun 1", _weaponManager, 100, 275, 90); // 1 turret projectile gun
			var quadTurrel:ProjectileQuad = new ProjectileQuad("gun 2", _weaponManager, 225, 275, 90); // 4 turret projectile gun
			var laserSingle:LaserSingle = new LaserSingle("gun 3", _weaponManager, 350, 275, 90); // 1 turret laser gun
			var laserDual:LaserDual = new LaserDual("gun 4", _weaponManager, 400, 275, 90); // 2 turret laser gun
			
			// add created weapons to weapon manager
			_weaponManager.addWeapon(singleTurret);
			_weaponManager.addWeapon(quadTurrel);
			_weaponManager.addWeapon(laserSingle);
			_weaponManager.addWeapon(laserDual);
			
			// add solid objects to WeaponManager
			_weaponManager.addSolidObject(wall01);
			_weaponManager.addSolidObject(wall02);
			_weaponManager.addSolidObject(wall03);
			_weaponManager.addSolidObject(wall04);
		}
		
		//////////////////////////////////////
		// Event Handlers
		//////////////////////////////////////
		
		/**
		 * Enter Frame handler
		 * @param	event	Uses Event
		 */
		private function enterFrameHandler(event:Event):void
		{
			_weaponManager.update();
			
			bulletsTxt.text = String(_weaponManager.getBulletsArray().length);
		}
		
		/**
		 * Mouse Down handler
		 * @param	e	Uses MouseEvent
		 */
		private function onMouseDownHandler(event:MouseEvent):void 
		{
			_weaponManager.fireWeapons();
		}
		
		/**
		 * Mouse Up handler
		 * @param	e	Uses MouseEvent
		 */
		private function onMouseUpHandler(event:MouseEvent):void 
		{
			_weaponManager.stopWeapons();
		}
		
	}
}