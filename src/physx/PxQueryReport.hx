package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;

/**
Scene query and geometry query behavior flags.

PxHitFlags are used for 3 different purposes:

1) To request hit fields to be filled in by scene queries (such as hit position, normal, face index or UVs).
2) Once query is completed, to indicate which fields are valid (note that a query may produce more valid fields than requested).
3) To specify additional options for the narrow phase and mid-phase intersection routines.

All these flags apply to both scene queries and geometry queries (PxGeometryQuery).

@see PxRaycastHit PxSweepHit PxOverlapHit PxScene.raycast PxScene.sweep PxScene.overlap PxGeometryQuery PxFindFaceIndex
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxHitFlag", PxU16))
extern enum abstract PxHitFlag(PxHitFlagImpl) 
{
    /**
     * "position" member of `PxQueryHit` is valid
     */
    var ePOSITION = (1<<0);
    /**
     * "normal" member of `PxQueryHit` is valid
     */
    var eNORMAL = (1<<1);
    /**
     * "u" and "v" barycentric coordinates of `PxQueryHit` are valid. Not applicable to sweep queries.
     */
    var eUV = (1<<3);
    /**
     * Performance hint flag for sweeps when it is known upfront there's no initial overlap.
     * NOTE: using this flag may cause undefined results if shapes are initially overlapping.
     */
    var eASSUME_NO_INITIAL_OVERLAP = (1<<4);
    /**
     * Report all hits for meshes rather than just the first. Not applicable to sweep queries.
     */
    var eMESH_MULTIPLE = (1<<5);
    /**
     * Report any first hit for meshes. If neither eMESH_MULTIPLE nor eMESH_ANY is specified,
     * a single closest hit will be reported for meshes.
     */
    var eMESH_ANY = (1<<6);
    /**
     * Report hits with back faces of mesh triangles. Also report hits for raycast
     * originating on mesh surface and facing away from the surface normal. Not applicable to sweep queries.
     * Please refer to the user guide for heightfield-specific differences.
     */
    var eMESH_BOTH_SIDES = (1<<7);
    /**
     * Use more accurate but slower narrow phase sweep tests.
     * May provide better compatibility with PhysX 3.2 sweep behavior.
     */
    var ePRECISE_SWEEP = (1<<8);
    /**
     * Report the minimum translation depth, normal and contact point.
     */
    var eMTD = (1<<9);
    /**
     * "face index" member of `PxQueryHit` is valid
     */
    var eFACE_INDEX = (1<<10);

    var eDEFAULT = ePOSITION | eNORMAL | eFACE_INDEX;

    /**
     * Only this subset of flags can be modified by pre-filter. Other modifications will be discarded.
     */
    var eMODIFIABLE_FLAGS = eMESH_MULTIPLE | eMESH_BOTH_SIDES | eASSUME_NO_INITIAL_OVERLAP | ePRECISE_SWEEP;
}

@:include("PxQueryReport.h")
@:native("physx::PxHitFlags")
private extern class PxHitFlagImpl {}

/**
collection of set bits defined in PxHitFlag.

@see PxHitFlag
*/
extern abstract PxHitFlags(PxHitFlag) from PxHitFlag to PxHitFlag {}

/**
Combines a shape pointer and the actor the shape belongs to into one memory location.

Serves as a base class for PxQueryHit.

@see PxQueryHit
*/
@:include("PxQueryReport.h")
@:native("physx::PxActorShape")
@:structAccess
extern class PxActorShape
{
    var actor:PxRigidActor;
    var shape:PxShape;
}

/**
Scene query hit information.
*/
@:include("PxQueryReport.h")
@:native("physx::PxQueryHit")
@:structAccess
extern class PxQueryHit extends PxActorShape
{
    /**
    Face index of touched triangle, for triangle meshes, convex meshes and height fields.

    **Note:** This index will default to 0xFFFFffff value for overlap queries.
    **Note:** Please refer to the user guide for more details for sweep queries.
    **Note:** This index is remapped by mesh cooking. Use `PxTriangleMesh.getTrianglesRemap()` to convert to original mesh index.
    **Note:** For convex meshes use `PxConvexMesh.getPolygonData()` to retrieve touched polygon data.
    */
    var faceIndex:PxU32;
}

