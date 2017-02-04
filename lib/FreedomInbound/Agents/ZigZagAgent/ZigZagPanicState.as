package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	
	// zig zag agent panic state
	public class ZigZagPanicState implements IZigZagAgentState {

		// ran when state is entered
		public function enter(agent:ZigZagAgent):void {
			agent.say("Every man for themself!");
			agent.speed = 5;
			agent.setSliders(0.24, 55, 48, 1.87, 43.08, 97.65);
			agent.setWalkOffset(2);
		}
		
		// ran every frame while in state
		public function update(agent:ZigZagAgent):void {
			if (agent.health.getHealth() <= 50) {
				agent.setState(ZigZagAgent.ZIG_ZAG_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:ZigZagAgent):void {
		}

	}
	
}
