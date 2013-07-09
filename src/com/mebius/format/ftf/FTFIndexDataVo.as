package com.mebius.format.ftf
{
	internal class FTFIndexDataVo
	{
		
		private var _IDLength:uint = 0;
		private var _ID:String = "";
		private var _index:uint = 0;
		private var _length:uint = 0;
		private var _type:int = 0;
		
		
		public function get IDLength():uint
		{
			return _IDLength;
		}

		public function set IDLength(value:uint):void
		{
			_IDLength = value;
		}

		public function get ID():String
		{
			return _ID;
		}

		public function set ID(value:String):void
		{
			_ID = value;
		}

		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			_index = value;
		}

		public function get length():uint
		{
			return _length;
		}

		public function set length(value:uint):void
		{
			_length = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}


	}
}