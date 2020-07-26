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
extern enum abstract PxBroadPhaseType(PxBroadPhaseTypeImpl)
{
    /**
     * 3-axes sweep-and-prune
     */
    @:native("physx::PxBroadPhaseType::eSAP") var eSAP;
    /**
     * Multi box pruning
     */
    @:native("physx::PxBroadPhaseType::eMBP") var eMBP;
    /**
     * Automatic box pruning
     */
    @:native("physx::PxBroadPhaseType::eABP") var eABP;

    @:native("physx::PxBroadPhaseType::eGPU") var eGPU;
    @:native("physx::PxBroadPhaseType::eLAST") var eLAST;
}

@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseType::Enum")
private extern class PxBroadPhaseTypeImpl {}

/**
\brief Broad-phase callback to receive broad-phase related events.

Each broadphase callback object is associated with a PxClientID. It is possible to register different
callbacks for different clients. The callback functions are called this way:
- for shapes/actors, the callback assigned to the actors' clients are used
- for aggregates, the callbacks assigned to clients from aggregated actors  are used

\note SDK state should not be modified from within the callbacks. In particular objects should not
be created or destroyed. If state modification is needed then the changes should be stored to a buffer
and performed after the simulation step.

<b>Threading:</b> It is not necessary to make this class thread safe as it will only be called in the context of the
user thread.

@see PxSceneDesc PxScene.setBroadPhaseCallback() PxScene.getBroadPhaseCallback()
*/
class PxBroadPhaseCallbackHx
{
    /**
    \brief Out-of-bounds notification.
    
    This function is called when an object leaves the broad-phase.

    \param[in] shape	Shape that left the broad-phase bounds
    \param[in] actor	Owner actor
    */
    function onObjectOutOfBounds(shape:PxShape, actor:PxActor):Void {}

    /**
    \brief Out-of-bounds notification.
    
    This function is called when an aggregate leaves the broad-phase.

    \param[in] aggregate	Aggregate that left the broad-phase bounds
    */
    function onAggregateOutOfBounds(aggregate:PxAggregate):Void {}
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
extern class PxBroadPhaseRegion
{
    var bounds:PxBounds3;		//!< Region's bounds
    var userData:physx.hx.PxUserData;	//!< Region's user-provided data
}

/**
\brief Information & stats structure for a region
*/
@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseRegionInfo")
extern class PxBroadPhaseRegionInfo
{
    var region:PxBroadPhaseRegion;				//!< User-provided region data
    var nbStaticObjects:PxU32;	//!< Number of static objects in the region
    var nbDynamicObjects:PxU32;	//!< Number of dynamic objects in the region
    var active:Bool;				//!< True if region is currently used, i.e. it has not been removed
    var overlap:Bool;			//!< True if region overlaps other regions (regions that are just touching are not considering overlapping)
}

/**
\brief Caps class for broad phase.
*/
@:include("PxBroadPhase.h")
@:native("physx::PxBroadPhaseCaps")
extern class PxBroadPhaseCaps
{
    var maxNbRegions:PxU32;			//!< Max number of regions supported by the broad-phase
    var maxNbObjects:PxU32;			//!< Max number of objects supported by the broad-phase
    var needsPredefinedBounds:Bool;	//!< If true, broad-phase needs 'regions' to work
}