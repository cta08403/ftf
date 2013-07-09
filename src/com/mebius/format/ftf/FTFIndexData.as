package com.mebius.format.ftf
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	internal class FTFIndexData
	{
		private var _voVec:Vector.<FTFIndexDataVo>;
		private var _fileDatas:Dictionary;
		private var _ids:Array;
		
		public function FTFIndexData()
		{
			init();
		}
		
		private function init():void
		{
			this._voVec = new Vector.<FTFIndexDataVo>();
			this._fileDatas = new Dictionary();
			this._ids = new Array();
		}
		
		public function pushData( _id:String, _index:uint, _length:uint, type:uint ):void
		{
			var data:FTFIndexDataVo = new FTFIndexDataVo();
			data.IDLength = _id.length;
			data.ID = _id;
			data.index = _index;
			data.length = _length;
			data.type = type;
			this._voVec.push( data );
			
		}
		
		public function getIndexData():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			
			//将数组中的数据全部写入到二进制流中
			for( var i:int = 0; i<this._voVec.length; i++ )
			{
				var data:FTFIndexDataVo = this._voVec[i];
				
				byte.writeShort( data.IDLength );
				byte.writeUTFBytes( data.ID );
				byte.writeUnsignedInt( data.index );
				byte.writeUnsignedInt( data.length );
				byte.writeShort( data.type );
			}
			
			return byte;
		}
		
		public function readIndexData(val:ByteArray,blockNum:uint):void
		{
			val.position = 0;
			for( var i:uint=0;i<blockNum; i++ )
			{
				var strlength:uint = val.readShort();
				var id:String = val.readUTFBytes(strlength);
				var indexs:uint = val.readUnsignedInt();
				var datalengths:uint = val.readUnsignedInt();
				var types:uint = val.readShort();
				
				this._fileDatas[id] = {index:indexs,length:datalengths,type:types};
				
				this._ids.push( id );
			}
		}
		
		public function getByteDataByID(id:String):Object
		{
			return this._fileDatas[id];
		}
		
		public function getIndexBlockDataNum():uint
		{
			return this._voVec.length;
		}

		public function get ids():Array
		{
			return _ids;
		}

	}
}