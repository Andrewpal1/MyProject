package lib.FreedomInbound.Bombs {
	import flash.display.MovieClip;
	
	// bomb type 1 class - normal grenade
	public class BombType1 extends MovieClip {
		
		private var pointBlankDamage:Number = 50;		// points blank damage of bomb
		private var blastRadius:Number = 275;			// blast radius of bomb
		
		public function BombType1() {
		}
		
		// returns damage of bomb calculated with distance away from bomb
		public function getDamage(distance:Number):Number {
			if (distance <= blastRadius) {
				return pointBlankDamage * (blastRadius/(blastRadius+2*distance));
			} else {
				return 0;
			}
		}
		
		// returns bomb info string to be displayed on screen
		public function getBombInfo():String {
			return "Blast radius: " + blastRadius + '\n' + "Point blank damage: " + pointBlankDamage + '\n' +
				   "Damage at 100 meters: " + Math.round(this.getDamage(100)) + '\n' +
				   "Damage at 200 meters: " + Math.round(this.getDamage(200)) + '\n' +
				   "Damage at 300 meters: " + Math.round(this.getDamage(300)) + '\n' +
				   "Damage at 400 meters: " + Math.round(this.getDamage(400)) + '\n' +
			       "Damage at 500 meters: " + Math.round(this.getDamage(500)) + '\n' +
			       "Damage at 600 meters: " + Math.round(this.getDamage(600)) + '\n';
		}
	}
	
}