/**
Scene query hit information for raycasts and sweeps returning hit position and normal information.

::PxHitFlag flags can be passed to scene query functions, as an optimization, to cause the SDK to
only generate specific members of this structure.
*/
@:include("PxQueryReport.h")
@:native("physx::PxLocationHit")
@:structAccess
extern class PxLocationHit extends PxQueryHit
{
    function hadInitialOverlap():Bool;

    // the following fields are set in accordance with the `PxHitFlags`
    
    /**
     * Hit flags specifying which members contain valid values.
     */
    var flags:PxHitFlags;
    /**
     * World-space hit position (flag: `PxHitFlag.ePOSITION)`
     */
    var position:PxVec3;
    /**
     * World-space hit normal (flag: `PxHitFlag.eNORMAL)`
     */
    var normal:PxVec3;

    /**
    \brief	Distance to hit.
    **Note:**	If the eMTD flag is used, distance will be a negative value if shapes are overlapping indicating the penetration depth.
    **Note:**	Otherwise, this value will be >= 0 
    */
    var distance:PxF32;
}

/**
Stores results of raycast queries.

::PxHitFlag flags can be passed to raycast function, as an optimization, to cause the SDK to only compute specified members of this
structure.

Some members like barycentric coordinates are currently only computed for triangle meshes and height fields, but next versions
might provide them in other cases. The client code should check `flags` to make sure returned values are valid.

@see PxScene.raycast PxBatchQuery.raycast
*/
@:include("PxQueryReport.h")
@:native("physx::PxRaycastHit")
@:structAccess
extern class PxRaycastHit extends PxLocationHit
{
    // the following fields are set in accordance with the `PxHitFlags`

    /**
     * barycentric coordinates u of hit point, for triangle mesh and height field (flag: `PxHitFlag.eUV`)
     */
    var u:PxReal;
    /**
     * barycentric coordinates v of hit point, for triangle mesh and height field (flag: `PxHitFlag.eUV`)
     */
    var v:PxReal;
// `if` !PX_P64_FAMILY
// 	PxU32	padTo16Bytes[3];
// `endif`
}

/**
Stores results of overlap queries.

@see PxScene.overlap PxBatchQuery.overlap
*/
@:include("PxQueryReport.h")
@:native("physx::PxOverlapHit")
@:structAccess
extern class PxOverlapHit extends PxQueryHit {}

/**
Stores results of sweep queries.

@see PxScene.sweep PxBatchQuery.sweep
*/
@:include("PxQueryReport.h")
@:native("physx::PxSweepHit")
@:structAccess
extern class PxSweepHit extends PxLocationHit {}

/**
Describes query behavior after returning a partial query result via a callback.

If callback returns true, traversal will continue and callback can be issued again.
If callback returns false, traversal will stop, callback will not be issued again.

@see PxHitCallback
*/
typedef PxAgain = Bool;


/**
\brief	This callback class facilitates reporting scene query hits (intersections) to the user.

User overrides the virtual processTouches function to receive hits in (possibly multiple) fixed size blocks.

**Note:**	PxHitBuffer derives from this class and is used to receive touching hits in a fixed size buffer.
**Note:**	Since the compiler doesn't look in template dependent base classes when looking for non-dependent names
**Note:**	with some compilers it will be necessary to use "this->hasBlock" notation to access a parent variable
**Note:**	in a child callback class.
**Note:**	Pre-made typedef shorthands, such as ::PxRaycastCallback can be used for raycast, overlap and sweep queries.

@see PxHitBuffer PxRaycastHit PxSweepHit PxOverlapHit PxRaycastCallback PxOverlapCallback PxSweepCallback
*/
private extern class PxHitCallbackNative<HitType:PxQueryHit>
{
    var block:HitType;
    var hasBlock:Bool;
    var touches:cpp.Pointer<HitType>;
    var maxNbTouches:PxU32;
    var nbTouches:PxU32;
    function hasAnyHits():Bool;
}

