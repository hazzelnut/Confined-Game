/**
 * Advanced Weapon System
 * Laser Dual Turret Example
 * ---------------------
 * VERSION: 1.1.2
 * DATE: 8/27/2011
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package com.freeactionscript.weaponsystem.weapons
{
	import com.freeactionscript.weaponsystem.components.AbstractWeapon;
	import com.freeactionscript.weaponsystem.components.WeaponTypes;
	import com.freeactionscript.weaponsystem.WeaponManager;
	
	public class LaserSingle extends AbstractWeapon 
	{
		public function LaserSingle(id:String, manager:WeaponManager, x:Number, y:Number, rotation:Number):void
		{
			super(id, manager, x, y, rotation);
			
			// set skins
			skinGun = "WeaponDualSkin";
			skinBarrel = "Barrel4Skin";
			skinBullet = "";
			
			// add weapon skin
			addChild(super.attachSkin(skinGun));
			
			// create weapon barrels
			// createBarrel(weapon instance, skin, x, y, length)
			super.createBarrel(this, super.attachSkin(skinBarrel), 0, 0, 8)
			
			// gun settings
			type = WeaponTypes.LASER;
			rotateSpeedMax = 10;
			reloadTime = 2500; // milliseconds
			bulletSpread = 5; // pixels
			bulletLifeTime = 1000; // milliseconds
			
			// bullet settings
			bulletSpeed = 10;
			maxDistance = 250; // pixels
			laserColor = 0x00FF00;
			laserWidth = 3;
			laserAlpha = 1;
			
		}
	}

}