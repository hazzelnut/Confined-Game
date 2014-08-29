/**
 * Advanced Weapon System
 * Single Barrel Example
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
	
	public class ProjectileSingle extends AbstractWeapon 
	{
		public function ProjectileSingle(id:String, manager:WeaponManager, x:Number, y:Number, rotation:Number):void
		{
			super(id, manager, x, y, rotation);
			
			// set skins
			skinGun = "WeaponSingleSkin";
			skinBarrel = "Barrel1Skin";
			skinBullet = "BulletRed";
			
			// add weapon skin
			addChild(super.attachSkin(skinGun));
			
			// create weapon barrels
			// createBarrel(weapon instance, skin, x, y, length) 
			super.createBarrel(this, super.attachSkin(skinBarrel), -10, 0, 5)
			
			// gun settings
			type = WeaponTypes.PROJECTILE;
			rotateSpeedMax = 5;
			reloadTime = 250; // milliseconds
			bulletSpread = 5; // pixels
			bulletLifeTime = 2000; // milliseconds
			
			
			// bullet settings
			bulletSpeed = 6;
			maxDistance = 200; // pixels
			laserColor = 0x00FF00;
			laserWidth = 2;
			laserAlpha = .75;
			
		}
	}

}