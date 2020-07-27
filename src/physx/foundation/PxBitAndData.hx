package physx.foundation;

@:forward
extern abstract PxBitAndByte(PxBitAndByteImpl)
{
    inline function new(data:cpp.UInt8, bit:Bool = false)
    {
        this = PxBitAndByteImpl.create(data, bit);
    }
    static inline function zero():PxBitAndByte
    {
        return cast PxBitAndByteImpl.create();
    }
    static inline function empty():PxBitAndByte
    {
        return untyped __cpp__("physx::PxBitAndByte(physx::PxEmpty)");
    }
    @:to inline function data():cpp.UInt8
    { 
        return untyped __cpp__("static_cast<unsigned char>({0})", this);
    }
}

@:include("foundation/PxBitAndData.h")
@:native("physx::PxBitAndByte")
private extern class PxBitAndByteImpl
{
    @:native("physx::PxBitAndByte")
    @:overload(function():PxBitAndByteImpl {})
    static function create(data:cpp.UInt8, bit:Bool = false):PxBitAndByteImpl;
    function setBit():Void;
    function clearBit():Void;
    function isBitSet():cpp.UInt8;
}