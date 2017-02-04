package lib.FreedomInbound.Agents.ZigZagAgent {
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgentBones.*;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lib.FreedomInbound.Agents.AgentHealth;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	// zig zag agent class, deals with state and characteristics of agent
	public class ZigZagAgent extends MovieClip {

		public static const ZIG_ZAG_IDLE:IZigZagAgentState = new ZigZagIdleState();			// idle state
		public static const ZIG_ZAG_WANDER:IZigZagAgentState = new ZigZagWanderState();		// wander state
		public static const ZIG_ZAG_PANIC:IZigZagAgentState = new ZigZagPanicState();		// panic state
		public static const ZIG_ZAG_INJURED:IZigZagAgentState = new ZigZagInjuredState();	// injured state
		
		private var currentState:IZigZagAgentState;			// current state of agent
		private var previousState:IZigZagAgentState;		// prev state of agent
		
		public var health:AgentHealth;				// agent health object keeps track of health
		public var frameCount:uint = 0;				// frame count
		public var idleCycles:uint = 0;				// idle cycles counter
		public var zigZagCycles:uint = 0;			// zig zag cycles
		public var agentText:TextField;				// agent text
		public var speed:Number = 0;				// agent speed
		public var velocity:Point = new Point();	// agent velocity
		public var bombDropped:Boolean = false;		// bomb dropped status
		
		private var walkingDirection:String = "None";	// walking direction state (string)
		private var none:ZigZagAgentDown;				// default idle image, displayed with CircularAgentDown
		
		// kinematics value sliders
		private var speedSlider:Number = 0.18; 
		private var thighRangeSlider:Number = 40; 
		private var thighBaseSlider:Number = 0;
		private var calfRangeSlider:Number = 40; 
		private var calfOffsetSlider:Number = 1.57; 
		private var armRangeSlider:Number = 15; 
		private var armBaseSlider:Number = 0;
		private var cycle:Number = 0;
		private var counter:uint = 0;
		private var leftUp:Boolean = true;
		private var rightUp:Boolean = false;
		private var walkOffset:Number = 5;
		
		// for left or right movement direction
		private var leftArmL:ZigZagLeftArm;
		private var rightArmL:ZigZagLeftArm;
		private var rightThighL:ZigZagLeftThigh;
		private var leftThighL:ZigZagLeftThigh;
		private var leftShinL:ZigZagLeftShin;
		private var rightShinL:ZigZagLeftShin;
		private var leftTorsoL:ZigZagLeftTorso;
		
		//for up movement direction
		private var leftArmU:ZigZagUpLeftArm;
		private var rightArmU:ZigZagUpRightArm;
		private var rightLegU:ZigZagUpRightLeg;
		private var leftLegU:ZigZagUpLeftLeg;
		private var torsoU:ZigZagUpTorso;
		
		//for down movement direction
		private var leftArmD:ZigZagDownLeftArm;
		private var rightArmD:ZigZagDownRightArm;
		private var rightLegD:ZigZagDownRightLeg;
		private var leftLegD:ZigZagDownLeftLeg;
		private var torsoD:ZigZagDownTorso;
		
		private var agentParts:Array = new Array();		// array to keep track of current parts of agent
				
		// zig zag agent constructor
		public function ZigZagAgent() {
			init();
		}
		
		// zig zag agent initialization
		private function init():void {
			addHealthBar();
			currentState = ZIG_ZAG_IDLE;
			agentText = new TextField();
			agentText.defaultTextFormat = new TextFormat("Silom", 10);
			agentText.autoSize = TextFieldAutoSize.CENTER;
			agentText.x = this.x;
			agentText.y = this.y + 50;
			addChild(agentText);
			
			none = new ZigZagAgentDown();
			agentParts.push(none);
			addChild(none);
		}
		
		// updates state of current agent
		public function update():void {
			if (!currentState) {
				return;
			}
			currentState.update(this);
			
			x += velocity.x*speed;
			y += velocity.y*speed;
			if (x + velocity.x > stage.stageWidth || x + velocity.x < 0) {
				x = Math.max(0, Math.min(stage.stageWidth, x));
				velocity.x *= -1;
				findMovementDirection();
			}
			if (y + velocity.y > stage.stageHeight - 158.75 || y + velocity.y < 0) {
				y = Math.max(0, Math.min(stage.stageHeight, y));
				velocity.y *= -1;
				findMovementDirection();
			}
			
			if (walkingDirection == "Left") {
				walkLeftOrRight(rightThighL, rightShinL, cycle, thighRangeSlider, -calfRangeSlider);
				walkLeftOrRight(leftThighL, leftShinL, cycle + Math.PI, thighRangeSlider, -calfRangeSlider);
				swingLeftOrRight(leftArmL, rightArmL, cycle, armBaseSlider);
				cycle += speedSlider;
			}  else if (walkingDirection == "Right") {
				walkLeftOrRight(rightThighL, rightShinL, cycle, -thighRangeSlider, calfRangeSlider);
				walkLeftOrRight(leftThighL, leftShinL, cycle + Math.PI, -thighRangeSlider, calfRangeSlider);
				swingLeftOrRight(leftArmL, rightArmL, cycle, -armBaseSlider);
				cycle += speedSlider;
			} else if (walkingDirection == "Up") {
				walkUp();
			} else if (walkingDirection == "Down") {
				walkDown();
			}
			counter++;
		}
		
		// sets state of agent, finds movement direction
		public function setState(newState:IZigZagAgentState):void {
			if (currentState == newState) {
				return;
			}
			if (currentState) {
				currentState.exit(this);
			}
			previousState = currentState;
			currentState = newState;
			currentState.enter(this);
			findMovementDirection();
		}
		
		// returns current state
		public function getCurrentState():IZigZagAgentState {
			return currentState;
		}
		
		// returns previous state
		public function getPreviousState():IZigZagAgentState {
			return previousState;
		}
		
		// adds health bar to agent
		private function addHealthBar():void {
			health = new AgentHealth();
			health.y = this.y - 60;
			addChild(health);
		}
		
		// chooses a random direction (random velocity) for agent
		public function randomDirection():void {
			var a:Number = Math.random() * 6.28;
			velocity.x = Math.cos(a);
			velocity.y = Math.sin(a);
		}
		
		// sets agent text
		public function say(string:String):void {
			agentText.text = string;
		}
		
		// reduces health of agent by damage parameter
		public function takeDamage(damage:Number):void {
			this.health.takeDamamge(damage);
		}
		
		// sets slider values, used in agent state classes
		public function setSliders(newSpeed:Number, newThighRange:Number, newCalfRange:Number, newCalfOffset:Number,
								   newArmRange:Number, newArmBase:Number):void {
			this.speedSlider = newSpeed;
			this.thighRangeSlider = newThighRange;
			this.calfRangeSlider = newCalfRange;
			this.calfOffsetSlider = newCalfOffset;
			this.armRangeSlider = newArmRange;
			this.armBaseSlider = newArmBase;
		}
		
		// sets walk offset value, used in agent state classes
		public function setWalkOffset(newWalkOffset:Number):void {
			this.walkOffset = newWalkOffset;
		}
		
		// calculates which direction agent is moving, sets walking direction and adds agent parts
		private function findMovementDirection():void {
			if (speed > 0) {
				if ((velocity.x < 0 && velocity.y < 0 && velocity.y/velocity.x > 1) ||
				    (velocity.x > 0 && velocity.y < 0 && velocity.y/velocity.x < -1)) {
								addUp();
								walkingDirection = "Up";
				} else if ((velocity.x > 0 && velocity.y > 0 && velocity.y/velocity.x < 1) ||
						   (velocity.x > 0 && velocity.y < 0 && velocity.y/velocity.x > -1)) {
								addRight();
								walkingDirection = "Right";
				} else if ((velocity.x < 0 && velocity.y > 0 && velocity.y/velocity.x < -1) ||
						   (velocity.x > 0 && velocity.y > 0 && velocity.y/velocity.x > 1)) {
								addDown();
								walkingDirection = "Down";
				} else if ((velocity.x < 0 && velocity.y > 0 && velocity.y/velocity.x > -1) ||
						   (velocity.x < 0 && velocity.y < 0 && velocity.y/velocity.x > -1)) {
								addLeft();
								walkingDirection = "Left";
				} else if (velocity.x > 0 && velocity.y == 0) {
								addRight();
								walkingDirection = "Right";
				} else if (velocity.x < 0 && velocity.y == 0) {
								addLeft();
								walkingDirection = "Left";
				} else if (velocity.x == 0 && velocity.y < 0) {
								addUp();
								walkingDirection = "Up";
				} else if (velocity.x == 0 && velocity.y > 0) {
								addDown();
								walkingDirection = "Down";
				}
			} else {
				addNone();
				walkingDirection = "None";
			}
		}
		
		// adds pieces of agent when moving left
		private function addLeft():void {
			clearArray();
			rightArmL = new ZigZagLeftArm();
			rightThighL = new ZigZagLeftThigh();
			rightShinL = new ZigZagLeftShin();
			leftThighL = new ZigZagLeftThigh();
			leftShinL = new ZigZagLeftShin();
			leftTorsoL = new ZigZagLeftTorso();
			leftArmL = new ZigZagLeftArm();
			agentParts.push(rightArmL);
			agentParts.push(rightThighL);
			agentParts.push(rightShinL);
			agentParts.push(leftThighL);
			agentParts.push(leftShinL);
			agentParts.push(leftTorsoL);
			agentParts.push(leftArmL);
			addChild(rightArmL);
			addChild(rightThighL);
			addChild(rightShinL);
			addChild(leftThighL);
			addChild(leftShinL);
			addChild(leftTorsoL);
			addChild(leftArmL);
			leftTorsoL.y = -50;
		}
		
		// adds pieces of agent when moving right
		// same function as addLeft() but scaleX *= -1 to change direction of mc's
		private function addRight():void {
			clearArray();
			leftArmL = new ZigZagLeftArm();
			leftThighL = new ZigZagLeftThigh();
			leftShinL = new ZigZagLeftShin();
			rightThighL = new ZigZagLeftThigh();
			rightShinL = new ZigZagLeftShin();
			leftTorsoL = new ZigZagLeftTorso();
			rightArmL = new ZigZagLeftArm();
			agentParts.push(leftArmL);
			agentParts.push(leftThighL);
			agentParts.push(leftShinL);
			agentParts.push(rightThighL);
			agentParts.push(rightShinL);
			agentParts.push(leftTorsoL);
			agentParts.push(rightArmL);
			addChild(leftArmL);
			addChild(leftThighL);
			addChild(leftShinL);
			addChild(rightThighL);
			addChild(rightShinL);
			addChild(leftTorsoL);
			addChild(rightArmL);
			leftTorsoL.y = -50;
			leftArmL.scaleX *= -1;
			leftThighL.scaleX *= -1;
			leftShinL.scaleX *= -1;
			rightThighL.scaleX *= -1;
			rightShinL.scaleX *= -1;
			leftTorsoL.scaleX *= -1;
			rightArmL.scaleX *= -1;
		}
		
		// adds pieces of agent when moving up
		private function addUp():void {
			clearArray();
			rightLegU = new ZigZagUpRightLeg();
			leftLegU = new ZigZagUpLeftLeg();
			torsoU = new ZigZagUpTorso();
			leftArmU = new ZigZagUpLeftArm();
			rightArmU = new ZigZagUpRightArm();
			agentParts.push(rightLegU);
			agentParts.push(leftLegU);
			agentParts.push(torsoU);
			agentParts.push(leftArmU);
			agentParts.push(rightArmU);
			addChild(rightLegU);
			addChild(leftLegU);
			addChild(torsoU);
			addChild(leftArmU);
			addChild(rightArmU);
		}
		
		// adds pieces of agent when moving down
		private function addDown():void {
			clearArray();
			rightLegD = new ZigZagDownRightLeg();
			leftLegD = new ZigZagDownLeftLeg;
			torsoD = new ZigZagDownTorso();
			leftArmD = new ZigZagDownLeftArm();
			rightArmD = new ZigZagDownRightArm();
			agentParts.push(rightLegD);
			agentParts.push(leftLegD);
			agentParts.push(torsoD);
			agentParts.push(leftArmD);
			agentParts.push(rightArmD);
			addChild(rightLegD);
			addChild(leftLegD);
			addChild(torsoD);
			addChild(leftArmD);
			addChild(rightArmD);
		}
		
		// adds piece of agent when idle
		private function addNone():void {
			clearArray();
			none = new ZigZagAgentDown();
			agentParts.push(none);
			addChild(none);
		}
		
		// clears all pieces of agent so new pieces can be added and displayed
		private function clearArray():void {
			for (var i:uint = 0; i < agentParts.length; i++) {
				removeChild(agentParts[i]);
				agentParts.removeAt(i);
				i--;
			}
		}
		
		// handles kinematics of legs for left and right movement
		private function walkLeftOrRight(mc_A:ZigZagLeftThigh, mc_B:ZigZagLeftShin, cyc:Number, thighRangeSliderVal:Number, calfRangeSliderVal:Number):void {
			var angleA:Number = Math.sin(cyc) * thighRangeSliderVal + thighBaseSlider;
			var angleB:Number = Math.sin(cyc + calfOffsetSlider) * calfRangeSliderVal + calfRangeSliderVal;
			mc_A.rotation = angleA;
			mc_A.x = leftTorsoL.x;
			mc_A.y = leftTorsoL.y + leftTorsoL.height;			
			mc_B.x = mc_A.x - 10 * Math.sin((angleA*(Math.PI / 180)));
			mc_B.y = mc_A.y + 14 * Math.cos((angleA*(Math.PI / 180)));
			mc_B.rotation = mc_A.rotation + angleB;
		}
		
		// handles kinematics of arms for left or right movement
		private function swingLeftOrRight(mc_C:ZigZagLeftArm, mc_D:ZigZagLeftArm, cyc:Number, armBaseSliderVal:Number):void {
			var angleC:Number = Math.sin(cyc) * armRangeSlider + armBaseSliderVal;
			var angleD:Number = Math.sin(cyc + Math.PI + calfOffsetSlider) * armRangeSlider + armBaseSliderVal;
			mc_C.rotation = angleC;
			mc_D.rotation = mc_C.rotation + angleD;
			mc_C.x = leftTorsoL.x;
			mc_C.y = leftTorsoL.y + leftTorsoL.height / 2;			
			mc_D.x = leftTorsoL.x;
			mc_D.y = leftTorsoL.y + leftTorsoL.height / 2;
		}
		
		// handles walking in upward direction
		private function walkUp():void {
			if (counter % walkOffset == 0) {
				leftUp = !leftUp;
				rightUp = !rightUp;
			}
			if (leftUp) {
				leftLegU.y = 0;
				rightLegU.y = -4;
			}
			if (rightUp) {
				rightLegU.y = 0;
				leftLegU.y = -4;
			}
		}
		
		// handles walking in downward direction
		private function walkDown():void {
			if (counter % walkOffset == 0) {
				leftUp = !leftUp;
				rightUp = !rightUp;
			}
			if (leftUp) {
				leftLegD.y = 0;
				rightLegD.y = -4;
			}
			if (rightUp) {
				rightLegD.y = 0;
				leftLegD.y = -4;
			}
		}
		
	}
}