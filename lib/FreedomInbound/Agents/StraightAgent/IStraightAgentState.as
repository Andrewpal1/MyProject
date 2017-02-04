package lib.FreedomInbound.Agents.StraightAgent {
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	import flash.events.Event;
	
	// interface for straight agent
	public interface IStraightAgentState {

		function enter(agent:StraightAgent):void;
		function update(agent:StraightAgent):void;
		function exit(agent:StraightAgent):void;

	}
	
}
