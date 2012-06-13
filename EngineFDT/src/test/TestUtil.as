package test
{
	import utils.GDrawUtil;

	import flash.display.Sprite;

	/**
	 * @author Administrator
	 */
	public class TestUtil extends Sprite
	{
		public function TestUtil()
		{
			graphics.clear();
			graphics.lineStyle(1,0xff0000);
			//GDrawUtil.drawRoundRectComplex(this.graphics,1,1,100,100,10,10,10,10);
			GDrawUtil.drawBorder(this.graphics,100,1,8,100);
		}
	}
}
