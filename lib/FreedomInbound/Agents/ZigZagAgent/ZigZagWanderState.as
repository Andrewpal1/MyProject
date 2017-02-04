package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	
	// zig zag agent wander state
	public class ZigZagWanderState implements IZigZagAgentState {

		// ran when state is entered
		public function enter(agent:ZigZagAgent):void {
			agent.say("La la la...");
			agent.frameCount = 0;
			agent.speed = 2;
			agent.setSliders(0.18, 40, 40, 1.57, 15, 0);
			agent.setWalkOffset(5);
		}
		
		// ran every frame while in state
		public function update(agent:ZigZagAgent):void {
			agent.frameCount++;
			if (agent.frameCount >= 180) {
				agent.frameCount = 0;
				agent.setState(ZigZagAgent.ZIG_ZAG_IDLE);
			}
			if (agent.bombDropped) {
				agent.setState(ZigZagAgent.ZIG_ZAG_PANIC);
			}
			
			if (agent.health.getHealth() <= 50) {
				agent.setState(ZigZagAgent.ZIG_ZAG_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:ZigZagAgent):void {
		}

	}
	
}
