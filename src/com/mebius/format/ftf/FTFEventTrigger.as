package com.mebius.format.ftf
{
	/**
	 * FTFManage事件触发器 
	 * @author mebius
	 * 
	 */	
	internal class FTFEventTrigger
	{
		private static var ftf:FTFManage;
		
		public function FTFEventTrigger( ftfm:FTFManage )
		{
			ftf = ftfm;
		}
		
		public static function disEvent(eventType:String, info:String):void
		{
			var evt:FTFErrorEvent = new FTFErrorEvent( eventType );
			evt.errorInfo = info + " file path:" + ftf.readFilePath;
			ftf.dispatchEvent( evt );
		}
	}
}