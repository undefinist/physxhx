package physx.extensions;

import physx.foundation.PxSimpleTypes.PxU32;
import physx.task.PxCpuDispatcher;

/**
A default implementation for a CPU task dispatcher.

The default implementation has been modified to allow multi-threading in Haxe safely.

To create, use `PxDefaultCpuDispatcher.create()`.
*/
@:include("PxDefaultCpuDispatcherHx.h")
@:native("::cpp::Reference<physx::PxDefaultCpuDispatcherHx>")
extern class PxDefaultCpuDispatcher extends PxCpuDispatcher
{
    /**
    Deletes the dispatcher.
    
    Do not keep a reference to the deleted instance.

    @see PxDefaultCpuDispatcherCreate()
    */
    function release():Void;

    /**
    Enables profiling at task level.

    **Note:** By default enabled only in profiling builds.
    
    @param [in]runProfiled True if tasks should be profiled.
    */
    function setRunProfiled(runProfiled:Bool):Void;
    
    /**
    Enables profiling at task level.

    **Note:** By default enabled only in profiling builds.
    
    @param [in]runProfiled True if tasks should be profiled.
    */
    function getRunProfiled():Bool;

    /**
    Create default dispatcher, extensions SDK needs to be initialized first.

    `numThreads` may be zero in which case no worker thread are initialized and
    simulation tasks will be executed on the thread that calls `PxScene.simulate()`

    @param numThreads Number of worker threads the dispatcher should use.
    @param affinityMasks Array with affinity mask for each thread. If not defined, default masks will be used.

    @see PxDefaultCpuDispatcher
    */
    inline static function create(numThreads:PxU32, ?affinityMasks:Array<PxU32>):PxDefaultCpuDispatcher
    {
        if(affinityMasks == null || affinityMasks.length == 0)
            return untyped __cpp__(
                "physx::PxDefaultCpuDispatcherCreateHx({0})", numThreads);
        else 
            return untyped __cpp__(
                "physx::PxDefaultCpuDispatcherCreateHx({0}, {1})", numThreads, cpp.Pointer.ofArray(affinityMasks));
    }
}