package com.reyco1.physinjector.plugins
{
	import Box2D.Collision.b2Distance;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	
	import com.reyco1.physinjector.PhysInjector;

	public class ExplosionPlugin
	{
		private var injector:PhysInjector;
		private var _active:Boolean
		
		public function ExplosionPlugin(injector:PhysInjector)
		{
			this.injector = injector;
			_active = true;
		}
		
		public function create(x:Number, y:Number, coverage:Number = 200, impulseForce:Number = 30):void
		{
			if(_active)
			{
				for (var a:int = 0; a < injector.bodies.length; a++) 
				{
					var expOrigen:b2Vec2 = new b2Vec2(x/PhysInjector.WORLD_SCALE, y/PhysInjector.WORLD_SCALE);
					var bodyPosition:b2Vec2 = injector.bodies[a].GetPosition();
					
					var maxDistance:Number = coverage / PhysInjector.WORLD_SCALE;
					var maxForce:int = impulseForce;
					var distance:Number;
					var strength:Number;
					var force:Number;
					var angle:Number;
					
					distance = b2Math.Distance(bodyPosition, expOrigen);
					if(distance > maxDistance) 
						distance = maxDistance - 0.01;
					
					strength = (maxDistance - distance) / maxDistance;
					force 	 = strength * maxForce;
					angle 	 = Math.atan2(bodyPosition.y - expOrigen.y, bodyPosition.x - expOrigen.x);
					
					var impulse:b2Vec2 = new b2Vec2( Math.cos(angle) * force, Math.sin(angle) * force);
					injector.bodies[a].ApplyImpulse(impulse, injector.bodies[a].GetPosition());
				}	
			}
		}
		
		public function dispose():void
		{
			injector = null;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

	}
}