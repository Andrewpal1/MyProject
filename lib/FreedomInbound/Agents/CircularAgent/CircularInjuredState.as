package lib.FreedomInbound.Agents.CircularAgent {
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	
	// circular agent injured state
	public class CircularInjuredState implements ICircularAgentState {
		
		// ran when state is entered
		public function enter(agent:CircularAgent):void {
			agent.say("Just put me out of my misery!");
			agent.speed = 0.5;
			agent.setSliders(0.12, 20, 20, 1.2, 5, 0);
			agent.setWalkOffset(6);
		}
		
		// ran every frame while in state
		public function update(agent:CircularAgent):void {
		}
		
		// ran when state is exited
		public function exit(agent:CircularAgent):void {
		}

	}
	
}
