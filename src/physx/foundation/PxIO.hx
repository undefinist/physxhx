package physx.foundation;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.io.BytesData;

@:native("::cpp::Reference<physx::foundation::PxInputStreamNative>")
@:noCompletion extern class PxInputStreamNative {}

@:native("::cpp::Reference<physx::foundation::PxInputDataNative>")
@:noCompletion extern class PxInputDataNative extends PxInputStreamNative {}

@:native("::cpp::Reference<physx::foundation::PxOutputStreamNative>")
@:noCompletion extern class PxOutputStreamNative {}



/**
Input stream class for I/O.

The user needs to supply a PxInputStream implementation to a number of methods to allow the SDK to read data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxInputStreamNative : public physx::PxInputStream
{
public:
    PxInputStreamHx hxHandle;
    PxInputStreamNative(PxInputStreamHx hxHandle):hxHandle{ hxHandle } {}
    uint32_t read(void* dest, uint32_t count) override;
};
")
@:cppNamespaceCode("
uint32_t PxInputStreamNative::read(void* dest, uint32_t count) { return hxHandle->_read(static_cast<uint8_t*>(dest), count); }
")
class PxInputStreamHx
{
    @:allow(physx.foundation.PxInputStream) @:noCompletion
    private var _native:PxInputStreamNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxInputStreamNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxInputStreamHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    @:noCompletion @:noDoc
    final private function _read(dest:cpp.Pointer<cpp.UInt8>, count:cpp.UInt32):cpp.UInt32
    {
        var bytes = Bytes.ofData(dest.toUnmanagedArray(count));
        return read(bytes);
    }

    /**
     * Read from the stream. The number of bytes read may be less than the number requested.
     * 
     * @param data the buffer to fill.
     * @return the number of bytes read from the stream.
     */
    public function read(data:Bytes):UInt { return 0; }
}



/**
Input data class for I/O which provides random read access.

The user needs to supply a PxInputData implementation to a number of methods to allow the SDK to read data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxInputDataNative : public physx::PxInputData
{
public:
    PxInputDataHx hxHandle;
    PxInputDataNative(PxInputDataHx hxHandle):hxHandle{ hxHandle } {}
    uint32_t read(void* dest, uint32_t count) override;
    uint32_t getLength() const override;
    void seek(uint32_t offset) override;
    uint32_t tell() const override;
};
")
@:cppNamespaceCode("
uint32_t PxInputDataNative::read(void* dest, uint32_t count) { return hxHandle->_read(static_cast<uint8_t*>(dest), count); }
uint32_t PxInputDataNative::getLength() const { return const_cast<PxInputDataHx&>(hxHandle)->getLength(); }
void PxInputDataNative::seek(uint32_t offset) { return hxHandle->seek(offset); }
uint32_t PxInputDataNative::tell() const { return const_cast<PxInputDataHx&>(hxHandle)->tell(); }
")
class PxInputDataHx
{
    @:allow(physx.foundation.PxInputStream, physx.foundation.PxInputData) @:noCompletion
    private var _native:PxInputDataNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxInputDataNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxInputDataHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Return the length of the input data
     * 
     * @return size in bytes of the input data
     */
    public function getLength():cpp.UInt32 { return 0; }

    /** 
     * Seek to the given offset from the start of the data.
     * 
     * @param offset the offset to seek to. If greater than the length of the data, this call is equivalent to
     * `seek(length)`.
     */
    public function seek(offset:cpp.UInt32):Void {}

    /**
     * Return the current offset from the start of the data
     * 
     * @return the offset to seek to.
     */
    public function tell():cpp.UInt32 { return 0; }

    /**
     * Read from the stream. The number of bytes read may be less than the number requested.
     * 
     * @param data the buffer to fill.
     * @return the number of bytes read from the stream.
     */
    public function read(data:Bytes):UInt { return 0; }
    final private function _read(dest:cpp.Pointer<cpp.UInt8>, count:cpp.UInt32):cpp.UInt32
    {
        var bytes = Bytes.ofData(dest.toUnmanagedArray(count));
        return read(bytes);
    }
}



/**
Output stream class for I/O.

The user needs to supply a PxOutputStream implementation to a number of methods to allow the SDK to write data.
*/
@:headerInclude("foundation/PxIO.h")
@:headerNamespaceCode("
class PxOutputStreamNative : public physx::PxOutputStream
{
public:
    PxOutputStreamHx hxHandle;
    PxOutputStreamNative(PxOutputStreamHx hxHandle):hxHandle{ hxHandle } {}
    uint32_t write(const void* src, uint32_t count) override;
};
")
@:cppNamespaceCode("
uint32_t PxOutputStreamNative::write(const void* src, uint32_t count) { return hxHandle->_write(static_cast<const uint8_t*>(src), count); }
")
class PxOutputStreamHx
{
    @:allow(physx.foundation.PxOutputStream) @:noCompletion
    private var _native:PxOutputStreamNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxOutputStreamNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxOutputStreamHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Write to the stream. The number of bytes written may be less than the number sent.
     * 
     * @param data Source data buffer. It is **IMMUTABLE**!
     * 
     * @return The number of bytes written to the stream by this call.
     */
    public function write(data:BytesInput):UInt { return 0; }

    @:noCompletion @:noDoc @:keep
    final function _write(src:cpp.ConstPointer<cpp.UInt8>, count:cpp.UInt32):cpp.UInt32
    {
        var bytes = Bytes.ofData(cpp.Pointer.fromRaw(src.raw).toUnmanagedArray(count));
        return write(new BytesInput(bytes));
    }
}



/**
 * Assign with a Haxe class that extends `PxInputStreamHx` or `PxInputDataHx`,
 * or the default streams `PxDefaultMemoryInputData` or `PxDefaultFileInputData`.
 */
@:noCompletion extern abstract PxInputStream(PxInputStreamNative) from PxInputStreamNative
{
    @:from static inline function fromInputStreamHx(hxHandle:PxInputStreamHx):PxInputStream
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
    @:from static inline function fromInputDataHx(hxHandle:PxInputDataHx):PxInputStream
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}

/**
 * Assign with a Haxe class that extends `PxInputDataHx`,
 * or the default streams `PxDefaultMemoryInputData` or `PxDefaultFileInputData`.
 */
@:noCompletion extern abstract PxInputData(PxInputDataNative) from PxInputDataNative
{
    @:from static inline function from(hxHandle:PxInputDataHx):PxInputData
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}

/**
 * Assign with a Haxe class that extends `PxOutputStreamHx`,
 * or the default streams `PxDefaultMemoryOutputStream` or `PxDefaultFileOutputStream`.
 */
@:noCompletion extern abstract PxOutputStream(PxOutputStreamNative) from PxOutputStreamNative
{
    @:from static inline function from(hxHandle:PxOutputStreamHx):PxOutputStream
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}