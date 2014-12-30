package 
{

	import flash.display.MovieClip;
	import com.greensock.TweenLite; 
	import com.greensock.easing.*
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	import ibw.com.ui.ImageContainer;




	public class Main extends MovieClip
	{
		private var time:Number=10;
		private var total:Number=16;
		private var msg:String;
		private var bg:String = String(stage.loaderInfo.parameters["bg"]);

		public function Main()
		{
			init();
			
		}
		public function init():void
		{
			 ExternalInterface.addCallback("setTarget", setTarget);
			 initEvt();
			 loadDrawPlate();
		}
		public function loadDrawPlate():void
		{
			var img:ImageContainer=new ImageContainer(stage.stageWidth,stage.stageHeight);
			img.loadImage(bg);
			this.addChildAt(img,0);
		}
		public function initEvt():void
		{
			drawBtn.addEventListener(MouseEvent.CLICK,startLuckDraw);
		}
		private function startLuckDraw(e:MouseEvent):void
		{
			drawBtn.removeEventListener(MouseEvent.CLICK,startLuckDraw);
			ExternalInterface.call("loadResult");
		}
		public function setTarget(id:int, m:String){
			drawBtn.buttonMode=true;
			if(arguments.length !=2){
				msg= "出错啦！请重试";
				ExternalInterface.call("showResult",id,msg);
				return;
			}
			var seed = 0.4 - Math.random()*.8;
			msg = m;
			if(id>=0 && id<=16 && m.length>0){
				easeRotateTo(hand,id,8);
			}else if(id==-1){
				msg=m;
				ExternalInterface.call("showResult",id,msg);
				return;
			}else{
				msg = "出错啦！请重试";
				ExternalInterface.call("showResult",id,msg);
				return;
			}
		}
		public function easeRotateTo(mc:MovieClip,id:Number,time:Number=8):void{
			if(!time || time<3) time=3;
			var degIni = mc.rotation;	
			var degCur=0, degTo = id*360/total+360*10-degIni;
			var timer:Timer = new Timer(20); 
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
				var t = timer.currentCount*.02;
				if(t<=(1*time/3)){
					degCur = (3*degTo*t*t)/(time*time);
				}else if(t<=time){
					degCur = degTo*(3*t/time-(3*t*t)/(2*time*time)-1/2);
				}else{
					degCur = degTo;
					timer.stop();
					drawBtn.addEventListener(MouseEvent.CLICK,startLuckDraw);
					ExternalInterface.call("showResult",id,msg);
				}
				mc.rotation = degIni+degCur;
			});
		timer.start();
		}
	}

}