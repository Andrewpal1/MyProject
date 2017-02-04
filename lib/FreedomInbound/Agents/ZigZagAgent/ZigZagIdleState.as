package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	
	// zig zag agent idle state
	public class ZigZagIdleState implements IZigZagAgentState {

		// ran when state is entered
		public function enter(agent:ZigZagAgent):void {
			agent.speed = 0;
			agent.idleCycles = 0;
		}
		
		// ran every frame while in state
		public function update(agent:ZigZagAgent):void {
			agent.frameCount++;
			if (agent.idleCycles > 2) {
				agent.setState(ZigZagAgent.ZIG_ZAG_WANDER);
			}
			if (agent.frameCount >= 30) {
				agent.frameCount = 0;
				agent.idleCycles++;
			} else if (agent.frameCount >= 24) {
				agent.say("...");
			} else if (agent.frameCount >= 18) {
				agent.say("..");
			} else if (agent.frameCount >= 12) {
				agent.say(".");
			} else if (agent.frameCount >= 6) {
				agent.say("");
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
			agent.randomDirection();
		}

	}
	
}
