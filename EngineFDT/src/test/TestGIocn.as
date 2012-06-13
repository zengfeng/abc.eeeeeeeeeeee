package test
{
	import gameui.data.GIconData;
	import gameui.controls.GIcon;
	import flash.display.Sprite;

	/**
	 * @author yangyiqiang
	 */
	public class TestGIocn extends Sprite
	{
		private var _ioc:GIcon;
		public function TestGIocn()
		{
			initIoc();
		}
		
		private function initIoc():void
		{
			var data:GIconData=new GIconData();
			_ioc=new GIcon(data);
		}
	}
}
