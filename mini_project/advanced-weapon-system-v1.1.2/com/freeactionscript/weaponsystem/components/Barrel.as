/**
 * Advanced Weapon System
 * Barrel Class
 * ---------------------
 * VERSION: 1.1.2
 * DATE: 8/27/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package com.freeactionscript.weaponsystem.components
{
	import com.freeactionscript.utils.MathTools;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	public class Barrel extends Sprite
	{
		// settings
		private var _parentWeapon:AbstractWeapon;
		private var _skin:DisplayObjectContainer;
		private var _relativeX:Number;
		private var _relativeY:Number;
		private var _length:Number
		
		private var _reloadTimer:Timer;
		
		// common vars
		private var _barrelDistance:Number;
		private var _barrelRadians:Number;
		private var _weaponRadians:Number;
		private var _totalRadians:Number;
		private var _newX:Number;
		private var _newY:Number;
		
		/**
		 * Barrel Constructor
		 * @param	skin	Skin movieclip
		 * @param	x	Relative X position of the barrel from anchor
		 * @param	y	Relative Y position of the barrel from anchor
		 * @param	length	Barrel length in pixels
		 */
		public function Barrel(parentWeapon:AbstractWeapon, skin:DisplayObjectContainer, x:Number, y:Number, length:Number) 
		{
			this.parentWeapon = parentWeapon;
			this.skin = skin;
			this.relativeX = x;
			this.relativeY = y
			this.length = length;
			
			reloadTimer = new Timer(0);
			
			addChild(skin);
		}
		
		//////////////////////////////////////
		// Public API
		//////////////////////////////////////
		
		/**
		 * This method updates the barrel
		 */
		public function update():void
		{
			// calucate position & rotation
			_barrelDistance = MathTools.getDistance(this.relativeX, this.relativeY);
			_barrelRadians = Math.atan2(this.relativeY, this.relativeX);
			//_weaponRadians = parentWeapon.rotation * Math.PI / 180;
			_weaponRadians = parentWeapon.rotation * 0.01745;
			_totalRadians = _weaponRadians + _barrelRadians;
			
			// set position & rotation
			this.x = parentWeapon.x + _barrelDistance * Math.cos(_totalRadians);
			this.y = parentWeapon.y + _barrelDistance * Math.sin(_totalRadians);
			this.rotation = parentWeapon.rotation;
		}
		
		/**
		 * Use this method when destroying a bullet
		 */
		public function destroy():void
		{
			removeChild(skin);
		}
		
		//////////////////////////////////////
		// Private Methods
		//////////////////////////////////////
		
		//////////////////////////////////////
		// Getters & Setters
		//////////////////////////////////////
		
		public function get relativeX():Number 
		{
			return _relativeX;
		}
		
		public function set relativeX(value:Number):void 
		{
			_relativeX = value;
		}
		
		public function get relativeY():Number 
		{
			return _relativeY;
		}
		
		public function set relativeY(value:Number):void 
		{
			_relativeY = value;
		}
		
		public function get length():Number 
		{
			return _length;
		}
		
		public function set length(value:Number):void 
		{
			_length = value;
		}
		
		public function get skin():DisplayObjectContainer 
		{
			return _skin;
		}
		
		public function set skin(value:DisplayObjectContainer):void 
		{
			_skin = value;
		}
		
		public function get reloadTimer():Timer 
		{
			return _reloadTimer;
		}
		
		public function set reloadTimer(value:Timer):void 
		{
			_reloadTimer = value;
		}
		
		public function get parentWeapon():AbstractWeapon 
		{
			return _parentWeapon;
		}
		
		public function set parentWeapon(value:AbstractWeapon):void 
		{
			_parentWeapon = value;
		}
		
	}

}