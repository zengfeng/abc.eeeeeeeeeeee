package gameui.controls
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import bd.BDData;
	import bd.BDUnit;
	import gameui.core.GComponentData;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author yangyiqiang
	 */
	public class BDAvatar extends MovieClip
	{
		private var _xml : XMLList;

		private var _source : BitmapData;

		public function BDAvatar()
		{
			addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);
		}

		private var _bds : Vector.<Units > = new Vector.<Units >(6);

		private var _bdPlayer : BDPlayer;

		private var _nameSprite : Sprite;

		private var _shadowSprite : Sprite;

		private function initPlay() : void
		{
			var num : int = 0;
			for each (var xml:XML in _xml["frame"])
			{
				var frames : Vector.<BDUnit > = new Vector.<BDUnit >   ;
				for each (var frame:XML in xml["item"])
				{
					var unit : BDUnit = new BDUnit();
					var rect : Rectangle = new Rectangle(frame. @ x,frame. @ y,frame. @ w,frame. @ h);
					var bds : BitmapData = new BitmapData(rect.width,rect.height,true,0);
					bds.copyPixels(_source,rect,new Point());
					unit.offset = new Point(frame. @ offsetX,frame. @ offsetY);
					unit.bds = bds;
					frames.push(unit);
				}
				num = Number(String(xml.@name).split("_")[1]);
				_bds[num] = new Units(new BDData(frames),xml.@time);
			}
			_xml = null;
			var data : GComponentData = new GComponentData();
			_bdPlayer = new BDPlayer(data);
			addChild(_bdPlayer);
			with(_nameSprite)
			{
				graphics.beginFill(16711680,0.5);
				graphics.drawRect(-30,-10,60,20);
			}
			with(_shadowSprite)
			{
				graphics.beginFill(16711680,0.5);
				graphics.drawEllipse(-25,-15,50,30);
				y += 300;
			}
			addChild(_nameSprite);
			addChild(_shadowSprite);
			_nameSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_nameSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_shadowSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_shadowSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseDown(event:MouseEvent) : void
		{
			(event.target as Sprite).startDrag();
		}

		private function onMouseUp(event:MouseEvent) : void
		{
			(event.target as Sprite).stopDrag();
		}

		private function addToStageHandler(event : Event) : void
		{
			initPlay();
			action = 1;
		}

		private function onComplete(event : Event) : void
		{
			if (_frame == 5)
			{
				_bdPlayer.stop();
			}
			else
			{
				action = 1;
			}
		}

		private function removeFromStageHandler(event : Event) : void
		{
			_bdPlayer.dispose();
			_bdPlayer.hide();
			_nameSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_nameSprite.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_shadowSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_shadowSprite.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private var _frame : int = 0;

		// 设置动作（使用本函数的静态常量）
		public function set action(value : int) : void
		{
			if (!_bdPlayer || !_bds || value < 0 || value > _bds.length || !_bds[value])
			{
				return;
			}
			_bdPlayer.setBDData(_bds[value].bds);
			_frame = value;
			_bdPlayer.play(_bds[value].timer,null,value == 1 ? 0 : 1);
			_bdPlayer.addEventListener(Event.COMPLETE,onComplete);
		}

		public function set xml(value :XMLList) : void
		{
			_xml = value;
		}

		public function set BitmapData(value : BitmapData) : void
		{
			_source = value;
		}
	}
}
import bd.BDData;

class Units
{
	public var timer : int;

	public var bds : BDData;

	public function Units(_bd : BDData, _timer : int = 80)
	{
		bds = _bd;
		timer = _timer;
	}
}
