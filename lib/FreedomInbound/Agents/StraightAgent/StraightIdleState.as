package lib.FreedomInbound.Agents.StraightAgent {
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	
	// straight agent idle state
	public class StraightIdleState implements IStraightAgentState {
		
		// ran when state is entered
		public function enter(agent:StraightAgent):void {
			agent.speed = 0;
			agent.idleCycles = 0;
		}
		
		// ran every frame while in state
		public function update(agent:StraightAgent):void {
			agent.frameCount++;
			if (agent.idleCycles > 1) {
				agent.setState(StraightAgent.STRAIGHT_IDLE);
			}
			if (agent.frameCount >= 30) {
				agent.frameCount = 0;
				agent.idleCycles++;
				agent.setState(StraightAgent.STRAIGHT_WANDER);
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
				agent.setState(StraightAgent.STRAIGHT_PANIC);
			}
			
			if (agent.health.getHealth() <= 50) {
				agent.setState(StraightAgent.STRAIGHT_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:StraightAgent):void {
			agent.randomDirection();
		}

	}
	
}
