package lib.FreedomInbound.Agents.StraightAgent {
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	
	// straight agent panic state
	public class StraightPanicState implements IStraightAgentState {

		// ran when state is entered
		public function enter(agent:StraightAgent):void {
			agent.speed = 5;
			agent.setSliders(0.24, 55, 48, 1.87, 43.08, 97.65);
			agent.setWalkOffset(2);
		}
		
		// ran every frame while in state
		public function update(agent:StraightAgent):void {
			agent.frameCount++;
			if (agent.frameCount >= 30) {
				agent.frameCount = 0;
			} else if (agent.frameCount >= 20) {
				agent.say("aaaaaaaaaah!");
			} else if (agent.frameCount >= 18) {
				agent.say("aaaaaaaaah!");
			} else if (agent.frameCount >= 16) {
				agent.say("aaaaaaaah!");
			} else if (agent.frameCount >= 14) {
				agent.say("aaaaaah!");
			} else if (agent.frameCount >= 12) {
				agent.say("aaaaah!");
			} else if (agent.frameCount >= 10) {
				agent.say("aaaah!");
			} else if (agent.frameCount >= 8) {
				agent.say("aaah!");
			} else if (agent.frameCount >= 6) {
				agent.say("aah!");
			} else if (agent.frameCount >= 4) {
				agent.say("ah!");
			}
			
			if (agent.health.getHealth() <= 50) {
				agent.setState(StraightAgent.STRAIGHT_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:StraightAgent):void {
		}

	}
	
}
