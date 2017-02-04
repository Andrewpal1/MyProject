package lib.FreedomInbound {
	import lib.FreedomInbound.Intro.IntroClip;
	import lib.FreedomInbound.Bombs.BombSelectionBar;
	import lib.FreedomInbound.Feedback.PointsFeedback;
	import lib.FreedomInbound.Backgrounds.*;
	import lib.FreedomInbound.Bombs.*;
	import lib.FreedomInbound.Agents.AgentHealth;
	import lib.FreedomInbound.Agents.StraightAgent.StraightAgent;
	import lib.FreedomInbound.Agents.ZigZagAgent.ZigZagAgent;
	import lib.FreedomInbound.Agents.CircularAgent.CircularAgent;
	import flash.net.SharedObject;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import fl.motion.Color;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	// Main class that handles Freedom Inbound gameplay
	public class Main extends MovieClip {
		
		private static const EMPTY:String = "Empty";			// bomb selection empty state
		private static const BOMB1:String = "Bomb1";			// bomb selection Bomb1 state
		private static const BOMB2:String = "Bomb2";			// bomb selection Bomb2 state
		private static const BOMB3:String = "Bomb3";			// bomb selection Bomb3 state
		
		private var introClip:IntroClip;						// intro clip to be played when game launches
		private var introTimer:Timer;							// intro clip timer to launch main menu
		
		private var straightAgents:Number = 1;					// count of straight agents to be added
		private var circularAgents:Number = 1;					// count of circular agents to be added
		private var zigZagAgents:Number = 1;					// count of zig zag agents to be added
		private var level:Number = 1;							// current level
		
		private var frameCount:Number = 0;						// frame count
		
		private var pointsText:TextField;						// text field to display player points
		private var levelText:TextField = new TextField();		// text field to display level
		private var bomb1CountText:TextField = new TextField(); // text field to display bomb 1 count
		private var bomb2CountText:TextField = new TextField();	// text field to display bomb 2 count
		private var bomb3CountText:TextField = new TextField(); // text field to display bomb 3 count
		
		private var bomb1Count:uint;							// bomb type 1 count
		private var bomb2Count:uint;							// bomb type 2 count
		private var bomb3Count:uint;							// bomb type 3 count
		
		private var bomb1Cost:uint = 50;						// bomb type 1 cost
		private var bomb2Cost:uint = 275;						// bomb type 2 cost
		private var bomb3Cost:uint = 1000;						// bomb type 3 cost
		
		private var pointsPerKill:uint = 125;					// points per kill
		
		private var highScoreData:SharedObject = SharedObject.getLocal("sharedStorage");	// stores high score data
		
		private var points:uint;								// player points
		private var currentBombSelection:String;				// current bomb selection
				
		private var backgroundMusic:Sound;						// song to be played
		private var bomb1Sound:Sound = new Sound(new URLRequest("155235__zangrutz__bomb-small.mp3"));
		private var bomb2Sound:Sound = new Sound(new URLRequest("259300__unfa__huge-explosion.mp3"));
		private var bomb3Sound:Sound = new Sound(new URLRequest("245372__quaker540__hq-explosion.mp3"));
		private var purchaseSound:Sound = new Sound(new URLRequest("254948_thecityrings_mysound-gwech-dphotographyclas.mp3"));
		private var channel:SoundChannel;						// sound channel to keep track of state of song
		
		private var feedbackPoints:Array = new Array();			// array of feedback, used to remove feedback from stage
		
		private var agents:Array;								// array of agents, used to remove agents from stage
		private var straightAgent:StraightAgent;				// straight agent
		private var zigZagAgent:ZigZagAgent;					// zig zag agent
		private var circularAgent:CircularAgent;				// circular agent
		
		private var bombType1Button:BombType1Button;			// bomb type 1 selection button
		private var bombType2Button:BombType2Button;			// bomb type 2 selection button
		private var bombType3Button:BombType3Button;			// bomb type 3 selection button
				
		private var bomb1:BombType1;							// bomb type 1
		private var bomb2:BombType2;							// bomb type 2
		private var bomb3:BombType3;							// bomb type 3
		private var crater:Crater;								// crater mc, displays image

		private var bombDropped:Boolean = false;				// bomb has been dropped status
		
		// start menu screen, adds music
		public function Main():void {
			addIntroClip();
			introTimer = new Timer(14000, 0);
			introTimer.addEventListener(TimerEvent.TIMER, timer);
			introTimer.start();
		}
		
		// timer to go to main menu after intro clip
		public function timer(evt:TimerEvent):void {
			removeEventListener(TimerEvent.TIMER, timer);
			introTimer.stop();
			addMainMenu();
		}
		
		// add intro and play intro clip
		private function addIntroClip():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT; //exactFit (EXACT_FIT), noBorder (NO_BORDER), noScale (NO_SCALE), showAll (SHOW_ALL)
			introClip = new IntroClip(); //20 seconds fade to black with intro text
			introClip.x = stage.stageWidth/2;
			introClip.y = stage.stageHeight/2;
			addChild(introClip);
		}
		
		// add main menu
		private function addMainMenu():void {
			clearStage();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT; //exactFit (EXACT_FIT), noBorder (NO_BORDER), noScale (NO_SCALE), showAll (SHOW_ALL)
			
			var mainMenu:MainMenu = new MainMenu();
			mainMenu.x = stage.stageWidth/2;
			mainMenu.y = stage.stageHeight/2;
			addChild(mainMenu);
			channel = new SoundChannel();
			backgroundMusic = new Sound();
			backgroundMusic.load(new URLRequest("Defense Line.mp3"));
			channel = backgroundMusic.play();
			channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
			mainMenu.startButton.addEventListener(MouseEvent.CLICK, startButtonPressed);
		}
		
		// initiates game, sets bomb counts to zero and points to default, goes to purchase menu
		private function startButtonPressed(evt:MouseEvent):void {
			clearStage();
			points = 2000;
			bomb1Count = 0;
			bomb2Count = 0;
			bomb3Count = 0;
			goToPurchaseMenu();
		}
		
		// goes to purchase menu, sets bomb counts to 0
		private function goToPurchaseMenu():void {
			clearStage();
			var purchaseMenu:PurchaseMenu = new PurchaseMenu();
			purchaseMenu.x = stage.stageWidth/2;
			purchaseMenu.y = stage.stageHeight/2;
			bomb1Count = 0;
			bomb2Count = 0;
			bomb3Count = 0;
			purchaseMenu.enemyCountText.text = "Total Enemies Next Round: " + (straightAgents + circularAgents + zigZagAgents).toString();
			addChild(purchaseMenu);
			purchaseMenu.bomb1PointsText.text = bomb1Cost.toString();
			purchaseMenu.bomb2PointsText.text = bomb2Cost.toString();
			purchaseMenu.bomb3PointsText.text = bomb3Cost.toString();
			pointsText = new TextField();
			pointsText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			pointsText.autoSize = TextFieldAutoSize.CENTER;
			pointsText.x = stage.stageWidth/2;
			pointsText.y = 120;
			pointsText.text = "Points: " + points.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(pointsText);
			
			bomb1CountText = new TextField();
			bomb1CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb1CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb1CountText.x = 290;
			bomb1CountText.y = 535;
			bomb1CountText.text = bomb1Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb1CountText);
			
			bomb2CountText = new TextField();
			bomb2CountText = new TextField();
			bomb2CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb2CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb2CountText.x = 750;
			bomb2CountText.y = 535;
			bomb2CountText.text = bomb2Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb2CountText);
			
			bomb3CountText = new TextField();
			bomb3CountText = new TextField();
			bomb3CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb3CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb3CountText.x = 1225;
			bomb3CountText.y = 535;
			bomb3CountText.text = bomb3Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb3CountText);
			
			purchaseMenu.bomb1Button.addEventListener(MouseEvent.CLICK, purchaseBomb1);
			purchaseMenu.bomb2Button.addEventListener(MouseEvent.CLICK, purchaseBomb2);
			purchaseMenu.bomb3Button.addEventListener(MouseEvent.CLICK, purchaseBomb3);
			purchaseMenu.advanceButton.addEventListener(MouseEvent.CLICK, startNextLevel);
		}
		
		// starts next level
		private function startNextLevel(evt:MouseEvent):void {
			clearStage();
			bombDropped = false;
			if (pointsPerKill > 20) {
				pointsPerKill -= 3; 
			} else {
				pointsPerKill = 20;
			}
			if (level == 1) {
				pointsPerKill = 125;
			}
			startFirstLevel(straightAgents, zigZagAgents, circularAgents, level);
		}
		
		// starts level with parameters to determine count of each type of enemy and what level player is on (method name is misleading)
		private function startFirstLevel(straight:Number, zigZag:Number, circular:Number, levelNumber:Number):void {
			clearStage();
			
			addBackground();
			addBombSelectionBar();
			levelText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			levelText.autoSize = TextFieldAutoSize.LEFT;
			levelText.x = 0;
			levelText.y = 0;
			levelText.text = "Level: " + level.toString();
			addChild(levelText);
			
			currentBombSelection = EMPTY;
			
			bomb1 = new BombType1();
			bomb2 = new BombType2();
			bomb3 = new BombType3();
						
			removeEventListener(Event.ADDED_TO_STAGE, startNextLevel);
			agents = new Array();
			
			feedbackPoints = new Array();
			
			for (var i:uint = 0; i < straightAgents; i++) {
				addStraightAgent(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight - 158.75);
				addZigZagAgent(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight - 158.75);
				addCircularAgent(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight - 158.75);
			}
			addBombButtons();
			addBombInfo();
			
			pointsText = new TextField();
			pointsText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			pointsText.autoSize = TextFieldAutoSize.CENTER;
			pointsText.x = stage.stageWidth/2;
			pointsText.text = "Points: " + points.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(pointsText);
			
			addEventListener(MouseEvent.CLICK, dropBomb);
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		// loops through agents, updating states each frame, checks if level is completed or failed
		private function gameLoop(event:Event):void {
			for (var i:int = 0; i < agents.length; i++) {
				agents[i].update();
				if (agents[i].health.getHealth() <= 0) {
					addFeedback(agents[i].x, agents[i].y);
					removeChild(agents[i]);
					agents.removeAt(i);
					points += pointsPerKill;
					pointsText.text = "Points: " + points.toString();
				}
			}
			
			for (var j:int = 0; j < feedbackPoints.length; j++) {
				if (feedbackPoints[j].isReadyToRemove()) {
					removeChild(feedbackPoints[j]);
					feedbackPoints.removeAt(j);
				}
			}
			
			if (agents.length <= 0) {
				if (frameCount >= 24) {
					firstLevelCompleted();
				} else {
					frameCount++;
				}
			}
			
			if (bomb1Count <= 0 && bomb2Count <= 0 && bomb3Count <= 0 && agents.length > 0) {
				if (frameCount >= 24) {
					loseCondition();
				} else {
					frameCount++;
				}
			}
		}
		
		// resets state of game and goes to main menu
		private function resetGame(evt:Event):void {
			clearStage();
			straightAgents = 1;
			zigZagAgents = 1;
			circularAgents = 1;
			level = 1;
			frameCount = 0;
			var mainMenu:MainMenu = new MainMenu();
			mainMenu.x = stage.stageWidth/2;
			mainMenu.y = stage.stageHeight/2;
			addChild(mainMenu);
			mainMenu.startButton.addEventListener(MouseEvent.CLICK, startButtonPressed);
		}
		
		// clears stage and goes to purhcase menu, checks to see if player set a high score
		private function firstLevelCompleted():void {
			removeEventListener(MouseEvent.CLICK, dropBomb);
			removeEventListener(Event.ENTER_FRAME, gameLoop);
			currentBombSelection = EMPTY;
			clearStage();
			if (straightAgents < 40) {
				straightAgents++;
				zigZagAgents++;
				circularAgents++;
			}
			level++;
			frameCount = 0;
			goToPurchaseMenu();
		}
		
		// handles lose condition of game, goes to lose menu
		private function loseCondition():void {
			currentBombSelection = EMPTY;
			removeEventListener(Event.ENTER_FRAME, gameLoop);
			clearStage();

			if (highScoreData.data.highScoreLevel == null) {	// first time highScoreData is accessed
				highScoreData.data.highScoreLevel = 0;
				highScoreData.data.highScorePoints = 0;
			}
			
			if (level > highScoreData.data.highScoreLevel) {
				highScoreData.data.highScoreLevel = level;
				highScoreData.data.highScorePoints = points;
				highScoreData.flush();
			} else if (level == highScoreData.data.highScoreLevel) {
				highScoreData.data.highScoreLevel = level;
				if (points > highScoreData.data.highScorePoints) {
					highScoreData.data.highScorePoints = points;
				}
				highScoreData.flush();
			}
			
			var loseMenu:LoseMenu = new LoseMenu();

			loseMenu.width = 1334;
			loseMenu.height = 750;
			loseMenu.x = 1334/2;
			loseMenu.y = 750/2;
			levelText.text = "You survived " + level.toString() + " level(s)!\nand earned " + points.toString() + " points!";
			loseMenu.loseText.text = levelText.text;
			loseMenu.highScoreText.text = "High Score: " + highScoreData.data.highScoreLevel.toString() + " level(s) with " + highScoreData.data.highScorePoints.toString() + " points";
			addChild(loseMenu);
			
			loseMenu.playAgainButton.addEventListener(MouseEvent.CLICK, resetGame);
		}
		
		// adds straight moving enemy to stage
		private function addStraightAgent(xPos:Number, yPos:Number):void {
			straightAgent = new StraightAgent();
			straightAgent.x = xPos;
			straightAgent.y = yPos;
			addChild(straightAgent);
			agents.push(straightAgent);
		}
		
		// adds zig zag moving enemy to stage
		private function addZigZagAgent(xPos:Number, yPos:Number):void {
			zigZagAgent = new ZigZagAgent();
			zigZagAgent.x = xPos;
			zigZagAgent.y = yPos;
			addChild(zigZagAgent);
			agents.push(zigZagAgent);
		}
		
		// adds circular moving enemy to stage
		private function addCircularAgent(xPos:Number, yPos:Number):void {
			circularAgent = new CircularAgent();
			circularAgent.x = xPos;
			circularAgent.y = yPos;
			addChild(circularAgent);
			agents.push(circularAgent);
		}
		
		// adds background image to stage
		private function addBackground():void {
			var random:Number = Math.random() * 3;	// multiply by number of background images being randomized
			if (random <= 1) {
				var background1:BackgroundOne = new BackgroundOne();
				background1.x = stage.stageWidth/2;
				background1.y = stage.stageHeight/2;
				addChild(background1);
			} else if (random <= 2) {
				var background2:BackgroundTwo = new BackgroundTwo();
				background2.x = stage.stageWidth/2;
				background2.y = stage.stageHeight/2;
				addChild(background2);
			} else if (random <= 3) {
				var background3:BackgroundThree = new BackgroundThree();
				background3.x = stage.stageWidth/2;
				background3.y = stage.stageHeight/2;
				addChild(background3);
			}
		}
		
		// adds bomb buttons to stage
		private function addBombButtons():void {
			bombType1Button = new BombType1Button();
			bombType1Button.x = 65;
			bombType1Button.y = stage.stageHeight - 5;
			bombType1Button.addEventListener(MouseEvent.CLICK, setBomb1Selection);
			addChild(bombType1Button);
			bomb1CountText = new TextField();
			bomb1CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb1CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb1CountText.x = bombType1Button.x - 35;
			bomb1CountText.y = bombType1Button.y - 80;
			bomb1CountText.text = bomb1Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb1CountText);
			
			bombType2Button = new BombType2Button();
			bombType2Button.x = 565;
			bombType2Button.y = stage.stageHeight - 5;
			bombType2Button.addEventListener(MouseEvent.CLICK, setBomb2Selection);
			addChild(bombType2Button);
			bomb2CountText = new TextField();
			bomb2CountText = new TextField();
			bomb2CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb2CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb2CountText.x = bombType2Button.x - 35;
			bomb2CountText.y = bombType2Button.y - 80;
			bomb2CountText.text = bomb2Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb2CountText);
			
			bombType3Button = new BombType3Button();
			bombType3Button.x = 1065;
			bombType3Button.y = stage.stageHeight - 5;
			bombType3Button.addEventListener(MouseEvent.CLICK, setBomb3Selection);
			addChild(bombType3Button);
			bomb3CountText = new TextField();
			bomb3CountText = new TextField();
			bomb3CountText.defaultTextFormat = new TextFormat("Silom", 48, 0xFF00FF);
			bomb3CountText.autoSize = TextFieldAutoSize.CENTER;
			bomb3CountText.x = bombType3Button.x - 35;
			bomb3CountText.y = bombType3Button.y - 80;
			bomb3CountText.text = bomb3Count.toString();
			pointsText.type = TextFieldType.DYNAMIC;
			addChild(bomb3CountText);
		}
		
		// adds bomb information text next to bomb buttons
		private function addBombInfo():void {
			var bomb1InfoText:TextField = new TextField();
			bomb1InfoText.x = bombType1Button.x + 110;
			bomb1InfoText.y = bombType1Button.y - 105;
			bomb1InfoText.defaultTextFormat = new TextFormat("Silom", 10);
			bomb1InfoText.autoSize = TextFieldAutoSize.LEFT;
			bomb1InfoText.text = bomb1.getBombInfo();
			addChild(bomb1InfoText);
			
			var bomb2InfoText:TextField = new TextField();
			bomb2InfoText.x = bombType2Button.x + 110;
			bomb2InfoText.y = bombType2Button.y - 105;
			bomb2InfoText.defaultTextFormat = new TextFormat("Silom", 10);
			bomb2InfoText.autoSize = TextFieldAutoSize.LEFT;
			bomb2InfoText.text = bomb2.getBombInfo();
			addChild(bomb2InfoText);
			
			var bomb3InfoText:TextField = new TextField();
			bomb3InfoText.x = bombType3Button.x + 110;
			bomb3InfoText.y = bombType3Button.y - 105;
			bomb3InfoText.defaultTextFormat = new TextFormat("Silom", 10);
			bomb3InfoText.autoSize = TextFieldAutoSize.LEFT;
			bomb3InfoText.text = bomb3.getBombInfo();
			addChild(bomb3InfoText);
		}
		
		// adds feedback, used when enemy is killed to display points earned on the kill
		private function addFeedback(xPos:Number, yPos:Number):void {
			var pointsFeedback:PointsFeedback = new PointsFeedback("+" + pointsPerKill);
			pointsFeedback.x = xPos;
			pointsFeedback.y = yPos - 50;
			feedbackPoints.push(pointsFeedback);
			addChild(pointsFeedback);
		}
		
		// adds bomb selection bar
		private function addBombSelectionBar():void {
			var bombSelectionBar:BombSelectionBar = new BombSelectionBar();
			bombSelectionBar.x = 1;
			bombSelectionBar.y = stage.stageHeight - 108.75;
			addChild(bombSelectionBar);
		}
		
		// sets current bomb selection to Bomb1
		private function setBomb1Selection(evt:MouseEvent):void {
			currentBombSelection = BOMB1;
		}
		
		// sets current bomb selection to Bomb2
		private function setBomb2Selection(evt:MouseEvent):void {
			currentBombSelection = BOMB2;
		}
		
		// sets current bomb selection to Bomb3
		private function setBomb3Selection(evt:MouseEvent):void {
			currentBombSelection = BOMB3;
		}
		
		// checks to see if bomb can be dropped, adds bomb to stage if true
		private function dropBomb(evt:MouseEvent):void {
			if (mouseY < 641.25 && validBomb()) {
				if (!bombDropped) {
					bombDropped = true;
					for each (var agent:MovieClip in agents) {
						agent.bombDropped = true;
					}
				}
				if (currentBombSelection == BOMB1) {
					bomb1Sound.play();
					bomb1Count--;
					bomb1CountText.text = bomb1Count.toString();
					bomb1 = new BombType1();
					bomb1.x = mouseX;
					bomb1.y = mouseY;
					addChild(bomb1);
					bomb1.gotoAndPlay(2);
					crater = new Crater();
					crater.x = bomb1.x;
					crater.y = bomb1.y;
					crater.width = 100;
					crater.height = 100;
					addChildAt(crater, 1);
					for (var i:uint = 0; i < agents.length; i++) {
						agents[i].takeDamage(bomb1.getDamage(calculateDistanceToAgent(agents[i].x, agents[i].y)));
					}
				} else if (currentBombSelection == BOMB2) {
					bomb2Sound.play();
					bomb2Count--;
					bomb2CountText.text = bomb2Count.toString();
					bomb2 = new BombType2();
					bomb2.x = mouseX;
					bomb2.y = mouseY;
					addChild(bomb2);
					bomb2.gotoAndPlay(2);
					crater = new Crater();
					crater.x = bomb2.x;
					crater.y = bomb2.y;
					crater.width = 300;
					crater.height = 300;
					addChildAt(crater, 1);
					for (var j:uint = 0; j < agents.length; j++) {
						agents[j].takeDamage(bomb2.getDamage(calculateDistanceToAgent(agents[j].x, agents[j].y)));
					}
				} else if (currentBombSelection == BOMB3) {
					bomb3Sound.play();
					bomb3Count--;
					bomb3CountText.text = bomb3Count.toString();
					bomb3 = new BombType3();
					bomb3.x = mouseX;
					bomb3.y = mouseY;
					addChild(bomb3);
					bomb3.gotoAndPlay(2);
					crater = new Crater();
					crater.x = bomb3.x;
					crater.y = bomb3.y;
					crater.width = 600;
					crater.height = 600;
					addChildAt(crater, 1);
					for (var k:uint = 0; k < agents.length; k++) {
						agents[k].takeDamage(bomb3.getDamage(calculateDistanceToAgent(agents[k].x, agents[k].y)));
					}
				}
			}
		}
		
		// returns distance agent is away from bomb that is dropped
		private function calculateDistanceToAgent(agentX:Number, agentY:Number):Number {
			return Math.sqrt((mouseX - agentX)*(mouseX - agentX)) + Math.sqrt((mouseY - agentY)*(mouseY-agentY));
		}
		
		// returns if bomb is available to be dropped
		private function validBomb():Boolean {
			if (currentBombSelection == BOMB1) {
				return bomb1Count > 0;
			} else if (currentBombSelection == BOMB2) {
				return bomb2Count > 0;
			} else if (currentBombSelection == BOMB3) {
				return bomb3Count > 0;
			} else {
				return false;
			}
		}
		
		// purchases bomb type 1 with points
		private function purchaseBomb1(evt:MouseEvent):void {
			if (points >= bomb1Cost) {
				purchaseSound.play();
				points -= bomb1Cost;
				bomb1Count++;
				bomb1CountText.text = bomb1Count.toString();
				pointsText.text = "Points: " + points.toString();
			}
		}
		
		// purchases bomb type 2 with points
		private function purchaseBomb2(evt:MouseEvent):void {
			if (points >= bomb2Cost) {
				purchaseSound.play();
				points -= bomb2Cost;
				bomb2Count++;
				bomb2CountText.text = bomb2Count.toString();
				pointsText.text = "Points: " + points.toString();
			}
		}
		
		// purchases bomb type 3 with points
		private function purchaseBomb3(evt:MouseEvent):void {
			if (points >= bomb3Cost) {
				purchaseSound.play();
				points -= bomb3Cost;
				bomb3Count++;
				bomb3CountText.text = bomb3Count.toString();
				pointsText.text = "Points: " + points.toString();
			}
		}
		
		// clears all movieclips from stage
		private function clearStage():void {
			var i:int = this.numChildren;
			while (i--) {
				removeChildAt(i);
			}
		}
		
		// restarts music
        private function playMusic():void {
            channel = backgroundMusic.play();
            channel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
        }

        // calls playMusic method
        private function loopMusic(evt:Event):void {
            if (channel != null) {
                channel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
                playMusic();
            }
        }

	}
	
}