package lib.FreedomInbound.Agents.CircularAgent {
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	
	// circular agent panic state
	public class CircularPanicState implements ICircularAgentState {
		
		// ran when state is entered
		public function enter(agent:CircularAgent):void {
			agent.say("Run for your lives!");
			agent.speed = 5;
			agent.setSliders(0.24, 55, 48, 1.87, 43.08, 97.65);
			agent.setWalkOffset(2);
		}
		
		// ran every frame while in state
		public function update(agent:CircularAgent):void {
			if (agent.health.getHealth() <= 50) {
				agent.setState(CircularAgent.CIRCULAR_INJURED);
			}
		}
		
		// ran when state is exited
		public function exit(agent:CircularAgent):void {
		}

	}
	
}
