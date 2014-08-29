/**
 * Advanced Weapon System
 * Quad Barrel Gun Example
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
	
	public class ProjectileQuad extends AbstractWeapon 
	{
		public function ProjectileQuad(id:String, manager:WeaponManager, x:Number, y:Number, rotation:Number):void
		{
			super(id, manager, x, y, rotation);
			
			// set skins
			skinGun = "WeaponQuadSkin";
			skinBarrel = "Barrel2Skin";
			skinBullet = "BulletYellow";
			
			// add weapon skin
			addChild(super.attachSkin(skinGun));
			
			// create weapon barrels
			// createBarrel(weapon instance, skin, x, y, length) 
			super.createBarrel(this, super.attachSkin(skinBarrel), 0, -20, 5)
			super.createBarrel(this, super.attachSkin(skinBarrel), -5, -10, 5)
			super.createBarrel(this, super.attachSkin(skinBarrel), -5, 10, 5)
			super.createBarrel(this, super.attachSkin(skinBarrel), 0, 20, 5)
			
			// gun settings
			type = WeaponTypes.PROJECTILE;
			rotateSpeedMax = 20;
			reloadTime = 250; // milliseconds
			bulletSpread = 10; // pixels
			bulletLifeTime = 3000; // milliseconds
			
			// bullet settings
			bulletSpeed = 4;
			maxDistance = 200; // pixels
			laserColor = 0x000000;
			laserWidth = 0;
			laserAlpha = 0;
			
		}
	}

}