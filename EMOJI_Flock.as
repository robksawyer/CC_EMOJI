﻿package  {	import flash.display.MovieClip;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		import flash.display.Loader;	import flash.events.Event;	import flash.events.IEventDispatcher;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.net.URLRequest;		import flash.utils.getDefinitionByName;	import flash.utils.getQualifiedClassName;		//Flint Particles	import org.flintparticles.twoD.renderers.BitmapRenderer;	import org.flintparticles.twoD.emitters.Emitter2D;	import org.flintparticles.common.initializers.SharedImages;	import org.flintparticles.common.counters.*;	import org.flintparticles.twoD.actions.*;	import org.flintparticles.twoD.initializers.*;	import org.flintparticles.twoD.zones.*;		//Logging	import com.demonsters.debugger.MonsterDebugger;		//import the Resolume communication classes	//make sure you have added the source path to these files in the ActionScript 3 Preferences of Flash	import resolumeCom.*;	import resolumeCom.parameters.*;	import resolumeCom.events.*;		public class EMOJI_Flock extends MovieClip 	{				/*****************TEST PARAMS********************/				private static var TESTING:Boolean = false;				/************************************************/						/*****************PRIVATE********************/		/**		* Create the resolume object that will do all the hard work for you.		*/		private var resolume:Resolume = new Resolume();				/**		* Examples of parameters that can be used inside of Resolume		*/		/*private var paramScaleX:FloatParameter = resolume.addFloatParameter("Scale X", 0.5);		private var paramScaleY:FloatParameter = resolume.addFloatParameter("Scale Y", 0.5);		private var paramRotate:FloatParameter = resolume.addFloatParameter("Rotate", 0.0);		private var paramFooter:StringParameter = resolume.addStringParameter("Footer", "VJ BOB");		private var paramShowBackground:BooleanParameter = resolume.addBooleanParameter("Background", true);		private var paramShowSurprise:EventParameter = resolume.addEventParameter("Surprise!");*/				private var emojisInfo:Object = {										keys: new Array(48, 64, 96),								   		sizes: new Array("48x48","64x64","96x96"),								  		total: new Number(10) //total number of emojis is 1363										};												//Hold the actual emoji bitmap references per size in separate arrays		private var emojis:Array = new Array();		private var emojiSearchableData:Array = new Array();				//Flint		public var renderer:BitmapRenderer;		public var emitter:Emitter2D;				//Other Resolume Parameters		private var paramAccel:FloatParameter;		private var paramParticleCount:FloatParameter;				public static var EMOJI_SIZE:String = "96";				public function EMOJI_Flock():void		{			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						//Make a Flint renderer			renderer = new BitmapRenderer( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight ) );						// Start the MonsterDebugger			MonsterDebugger.initialize(this);						initData();						//Initialize the Resolume parameters			initParams();						//set callback, this will notify us when a parameter has changed			resolume.addParameterListener(paramChanged);						addEventListener(Event.ADDED_TO_STAGE, init);		}				/**		* Initialize data 		* - initialize all of the emojis bitmaps that are used in the plugin		*/		private function initData()		{			//			/*			* TODO: I wish I could get this to work.			* See: http://stackoverflow.com/questions/4103641/working-with-swcs-getdefinitionbyname-issue			* http://stackoverflow.com/questions/1023205/as3-embed-or-import-all-classes-in-an-external-swf-without-referencing-each-clas			*/			/*for(var j = 0; j < emojis.sizes.length; j++){				//Create an array for the different sized emojis				emojis.bitmapdata[j] = new Array();				emojis.bitmap[j] = new Array();								for(var i = 1; i < emojis.total; i++){					("Emoji_" + emojis.sizes[j] + "_" + i);					var ClassReference:Class = new (getDefinitionByName("Emoji_" + emojis.sizes[j] + "_" + i) as Class)();										MonsterDebugger.trace(this, ClassReference.toString());					MonsterDebugger.trace(this, "Emoji_"+emojis.sizes[0]+"_"+i);					//emojis.bitmapdata[j][i] = new dynClass(); 					//MonsterDebugger.trace(this, emojis.bitmapdata[j][i].toString());					//emojis.bitmap[j][i] = new Bitmap(emojis.bitmapdata[i]); 				}			}*/						emojis = [				{				  name: "Happy Face",				  id: 55,				  bitmap48: new Bitmap( new Emoji_48x48_55() ),				  bitmap96: new Bitmap( new Emoji_96x96_55() )				},				{				  name: "Santa Yellow",				  id: 509,				  bitmap48: new Bitmap( new Emoji_48x48_509() ),				  bitmap96: new Bitmap( new Emoji_96x96_509() )				},				{				  name: "Santa Whiter",				  id: 510,				  bitmap48: new Bitmap( new Emoji_48x48_510() ),				  bitmap96: new Bitmap( new Emoji_96x96_510() )				},				{				  name: "Santa White",				  id: 511,				  bitmap48: new Bitmap( new Emoji_48x48_511() ),				  bitmap96: new Bitmap( new Emoji_96x96_511() )				},				{				  name: "Santa Tan",				  id: 512,				  bitmap48: new Bitmap( new Emoji_48x48_512() ),				  bitmap96: new Bitmap( new Emoji_96x96_512() )				},				{				  name: "Santa Brown",				  id: 513,				  bitmap48: new Bitmap( new Emoji_48x48_513() ),				  bitmap96: new Bitmap( new Emoji_96x96_513() )				},				{				  name: "Santa Black",				  id: 514,				  bitmap48: new Bitmap( new Emoji_48x48_514() ),				  bitmap96: new Bitmap( new Emoji_96x96_514() )				},				{				  name: "Yellow Boy",				  id: 778,				  bitmap48: new Bitmap( new Emoji_48x48_778() ),				  bitmap96: new Bitmap( new Emoji_96x96_778() )				},				{				  name: "Whiter Boy",				  id: 779,				  bitmap48: new Bitmap( new Emoji_48x48_779() ),				  bitmap96: new Bitmap( new Emoji_96x96_779() )				},				{				  name: "White Boy",				  id: 780,				  bitmap48: new Bitmap( new Emoji_48x48_780() ),				  bitmap96: new Bitmap( new Emoji_96x96_780() )				},				{				  name: "Tan Boy",				  id: 781,				  bitmap48: new Bitmap( new Emoji_48x48_781() ),				  bitmap96: new Bitmap( new Emoji_96x96_781() )				},				{				  name: "Brown Boy",				  id: 782,				  bitmap48: new Bitmap( new Emoji_48x48_782() ),				  bitmap96: new Bitmap( new Emoji_96x96_782() )				},				{				  name: "Black Boy",				  id: 783,				  bitmap48: new Bitmap( new Emoji_48x48_783() ),				  bitmap96: new Bitmap( new Emoji_96x96_783() )				},				{				  name: "Yellow Girl",				  id: 784,				  bitmap48: new Bitmap( new Emoji_48x48_784() ),				  bitmap96: new Bitmap( new Emoji_96x96_784() )				},				{				  name: "Whiter Girl",				  id: 785,				  bitmap48: new Bitmap( new Emoji_48x48_785() ),				  bitmap96: new Bitmap( new Emoji_96x96_785() )				},				{				  name: "White Girl",				  id: 786,				  bitmap48: new Bitmap( new Emoji_48x48_786() ),				  bitmap96: new Bitmap( new Emoji_96x96_786() )				},				{				  name: "Tan Girl",				  id: 787,				  bitmap48: new Bitmap( new Emoji_48x48_787() ),				  bitmap96: new Bitmap( new Emoji_96x96_787() )				},				{				  name: "Brown Girl",				  id: 788,				  bitmap48: new Bitmap( new Emoji_48x48_788() ),				  bitmap96: new Bitmap( new Emoji_96x96_788() )				},				{				  name: "Black Girl",				  id: 789,				  bitmap48: new Bitmap( new Emoji_48x48_789() ),				  bitmap96: new Bitmap( new Emoji_96x96_789() )				},				{				  name: "Yellow Man",				  id: 790,				  bitmap48: new Bitmap( new Emoji_48x48_790() ),				  bitmap96: new Bitmap( new Emoji_96x96_790() )				},				{				  name: "Whiter Man",				  id: 791,				  bitmap48: new Bitmap( new Emoji_48x48_791() ),				  bitmap96: new Bitmap( new Emoji_96x96_791() )				},				{				  name: "White Man",				  id: 792,				  bitmap48: new Bitmap( new Emoji_48x48_792() ),				  bitmap96: new Bitmap( new Emoji_96x96_792() )				},				{				  name: "Tan Man",				  id: 793,				  bitmap48: new Bitmap( new Emoji_48x48_793() ),				  bitmap96: new Bitmap( new Emoji_96x96_793() )				},				{				  name: "Brown Man",				  id: 794,				  bitmap48: new Bitmap( new Emoji_48x48_794() ),				  bitmap96: new Bitmap( new Emoji_96x96_794() )				},				{				  name: "Black Man",				  id: 795,				  bitmap48: new Bitmap( new Emoji_48x48_795() ),				  bitmap96: new Bitmap( new Emoji_96x96_795() )				},				{				  name: "Yellow Woman",				  id: 796,				  bitmap48: new Bitmap( new Emoji_48x48_796() ),				  bitmap96: new Bitmap( new Emoji_96x96_796() )				},				{				  name: "Whiter Woman",				  id: 797,				  bitmap48: new Bitmap( new Emoji_48x48_797() ),				  bitmap96: new Bitmap( new Emoji_96x96_797() )				},				{				  name: "White Woman",				  id: 798,				  bitmap48: new Bitmap( new Emoji_48x48_798() ),				  bitmap96: new Bitmap( new Emoji_96x96_798() )				},				{				  name: "Tan Woman",				  id: 799,				  bitmap48: new Bitmap( new Emoji_48x48_799() ),				  bitmap96: new Bitmap( new Emoji_96x96_799() )				},				{				  name: "Brown Woman",				  id: 800,				  bitmap48: new Bitmap( new Emoji_48x48_800() ),				  bitmap96: new Bitmap( new Emoji_96x96_800() )				},				{				  name: "Black Woman",				  id: 801,				  bitmap48: new Bitmap( new Emoji_48x48_801() ),				  bitmap96: new Bitmap( new Emoji_96x96_801() )				},				{				  name: "Yellow Policeman",				  id: 820,				  bitmap48: new Bitmap( new Emoji_48x48_820() ),				  bitmap96: new Bitmap( new Emoji_96x96_820() )				},				{				  name: "Whiter Policeman",				  id: 821,				  bitmap48: new Bitmap( new Emoji_48x48_821() ),				  bitmap96: new Bitmap( new Emoji_96x96_821() )				},				{				  name: "White Policeman",				  id: 822,				  bitmap48: new Bitmap( new Emoji_48x48_822() ),				  bitmap96: new Bitmap( new Emoji_96x96_822() )				},				{				  name: "Tan Policeman",				  id: 823,				  bitmap48: new Bitmap( new Emoji_48x48_823() ),				  bitmap96: new Bitmap( new Emoji_96x96_823() )				},				{				  name: "Brown Policeman",				  id: 824,				  bitmap48: new Bitmap( new Emoji_48x48_824() ),				  bitmap96: new Bitmap( new Emoji_96x96_824() )				},				{				  name: "Black Policeman",				  id: 825,				  bitmap48: new Bitmap( new Emoji_48x48_825() ),				  bitmap96: new Bitmap( new Emoji_96x96_825() )				},				{				  name: "Bunny Dancers",				  id: 826,				  bitmap48: new Bitmap( new Emoji_48x48_826() ),				  bitmap96: new Bitmap( new Emoji_96x96_826() )				},				{				  name: "Yellow Bride",				  id: 827,				  bitmap48: new Bitmap( new Emoji_48x48_827() ),				  bitmap96: new Bitmap( new Emoji_96x96_827() )				},				{				  name: "Whiter Bride",				  id: 828,				  bitmap48: new Bitmap( new Emoji_48x48_828() ),				  bitmap96: new Bitmap( new Emoji_96x96_828() )				},				{				  name: "White Bride",				  id: 829,				  bitmap48: new Bitmap( new Emoji_48x48_829() ),				  bitmap96: new Bitmap( new Emoji_96x96_829() )				},				{				  name: "Tan Bride",				  id: 830,				  bitmap48: new Bitmap( new Emoji_48x48_830() ),				  bitmap96: new Bitmap( new Emoji_96x96_830() )				},				{				  name: "Brown Bride",				  id: 831,				  bitmap48: new Bitmap( new Emoji_48x48_831() ),				  bitmap96: new Bitmap( new Emoji_96x96_831() )				},				{				  name: "Black Bride",				  id: 832,				  bitmap48: new Bitmap( new Emoji_48x48_832() ),				  bitmap96: new Bitmap( new Emoji_96x96_832() )				},				{				  name: "Yellow Boy 2",				  id: 833,				  bitmap48: new Bitmap( new Emoji_48x48_833() ),				  bitmap96: new Bitmap( new Emoji_96x96_833() )				},				{				  name: "Whiter Boy 2",				  id: 834,				  bitmap48: new Bitmap( new Emoji_48x48_834() ),				  bitmap96: new Bitmap( new Emoji_96x96_834() )				},				{				  name: "White Boy 2",				  id: 835,				  bitmap48: new Bitmap( new Emoji_48x48_835() ),				  bitmap96: new Bitmap( new Emoji_96x96_835() )				},				{				  name: "Tan Boy 2",				  id: 836,				  bitmap48: new Bitmap( new Emoji_48x48_836() ),				  bitmap96: new Bitmap( new Emoji_96x96_836() )				},				{				  name: "Brown Boy 2",				  id: 837,				  bitmap48: new Bitmap( new Emoji_48x48_837() ),				  bitmap96: new Bitmap( new Emoji_96x96_837() )				},				{				  name: "Black Boy 2",				  id: 838,				  bitmap48: new Bitmap( new Emoji_48x48_838() ),				  bitmap96: new Bitmap( new Emoji_96x96_838() )				},				{				  name: "Yellow Man w/Skullcap",				  id: 839,				  bitmap48: new Bitmap( new Emoji_48x48_839() ),				  bitmap96: new Bitmap( new Emoji_96x96_839() )				},				{				  name: "Whiter Man w/Skullcap",				  id: 840,				  bitmap48: new Bitmap( new Emoji_48x48_840() ),				  bitmap96: new Bitmap( new Emoji_96x96_840() )				},				{				  name: "White Man w/Skullcap",				  id: 841,				  bitmap48: new Bitmap( new Emoji_48x48_841() ),				  bitmap96: new Bitmap( new Emoji_96x96_841() )				},				{				  name: "Tan Man w/Skullcap",				  id: 842,				  bitmap48: new Bitmap( new Emoji_48x48_842() ),				  bitmap96: new Bitmap( new Emoji_96x96_842() )				},				{				  name: "Brown Man w/Skullcap",				  id: 843,				  bitmap48: new Bitmap( new Emoji_48x48_843() ),				  bitmap96: new Bitmap( new Emoji_96x96_843() )				},				{				  name: "Black Man w/Skullcap",				  id: 844,				  bitmap48: new Bitmap( new Emoji_48x48_844() ),				  bitmap96: new Bitmap( new Emoji_96x96_844() )				},				{				  name: "Yellow Man w/Turban",				  id: 845,				  bitmap48: new Bitmap( new Emoji_48x48_845() ),				  bitmap96: new Bitmap( new Emoji_96x96_845() )				},				{				  name: "Whiter Man w/Turban",				  id: 846,				  bitmap48: new Bitmap( new Emoji_48x48_846() ),				  bitmap96: new Bitmap( new Emoji_96x96_846() )				},				{				  name: "White Man w/Turban",				  id: 847,				  bitmap48: new Bitmap( new Emoji_48x48_847() ),				  bitmap96: new Bitmap( new Emoji_96x96_847() )				},				{				  name: "Tan Man w/Turban",				  id: 848,				  bitmap48: new Bitmap( new Emoji_48x48_848() ),				  bitmap96: new Bitmap( new Emoji_96x96_848() )				},				{				  name: "Brown Man w/Turban",				  id: 849,				  bitmap48: new Bitmap( new Emoji_48x48_849() ),				  bitmap96: new Bitmap( new Emoji_96x96_849() )				},				{				  name: "Black Man w/Turban",				  id: 850,				  bitmap48: new Bitmap( new Emoji_48x48_850() ),				  bitmap96: new Bitmap( new Emoji_96x96_850() )				},				{				  name: "Yellow Old Man",				  id: 851,				  bitmap48: new Bitmap( new Emoji_48x48_851() ),				  bitmap96: new Bitmap( new Emoji_96x96_851() )				},				{				  name: "Whiter Old Man",				  id: 852,				  bitmap48: new Bitmap( new Emoji_48x48_852() ),				  bitmap96: new Bitmap( new Emoji_96x96_852() )				},				{				  name: "White Old Man",				  id: 853,				  bitmap48: new Bitmap( new Emoji_48x48_853() ),				  bitmap96: new Bitmap( new Emoji_96x96_853() )				},				{				  name: "Tan Old Man",				  id: 854,				  bitmap48: new Bitmap( new Emoji_48x48_854() ),				  bitmap96: new Bitmap( new Emoji_96x96_854() )				},				{				  name: "Brown Old Man",				  id: 855,				  bitmap48: new Bitmap( new Emoji_48x48_855() ),				  bitmap96: new Bitmap( new Emoji_96x96_855() )				},				{				  name: "Black Old Man",				  id: 856,				  bitmap48: new Bitmap( new Emoji_48x48_856() ),				  bitmap96: new Bitmap( new Emoji_96x96_856() )				},				{				  name: "Yellow Old Woman",				  id: 857,				  bitmap48: new Bitmap( new Emoji_48x48_857() ),				  bitmap96: new Bitmap( new Emoji_96x96_857() )				},				{				  name: "Whiter Old Woman",				  id: 858,				  bitmap48: new Bitmap( new Emoji_48x48_858() ),				  bitmap96: new Bitmap( new Emoji_96x96_858() )				},				{				  name: "White Old Woman",				  id: 859,				  bitmap48: new Bitmap( new Emoji_48x48_859() ),				  bitmap96: new Bitmap( new Emoji_96x96_859() )				},				{				  name: "Tan Old Woman",				  id: 860,				  bitmap48: new Bitmap( new Emoji_48x48_860() ),				  bitmap96: new Bitmap( new Emoji_96x96_860() )				},				{				  name: "Brown Old Woman",				  id: 861,				  bitmap48: new Bitmap( new Emoji_48x48_861() ),				  bitmap96: new Bitmap( new Emoji_96x96_861() )				},				{				  name: "Black Old Woman",				  id: 862,				  bitmap48: new Bitmap( new Emoji_48x48_862() ),				  bitmap96: new Bitmap( new Emoji_96x96_862() )				},				{				  name: "Yellow Baby",				  id: 863,				  bitmap48: new Bitmap( new Emoji_48x48_863() ),				  bitmap96: new Bitmap( new Emoji_96x96_863() )				},				{				  name: "Whiter Baby",				  id: 864,				  bitmap48: new Bitmap( new Emoji_48x48_864() ),				  bitmap96: new Bitmap( new Emoji_96x96_864() )				},				{				  name: "White Baby",				  id: 865,				  bitmap48: new Bitmap( new Emoji_48x48_865() ),				  bitmap96: new Bitmap( new Emoji_96x96_865() )				},				{				  name: "Tan Baby",				  id: 866,				  bitmap48: new Bitmap( new Emoji_48x48_866() ),				  bitmap96: new Bitmap( new Emoji_96x96_866() )				},				{				  name: "Brown Baby",				  id: 867,				  bitmap48: new Bitmap( new Emoji_48x48_867() ),				  bitmap96: new Bitmap( new Emoji_96x96_867() )				},				{				  name: "Black Baby",				  id: 868,				  bitmap48: new Bitmap( new Emoji_48x48_868() ),				  bitmap96: new Bitmap( new Emoji_96x96_868() )				}			];									//Build an array that is more searchable			for(var i=0;i<emojis.length;i++){				emojis[emojis[i].name] = emojis[i];			}		}				/**			* Initialize parameters that are used inside of Resolume		*/		public function initParams():void		{			MonsterDebugger.trace(this, "Iniailizing Resolume parameters.", "Init Phase");						if(TESTING)			{				emojis[0].param = resolume.addBooleanParameter(emojis[0].name, true);				emojis[0].activated = false;			}			else			{				//Booleans				for(var i=0;i<emojis.length;i++)				{					emojis[i].param = resolume.addBooleanParameter(emojis[i].name, false);					emojis[i].activated = false;				}			}						//Floats			paramAccel = resolume.addFloatParameter("Acceleration", 0.2 );			paramParticleCount = resolume.addFloatParameter("Particles", 0.1 );		}			/**			* Main initialize method		*/		public function init( e:Event ):void		{			MonsterDebugger.trace(this, "EMOJI Initialized", "Init Phase");						emitter = new Emitter2D();			renderer.addEmitter( emitter );			addChild( renderer );									if(TESTING)			{				handleBooleanState(emojis, 0);			}		}					/**		* This method will be called everytime you change a paramater in Resolume.		*/		public function paramChanged( event:ChangeEvent ):void 		{			MonsterDebugger.trace(this, "Param Changed: " + event.object, "Interactive Phase");			//Check to see if the param was a Boolean			//Find the emoji in the array based on the name			if(getQualifiedClassName(event.object) == "resolumeCom.parameters::BooleanParameter")			{				//MonsterDebugger.trace(this, "It's a Boolean.", "Interactive Phase");				//Find the emoji that should be activated				//MonsterDebugger.trace(this, "Param index: " + emojis.indexOf(emojis[event.object.name]), "Testing");				handleBooleanState( emojis, emojis.indexOf(emojis[event.object.name]) );			}			else			{				switch(event.object)				{					case paramAccel:						var newAccel:Number = paramAccel.getValue() * 1000;						applyAccelToEmitters(emojis, newAccel);						break;										case paramParticleCount:						var newCount:Number = paramParticleCount.getValue() * 100;						if(newCount > 100) newCount = 250;						applyParticleCount(emojis, newCount);						break;											default:						MonsterDebugger.trace(this, event.object);						break;				}			}		}				/**			*		*/		private function applyAccelToEmitters(ar:Array, accel:Number):void		{			clearParticles();			emitter.addAction( new MatchVelocity( 20, accel ) );			emitter.addAction( new SpeedLimit( accel ) );			emitter.start();		}				/**			*		*/		private function applyParticleCount(ar:Array, count:Number):void		{			clearParticles();			emitter.counter = new Blast( count );			emitter.start();		}				/**		* Handle the parameter state		*/		public function handleBooleanState(ar:Array, id: Number):void		{			var emojiObjRef:Object = ar[id];						if(ar[id].param.getValue() == 0)			{				stageCheckRemoval( emojiObjRef );			}			else			{				stageCheckAdd( emojiObjRef );			}		}				/**			* Check to see if the emoji should be removed from the stage.		*/		public function stageCheckRemoval( emojiObj:Object ):void		{			var emoji:Bitmap  = emojiObj["bitmap" + EMOJI_SIZE];						if(emojiObj.activated)			{				MonsterDebugger.trace(this, emoji.name + " is activated.", "Stage Check Phase");								//Clear the particles (BitmapRenderer)				clearParticles();								if(emoji.stage){					emoji.parent.removeChild(emoji);  //remove emoji84 from display list					emoji = null //remove reference to the emoji84, mark it for garbage collection				}								//Change state				emojiObj.activated = false;								//Add the emojis currently activated to stage				reInitEmojisOnStage();			}			else			{				MonsterDebugger.trace(this, emoji.name + " isn't activated.", "Stage Check Phase");			}		}				/**			* Check to see if the emoji should be added to the stage.		*/		public function stageCheckAdd( emojiObj:Object ):void		{			var emoji:Bitmap  = emojiObj["bitmap" + EMOJI_SIZE];;						if(emojiObj.activated)			{				MonsterDebugger.trace(this, emoji.name + " is already activated.", "Stage Check Phase");			}			else			{				MonsterDebugger.trace(this, emoji.name + " wasn't activated.", "Stage Check Phase");								//Change state (WARNING: MUST BE BEFORE FLOCK)				emojiObj.activated = true;								//Start the flock				startFlock();			}		}				/**		*		*/		private function startFlock():void		{							MonsterDebugger.trace(this, "Flocking...", "Action Phase");						var acceleration:Number = paramAccel.getValue() * 1000;			var particleCount:Number = paramParticleCount.getValue() * 100;						emitter.counter = new Blast( particleCount );						//Add the emojis currently activated to stage			reInitEmojisOnStage(); 						emitter.addInitializer( new Position( new RectangleZone( 10, 10,  stage.stageWidth, stage.stageHeight ) ) );			emitter.addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 150, 100 ) ) );						emitter.addAction( new ApproachNeighbours( 150, 100 ) );			emitter.addAction( new MatchVelocity( 20, acceleration ) );			emitter.addAction( new MinimumDistance( 10, 600 ) );			emitter.addAction( new SpeedLimit( 100, true ) );			emitter.addAction( new RotateToDirection() );			emitter.addAction( new BoundingBox( 0, 0, 700, 500 ) );			emitter.addAction( new SpeedLimit( acceleration ) );			emitter.addAction( new Move() );					emitter.start();		}				/**			*		*/		private function reInitEmojisOnStage():void		{			if(emitter.running)			{				emitter.stop();			}			//Add the emojis that are activated			var emojisToStage:Array = new Array();			for (var i=0;i<emojis.length;i++)			{				if(emojis[i].activated)				{					emojisToStage.push(emojis[i].bitmap48);				}			}						if(emojisToStage.length > 0)			{				emitter.addInitializer( new SharedImages( emojisToStage ) );				emitter.start();			}		}						/**		* Clears the Flint particles		*/		public function clearParticles(){			//Clear the stage			emitter.killAllParticles();			renderer.bitmapData.fillRect( renderer.bitmapData.rect, 0 );		}				/**		* Finds the class name of an object and creates an object based on a class's String-formated name.		* Source: https://delfeld.wordpress.com/2009/04/21/object_from_class_name/		*/		public function getClassObj(obj:*):*		{			var objClass:Class = Class(getDefinitionByName(getQualifiedClassName(obj)));			return new objClass();		}			}}