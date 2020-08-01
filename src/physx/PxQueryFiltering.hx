package physx;

import physx.PxQueryReport;
import physx.PxFiltering.PxFilterData;

/**
\brief Filtering flags for scene queries.

@see PxQueryFilterData.flags
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxQueryFlag", physx.foundation.PxSimpleTypes.PxU16))
extern enum abstract PxQueryFlag(PxQueryFlagImpl) 
{
    /**
     * Traverse static shapes
     */
    var eSTATIC = (1<<0);
    /**
     * Traverse dynamic shapes
     */
    var eDYNAMIC = (1<<1);
    /**
     * Run the pre-intersection-test filter (see #PxQueryFilterCallback::preFilter())
     */
    var ePREFILTER = (1<<2);
    /**
     * Run the post-intersection-test filter (see #PxQueryFilterCallback::postFilter())
     */
    var ePOSTFILTER = (1<<3);
    /**
     * Abort traversal as soon as any hit is found and return it via callback.block.
     * Helps query performance. Both eTOUCH and eBLOCK hitTypes are considered hits with this flag.
     */
    var eANY_HIT = (1<<4);
    /**
     * All hits are reported as touching. Overrides eBLOCK returned from user filters with eTOUCH.
     * This is also an optimization hint that may improve query performance.
     */
    var eNO_BLOCK = (1<<5);
    // /**
    //  * Reserved for internal use
    //  */
    // var eRESERVED = (1<<15);
}

@:include("PxQueryFiltering.h")
@:native("physx::PxQueryFlags")
private extern class PxQueryFlagImpl {}

/**
\brief Flags typedef for the set of bits defined in PxQueryFlag.
*/
extern abstract PxQueryFlags(PxQueryFlag) from PxQueryFlag to PxQueryFlag {}

/**
\brief Classification of scene query hits (intersections).

 - eNONE: Returning this hit type means that the hit should not be reported.
 - eBLOCK: For all raycast, sweep and overlap queries the nearest eBLOCK type hit will always be returned in PxHitCallback::block member.
 - eTOUCH: Whenever a raycast, sweep or overlap query was called with non-zero PxHitCallback::nbTouches and PxHitCallback::touches
           parameters, eTOUCH type hits that are closer or same distance (touchDistance <= blockDistance condition)
           as the globally nearest eBLOCK type hit, will be reported.
 - For example, to record all hits from a raycast query, always return eTOUCH.

All hits in overlap() queries are treated as if the intersection distance were zero.
This means the hits are unsorted and all eTOUCH hits are recorded by the callback even if an eBLOCK overlap hit was encountered.
Even though all overlap() blocking hits have zero length, only one (arbitrary) eBLOCK overlap hit is recorded in PxHitCallback::block.
All overlap() eTOUCH type hits are reported (zero touchDistance <= zero blockDistance condition).

For raycast/sweep/overlap calls with zero touch buffer or PxHitCallback::nbTouches member,
only the closest hit of type eBLOCK is returned. All eTOUCH hits are discarded.

@see PxQueryFilterCallback.preFilter PxQueryFilterCallback.postFilter PxScene.raycast PxScene.sweep PxScene.overlap
*/
@:build(physx.hx.EnumBuilder.build("physx::PxQueryHitType"))
extern enum abstract PxQueryHitType(PxQueryHitTypeImpl) 
{
    /**
     * the query should ignore this shape
     */
    var eNONE = 0;
    /**
     * a hit on the shape touches the intersection geometry of the query but does not block it
     */
    var eTOUCH = 1;
    /**
     * a hit on the shape blocks the query (does not block overlap queries)
     */
    var eBLOCK = 2;
}

@:include("PxQueryFiltering.h")
@:native("physx::PxQueryHitType::Enum")
private extern class PxQueryHitTypeImpl {}

/**
Scene query filtering data.

Whenever the scene query intersects a shape, filtering is performed in the following order:

- For non-batched queries only:  
If the data field is non-zero, and the bitwise-AND value of data AND the shape's
queryFilterData is zero, the shape is skipped
- If filter callbacks are enabled in flags field (see `PxQueryFlags`) they will get invoked accordingly.
- If neither `PxQueryFlag.ePREFILTER` or `PxQueryFlag.ePOSTFILTER` is set, the hit defaults
to type `PxQueryHitType.eBLOCK` when the value of `PxHitCallback.nbTouches` provided with the query is zero and to type
`PxQueryHitType.eTOUCH` when `PxHitCallback.nbTouches` is positive.

@see PxScene.raycast PxScene.sweep PxScene.overlap PxBatchQuery.raycast PxBatchQuery.sweep PxBatchQuery.overlap PxQueryFlag::eANY_HIT
*/
@:forward
extern abstract PxQueryFilterData(PxQueryFilterDataData) 
{
    /**
     * Defaulted to `eDYNAMIC | eSTATIC` flags.
     */
    inline function new(?f:PxQueryFlags, ?fd:PxFilterData)
    {
        this = PxQueryFilterDataData.create(fd, f == null ? eDYNAMIC | eSTATIC : f);
    }
}

