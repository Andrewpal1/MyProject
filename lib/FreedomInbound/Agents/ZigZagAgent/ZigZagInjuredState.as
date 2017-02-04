package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	
	// zig zag agent injured state
	public class ZigZagInjuredState implements IZigZagAgentState {
		
		// ran when state is entered
		public function enter(agent:ZigZagAgent):void {
			agent.say("Someone help me!");
			agent.speed = 0.5;
			agent.setSliders(0.12, 20, 20, 1.2, 5, 0);
			agent.setWalkOffset(6);
		}
		
		// ran every frame while in state
		public function update(agent:ZigZagAgent):void {
		}
		
		// ran when state is exited
		public function exit(agent:ZigZagAgent):void {
		}

	}
	
}
