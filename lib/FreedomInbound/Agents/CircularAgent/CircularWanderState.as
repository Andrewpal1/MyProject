package lib.FreedomInbound.Agents.CircularAgent {
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	
	// circular agent wander state
	public class CircularWanderState implements ICircularAgentState {

		// ran when state is entered
		public function enter(agent:CircularAgent):void {
			agent.say("What's for dinner?");
			agent.frameCount = 0;
			agent.speed = 2;
			agent.setSliders(0.18, 40, 40, 1.57, 15, 0);
			agent.setWalkOffset(5);
		}
		
		// ran every frame while in state
		public function update(agent:CircularAgent):void {
			agent.frameCount++;
			if (agent.frameCount >= 240) {
				agent.frameCount = 0;
				agent.setState(CircularAgent.CIRCULAR_IDLE);
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
		}

	}
	
}
