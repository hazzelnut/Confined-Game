/**
 * Advanced Weapon System
 * ---------------------
 * VERSION: 1.1.2
 * DATE: 8/27/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package com.freeactionscript.weaponsystem 
{
	import com.freeactionscript.utils.MathTools;
	import com.freeactionscript.weaponsystem.components.AbstractWeapon;
	import com.freeactionscript.weaponsystem.components.Bullet;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class WeaponManager 
	{
		// vars
		private var _container:DisplayObjectContainer;
		private var _weapons:Array = [];
		private var _bullets:Array = [];
		private var _solidObjects:Array = [];
		
		// shared vars
		private var _tempWeapon:AbstractWeapon;
		private var _tempBullet:Bullet;
		private var _tempSolidObject:DisplayObjectContainer;
		
		//////////////////////////////////////
		// Constructor
		//////////////////////////////////////
		
		public function WeaponManager(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		//////////////////////////////////////
		// Public API
		//////////////////////////////////////
		
		/**
		 * Use this method to add a weapon to the weapon manager
		 * @param	weapon	Takes Weapon class as argument
		 */
		public function addWeapon(weapon:AbstractWeapon):void
		{
			container.addChild(weapon);
			
			weapon.createDisplay();
			
			_weapons[_weapons.length] = weapon;
		}
		
		/**
		 * Use this method to remove a weapon from the weapon manager
		 * @param	weapon	Takes Weapon class as argument
		 */
		public function removeWeapon(weapon:AbstractWeapon):void
		{
			weapon.destroy();
			_weapons.splice(_weapons.indexOf(weapon), 1);
			container.removeChild(weapon);
		}
		
		/**
		 * Use this method to fire all weapons
		 */
		public function fireWeapons():void
		{
			var i:uint;
			var l:int = _weapons.length;
			
			// loop thru array
			for (i = 0; i < l; i++)
			{
				// save a reference to current object
				tempWeapon = _weapons[i];
				
				// update
				tempWeapon.isFiring = true;
			}
		}
		
		/**
		 * Use this method to fire all weapons
		 */
		public function stopWeapons():void
		{
			var i:uint;
			var l:int = _weapons.length;
			
			// loop thru array
			for (i = 0; i < l; i++)
			{
				// save a reference to current object
				tempWeapon = _weapons[i];
				
				// update
				tempWeapon.isFiring = false;
			}
		}
		
		/**
		 * Use this method to add a bullet to the weapon manager
		 * @param	weapon	Takes Bullet as argument
		 */
		public function addBullet(bullet:DisplayObjectContainer):void
		{
			container.addChild(bullet);
			
			_bullets[_bullets.length] = bullet;
		}
		
		/**
		 * Use this method to remove a bullet from the weapon manager
		 * @param	weapon	Takes Bullet as argument
		 */
		public function removeBullet(bullet:DisplayObjectContainer):void
		{
			Bullet(tempBullet).destroy();
			_bullets.splice(_bullets.indexOf(bullet), 1);
			container.removeChild(bullet);
		}
		
		/**
		 * Use this method to add a solid object to _solidObjects array
		 * @param	solidObject	Takes DisplayObjectContainer
		 */
		public function addSolidObject(solidObject:DisplayObjectContainer):void
		{
			_solidObjects[_solidObjects.length] = solidObject;
		}
		
		/**
		 * Use this method to remove a solid object from _solidObjects array
		 * @param	solidObject	Takes DisplayObjectContainer
		 */
		public function removeSolidObject(solidObject:DisplayObjectContainer):void
		{
			_solidObjects.splice(_solidObjects.indexOf(solidObject), 1);
			container.removeChild(solidObject);
		}
		
		/**
		 * Checks for collisions between points and objects in _solidObjects
		 * @return	Collision boolean
		 */
		public function checkCollisionPoint(testX:Number, testY:Number):Boolean
		{
			// if nothing to check against, abort
			if (_solidObjects.length == 0) return false;
			
			var i:uint;
			var l:int =  _solidObjects.length;
			
			// loop thru _solidObjects array
			for (i = 0; i < l; i++)
			{
				// save a reference to current object
				tempSolidObject = _solidObjects[i];
				
				// do a hit test
				if (tempSolidObject.hitTestPoint(testX, testY, true))
				{
					return true;
					
					// stop loop
					break;
				}
			}
			return false;
		}
		
		/**
		 * Checks for collisions between bounding box of objects in _solidObjects
		 * @return	Collision boolean
		 */
		public function checkCollisionBox(object:DisplayObjectContainer):Boolean
		{
			// if nothing to check against, abort
			if (_solidObjects.length == 0) return false;
			
			var i:uint;
			var l:int =  _solidObjects.length;
			
			// loop thru _solidObjects array
			for (i = 0; i < l; i++)
			{
				// save a reference to current object
				tempSolidObject = _solidObjects[i];
				
				// do a hit test
				if (tempSolidObject.hitTestObject(object))
				{
					return true;
					
					// stop loop
					break;
				}
			}
			return false;
		}
		
		/**
		 * Use this method to update the weapon manager
		 */
		public function update():void
		{
			updateWeapons();
			updateBullets();
		}
		
		////////////////////
		// Private Methods
		////////////////////
		
		/**
		 * Use this method to update all weapons
		 */
		private function updateWeapons():void
		{
			var i:uint;
			var l:int = _weapons.length;
			
			// loop thru array
			for (i = 0; i < l; i++)
			{
				// save a reference to current object
				tempWeapon = _weapons[i];
				
				// update
				tempWeapon.update();
			}
		}
		
		/**
		 * Updates bullets
		 */
		private function updateBullets():void
		{
			var i:uint;
			
			// loop thru _bullets array
			for (i = 0; i < _bullets.length; i++)
			{
				// save a reference to current bullet
				tempBullet = _bullets[i];
				
				tempBullet.update();
				
				// check if bullet is expired
				if (tempBullet.expired)
				{
					removeBullet(tempBullet);
				}
				
				// first, a basic collision test
				if (checkCollisionBox(tempBullet))
				{
					// then, complex collision test
					if (checkCollisionPoint(tempBullet.x, tempBullet.y))
					{
						removeBullet(tempBullet);
					}
				}
			}
		}
		
		////////////////////
		// Getters & Setters
		////////////////////
		
		public function get container():DisplayObjectContainer 
		{
			return _container;
		}
		
		public function set container(value:DisplayObjectContainer):void 
		{
			_container = value;
		}
		
		public function get tempWeapon():AbstractWeapon 
		{
			return _tempWeapon;
		}
		
		public function set tempWeapon(value:AbstractWeapon):void 
		{
			_tempWeapon = value;
		}
		
		public function get tempBullet():Bullet 
		{
			return _tempBullet;
		}
		
		public function set tempBullet(value:Bullet):void 
		{
			_tempBullet = value;
		}
		
		public function get tempSolidObject():DisplayObjectContainer 
		{
			return _tempSolidObject;
		}
		
		public function set tempSolidObject(value:DisplayObjectContainer):void 
		{
			_tempSolidObject = value;
		}
		
		public function getBulletsArray():Array 
		{
			return _bullets;
		}
		
		public function getSolidObjectsArray():Array 
		{
			return _solidObjects;
		}
		
		public function getWeaponsArray():Array 
		{
			return _weapons;
		}
		
	}

}