@:native("::cpp::Reference<physx::PxRaycastCallbackNative>")
private extern class PxRaycastCallbackNative extends PxHitCallbackNative<PxRaycastHit> {}
@:native("::cpp::Reference<physx::PxOverlapCallbackNative>")
private extern class PxOverlapCallbackNative extends PxHitCallbackNative<PxOverlapHit> {}
@:native("::cpp::Reference<physx::PxSweepCallbackNative>")
private extern class PxSweepCallbackNative   extends PxHitCallbackNative<PxSweepHit> {}

/**
 * Raycast query callback.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:headerInclude("PxQueryReport.h")
@:headerNamespaceCode("
class PxRaycastCallbackNative : public PxRaycastCallback
{
public:
    PxRaycastCallbackHx hxHandle;
    PxRaycastCallbackNative(PxRaycastCallbackHx hxHandle, PxRaycastHit* aTouches, PxU32 aMaxNbTouches):PxRaycastCallback(aTouches, aMaxNbTouches), hxHandle{ hxHandle } {}
    PxAgain processTouches(const PxRaycastHit* buffer, PxU32 nbHits) override;
    void finalizeQuery() override;
};
")
@:cppNamespaceCode("
PxAgain PxRaycastCallbackNative::processTouches(const PxRaycastHit* buffer, PxU32 nbHits) { return hxHandle->processTouches(buffer, nbHits); }
void PxRaycastCallbackNative::finalizeQuery() { hxHandle->finalizeQuery(); }
")
class PxRaycastCallbackHx
{
    @:allow(physx.PxRaycastCallback) @:noCompletion
    private var _native:PxRaycastCallbackNative;

    /**
     * Initializes the class with user provided buffer.
     * 
     * **Note:** If `touches` is `null` or its `.length` is 0, only the closest blocking hit will be recorded by the query.
     * If `PxQueryFlag.eANY_HIT` flag is used as a query parameter, `hasBlock` will be set to `true` and `blockingHit` will be used to receive the result.
     * Both `eTOUCH` and `eBLOCK` hits will be registered as `hasBlock=true` and stored in `PxHitCallback.block` when `eANY_HIT` flag is used.
     * 
     * @param touches Optional array for recording `PxQueryHitType.eTOUCH` type hits. Must be resized in advance.
     * 
     * @see PxHitCallback.hasBlock PxHitCallback.block 
     */
    public function new(?touches:Array<PxRaycastHit>) 
    {
        if(touches == null || touches.length == 0)
            _native = untyped __cpp__("new PxRaycastCallbackNative(this, nullptr, 0)");
        else
            _native = untyped __cpp__("new PxRaycastCallbackNative(this, {0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxRaycastCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Virtual callback function used to communicate query results to the user.
     * 
     * This callback will always be invoked with `touches` as a buffer if `touches` was specified as non-NULL.
     * All reported touch hits are guaranteed to be closer than the closest blocking hit.
     * 
     * **Note:** There is a significant performance penalty in case multiple touch callbacks are issued (up to 2x)  
     * to avoid the penalty use a bigger buffer so that all touching hits can be reported in a single buffer.  
     * If true (again) is returned from the callback, nbTouches will be reset to 0,  
     * If false is returned, nbTouched will remain unchanged.
     * By the time processTouches is first called, the globally closest blocking hit is already determined,
     * values of hasBlock and block are final and all touch hits are guaranteed to be closer than the blocking hit.
     * touches and maxNbTouches can be modified inside of processTouches callback.
     * 
     * @param [in]buffer Callback will report touch hits to the user in this buffer. This pointer will be the same as `touches.`
     * @param [in]nbHits Number of touch hits reported in buffer. This number will not exceed `maxNbTouches.`
     * 
     * @return true to continue receiving callbacks in case there are more hits or false to stop.
     * 
     * @see PxAgain PxRaycastHit PxSweepHit PxOverlapHit 
     */
    function processTouches(buffer:cpp.ConstPointer<PxRaycastHit>, nbHits:PxU32):PxAgain { return false; }
    /**
     * Query finalization callback, called after the last `processTouches` callback.
     */
    function finalizeQuery() {}
}

/**
 * Overlap query callback.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:headerInclude("PxQueryReport.h")
@:headerNamespaceCode("
class PxOverlapCallbackNative : public PxOverlapCallback
{
public:
    PxOverlapCallbackHx hxHandle;
    PxOverlapCallbackNative(PxOverlapCallbackHx hxHandle, PxOverlapHit* aTouches, PxU32 aMaxNbTouches):PxOverlapCallback(aTouches, aMaxNbTouches), hxHandle{ hxHandle } {}
    PxAgain processTouches(const PxOverlapHit* buffer, PxU32 nbHits) override;
    void finalizeQuery() override;
};
")
@:cppNamespaceCode("
PxAgain PxOverlapCallbackNative::processTouches(const PxOverlapHit* buffer, PxU32 nbHits) { return hxHandle->processTouches(buffer, nbHits); }
void PxOverlapCallbackNative::finalizeQuery() { hxHandle->finalizeQuery(); }
")
class PxOverlapCallbackHx
{
    @:allow(physx.PxOverlapCallback) @:noCompletion
    private var _native:PxOverlapCallbackNative;

    /**
     * Initializes the class with user provided buffer.
     * 
     * **Note:** If `touches` is `null` or its `.length` is 0, only the closest blocking hit will be recorded by the query.
     * If `PxQueryFlag.eANY_HIT` flag is used as a query parameter, `hasBlock` will be set to `true` and `blockingHit` will be used to receive the result.
     * Both `eTOUCH` and `eBLOCK` hits will be registered as `hasBlock=true` and stored in `PxHitCallback.block` when `eANY_HIT` flag is used.
     * 
     * @param touches Optional array for recording `PxQueryHitType.eTOUCH` type hits. Must be resized in advance.
     * 
     * @see PxHitCallback.hasBlock PxHitCallback.block 
     */
    public function new(?touches:Array<PxOverlapHit>) 
    {
        if(touches == null || touches.length == 0)
            _native = untyped __cpp__("new PxOverlapCallbackNative(this, nullptr, 0)");
        else
            _native = untyped __cpp__("new PxOverlapCallbackNative(this, {0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxOverlapCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Virtual callback function used to communicate query results to the user.
     * 
     * This callback will always be invoked with `touches` as a buffer if `touches` was specified as non-NULL.
     * All reported touch hits are guaranteed to be closer than the closest blocking hit.
     * 
     * **Note:** There is a significant performance penalty in case multiple touch callbacks are issued (up to 2x)  
     * to avoid the penalty use a bigger buffer so that all touching hits can be reported in a single buffer.  
     * If true (again) is returned from the callback, nbTouches will be reset to 0,  
     * If false is returned, nbTouched will remain unchanged.
     * By the time processTouches is first called, the globally closest blocking hit is already determined,
     * values of hasBlock and block are final and all touch hits are guaranteed to be closer than the blocking hit.
     * touches and maxNbTouches can be modified inside of processTouches callback.
     * 
     * @param [in]buffer Callback will report touch hits to the user in this buffer. This pointer will be the same as `touches.`
     * @param [in]nbHits Number of touch hits reported in buffer. This number will not exceed `maxNbTouches.`
     * 
     * @return true to continue receiving callbacks in case there are more hits or false to stop.
     * 
     * @see PxAgain PxRaycastHit PxSweepHit PxOverlapHit 
     */
    function processTouches(buffer:cpp.ConstPointer<PxRaycastHit>, nbHits:PxU32):PxAgain { return false; }
    /**
     * Query finalization callback, called after the last `processTouches` callback.
     */
    function finalizeQuery() {}
}

/**
 * Sweep query callback.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:headerInclude("PxQueryReport.h")
@:headerNamespaceCode("
class PxSweepCallbackNative : public PxSweepCallback
{
public:
    PxSweepCallbackHx hxHandle;
    PxSweepCallbackNative(PxSweepCallbackHx hxHandle, PxSweepHit* aTouches, PxU32 aMaxNbTouches):PxSweepCallback(aTouches, aMaxNbTouches), hxHandle{ hxHandle } {}
    PxAgain processTouches(const PxSweepHit* buffer, PxU32 nbHits) override;
    void finalizeQuery() override;
};
")
@:cppNamespaceCode("
PxAgain PxSweepCallbackNative::processTouches(const PxSweepHit* buffer, PxU32 nbHits) { return hxHandle->processTouches(buffer, nbHits); }
void PxSweepCallbackNative::finalizeQuery() { hxHandle->finalizeQuery(); }
")
class PxSweepCallbackHx
{
    @:allow(physx.PxSweepCallback) @:noCompletion
    private var _native:PxSweepCallbackNative;

    /**
     * Initializes the class with user provided buffer.
     * 
     * **Note:** If `touches` is `null` or its `.length` is 0, only the closest blocking hit will be recorded by the query.
     * If `PxQueryFlag.eANY_HIT` flag is used as a query parameter, `hasBlock` will be set to `true` and `blockingHit` will be used to receive the result.
     * Both `eTOUCH` and `eBLOCK` hits will be registered as `hasBlock=true` and stored in `PxHitCallback.block` when `eANY_HIT` flag is used.
     * 
     * @param touches Optional array for recording `PxQueryHitType.eTOUCH` type hits. Must be resized in advance.
     * 
     * @see PxHitCallback.hasBlock PxHitCallback.block 
     */
    public function new(?touches:Array<PxSweepHit>) 
    {
        if(touches == null || touches.length == 0)
            _native = untyped __cpp__("new PxSweepCallbackNative(this, nullptr, 0)");
        else
            _native = untyped __cpp__("new PxSweepCallbackNative(this, {0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxSweepCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Virtual callback function used to communicate query results to the user.
     * 
     * This callback will always be invoked with `touches` as a buffer if `touches` was specified as non-NULL.
     * All reported touch hits are guaranteed to be closer than the closest blocking hit.
     * 
     * **Note:** There is a significant performance penalty in case multiple touch callbacks are issued (up to 2x)  
     * to avoid the penalty use a bigger buffer so that all touching hits can be reported in a single buffer.  
     * If true (again) is returned from the callback, nbTouches will be reset to 0,  
     * If false is returned, nbTouched will remain unchanged.
     * By the time processTouches is first called, the globally closest blocking hit is already determined,
     * values of hasBlock and block are final and all touch hits are guaranteed to be closer than the blocking hit.
     * touches and maxNbTouches can be modified inside of processTouches callback.
     * 
     * @param [in]buffer Callback will report touch hits to the user in this buffer. This pointer will be the same as `touches.`
     * @param [in]nbHits Number of touch hits reported in buffer. This number will not exceed `maxNbTouches.`
     * 
     * @return true to continue receiving callbacks in case there are more hits or false to stop.
     * 
     * @see PxAgain PxRaycastHit PxSweepHit PxOverlapHit 
     */
    function processTouches(buffer:cpp.ConstPointer<PxRaycastHit>, nbHits:PxU32):PxAgain { return false; }
    /**
     * Query finalization callback, called after the last `processTouches` callback.
     */
    function finalizeQuery() {}
}


/**
\brief	Returns scene query hits (intersections) to the user in a preallocated buffer.

Will clip touch hits to maximum buffer capacity. When clipped, an arbitrary subset of touching hits will be discarded.
Overflow does not trigger warnings or errors. block and hasBlock will be valid in finalizeQuery callback and after query completion.
Touching hits are guaranteed to have closer or same distance ( <= condition) as the globally nearest blocking hit at the time any processTouches()
callback is issued.

**Note:**	Pre-made typedef shorthands, such as ::PxRaycastBuffer can be used for raycast, overlap and sweep queries.

@see PxHitCallback
@see PxRaycastBuffer PxOverlapBuffer PxSweepBuffer PxRaycastBufferN PxOverlapBufferN PxSweepBufferN
*/
private extern class PxHitBufferNative<HitType:PxQueryHit> extends PxHitCallbackNative<HitType>
{
    function getNbAnyHits():PxU32;
    function getAnyHit(index:PxU32):HitType;
    function getNbTouches():PxU32;
    function getTouches():cpp.ConstPointer<HitType>;
    function getTouch(index:PxU32):HitType;
    function getMaxNbTouches():PxU32;
}

@:native("::cpp::Struct<physx::PxRaycastBuffer>")
private extern class PxRaycastBufferNative extends PxHitBufferNative<PxRaycastHit> {}
@:native("::cpp::Struct<physx::PxOverlapBuffer>")
private extern class PxOverlapBufferNative extends PxHitBufferNative<PxOverlapHit> {}
@:native("::cpp::Struct<physx::PxSweepBuffer>")
private extern class PxSweepBufferNative   extends PxHitBufferNative<PxSweepHit> {}

/**
 * Raycast query buffer.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:forward
extern abstract PxRaycastBuffer(PxRaycastBufferNative) to PxRaycastBufferNative
{
    /**
     * Initializes the buffer with user memory.
     *
     * The buffer is initialized with 0 touch hits by default => query will only report a single closest blocking hit.
     * Use PxQueryFlag::eANY_HIT to tell the query to abort and return any first hit encoutered as blocking.
     * 
     * @param touches Optional array for recording PxQueryHitType::eTOUCH type hits. Must be resized in advance.
     */
    inline function new(?touches:Array<PxRaycastHit>) 
    {
        if(touches == null || touches.length == 0)
            this = untyped __cpp__("physx::PxRaycastBuffer(nullptr, 0)");
        else
            this = untyped __cpp__("physx::PxRaycastBuffer({0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
    }
}

/**
 * Overlap query buffer.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:forward
extern abstract PxOverlapBuffer(PxOverlapBufferNative) to PxOverlapBufferNative
{
    /**
     * Initializes the buffer with user memory.
     *
     * The buffer is initialized with 0 touch hits by default => query will only report a single closest blocking hit.
     * Use PxQueryFlag::eANY_HIT to tell the query to abort and return any first hit encoutered as blocking.
     * 
     * @param touches Optional array for recording PxQueryHitType::eTOUCH type hits. Must be resized in advance.
     */
    inline function new(?touches:Array<PxOverlapHit>) 
    {
        if(touches == null || touches.length == 0)
            this = untyped __cpp__("physx::PxOverlapBuffer(nullptr, 0)");
        else
            this = untyped __cpp__("physx::PxOverlapBuffer({0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
    }
}

/**
 * Sweep query buffer.
 * 
 * For touch buffer: Construct an external array, resize it, and pass it into `new`.
 */
@:forward
extern abstract PxSweepBuffer(PxSweepBufferNative) to PxSweepBufferNative
{
    /**
     * Initializes the buffer with user memory.
     *
     * The buffer is initialized with 0 touch hits by default => query will only report a single closest blocking hit.
     * Use PxQueryFlag::eANY_HIT to tell the query to abort and return any first hit encoutered as blocking.
     * 
     * @param touches Optional array for recording PxQueryHitType::eTOUCH type hits. Must be resized in advance.
     */
    inline function new(?touches:Array<PxSweepHit>) 
    {
        if(touches == null || touches.length == 0)
            this = untyped __cpp__("physx::PxSweepBuffer(nullptr, 0)");
        else
            this = untyped __cpp__("physx::PxSweepBuffer({0}, {1})", cpp.Pointer.ofArray(touches), cast touches.length);
    }
}

/**
 * Assign with `PxRaycastCallbackHx` or `PxRaycastBuffer`.
 */
@:noCompletion extern abstract PxRaycastCallback(PxHitCallbackNative<PxRaycastHit>) from PxRaycastBuffer
{
    @:from private static inline function from(hxHandle:PxRaycastCallbackHx):PxRaycastCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}

/**
 * Assign with `PxOverlapCallbackHx` or `PxOverlapBuffer`.
 */
@:noCompletion extern abstract PxOverlapCallback(PxHitCallbackNative<PxOverlapHit>) from PxOverlapBuffer
{
    @:from private static inline function from(hxHandle:PxOverlapCallbackHx):PxOverlapCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}

/**
 * Assign with `PxSweepCallbackHx` or `PxSweepBuffer`.
 */
@:noCompletion extern abstract PxSweepCallback(PxHitCallbackNative<PxSweepHit>) from PxSweepBuffer
{
    @:from private static inline function from(hxHandle:PxSweepCallbackHx):PxSweepCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}