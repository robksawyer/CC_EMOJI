﻿package  {	import flash.display.MovieClip;	import flash.display.BitmapData;	import flash.display.Bitmap;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.display.StageAlign;	import flash.display.StageScaleMode;		import flash.display.Loader;	import flash.events.Event;	import flash.events.IEventDispatcher;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.net.URLRequest;		import flash.utils.getDefinitionByName;	import flash.utils.getQualifiedClassName;		//Flint Particles	import org.flintparticles.twoD.renderers.BitmapRenderer;	import org.flintparticles.twoD.emitters.Emitter2D;	import org.flintparticles.common.initializers.SharedImages;	import org.flintparticles.common.counters.*;	import org.flintparticles.twoD.actions.*;	import org.flintparticles.twoD.initializers.*;	import org.flintparticles.twoD.zones.*;		//Logging	import com.demonsters.debugger.MonsterDebugger;		//import the Resolume communication classes	//make sure you have added the source path to these files in the ActionScript 3 Preferences of Flash	import resolumeCom.*;	import resolumeCom.parameters.*;	import resolumeCom.events.*;		public class EMOJI_Flock extends MovieClip 	{				/*****************PRIVATE********************/		/**		* Create the resolume object that will do all the hard work for you.		*/		private var resolume:Resolume = new Resolume();				private static var TESTING:Boolean = true;				/**		* Examples of parameters that can be used inside of Resolume		*/		/*private var paramScaleX:FloatParameter = resolume.addFloatParameter("Scale X", 0.5);		private var paramScaleY:FloatParameter = resolume.addFloatParameter("Scale Y", 0.5);		private var paramRotate:FloatParameter = resolume.addFloatParameter("Rotate", 0.0);		private var paramFooter:StringParameter = resolume.addStringParameter("Footer", "VJ BOB");		private var paramShowBackground:BooleanParameter = resolume.addBooleanParameter("Background", true);		private var paramShowSurprise:EventParameter = resolume.addEventParameter("Surprise!");*/				private var emojisInfo:Object = {										keys: new Array(48, 64, 96),								   		sizes: new Array("48x48","64x64","96x96"),								  		total: new Number(10) //total number of emojis is 1363										};												//Hold the actual emoji bitmap references per size in separate arrays		private var emojis:Array = new Array();					//Flint		public var renderer:BitmapRenderer;		public var emitter:Emitter2D;				//Other Resolume Parameters		private var paramAccel:FloatParameter;		private var paramParticleCount:FloatParameter;				public function EMOJI_Flock():void		{			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;						//Make a Flint renderer			renderer = new BitmapRenderer( new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight ) );						// Start the MonsterDebugger			MonsterDebugger.initialize(this);						initData();						//Initialize the Resolume parameters			initParams();						//set callback, this will notify us when a parameter has changed			resolume.addParameterListener(paramChanged);						addEventListener(Event.ADDED_TO_STAGE, init);		}				/**		* Initialize data 		* - initialize all of the emojis bitmaps that are used in the plugin		*/		private function initData()		{			//			/*			* TODO: I wish I could get this to work.			* See: http://stackoverflow.com/questions/4103641/working-with-swcs-getdefinitionbyname-issue			* http://stackoverflow.com/questions/1023205/as3-embed-or-import-all-classes-in-an-external-swf-without-referencing-each-clas			*/			/*for(var j = 0; j < emojis.sizes.length; j++){				//Create an array for the different sized emojis				emojis.bitmapdata[j] = new Array();				emojis.bitmap[j] = new Array();								for(var i = 1; i < emojis.total; i++){					("Emoji_" + emojis.sizes[j] + "_" + i);					var ClassReference:Class = new (getDefinitionByName("Emoji_" + emojis.sizes[j] + "_" + i) as Class)();										MonsterDebugger.trace(this, ClassReference.toString());					MonsterDebugger.trace(this, "Emoji_"+emojis.sizes[0]+"_"+i);					//emojis.bitmapdata[j][i] = new dynClass(); 					//MonsterDebugger.trace(this, emojis.bitmapdata[j][i].toString());					//emojis.bitmap[j][i] = new Bitmap(emojis.bitmapdata[i]); 				}			}*/						emojis = [				{				 id: 43,				 name: "Sun",				 bitmap48: new Bitmap( new Emoji_48x48_43() )				},				{				 id: 44,				 name: "Cloud",				 bitmap48: new Bitmap( new Emoji_48x48_44() )				},				{				 id: 77,				 name: "Lightning Bolt",				 bitmap48: new Bitmap( new Emoji_48x48_77() )				}			];		}				/**			* Initialize parameters that are used inside of Resolume		*/		public function initParams():void		{			MonsterDebugger.trace(this, "Iniailizing Resolume parameters.", "Init Phase");						if(TESTING)			{				emojis[0].param = resolume.addBooleanParameter(emojis[0].name, true);				emojis[0].activated = false;			}			else			{				//Booleans				for(var i=0;i<emojis.length;i++)				{					emojis[i].param = resolume.addBooleanParameter(emojis[i].name, false);					emojis[i].activated = false;				}			}						//Floats			paramAccel = resolume.addFloatParameter("Acceleration", 0.2 );			paramParticleCount = resolume.addFloatParameter("Particles", 0.1 );		}			/**			* Main initialize method		*/		public function init( e:Event ):void		{			MonsterDebugger.trace(this, "EMOJI Initialized", "Init Phase");						emitter = new Emitter2D();			renderer.addEmitter( emitter );			addChild( renderer );									if(TESTING)			{				handleBooleanState(emojis, 0);			}		}					/**		* This method will be called everytime you change a paramater in Resolume.		*/		public function paramChanged( event:ChangeEvent ):void 		{			MonsterDebugger.trace(this, "Param Changed: " + event.object, "Interactive Phase");			switch(event.object)			{				case emojis[0].param:					handleBooleanState(emojis, 0);					break;									case emojis[1].param:					handleBooleanState(emojis, 1);					break;									case emojis[2].param:					handleBooleanState(emojis, 2);					break;								case paramAccel:					var newAccel:Number = paramAccel.getValue() * 1000;					applyAccelToEmitters(emojis, newAccel);					break;								case paramParticleCount:					var newCount:Number = paramParticleCount.getValue() * 100;					if(newCount > 100) newCount = 250;					applyParticleCount(emojis, newCount);					break;									default:					MonsterDebugger.trace(this, event.object);					break;			}		}				/**			*		*/		private function applyAccelToEmitters(ar:Array, accel:Number):void		{			clearParticles();			emitter.addAction( new MatchVelocity( 20, accel ) );			emitter.addAction( new SpeedLimit( accel ) );			emitter.start();		}				/**			*		*/		private function applyParticleCount(ar:Array, count:Number):void		{			clearParticles();			emitter.counter = new Blast( count );			emitter.start();		}				/**		* Handle the parameter state		*/		public function handleBooleanState(ar:Array, id: Number):void		{			var emojiObjRef:Object = ar[id];						if(ar[id].param.getValue() == 0)			{				stageCheckRemoval( emojiObjRef );			}			else			{				stageCheckAdd( emojiObjRef );			}		}				/**			* Check to see if the emoji should be removed from the stage.		*/		public function stageCheckRemoval( emojiObj:Object ):void		{			var emoji:Bitmap  = emojiObj.bitmap48;						if(emojiObj.activated)			{				MonsterDebugger.trace(this, emoji.name + " is activated.", "Stage Check Phase");								//Clear the particles (BitmapRenderer)				clearParticles();								if(emoji.stage){					emoji.parent.removeChild(emoji);  //remove emoji84 from display list					emoji = null //remove reference to the emoji84, mark it for garbage collection				}								//Change state				emojiObj.activated = false;								//Add the emojis currently activated to stage				reInitEmojisOnStage();			}			else			{				MonsterDebugger.trace(this, emoji.name + " isn't activated.", "Stage Check Phase");			}		}				/**			* Check to see if the emoji should be added to the stage.		*/		public function stageCheckAdd( emojiObj:Object ):void		{			var emoji:Bitmap  = emojiObj.bitmap48;						if(emojiObj.activated)			{				MonsterDebugger.trace(this, emoji.name + " is already activated.", "Stage Check Phase");			}			else			{				MonsterDebugger.trace(this, emoji.name + " wasn't activated.", "Stage Check Phase");								//Change state (WARNING: MUST BE BEFORE FLOCK)				emojiObj.activated = true;								//Start the flock				startFlock();			}		}				/**		*		*/		private function startFlock():void		{							MonsterDebugger.trace(this, "Flocking...", "Action Phase");						var acceleration:Number = paramAccel.getValue() * 1000;			var particleCount:Number = paramParticleCount.getValue() * 100;						emitter.counter = new Blast( particleCount );						//Add the emojis currently activated to stage			reInitEmojisOnStage(); 						emitter.addInitializer( new Position( new RectangleZone( 10, 10,  stage.stageWidth, stage.stageHeight ) ) );			emitter.addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 150, 100 ) ) );						emitter.addAction( new ApproachNeighbours( 150, 100 ) );			emitter.addAction( new MatchVelocity( 20, acceleration ) );			emitter.addAction( new MinimumDistance( 10, 600 ) );			emitter.addAction( new SpeedLimit( 100, true ) );			emitter.addAction( new RotateToDirection() );			emitter.addAction( new BoundingBox( 0, 0, 700, 500 ) );			emitter.addAction( new SpeedLimit( acceleration ) );			emitter.addAction( new Move() );					emitter.start();		}				/**			*		*/		private function reInitEmojisOnStage():void		{			if(emitter.running)			{				emitter.stop();			}			//Add the emojis that are activated			var emojisToStage:Array = new Array();			for (var i=0;i<emojis.length;i++)			{				if(emojis[i].activated)				{					emojisToStage.push(emojis[i].bitmap48);				}			}						if(emojisToStage.length > 0)			{				emitter.addInitializer( new SharedImages( emojisToStage ) );				emitter.start();			}		}						/**		* Clears the Flint particles		*/		public function clearParticles(){			//Clear the stage			emitter.killAllParticles();			renderer.bitmapData.fillRect( renderer.bitmapData.rect, 0 );		}				/**		* Finds the class name of an object and creates an object based on a class's String-formated name.		* Source: https://delfeld.wordpress.com/2009/04/21/object_from_class_name/		*/		public function getClassObj(obj:*):*		{			var objClass:Class = Class(getDefinitionByName(getQualifiedClassName(obj)));			return new objClass();		}			}}