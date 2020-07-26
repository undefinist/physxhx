package physx.foundation;

import haxe.io.Bytes;
import haxe.io.BytesData;

@:native("::cpp::Struct<physx::foundation::PxInputStreamNative>")
extern class PxInputStreamNative
{
    var haxeDelegate:PxInputStream;
}

@:native("::cpp::Struct<physx::foundation::PxInputDataNative>")
extern class PxInputDataNative
{
    var haxeDelegate:PxInputData;
}

@:native("::cpp::Struct<physx::foundation::PxOutputStreamNative>")
extern class PxOutputStreamNative
{
    var haxeDelegate:PxOutputStream;
}



/**
\brief Input stream class for I/O.

The user needs to supply a PxInputStream implementation to a number of methods to allow the SDK to read data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxInputStreamNative : public physx::PxInputStream
{
public:
    physx::foundation::PxInputStream haxeDelegate;
    uint32_t read(void* dest, uint32_t count);
};
")
@:cppNamespaceCode("
uint32_t PxInputStreamNative::read(void* dest, uint32_t count)
{
    return haxeDelegate->_read(static_cast<uint8_t*>(dest), count);
}
")
class PxInputStream
{
    final _native:PxInputStreamNative = null;
    public function native():Dynamic
    {
        return _native;
    }

    public function new()
    {
        _native.haxeDelegate = this;
    }

    @:noCompletion @:noDoc @:keep
    final function _read(dest:cpp.Pointer<cpp.UInt8>, count:cpp.UInt32):cpp.UInt32
    {
        var bytes:Bytes = Bytes.alloc(count);
        count = read(bytes);
        for(i in 0...count)
            dest[i] = bytes.get(i);
        return count;
    }

    /**
    Read from the stream. The number of bytes read may be less than the number requested.

    @param data the buffer to fill.
    @return the number of bytes read from the stream.
    */
    public function read(data:Bytes):UInt { return 0; }
}



/**
\brief Input data class for I/O which provides random read access.

The user needs to supply a PxInputData implementation to a number of methods to allow the SDK to read data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxInputDataNative : public physx::PxInputData
{
public:
    physx::foundation::PxInputData haxeDelegate;
    uint32_t read(void* dest, uint32_t count);
    uint32_t getLength() const;
    void seek(uint32_t offset);
    uint32_t tell();
};
")
@:cppNamespaceCode("
uint32_t PxInputDataNative::read(void* dest, uint32_t count)
{
    return haxeDelegate->_read(static_cast<uint8_t*>(dest), count);
}
uint32_t PxInputDataNative::getLength() const
{
    return const_cast<physx::foundation::PxInputData&>(haxeDelegate)->getLength();
}
void PxInputDataNative::seek(uint32_t offset)
{
    return haxeDelegate->seek(offset);
}
uint32_t PxInputDataNative::tell()
{
    return haxeDelegate->tell();
}
")
class PxInputData extends PxInputStream
{
    override public function native():Dynamic
    {
        return untyped __cpp__("reinterpret_cast<PxInputDataNative*>(&{0}->_native);", this);
    }

    public function new()
    {
        super();
    }

    /**
	\brief return the length of the input data

	\return size in bytes of the input data
    */
    @:keep public function getLength():cpp.UInt32 { return 0; }

	/**
	\brief seek to the given offset from the start of the data.

	\param[in] offset the offset to seek to. 	If greater than the length of the data, this call is equivalent to
	seek(length);
	*/
    @:keep public function seek(offset:cpp.UInt32):Void {}

	/**
	\brief return the current offset from the start of the data

	\return the offset to seek to.
	*/
	@:keep public function tell():cpp.UInt32 { return 0; }
}



/**
\brief Output stream class for I/O.

The user needs to supply a PxOutputStream implementation to a number of methods to allow the SDK to write data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxOutputStreamNative : public physx::PxOutputStream
{
public:
    physx::foundation::PxOutputStream haxeDelegate;
    uint32_t write(const void* src, uint32_t count);
};
")
@:cppNamespaceCode("
uint32_t PxOutputStreamNative::write(const void* src, uint32_t count)
{
    return haxeDelegate->_write(static_cast<const uint8_t*>(src), count);
}
")
class PxOutputStream
{
    final _native:PxOutputStreamNative = null;
    public function native():PxOutputStreamNative
    {
        return _native;
    }

    public function new()
    {
        _native.haxeDelegate = this;
    }

    @:noCompletion @:noDoc @:keep
    final function _write(src:cpp.ConstPointer<cpp.UInt8>, count:cpp.UInt32):cpp.UInt32
    {
        var data = cpp.NativeArray.create(count);
        cpp.NativeArray.setUnmanagedData(data, src, count);
        var bytes:Bytes = Bytes.ofData(data);
        return write(bytes);
    }

    /**
	\brief write to the stream. The number of bytes written may be less than the number sent.

	\param[in] src the destination address from which the data will be written
	\param[in] count the number of bytes to be written

	\return the number of bytes written to the stream by this call.
	*/
    public function write(data:Bytes):UInt { return 0; }
}