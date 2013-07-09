package com.mebius.format.ftf
{
	import flash.utils.ByteArray;

	internal class FTFFormatData
	{
		private var _fileData:ByteArray;
		
		public function FTFFormatData()
		{
			init();
		}
		
		
		private function init():void
		{
			this._fileData = new ByteArray();
		}
		
		public function pushFile(val:ByteArray):void
		{
			this._fileData.writeBytes( val );
		}
		
		public function get currentPosition():uint
		{
			return this._fileData.position;
		}
		
		public function get byteLength():uint
		{
			return this._fileData.length;
		}

		public function get fileData():ByteArray
		{
			return _fileData;
		}

		
	}
}