@:include("PxQueryFiltering.h")
@:native("physx::PxQueryFilterData")
@:structAccess
private extern class PxQueryFilterDataData
{
    @:native("physx::PxQueryFilterData")
    static function create(fd:PxFilterData, f:PxQueryFlags):PxQueryFilterDataData;

    /**
     * Filter data associated with the scene query
     */
    var data:PxFilterData;
    /**
     * Filter flags (see `PxQueryFlags`)
     */
    var flags:PxQueryFlags;
}



@:native("::cpp::Reference<physx::PxQueryFilterCallbackNative>")
private extern class PxQueryFilterCallbackNative {}

/**
\brief Scene query filtering callbacks.

Custom filtering logic for scene query intersection candidates. If an intersection candidate object passes the data based filter
(see #PxQueryFilterData), filtering callbacks are executed if requested (see #PxQueryFilterData.flags)

\li If #PxQueryFlag::ePREFILTER is set, the preFilter function runs before exact intersection tests.
If this function returns #PxQueryHitType::eTOUCH or #PxQueryHitType::eBLOCK, exact testing is performed to
determine the intersection location.

The preFilter function may overwrite the copy of queryFlags it receives as an argument to specify any of #PxHitFlag::eMODIFIABLE_FLAGS
on a per-shape basis. Changes apply only to the shape being filtered, and changes to other flags are ignored.

\li If #PxQueryFlag::ePREFILTER is not set, precise intersection testing is performed using the original query's filterData.flags.

\li If #PxQueryFlag::ePOSTFILTER is set, the postFilter function is called for each intersection to determine the touch/block status.
This overrides any touch/block status previously returned from the preFilter function for this shape.

Filtering calls are not guaranteed to be sorted along the ray or sweep direction.

@see PxScene.raycast PxScene.sweep PxScene.overlap PxQueryFlags PxHitFlags
*/
@:headerInclude("PxQueryFiltering.h")
@:headerNamespaceCode("
class PxQueryFilterCallbackNative : public PxQueryFilterCallback
{
public:
    PxQueryFilterCallbackHx hxHandle;
    PxQueryFilterCallbackNative(PxQueryFilterCallbackHx hxHandle):hxHandle{ hxHandle } {}
    PxQueryHitType::Enum preFilter(const PxFilterData& filterData, const PxShape* shape, const PxRigidActor* actor, PxHitFlags& queryFlags) override;
    PxQueryHitType::Enum postFilter(const PxFilterData& filterData, const PxQueryHit& hit) override;
};
")
@:cppNamespaceCode("
PxQueryHitType::Enum PxQueryFilterCallbackNative::preFilter(const PxFilterData& filterData, const PxShape* shape, const PxRigidActor* actor, PxHitFlags& queryFlags)
    { return hxHandle->preFilter(filterData, shape, actor, queryFlags); }
PxQueryHitType::Enum PxQueryFilterCallbackNative::postFilter(const PxFilterData& filterData, const PxQueryHit& hit)
    { return hxHandle->postFilter(filterData, &hit); };
")
class PxQueryFilterCallbackHx
{
    @:allow(physx.PxQueryFilterCallback) @:noCompletion
    private var _native:PxQueryFilterCallbackNative;

    public function new()
    {
        _native = untyped __cpp__("new PxQueryFilterCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxQueryFilterCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * This filter callback is executed before the exact intersection test if PxQueryFlag::ePREFILTER flag was set.
     * 
     * @param [in]filterData custom filter data specified as the query's filterData.data parameter.
     * @param [in]shape **Immutable** A shape that has not yet passed the exact intersection test.
     * @param [in]actor **Immutable** The shape's actor.
     * @param [in,out]queryFlags scene query flags from the query's function call (only flags from PxHitFlag::eMODIFIABLE_FLAGS bitmask can be modified)
     * @return the updated type for this hit  (see #PxQueryHitType)
     */
    @:unreflective function preFilter(filterData:PxFilterData, shape:PxShape, actor:PxRigidActor, queryFlags:cpp.Reference<PxHitFlags>):PxQueryHitType { return eNONE; }

    /**
     * This filter callback is executed if the exact intersection test returned true and PxQueryFlag::ePOSTFILTER flag was set.
     * 
     * @param [in]filterData custom filter data of the query
     * @param [in]hit **Immutable** Scene query hit information. `faceIndex` member is not valid for overlap queries. For sweep and raycast queries the hit information can be cast to `PxSweepHit` and `PxRaycastHit` respectively.
     * @return the updated hit type for this hit  (see `PxQueryHitType`)
     */
    function postFilter(filterData:PxFilterData, hit:cpp.ConstPointer<PxQueryHit>):PxQueryHitType { return eBLOCK; }
}

/**
 * Assign with `PxQueryFilterCallbackHx`.
 */
@:noCompletion extern abstract PxQueryFilterCallback(PxQueryFilterCallbackNative)
{
    @:from private static inline function from(hxHandle:PxQueryFilterCallbackHx):PxQueryFilterCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}