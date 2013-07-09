package com.mebius.format.ftf
{
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	
	public class FTFManage extends EventDispatcher
	{
		private var _header:FTFHeader;
		private var _indexData:FTFIndexData;
		private var _formatData:FTFFormatData;
		private var stream:FileStream ;
		private var _eventTrigger:FTFEventTrigger;
		private var _filePath:String;
		
		public function FTFManage()
		{
			init();
		}
		
		
		private function init():void
		{
			this._eventTrigger = new FTFEventTrigger( this );
			
			this._header = new FTFHeader();
			this._indexData = new FTFIndexData();
			this._formatData = new FTFFormatData();
		}
		
		private function streamIOError_event(evt:IOErrorEvent):void
		{
			FTFEventTrigger.disEvent( FTFErrorEvent.SYSTEM_IO_ERROR,"io error in system.");
		}
		
		/**
		 *  
		 * @param val 即将被打包的文件路径
		 * 
		 */		
		public function createFTF(val:Array):ByteArray
		{
			this._header.setIndexDataNumBlock( val.length );
			for( var i:int =0;i<val.length; i++ )
			{
				var names:String = "";
				var str:String = val[i];
				var arr:Array = str.split("/");
				var s:String = arr[arr.length-1];
				var ar:Array = s.split(".");
				names = ar[0];
				var sfile:File = new File( val[i] );
				//添加索引
				this._indexData.pushData( names, this._formatData.byteLength, sfile.size ,1);
				
				//添加二进制数据
				var sstearm:FileStream = new FileStream();
				sstearm.open( sfile, FileMode.READ );
				var soundbyte:ByteArray = new ByteArray();
				sstearm.readBytes( soundbyte );
				sstearm.close();
				this._formatData.pushFile( soundbyte );
				
			}
			
			var bb:ByteArray = this._indexData.getIndexData();
			this._header.setUserDataPos( 22+bb.length );
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes( this._header.headerData );
			bytes.writeBytes( this._indexData.getIndexData() );
			bytes.writeBytes( this._formatData.fileData );
			
			return bytes;
		}
		
		/**
		 * 读取文件 
		 * @param filePath
		 * 
		 */		
		public function readFTF(filePath:String):void
		{
			this._filePath = filePath;
			
			var file:File = new File(filePath);
			if( !file.exists )
			{
				//文件不存在
				FTFEventTrigger.disEvent( FTFErrorEvent.FILE_NOT_FOUND, "file with ftf format not found.");
			}
			else
			{
				try
				{
					stream = new FileStream();
					stream.addEventListener(IOErrorEvent.IO_ERROR, streamIOError_event);
					stream.open( file, FileMode.READ );
					stream.position = 0;
					var header:ByteArray = new ByteArray();
					stream.readBytes( header,0,22);
					this._header.readHeaderData( header );
					stream.position = 22;
					var indexdata:ByteArray = new ByteArray();
					var length:uint = this._header.getUserDataPos() - 22;
					stream.readBytes( indexdata, 0, length );
					this._indexData.readIndexData( indexdata, this._header.getIndexDataNumBlock() );
				}
				catch(e:Error)
				{
					FTFEventTrigger.disEvent( FTFErrorEvent.FILE_CORRUPTION_ERROR,
						"file is error,is not FTF format file or file corruption.");
				}
				
			}
			
		}
		
		/**
		 * 根据ID获取对应的二进制文件 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getByteByID(id:String):ByteArray
		{
			var byte:ByteArray = new ByteArray();
			var obj:Object = this._indexData.getByteDataByID(id);
			if( obj == null )
			{
				FTFEventTrigger.disEvent( FTFErrorEvent.DATA_NOT_EXIST_ERROR,"date by id ‘"+id+"’ not found.");
			}
			else
			{
				this.stream.position = this._header.getUserDataPos() + obj.index;
			}
			try
			{
				stream.readBytes( byte,0 , obj.length );
			}
			catch(e:Error)
			{
				FTFEventTrigger.disEvent( FTFErrorEvent.FILE_CORRUPTION_ERROR,"file corruption.");
			}
			
			return byte;
		}
		
		/**
		 * 获取所有的ID列表 
		 * @return 
		 * 
		 */		
		public function getIDs():Array
		{
			return this._indexData.ids;
		}
		
		public function get readFilePath():String
		{
			return this._filePath;
		}
	}
}