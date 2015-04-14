﻿package  {	import flash.display.MovieClip;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.geom.Point;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		import flash.display.Loader;	import flash.events.Event;	import flash.events.IEventDispatcher;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.net.URLRequest;		import flash.utils.getDefinitionByName;	import flash.utils.getQualifiedClassName;		//Flint Particles	import org.flintparticles.common.counters.*;	import org.flintparticles.common.initializers.*;	import org.flintparticles.twoD.actions.*;	import org.flintparticles.twoD.emitters.Emitter2D;	import org.flintparticles.twoD.initializers.*;	import org.flintparticles.twoD.renderers.*;	import org.flintparticles.twoD.zones.*;		//Logging	import com.demonsters.debugger.MonsterDebugger;		//import the Resolume communication classes	//make sure you have added the source path to these files in the ActionScript 3 Preferences of Flash	import resolumeCom.*;	import resolumeCom.parameters.*;	import resolumeCom.events.*;		public class EMOJI extends MovieClip 	{			/*****************PRIVATE********************/		/**		* Create the resolume object that will do all the hard work for you.		*/		private var resolume:Resolume = new Resolume();				/**		* Examples of parameters that can be used inside of Resolume		*/		/*private var paramScaleX:FloatParameter = resolume.addFloatParameter("Scale X", 0.5);		private var paramScaleY:FloatParameter = resolume.addFloatParameter("Scale Y", 0.5);		private var paramRotate:FloatParameter = resolume.addFloatParameter("Rotate", 0.0);		private var paramFooter:StringParameter = resolume.addStringParameter("Footer", "VJ BOB");		private var paramShowBackground:BooleanParameter = resolume.addBooleanParameter("Background", true);		private var paramShowSurprise:EventParameter = resolume.addEventParameter("Surprise!");*/				private var emojisInfo:Object = {										keys: new Array(48, 64, 96),								   		sizes: new Array("48x48","64x64","96x96"),								  		total: new Number(10) //total number of emojis is 1363										};												//Hold the actual emoji bitmap references per size in separate arrays		private var emojis:Array = new Array();					//Flint		private var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();		private var emitter:Emitter2D = new Emitter2D();				public function EMOJI():void		{						// Start the MonsterDebugger			MonsterDebugger.initialize(this);						initData();						//Initialize the Resolume parameters			initParams();						//set callback, this will notify us when a parameter has changed			resolume.addParameterListener(paramChanged);						addEventListener(Event.ADDED_TO_STAGE, init);		}				/**		* Initialize data 		* - initialize all of the emojis bitmaps that are used in the plugin		*/		private function initData()		{			//			/*			* TODO: I wish I could get this to work.			* See: http://stackoverflow.com/questions/4103641/working-with-swcs-getdefinitionbyname-issue			* http://stackoverflow.com/questions/1023205/as3-embed-or-import-all-classes-in-an-external-swf-without-referencing-each-clas			*/			/*for(var j = 0; j < emojis.sizes.length; j++){				//Create an array for the different sized emojis				emojis.bitmapdata[j] = new Array();				emojis.bitmap[j] = new Array();								for(var i = 1; i < emojis.total; i++){					("Emoji_" + emojis.sizes[j] + "_" + i);					var ClassReference:Class = new (getDefinitionByName("Emoji_" + emojis.sizes[j] + "_" + i) as Class)();										MonsterDebugger.trace(this, ClassReference.toString());					MonsterDebugger.trace(this, "Emoji_"+emojis.sizes[0]+"_"+i);					//emojis.bitmapdata[j][i] = new dynClass(); 					//MonsterDebugger.trace(this, emojis.bitmapdata[j][i].toString());					//emojis.bitmap[j][i] = new Bitmap(emojis.bitmapdata[i]); 				}			}*/						emojis = [				{				 id: 43,				 name: "Sun",				 bitmap48: new Bitmap( new Emoji_48x48_43() )				},				{				 id: 44,				 name: "Cloud",				 bitmap48: new Bitmap( new Emoji_48x48_44() )				},				{				 id: 77,				 name: "Lightning Bolt",				 bitmap48: new Bitmap( new Emoji_48x48_77() )				}			];		}				/**			* Initialize parameters that are used inside of Resolume		*/		public function initParams():void		{			MonsterDebugger.trace(this, "Iniailizing Resolume parameters.");						//Booleans			for(var i=0;i<emojis.length;i++)			{				emojis[i].param = resolume.addBooleanParameter(emojis[i].name, false);			}		}			/**			* Main initialize method		*/		public function init(e:Event):void		{			MonsterDebugger.trace(this, "EMOJI Initialized");				}			/**		* This method will be called everytime you change a paramater in Resolume.		*/		public function paramChanged( event:ChangeEvent ):void 		{			MonsterDebugger.trace(this, "Param Changed: " + event.object);			switch(event.object)			{				case emojis[0].param:					handleBooleanState(emojis[0].param, emojis[0].bitmap48);					break;									case emojis[1].param:					handleBooleanState(emojis[1].param, emojis[1].bitmap48);					break;								default:					MonsterDebugger.trace(this, event.object);					break;			}		}				/**		* Handle the parameter state		*/		public function handleBooleanState(paramOption:BooleanParameter, emoji:Bitmap):void		{			if(paramOption.getValue() == 0)			{				stageCheckRemoval(emoji);			}			else			{				stageCheckAdd(emoji);			}		}				/**			* Check to see if the emoji should be removed from the stage.		*/		public function stageCheckRemoval(emoji: Bitmap):void		{			if(emoji.stage)			{				MonsterDebugger.trace(this, emoji.name + " is in display list");				emoji.parent.removeChild(emoji);  //remove emoji84 from display list				emoji = null //remove reference to the emoji84, mark it for garbage collection			}			else			{				MonsterDebugger.trace(this, emoji.name + " isn't in display list");			}		}				/**			* Check to see if the emoji should be added to the stage.		*/		public function stageCheckAdd(emoji: Bitmap):void		{			if(emoji.stage)			{				MonsterDebugger.trace(this, emoji.name + " is already in display list");			}			else			{				MonsterDebugger.trace(this, emoji.name + " isn't in display list");				//emoji.x = stage.stageWidth/2 - emoji.width/2;				//emoji.y = stage.stageHeight/2 - emoji.height/2;								//Start the flock				addChild(emoji);				startFlock(emoji);						}		}				/**		*		*/		private function startFlock( emoji:Bitmap ):void		{			emitter.counter = new Blast( 150 );						emitter.addInitializer( new SharedImage( emoji ) );			emitter.addInitializer( new Position( new RectangleZone( 10, 10,  680, 480 ) ) );			emitter.addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 150, 100 ) ) );						emitter.addAction( new ApproachNeighbours( 150, 100 ) );			emitter.addAction( new MatchVelocity( 20, 200 ) );			emitter.addAction( new MinimumDistance( 10, 600 ) );			emitter.addAction( new SpeedLimit( 100, true ) );			emitter.addAction( new RotateToDirection() );			emitter.addAction( new BoundingBox( 0, 0, 700, 500 ) );			emitter.addAction( new SpeedLimit( 200 ) );			emitter.addAction( new Move() );						//Flint emitter      		renderer.addEmitter( emitter );      		addChild( renderer );						emitter.start();		}	}}