package lib.FreedomInbound.Agents.StraightAgent {
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	
	// straight agent injured state
	public class StraightInjuredState implements IStraightAgentState {

		// ran when state is entered
		public function enter(agent:StraightAgent):void {
			agent.say("Have mercy!");
			agent.speed = 0.5;
			agent.setSliders(0.12, 20, 20, 1.2, 5, 0);
			agent.setWalkOffset(6);
		}
		
		// ran every frame while in state
		public function update(agent:StraightAgent):void {
		}
		
		// ran when state is exited
		public function exit(agent:StraightAgent):void {
		}

	}
	
}
