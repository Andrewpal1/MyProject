package lib.FreedomInbound.Agents.StraightAgent {
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	
	// straight agent wander state
	public class StraightWanderState implements IStraightAgentState {

		// ran when state is entered
		public function enter(agent:StraightAgent):void {
			agent.say("What a lovely day.");
			agent.frameCount = 0;
			agent.speed = 2;
			agent.setSliders(0.18, 40, 40, 1.57, 15, 0);
			agent.setWalkOffset(5);
		}
		
		// ran every frame while in state
		public function update(agent:StraightAgent):void {
			agent.frameCount++;
			if (agent.frameCount >= 90) {
				agent.frameCount = 0;
				agent.setState(StraightAgent.STRAIGHT_IDLE);
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
		}

	}
	
}
