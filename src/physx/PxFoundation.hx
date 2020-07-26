package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxAllocatorCallback;
import physx.foundation.PxErrors;
import physx.foundation.PxErrorCallback;

/**
\brief Foundation SDK singleton class.

You need to have an instance of this class to instance the higher level SDKs.
*/
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml("physx", "../../"))
#end
@:include("PxFoundation.h")
@:native("::cpp::Reference<physx::PxFoundation>")
extern class PxFoundation
{
    /**
    \brief Destroys the instance it is called on.

    The operation will fail, if there are still modules referencing the foundation object. Release all dependent modules
    prior
    to calling this method.

    @see PxCreateFoundation()
    */
    public function release():Void;

    /**
    retrieves error callback
    */
    public function getErrorCallback():PxErrorCallback;

    /**
    Sets mask of errors to report.
    */
    public function setErrorLevel(mask:PxErrorCode = eMASK_ALL):Void;

    /**
    Retrieves mask of errors to be reported.
    */
    public function getErrorLevel():PxErrorCode;

    /**
    Retrieves the allocator this object was created with.
    */
    public function getAllocatorCallback():PxAllocatorCallback;
    
    /**
    Retrieves if allocation names are being passed to allocator callback.
    */
    public function getReportAllocationNames():Bool;
    
    /**
    Set if allocation names are being passed to allocator callback.
    \details Enabled by default in debug and checked build, disabled by default in profile and release build.
    */
    public function setReportAllocationNames(value:Bool):Void;

    @:native("::PxCreateFoundation")
    public static function create(version:PxU32, allocator:PxAllocatorCallback, errorCallback:PxErrorCallback):PxFoundation;
}