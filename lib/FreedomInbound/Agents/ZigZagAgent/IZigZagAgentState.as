package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	import flash.events.Event;
	
	// interface for zig zag agent states
	public interface IZigZagAgentState {

		function enter(agent:ZigZagAgent):void;
		function update(agent:ZigZagAgent):void;
		function exit(agent:ZigZagAgent):void;

	}
	
}
