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
	
	public class LaserDual extends AbstractWeapon 
	{
		public function LaserDual(id:String, manager:WeaponManager, x:Number, y:Number, rotation:Number):void
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
			super.createBarrel(this, super.attachSkin(skinBarrel), 0, -5, 8)
			super.createBarrel(this, super.attachSkin(skinBarrel), 0, 5, 8)
			
			// gun settings
			type = WeaponTypes.LASER;
			rotateSpeedMax = 20;
			reloadTime = 500; // milliseconds
			bulletSpread = 5; // pixels
			bulletLifeTime = 2500; // milliseconds
			
			// bullet settings
			bulletSpeed = 10;
			maxDistance = 200; // pixels
			laserColor = 0xFF0000;
			laserWidth = 1;
			laserAlpha = 1;
			
		}
	}

}