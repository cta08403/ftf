#FTF Format File

##What's the FTF format file?

FTF文件格式是一个简单的文件打包格式。它将不同格式的二进制文件首尾相接，形成一个统一的数据包。同时数据包中包含一个表，用来描述FTF文件中不同文件的ID和起始点下标。

##FTF Format File Data
（格式说明中所谓的“起始点”表示所需数据在当前FTF文件中的字节下标）

###Header部分
	数据头
	FTF          4字节 uint 0x465446 "FTF"的ASCII编码
	version      2字节 int     1      版本，当前为1

	索引数据段
	type         2字节 int     0      始终为0，表示当前数据为索引数据段
	index_pos    4字节 uint    22     索引数据起始编号，使用为22
	num block    4字节 uint    n      索引数据块个数，uint最大值为4294967295

	用户数据信息数据段
	type         2字节 uint    1      始终为1，表示当前数据为用户数据信息数据段
	index_pos    4字节 uint    n      用户数据信息数据段的起始点

###索引数据块
	IDLength     2字节 int     n      该长度表示下方ID（UTF-8）字符串的长度
	ID           n字节 str UTF-8格式   对应文件的ID，ID可以为自定义名称，通常使用打包文件的文件名
	index        4字节 uint    n      对应数据再数据段的相对起始位置（何为相对起始位置，该起始位置所对应的起始点并非FTF文件的第1个字节，而是通过用户数据信息数据段中的index_pos值计算得来）
	length       4字节 uint    n      对应数据的字节长度（该长度取自于打包文件的对应文件实际体积）
	type         2字节 int     n      数据类型，该数据段在版本1中尚未使用，留作后期扩展

###用户数据段
	data 实际打包文件二进制首尾相接

##如何使用库

###AS3版本

首先引入需要的类
```ActionScript3
	import com.mebius.format.ftf.FTFManage;
	import com.mebius.format.ftf.FTFErrorEvent;
```

创建一个FTFManage对象，同时进行初始化
```ActionScript3
	private var _ftf:FTFManage;
	this._ftf = new FTFManage();

	this._ftf.addEventListener( FTFErrorEvent.SYSTEM_IO_ERROR, ftfError1_event);
	this._ftf.addEventListener( FTFErrorEvent.FILE_NOT_FOUND, ftfError2_event);
	this._ftf.addEventListener( FTFErrorEvent.FILE_TYPE_ERROR, ftfError3_event);
	this._ftf.addEventListener( FTFErrorEvent.VERSION_UNRECOGNIZED_ERROR, ftfError4_event);
	this._ftf.addEventListener( FTFErrorEvent.FILE_CORRUPTION_ERROR, ftfError5_event);
	this._ftf.addEventListener( FTFErrorEvent.DATA_NOT_EXIST_ERROR, ftfError6_event);
```

读取指定的FTF文件
```ActionScript3
	this._ftf.readFTF( File.applicationDirectory.nativePath+"/myFTF_file.ftf" );
```

通过ID获取对应文件的二进制数据,函数会返回一个ByteArray对象
```ActionScript3
	this._ftf.getByteByID(filename);
```

获取当前文件中的所有ID,此函数会返回一个Array对象
```ActionScript3
	this._ftf.getIDs();
```

