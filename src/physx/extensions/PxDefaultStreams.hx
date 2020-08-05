package physx.extensions;

import physx.foundation.PxAllocatorCallback;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxIO;

/** 
default implementation of a memory write stream

@see PxOutputStream
*/
@:include("extensions/PxDefaultStreams.h")
@:native("physx::PxDefaultMemoryOutputStream")
@:structAccess
extern class PxDefaultMemoryOutputStream extends PxOutputStreamNative
{
    @:native("physx::PxDefaultMemoryOutputStream")
    @:overload(function():PxDefaultMemoryOutputStream {})
    static function create(allocator:PxAllocatorCallback):PxDefaultMemoryOutputStream;
}

/** 
default implementation of a memory read stream

@see PxInputData
*/
@:include("extensions/PxDefaultStreams.h")
@:native("physx::PxDefaultMemoryInputData")
@:structAccess
extern class PxDefaultMemoryInputData extends PxInputDataNative
{
    @:native("physx::PxDefaultMemoryInputData")
    static function create(data:cpp.Pointer<PxU8>, length:PxU32):PxDefaultMemoryInputData;

    static inline function ofBytes(bytes:haxe.io.Bytes):PxDefaultMemoryInputData
    {
        return create(cpp.Pointer.ofArray(bytes.getData()), bytes.length);
    }
}

/** 
default implementation of a file write stream

@see PxOutputStream
*/
@:include("extensions/PxDefaultStreams.h")
@:native("physx::PxDefaultFileOutputStream")
@:structAccess
extern class PxDefaultFileOutputStream extends PxOutputStreamNative
{
    @:native("physx::PxDefaultFileOutputStream")
    static function to(name:cpp.ConstCharStar):PxDefaultFileOutputStream;
}

/** 
default implementation of a file read stream

@see PxInputData
*/
@:include("extensions/PxDefaultStreams.h")
@:native("physx::PxDefaultFileInputData")
@:structAccess
extern class PxDefaultFileInputData extends PxInputDataNative
{
    @:native("physx::PxDefaultFileInputData")
    static function from(name:cpp.ConstCharStar):PxDefaultFileInputData;
}