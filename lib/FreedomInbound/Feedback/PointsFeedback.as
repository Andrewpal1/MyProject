package lib.FreedomInbound.Feedback {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	// feedback class, displays points per kill text when enemy dies
	public class PointsFeedback extends MovieClip {
		
		private var readyToRemove:Boolean = false;			// feedback ready to be removed from screen boolean
		private var frameCount:uint = 0;					// frame counter
		
		// sets point feedback text
		public function PointsFeedback(pointsText:String) {
			this.pointsText.text = pointsText;
			addEventListener(Event.ENTER_FRAME, count);
		}
		
		// updates count, checks to see if ready to remove from screen
		public function count(evt:Event):void {
			frameCount++;
			this.y--;
			if (frameCount > 35) {
				readyToRemove = true;
				removeEventListener(Event.ENTER_FRAME, count);
			}
		}
		
		// returns if feedback is ready to be removed
		public function isReadyToRemove():Boolean {
			return readyToRemove;
		}
		
	}
	
}
