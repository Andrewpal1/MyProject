package lib.FreedomInbound.Agents.CircularAgent {
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	import flash.events.Event;
	
	// interface for states of circular agent
	public interface ICircularAgentState {

		function enter(agent:CircularAgent):void;
		function update(agent:CircularAgent):void;
		function exit(agent:CircularAgent):void;

	}
	
}
