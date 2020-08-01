package physx;

import physx.foundation.PxBounds3;
import physx.foundation.PxSimpleTypes;

/**
\brief Broad phase algorithm used in the simulation

eSAP is a good generic choice with great performance when many objects are sleeping. Performance
can degrade significantly though, when all objects are moving, or when large numbers of objects
are added to or removed from the broad phase. This algorithm does not need world bounds to be
defined in order to work.

eMBP is an alternative broad phase algorithm that does not suffer from the same performance
issues as eSAP when all objects are moving or when inserting large numbers of objects. However
its generic performance when many objects are sleeping might be inferior to eSAP, and it requires
users to define world bounds in order to work.

eABP is a revisited implementation of MBP, which automatically manages broad-phase regions.
It offers the convenience of eSAP (no need to define world bounds or regions) and the performance
of eMBP when a lot of objects are moving. While eSAP can remain faster when most objects are
sleeping and eMBP can remain faster when it uses a large number of properly-defined regions,
eABP often gives the best performance on average and the best memory usage.
*/
@:build(physx.hx.EnumBuilder.build("physx::PxBroadPhaseType"))
extern enum abstract PxBroadPhaseType(PxBroadPhaseTypeImpl)
{
    /** 3-axes sweep-and-prune */
    var eSAP;
    /** Multi box pruning */
    var eMBP;
    /** Automatic box pruning */
    var eABP;

    var eGPU;
    var eLAST;
}

@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseType::Enum")
private extern class PxBroadPhaseTypeImpl {}



@:native("::cpp::Reference<physx::PxBroadPhaseCallbackNative>")
private extern class PxBroadPhaseCallbackNative {}

/**
 * Broad-phase callback to receive broad-phase related events.
 * 
 * Each broadphase callback object is associated with a `PxClientID`. It is possible to register different
 * callbacks for different clients. The callback functions are called this way:
 * - for shapes/actors, the callback assigned to the actors' clients are used
 * - for aggregates, the callbacks assigned to clients from aggregated actors are used
 * 
 * **Note:** SDK state should not be modified from within the callbacks. In particular objects should not
 * be created or destroyed. If state modification is needed then the changes should be stored to a buffer
 * and performed after the simulation step.
 * 
 * **Threading:** It is not necessary to make this class thread safe as it will only be called in the context of the
 * user thread.
 * 
 * @see PxSceneDesc PxScene.setBroadPhaseCallback() PxScene.getBroadPhaseCallback()
 */
@:headerInclude("PxBroadPhase.h")
@:headerNamespaceCode("
class PxBroadPhaseCallbackNative : public physx::PxBroadPhaseCallback
{
public:
    physx::PxBroadPhaseCallbackHx hxHandle;
    PxBroadPhaseCallbackNative(physx::PxBroadPhaseCallbackHx hxHandle):hxHandle{ hxHandle } {}
    void onObjectOutOfBounds(PxShape& shape, PxActor& actor) override;
    void onObjectOutOfBounds(PxAggregate& aggregate) override;
};
")
@:cppNamespaceCode("
void PxBroadPhaseCallbackNative::onObjectOutOfBounds(PxShape& shape, PxActor& actor) { hxHandle->onObjectOutOfBounds(shape, actor); }
void PxBroadPhaseCallbackNative::onObjectOutOfBounds(PxAggregate& aggregate) { hxHandle->onAggregateOutOfBounds(aggregate); }
")
class PxBroadPhaseCallbackHx
{
    @:allow(physx.PxBroadPhaseCallback) @:noCompletion
    private var _native:PxBroadPhaseCallbackNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxBroadPhaseCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxBroadPhaseCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Out-of-bounds notification.
     * 
     * This function is called when an object leaves the broad-phase.
     * 
     * @param shape Shape that left the broad-phase bounds
     * @param actor Owner actor
     */
    function onObjectOutOfBounds(shape:PxShape, actor:PxActor):Void {}

    /**
     * \brief Out-of-bounds notification.
     *
     * This function is called when an aggregate leaves the broad-phase.
     *
     * @param aggregate Aggregate that left the broad-phase bounds
     */
    function onAggregateOutOfBounds(aggregate:PxAggregate):Void {}
}

/**
 * Assign with a Haxe class that extends `PxBroadPhaseCallbackHx`.
 */
@:noCompletion extern abstract PxBroadPhaseCallback(PxBroadPhaseCallbackNative)
{
    @:from static inline function from(hxHandle:PxBroadPhaseCallbackHx):PxBroadPhaseCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}



/**
\brief "Region of interest" for the broad-phase.

This is currently only used for the PxBroadPhaseType::eMBP broad-phase, which requires zones or regions to be defined
when the simulation starts in order to work. Regions can overlap and be added or removed at runtime, but at least one
region needs to be defined when the scene is created.

If objects that do no overlap any region are inserted into the scene, they will not be added to the broad-phase and
thus collisions will be disabled for them. A PxBroadPhaseCallback out-of-bounds notification will be sent for each one
of those objects.

The total number of regions is limited by PxBroadPhaseCaps::maxNbRegions.

The number of regions has a direct impact on performance and memory usage, so it is recommended to experiment with
various settings to find the best combination for your game. A good default setup is to start with global bounds
around the whole world, and subdivide these bounds into 4*4 regions. The PxBroadPhaseExt::createRegionsFromWorldBounds
function can do that for you.

@see PxBroadPhaseCallback PxBroadPhaseExt.createRegionsFromWorldBounds
*/
@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseRegion")
@:structAccess
extern class PxBroadPhaseRegion
{
    /**
     * Region's bounds
     */
    var bounds:PxBounds3;
    /**
     * Region's user-provided data
     */
    var userData:physx.hx.PxUserData;
}

/**
\brief Information & stats structure for a region
*/
@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseRegionInfo")
@:structAccess
extern class PxBroadPhaseRegionInfo
{
    /**
     * User-provided region data
     */
    var region:PxBroadPhaseRegion;
    /**
     * Number of static objects in the region
     */
    var nbStaticObjects:PxU32;
    /**
     * Number of dynamic objects in the region
     */
    var nbDynamicObjects:PxU32;
    /**
     * True if region is currently used, i.e. it has not been removed
     */
    var active:Bool;
    /**
     * True if region overlaps other regions (regions that are just touching are not considering overlapping)
     */
    var overlap:Bool;
}

/**
\brief Caps class for broad phase.
*/
@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseCaps")
@:structAccess
extern class PxBroadPhaseCaps
{
    /**
     * Max number of regions supported by the broad-phase
     */
    var maxNbRegions:PxU32;
    /**
     * Max number of objects supported by the broad-phase
     */
    var maxNbObjects:PxU32;
    /**
     * If true, broad-phase needs 'regions' to work
     */
    var needsPredefinedBounds:Bool;
}