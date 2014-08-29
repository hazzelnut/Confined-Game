/**
 * Advanced Weapon System
 * Abstract Weapon Class
 * ---------------------
 * VERSION: 1.1.2
 * DATE: 8/27/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package com.freeactionscript.weaponsystem.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	
	import com.freeactionscript.weaponsystem.WeaponManager;
	import com.freeactionscript.weaponsystem.components.Barrel;
	import com.freeactionscript.weaponsystem.components.Bullet;
	
	import com.freeactionscript.utils.MathTools;
	
	///////////////////////////
	// Abstract class. Must be subclassed and not instantiated.
	///////////////////////////
	
	public class AbstractWeapon extends Sprite 
	{
		// Weapon settings. These must be set.
		private var _id:String;
		private var _linkedBarrels:Boolean = true;
		private var _rotateSpeedMax:Number;
		private var _reloadTime:Number;
		private var _type:String;
		
		// Bullet settings. These must be set.
		private var _bulletSpread:Number;
		private var _bulletSpeed:Number;
		private var _bulletLifeTime:Number;
		private var _maxDistance:Number;
		private var _laserColor:int;
		private var _laserWidth:Number;
		private var _laserAlpha:Number;
		
		// Skins. These must be set.
		private var _tempSkin:Class;
		private var _skinGun:String;
		private var _skinBarrel:String;
		private var _skinBullet:String;
		
		////////////////////////
		
		// shared vars - do not edit
		private var _isFiring:Boolean = false;
		private var _endX:Number;
		private var _endY:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _reloadTimer:Timer;
		
		private var _manager:WeaponManager;
		private var _dx:Number;
		private var _dy:Number;
		private var _pcos:Number;
		private var _psin:Number;
		private var _rotateTo:Number;
		private var _trueRotation:Number;
		
		private var _barrelDistance:Number;
		private var _barrelRadians:Number;
		private var _weaponRadians:Number;
		private var _totalRadians:Number;
		
		private var _tempBarrel:Barrel;
		private var _tempBullet:Bullet;
		
		private var _weaponBarrels:Array = [];
		
		//////////////////////////////////////
		// Abstract Methods. Must be overriden in subclass.
		//////////////////////////////////////
		
		/**
		 * Use this to initialize the weapon
		 * @param	id	Weapon ID string
		 * @param	manager	WeaponManager class reference
		 * @param	x	Weapon starting X position
		 * @param	y	Weapon starting Y position
		 * @param	rotation	Weapon starting rotation
		 */
		public function AbstractWeapon(id:String, manager:WeaponManager, x:Number, y:Number, rotation:Number):void
		{
			// save default settings
			this.id = id;
			this.manager = manager;
			this.x = x;
			this.y = y;
			this.rotation = rotation;
		}
		
		//////////////////////////////////////
		// Public API
		//////////////////////////////////////
		
		/**
		 * Use this method to create a weapon barrel and attach it
		 * to a fixed relative position of the weapon platform
		 * @param	parentWeapon	Parent AbstractWeapon instance
		 * @param	skin	Barrel Skin (movieclip)
		 * @param	x	Relative X position of the barrel from anchor
		 * @param	y	Relative Y position of the barrel from anchor
		 * @param	length	Barrel length in pixels
		 */
		public function createBarrel(parentWeapon:AbstractWeapon, skin:DisplayObjectContainer, x:Number, y:Number, length:Number):void 
		{
			// Barrel(skin, x, y, barrelLength);
			tempBarrel = new Barrel(parentWeapon, skin, x, y, length);
			
			_barrelDistance = MathTools.getDistance(tempBarrel.relativeX, tempBarrel.relativeY);
			_barrelRadians = Math.atan2(tempBarrel.relativeY, tempBarrel.relativeX);
			
			//_weaponRadians = this.rotation * Math.PI / 180;
			_weaponRadians = this.rotation * 0.01745;
			_totalRadians = _weaponRadians + _barrelRadians;
			
			_startX = this.x + _barrelDistance * Math.cos(_totalRadians);
			_startY = this.y + _barrelDistance * Math.sin(_totalRadians);
			
			tempBarrel.x = _startX;
			tempBarrel.y = _startY;
			
			weaponBarrels[weaponBarrels.length] = tempBarrel;
		}
		
		/**
		 * This function adds all the elements to the display
		 */
		public function createDisplay():void
		{
			var i:uint;
			var l:int = _weaponBarrels.length;
			
			for (i = 0; i < l; i++)
			{
				tempBarrel = _weaponBarrels[i];
				
				manager.container.addChild(tempBarrel);
			}
		}
		
		/**
		 * This function removes all the elements from the display
		 */
		public function destroyDisplay():void
		{
			var i:uint;
			var l:int = _weaponBarrels.length;
			
			for (i = 0; i < l; i++)
			{
				tempBarrel = _weaponBarrels[i];
				
				manager.container.removeChild(tempBarrel);
			}
		}
		
		/**
		 * This method is used to update all weapon systems
		 */
		public function update():void
		{
			updateRotation();
			updateBarrels();
			fireBarrels();
		}
		
		/**
		 * Use this method when destroying a weapon
		 */
		public function destroy():void
		{
			destroyDisplay();
			
			var i:uint;
			var l:int = _weaponBarrels.length;
			
			for (i = 0; i < l; i++)
			{
				tempBarrel = _weaponBarrels[i];
				
				tempBarrel.destroy();
			}
			
			_weaponBarrels = [];
			
			// destroy timers
			reloadTimer.stop();
			reloadTimer.removeEventListener(TimerEvent.TIMER, reloadTimerHandler);
			reloadTimer = null;
		}
		
		////////////////////
		// Private Methods
		////////////////////
		
		/**
		 * This method is used to update the barrel position and rotation
		 */
		private function fireBarrels():void 
		{
			var i:uint;
			var l:int = _weaponBarrels.length;
			
			for (i = 0; i < l; i++)
			{
				tempBarrel = _weaponBarrels[i];
				
				// check if reload timer is running
				// if not, reload finished.
				if (!tempBarrel.reloadTimer.running)
				{
					if (isFiring == true)
					{
						createBullet(tempBarrel);
					}
				}
			}
		}
		
		/**
		 * This function creates a bullet object
		 * @param	barrel	Takes Barrel as argument
		 */
		private function createBullet(barrel:Barrel):void
		{
			// save a reference to barrel
			tempBarrel = barrel;
			
			// start reload timer
			tempBarrel.reloadTimer = new Timer(_reloadTime);
			tempBarrel.reloadTimer.addEventListener(TimerEvent.TIMER, reloadTimerHandler);
			tempBarrel.reloadTimer.start();
			
			// precalculate the cos & sine
			//_pcos = Math.cos(tempBarrel.rotation * Math.PI / 180);
			_pcos = Math.cos(tempBarrel.rotation * 0.01745);
			//_psin = Math.sin(tempBarrel.rotation * Math.PI / 180);
			_psin = Math.sin(tempBarrel.rotation * 0.01745);
			
			// start X & Y
			// calculate the tip of the barrel
			_startX = tempBarrel.x - tempBarrel.length * _pcos;
			_startY = tempBarrel.y - tempBarrel.length * _psin;
			
			// end X & Y
			// calculate where the bullet needs to go
			_endX = _startX - maxDistance * _pcos + (Math.random() * _bulletSpread - _bulletSpread * .5);
			_endY = _startY - maxDistance * _psin + (Math.random() * _bulletSpread - _bulletSpread * .5);
			
			// attach bullet from library
			if (type == WeaponTypes.LASER)
			{
				// if laser is the weapon type, attach blank clip
				tempBullet = new Bullet(new MovieClip());
			}
			else if (type == WeaponTypes.PROJECTILE)
			{
				// attach art from library
				tempBullet = new Bullet(attachSkin(skinBullet));
			}
			
			// start lifetime timer
			tempBullet.bulletLifeTimer = new Timer(bulletLifeTime);
			tempBullet.bulletLifeTimer.start();
			tempBullet.bulletLifeTimer.addEventListener(TimerEvent.TIMER, reloadTimerHandler);
			
			// save a reference to bullet parent barrel
			tempBullet.parentBarrel = tempBarrel;
			
			// calculate velocity
			if (type == WeaponTypes.LASER)
			{
				// laser bullet doesn't move
				tempBullet.vx = 0;
				tempBullet.vy = 0;
				
				tempBullet.type = WeaponTypes.LASER;
			}
			else if(type == WeaponTypes.PROJECTILE)
			{
				// calculate projectile bullet speed
				tempBullet.vx = (_endX - _startX) / maxDistance * _bulletSpeed;
				tempBullet.vy = (_endY - _startY) / maxDistance * _bulletSpeed;
				
				tempBullet.type = WeaponTypes.PROJECTILE;
			}
			
			// set position
			tempBullet.x = _startX;
			tempBullet.y = _startY;
			
			// save starting location
			tempBullet.startX = _startX;
			tempBullet.startY = _startY;
			
			// save ending location
			tempBullet.endX = _endX;
			tempBullet.endY = _endY;
			
			// set maximum allowed travel distance
			tempBullet.maxDistance = _maxDistance + tempBarrel.length;
			
			// set laser bullet properties
			tempBullet.laserColor = laserColor;
			tempBullet.laserWidth = laserWidth;
			tempBullet.laserAlpha = laserAlpha;
			
			// add bullet to bullets array
			manager.addBullet(tempBullet);
			
			// cache bullet as bitmap to improve performance
			tempBullet.cacheAsBitmap = true;
			
			// add to display list
			manager.container.addChild(tempBullet);
		}
		
		/**
		 * Calculate player rotation 
		 */
		private function updateRotation():void
		{
			// calculate rotation based on mouse X & Y
			_dx = this.x - this.parent.mouseX;
			_dy = this.y - this.parent.mouseY;
			
			// which way to rotate
			_rotateTo = MathTools.getDegrees(MathTools.getRadians(_dx, _dy));	
			
			// keep rotation positive, between 0 and 360 degrees
			if (_rotateTo > this.rotation + 180) _rotateTo -= 360;
			if (_rotateTo < this.rotation - 180) _rotateTo += 360;
			
			// ease rotation
			_trueRotation = (_rotateTo - this.rotation) / _rotateSpeedMax;
			
			// update rotation
			this.rotation += _trueRotation;			
		}
		
		/**
		 * This method is used to update the barrel
		 */
		private function updateBarrels():void 
		{
			var i:uint;
			var l:int = _weaponBarrels.length;
			
			for (i = 0; i < l; i++)
			{
				tempBarrel = _weaponBarrels[i];
				
				tempBarrel.update();
			}
		}
		
		//////////////////////////////////////
		// Display Handlers
		//////////////////////////////////////
		
		/**
		 * Use this method to get a skin class from the fla library via text string
		 * @param	name
		 * @return
		 */
		protected function attachSkin(name:String):DisplayObjectContainer
		{
			var returnValue:Object;			
			var newSkinClass:Class;
			
			/*
			try
			{
				// attach class
				newSkinClass = getDefinitionByName(name) as Class;			
				returnValue = new newSkinClass();
			}
			catch(err:Error)
			{
				// error
				trace(err.message);
				trace("'" + name + "' not found in library.");
				
				returnValue = new MovieClip();
			}
			*/
			
			// attach class
			newSkinClass = getDefinitionByName(name) as Class;			
			returnValue = new newSkinClass();
			
			return returnValue as DisplayObjectContainer;
		}
		
		//////////////////////////////////////
		// Event Handlers
		//////////////////////////////////////
		
		/**
		 * Reload timer
		 * @param	e	Takes TimerEvent
		 */
		private function reloadTimerHandler(e:TimerEvent):void 
		{
			// stop timer
			e.target.stop();
		}
		
		//////////////////////////////////////
		// Getters and Setters
		//////////////////////////////////////
		
		public function get isFiring():Boolean 
		{
			return _isFiring;
		}
		
		public function set isFiring(value:Boolean):void 
		{
			_isFiring = value;
		}
		
		public function get rotateSpeedMax():Number 
		{
			return _rotateSpeedMax;
		}
		
		public function set rotateSpeedMax(value:Number):void 
		{
			_rotateSpeedMax = value;
		}
		
		public function get bulletSpeed():Number 
		{
			return _bulletSpeed;
		}
		
		public function set bulletSpeed(value:Number):void 
		{
			_bulletSpeed = value;
		}
		
		public function get maxDistance():Number 
		{
			return _maxDistance;
		}
		
		public function set maxDistance(value:Number):void 
		{
			_maxDistance = value;
		}
		
		public function get reloadTime():Number 
		{
			return _reloadTime;
		}
		
		public function set reloadTime(value:Number):void 
		{
			_reloadTime = value;
		}
		
		public function get bulletSpread():Number 
		{
			return _bulletSpread;
		}
		
		public function set bulletSpread(value:Number):void 
		{
			_bulletSpread = value;
		}
		
		public function get reloadTimer():Timer 
		{
			return _reloadTimer;
		}
		
		public function set reloadTimer(value:Timer):void 
		{
			_reloadTimer = value;
		}
		
		public function get weaponBarrels():Array 
		{
			return _weaponBarrels;
		}
		
		public function set weaponBarrels(value:Array):void 
		{
			_weaponBarrels = value;
		}
		
		public function get skinBullet():String 
		{
			return _skinBullet;
		}
		
		public function set skinBullet(value:String):void 
		{
			_skinBullet = value;
		}
		
		public function get skinGun():String 
		{
			return _skinGun;
		}
		
		public function set skinGun(value:String):void 
		{
			_skinGun = value;
		}
		
		public function get skinBarrel():String 
		{
			return _skinBarrel;
		}
		
		public function set skinBarrel(value:String):void 
		{
			_skinBarrel = value;
		}
		
		public function get tempSkin():Class 
		{
			return _tempSkin;
		}
		
		public function set tempSkin(value:Class):void 
		{
			_tempSkin = value;
		}
		
		public function get manager():WeaponManager 
		{
			return _manager;
		}
		
		public function set manager(value:WeaponManager):void 
		{
			_manager = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get linkedBarrels():Boolean 
		{
			return _linkedBarrels;
		}
		
		public function set linkedBarrels(value:Boolean):void 
		{
			_linkedBarrels = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get bulletLifeTime():Number 
		{
			return _bulletLifeTime;
		}
		
		public function set bulletLifeTime(value:Number):void 
		{
			_bulletLifeTime = value;
		}
		
		public function get laserColor():int 
		{
			return _laserColor;
		}
		
		public function set laserColor(value:int):void 
		{
			_laserColor = value;
		}
		
		public function get laserWidth():Number 
		{
			return _laserWidth;
		}
		
		public function set laserWidth(value:Number):void 
		{
			_laserWidth = value;
		}
		
		public function get laserAlpha():Number 
		{
			return _laserAlpha;
		}
		
		public function set laserAlpha(value:Number):void 
		{
			_laserAlpha = value;
		}
		
		public function get tempBarrel():Barrel 
		{
			return _tempBarrel;
		}
		
		public function set tempBarrel(value:Barrel):void 
		{
			_tempBarrel = value;
		}
		
		public function get tempBullet():Bullet 
		{
			return _tempBullet;
		}
		
		public function set tempBullet(value:Bullet):void 
		{
			_tempBullet = value;
		}
		
	}
}