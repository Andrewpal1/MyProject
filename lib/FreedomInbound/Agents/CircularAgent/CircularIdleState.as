package lib.FreedomInbound.Agents.CircularAgent {
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	
	// circular agent idle state
	public class CircularIdleState implements ICircularAgentState {
		
		// ran when state is entered
		public function enter(agent:CircularAgent):void {
			agent.speed = 0;
			agent.idleCycles = 0;
		}
		
		// ran every frame while in state
		public function update(agent:CircularAgent):void {
			agent.frameCount++;
			if (agent.idleCycles > 1) {
				agent.setState(CircularAgent.CIRCULAR_IDLE);
			}
			if (agent.frameCount >= 30) {
				agent.frameCount = 0;
				agent.idleCycles++;
				agent.setState(CircularAgent.CIRCULAR_WANDER);
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
				agent.setState(CircularAgent.CIRCULAR_PANIC);
			}
			
			if (agent.health.getHealth() <= 50) {
				agent.setState(CircularAgent.CIRCULAR_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:CircularAgent):void {
			agent.randomDirection();
		}

	}
	
}
