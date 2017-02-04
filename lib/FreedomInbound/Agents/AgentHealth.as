package lib.FreedomInbound.Agents {
	
	import flash.display.MovieClip;
	
	// used to keep track of health of any agent
	public class AgentHealth extends MovieClip {
		
		private var health:Number = 100;		// health of agent
		
		public function AgentHealth() {
		}
		
		// returns health of agent
		public function getHealth():Number {
			return health;
		}
		
		// subtracts damage taken from health
		public function takeDamamge(damage:Number):void {
			health -= damage;
			if (health <= 0) {
				this.width = 0;
			} else {
				this.width -= damage;
			}
		}
	}
	
}
