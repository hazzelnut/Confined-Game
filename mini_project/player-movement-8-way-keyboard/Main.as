/**
 * Player Movement - 8-way keyboard
 * ---------------------
 * VERSION: 1.0
 * DATE: 9/23/2010
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://www.FreeActionScript.com
 **/
package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip
	{		
		// player
		private var _player:MovieClip;
		
		// player settings
		private var _playerSpeed:Number = 4;
		
		// movement flags
		private var _movingUp:Boolean = false;
		private var _movingDown:Boolean = false;
		private var _movingLeft:Boolean = false;
		private var _movingRight:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function Main() 
		{
			createPlayer();
			
			// add listeners
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, myOnPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, myOnRelease);			
		}
		
		/**
		 * Creates player
		 */
		private function createPlayer():void
		{
			_player = new Player();
			_player.x = stage.stageWidth / 2;
			_player.y = stage.stageHeight / 2;
			stage.addChild(_player);
		}
		
		/**
		 * EnterFrame Handlers
		 */
		private function enterFrameHandler(event:Event):void
		{
			// Move up, down, left, or right
			if ( _movingLeft && !_movingRight )
			{
				_player.x -= _playerSpeed;
				_player.rotation = 270;
			}
			if ( _movingRight && !_movingLeft )
			{
				_player.x += _playerSpeed;
				_player.rotation = 90;
			}
			if ( _movingUp && !_movingDown )
			{
				_player.y -= _playerSpeed;
				_player.rotation = 0;
			}
			if ( _movingDown && !_movingUp )
			{
				_player.y += _playerSpeed;
				_player.rotation = 180;
			}
			
			// Move diagonally
			if ( _movingLeft && _movingUp && !_movingRight && !_movingDown )
			{
				_player.rotation = 315;
			}
			if ( _movingRight && _movingUp && !_movingLeft && !_movingDown )
			{
				_player.rotation = 45;
			}
			if ( _movingLeft && _movingDown && !_movingRight && !_movingUp )
			{
				_player.rotation = 225;
			}
			if ( _movingRight && _movingDown && !_movingLeft && !_movingUp )
			{
				_player.rotation = 135;
			}
		}
		
		/**
		 * Key Press Handlers
		 */
		public function myOnPress(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					_movingUp = true;
					break;
					
				case Keyboard.DOWN:
					_movingDown = true;
					break;
					
				case Keyboard.LEFT:
					_movingLeft = true;
					break;
					
				case Keyboard.RIGHT:
					_movingRight = true;
					break;
			}
		}
		
		/**
		 * Key Release Handlers
		 */
		public function myOnRelease(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					_movingUp = false;
					break;
					
				case Keyboard.DOWN:
					_movingDown = false;
					break;
					
				case Keyboard.LEFT:
					_movingLeft = false;
					break;
					
				case Keyboard.RIGHT:
					_movingRight = false;
					break;
			}
		}
		
	}
	
}