package gameui.data
{
	import gameui.core.GAlign;
	import gameui.core.GComponentData;

	import net.LibData;

	/**
	 * @author yangyiqiang
	 */
	public class GImageData extends GComponentData
	{
		public var libData : LibData;
		
		public var iocData:GIconData;
		
		public var classsName:String="";
		
		public var isBDPlay:Boolean=true;
		
		public var autoLayout:Boolean=false;
		
		override protected function parse(source : *) : void
		{
			super.parse(source);
			var data : GImageData = source as GImageData;
			if (data == null) return;
		}

		public function GImageData()
		{
			super();
			width=1;
			height=1;
			iocData=new GIconData();
			iocData.align=new GAlign(-1,-1,-1,-1,0,0);
		}
	}
}
