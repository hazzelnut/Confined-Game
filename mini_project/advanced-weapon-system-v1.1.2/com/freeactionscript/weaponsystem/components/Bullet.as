/**
 * Advanced Weapon System
 * Bullet Class
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
	
	public class Bullet extends Sprite
	{
		// settings
		private var _bulletLifeTime:Number;
		private var _parentBarrel:Barrel;
		private var _maxDistance:Number;
		private var _skin:DisplayObjectContainer;
		private var _laserColor:int;
		private var _laserWidth:Number;
		private var _laserAlpha:Number;
		private var _expired:Boolean;
		private var _type:String;
		
		// shared vars
		private var _startX:Number;
		private var _startY:Number;
		private var _endX:Number;
		private var _endY:Number;
		private var _bulletLifeTimer:Timer;
		private var _vx:Number;
		private var _vy:Number;
		private var _pcos:Number;
		private var _psin:Number;
		private var _currentDistance:int;	
		
		/**
		 * Constructor
		 */
		public function Bullet(skin:DisplayObjectContainer) 
		{
			_skin = skin;
			
			// predefined bullet settings
			_expired = false;
			
			_vx = 0;
			_vy = 0;
			
			addChild(skin);
		}
		
		//////////////////////////////////////
		// Public API
		//////////////////////////////////////
		
		/**
		 * This method updates the bullet
		 */
		public function update():void
		{
			// check if bullet expired due to long life
			if (!this.bulletLifeTimer.running)
			{
				this.expired = true;
			}
			
			// check if bullet went too far
			if (MathTools.getDistance(this.startX - this.x, this.startY - this.y) > this.maxDistance)
			{
				this.expired = true;
			}
			
			// update bullet based on type
			if (type == WeaponTypes.PROJECTILE)
			{
				// update bullet position
				this.x += this.vx;
				this.y += this.vy;
			}
			else if (type == WeaponTypes.LASER)
			{
				// calculate the cosine & sine based on barrel rotation
				//pcos = Math.cos(this.parentBarrel.rotation * Math.PI / 180);
				pcos = Math.cos(this.parentBarrel.rotation * 0.01745);
				//psin = Math.sin(this.parentBarrel.rotation * Math.PI / 180);
				psin = Math.sin(this.parentBarrel.rotation * 0.01745);
				
				// calculate the tip of the barrel
				// this constantly needs to be updated for laser weapons
				this.startX = this.parentBarrel.x - this.parentBarrel.length * pcos;
				this.startY = this.parentBarrel.y - this.parentBarrel.length * psin;
				
				// run a loop to start drawing laser
				for (currentDistance = 0; currentDistance < this.maxDistance; currentDistance += 2)
				{		
					// get end X & Y, a point at a time (_accuracy)
					this.endX = this.parentBarrel.x - _pcos * currentDistance;
					this.endY = this.parentBarrel.y - _psin * currentDistance;
					
					// complex collision test
					if (parentBarrel.parentWeapon.manager.checkCollisionPoint(this.endX, this.endY))
					{
						// if hit, break loop
						break;
					}
				}
				
				// draw laser
				this.graphics.clear();
				this.graphics.lineStyle(this.laserWidth, this.laserColor, this.laserAlpha);
				this.graphics.moveTo(this.startX - this.x, this.startY - this.y);
				this.graphics.lineTo(this.endX - this.x, this.endY - this.y);
			}
		}
		
		/**
		 * Use this method when destroying a bullet
		 */
		public function destroy():void
		{
			_bulletLifeTimer = null;
			removeChild(skin);
		}
		
		//////////////////////////////////////
		// Private Methods
		//////////////////////////////////////
		
		//////////////////////////////////////
		// Getters & Setters
		//////////////////////////////////////
		
		public function get startX():Number 
		{
			return _startX;
		}
		
		public function set startX(value:Number):void 
		{
			_startX = value;
		}
		
		public function get startY():Number 
		{
			return _startY;
		}
		
		public function set startY(value:Number):void 
		{
			_startY = value;
		}
		
		public function get maxDistance():Number 
		{
			return _maxDistance;
		}
		
		public function set maxDistance(value:Number):void 
		{
			_maxDistance = value;
		}
		
		public function get vx():Number 
		{
			return _vx;
		}
		
		public function set vx(value:Number):void 
		{
			_vx = value;
		}
		
		public function get vy():Number 
		{
			return _vy;
		}
		
		public function set vy(value:Number):void 
		{
			_vy = value;
		}
		
		public function get skin():DisplayObjectContainer 
		{
			return _skin;
		}
		
		public function set skin(value:DisplayObjectContainer):void 
		{
			_skin = value;
		}
		
		public function get expired():Boolean 
		{
			return _expired;
		}
		
		public function set expired(value:Boolean):void 
		{
			_expired = value;
		}
		
		public function get endX():Number 
		{
			return _endX;
		}
		
		public function set endX(value:Number):void 
		{
			_endX = value;
		}
		
		public function get endY():Number 
		{
			return _endY;
		}
		
		public function set endY(value:Number):void 
		{
			_endY = value;
		}
		
		public function get parentBarrel():Barrel 
		{
			return _parentBarrel;
		}
		
		public function set parentBarrel(value:Barrel):void 
		{
			_parentBarrel = value;
		}
		
		public function get bulletLifeTime():Number 
		{
			return _bulletLifeTime;
		}
		
		public function set bulletLifeTime(value:Number):void 
		{
			_bulletLifeTime = value;
		}
		
		public function get bulletLifeTimer():Timer 
		{
			return _bulletLifeTimer;
		}
		
		public function set bulletLifeTimer(value:Timer):void 
		{
			_bulletLifeTimer = value;
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
		
		public function get pcos():Number 
		{
			return _pcos;
		}
		
		public function set pcos(value:Number):void 
		{
			_pcos = value;
		}
		
		public function get psin():Number 
		{
			return _psin;
		}
		
		public function set psin(value:Number):void 
		{
			_psin = value;
		}
		
		public function get currentDistance():int 
		{
			return _currentDistance;
		}
		
		public function set currentDistance(value:int):void 
		{
			_currentDistance = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
	}

}