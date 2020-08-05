package physx;

import physx.foundation.PxSimpleTypes;

/**
Collection of flags describing the actions to take for a collision pair.

@see PxPairFlags PxSimulationFilterShader.filter() PxSimulationFilterCallback
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxPairFlag", PxU16))
extern enum abstract PxPairFlag(PxPairFlagImpl)
{
    /**
    Process the contacts of this collision pair in the dynamics solver.

    **Note:** Only takes effect if the colliding actors are rigid bodies.
    */
    var eSOLVE_CONTACT = (1<<0);

    /**
    Call contact modification callback for this collision pair

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    @see PxContactModifyCallback
    */
    var eMODIFY_CONTACTS = (1<<1);

    /**
    Call contact report callback or trigger callback when this collision pair starts to be in contact.

    If one of the two collision objects is a trigger shape (see `PxShapeFlag.eTRIGGER_SHAPE)` 
    then the trigger callback will get called as soon as the other object enters the trigger volume. 
    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called when the actors of this collision pair start to be in contact.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    var eNOTIFY_TOUCH_FOUND = (1<<2);

    /**
    Call contact report callback while this collision pair is in contact

    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called while the actors of this collision pair are in contact.

    **Note:** Triggers do not support this event. Persistent trigger contacts need to be tracked separately by observing eNOTIFY_TOUCH_FOUND/eNOTIFY_TOUCH_LOST events.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** No report will get sent if the objects in contact are sleeping.

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    **Note:** If this flag gets enabled while a pair is in touch already, there will be no eNOTIFY_TOUCH_PERSISTS events until the pair loses and regains touch.

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    var eNOTIFY_TOUCH_PERSISTS = (1<<3);

    /**
    Call contact report callback or trigger callback when this collision pair stops to be in contact

    If one of the two collision objects is a trigger shape (see `PxShapeFlag.eTRIGGER_SHAPE)` 
    then the trigger callback will get called as soon as the other object leaves the trigger volume. 
    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called when the actors of this collision pair stop to be in contact.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** This event will also get triggered if one of the colliding objects gets deleted.

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    var eNOTIFY_TOUCH_LOST = (1<<4);

    /**
    Call contact report callback when this collision pair is in contact during CCD passes.

    If CCD with multiple passes is enabled, then a fast moving object might bounce on and off the same
    object multiple times. Hence, the same pair might be in contact multiple times during a simulation step.
    This flag will make sure that all the detected collision during CCD will get reported. For performance
    reasons, the system can not always tell whether the contact pair lost touch in one of the previous CCD 
    passes and thus can also not always tell whether the contact is new or has persisted. eNOTIFY_TOUCH_CCD
    just reports when the two collision objects were detected as being in contact during a CCD pass.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** Trigger shapes are not supported.

    **Note:** Only takes effect if eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    var eNOTIFY_TOUCH_CCD = (1<<5);

    /**
    Call contact report callback when the contact force between the actors of this collision pair exceeds one of the actor-defined force thresholds.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    var eNOTIFY_THRESHOLD_FORCE_FOUND = (1<<6);

    /**
    Call contact report callback when the contact force between the actors of this collision pair continues to exceed one of the actor-defined force thresholds.

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** If a pair gets re-filtered and this flag has previously been disabled, then the report will not get fired in the same frame even if the force threshold has been reached in the
    previous one (unless `eNOTIFY_THRESHOLD_FORCE_FOUND` has been set in the previous frame).

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    var eNOTIFY_THRESHOLD_FORCE_PERSISTS = (1<<7);

    /**
    Call contact report callback when the contact force between the actors of this collision pair falls below one of the actor-defined force thresholds (includes the case where this collision pair stops being in contact).

    **Note:** Only takes effect if the colliding actors are rigid bodies.

    **Note:** If a pair gets re-filtered and this flag has previously been disabled, then the report will not get fired in the same frame even if the force threshold has been reached in the
    previous one (unless `eNOTIFY_THRESHOLD_FORCE_FOUND` or `eNOTIFY_THRESHOLD_FORCE_PERSISTS` has been set in the previous frame).

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    var eNOTIFY_THRESHOLD_FORCE_LOST = (1<<8);

    /**
    Provide contact points in contact reports for this collision pair.

    **Note:** Only takes effect if the colliding actors are rigid bodies and if used in combination with the flags eNOTIFY_TOUCH_... or eNOTIFY_THRESHOLD_FORCE_...

    **Note:** Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxContactPair PxContactPair.extractContacts()
    */
    var eNOTIFY_CONTACT_POINTS = (1<<9);

    /**
    This flag is used to indicate whether this pair generates discrete collision detection contacts. 

    **Note:** Contacts are only responded to if eSOLVE_CONTACT is enabled.
    */
    var eDETECT_DISCRETE_CONTACT = (1<<10);
    
    /**
    This flag is used to indicate whether this pair generates CCD contacts. 

    **Note:** The contacts will only be responded to if eSOLVE_CONTACT is enabled on this pair.
    **Note:** The scene must have PxSceneFlag::eENABLE_CCD enabled to use this feature.
    **Note:** Non-static bodies of the pair should have PxRigidBodyFlag::eENABLE_CCD specified for this feature to work correctly.
    **Note:** This flag is not supported with trigger shapes. However, CCD trigger events can be emulated using non-trigger shapes 
    and requesting eNOTIFY_TOUCH_FOUND and eNOTIFY_TOUCH_LOST and not raising eSOLVE_CONTACT on the pair.

    @see PxRigidBodyFlag::eENABLE_CCD
    @see PxSceneFlag::eENABLE_CCD
    */
    var eDETECT_CCD_CONTACT = (1<<11);

    /**
    Provide pre solver velocities in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the velocities of the rigid bodies before contacts have been solved
    will be provided in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    **Note:** Usually it is not necessary to request these velocities as they will be available by querying the velocity from the provided
    PxRigidActor object directly. However, it might be the case that the velocity of a rigid body gets set while the simulation is running
    in which case the PxRigidActor would return this new velocity in the contact report callback and not the velocity the simulation used.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairVelocity, PxContactPairHeader.extraDataStream
    */
    var ePRE_SOLVER_VELOCITY = (1<<12);
    
    /**
    Provide post solver velocities in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the velocities of the rigid bodies after contacts have been solved
    will be provided in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairVelocity, PxContactPairHeader.extraDataStream
    */
    var ePOST_SOLVER_VELOCITY = (1<<13);
    
    /**
    Provide rigid body poses in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the rigid body poses at the contact event will be provided 
    in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    **Note:** Usually it is not necessary to request these poses as they will be available by querying the pose from the provided
    PxRigidActor object directly. However, it might be the case that the pose of a rigid body gets set while the simulation is running
    in which case the PxRigidActor would return this new pose in the contact report callback and not the pose the simulation used.
    Another use case is related to CCD with multiple passes enabled, A fast moving object might bounce on and off the same 
    object multiple times. This flag can be used to request the rigid body poses at the time of impact for each such collision event.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairPose, PxContactPairHeader.extraDataStream
    */
    var eCONTACT_EVENT_POSE = (1<<14);

    //var eNEXT_FREE;

    /**
    Provided default flag to do simple contact processing for this collision pair.
    */
    var eCONTACT_DEFAULT = eSOLVE_CONTACT | eDETECT_DISCRETE_CONTACT;

    /**
    Provided default flag to get commonly used trigger behavior for this collision pair.
    */
    var eTRIGGER_DEFAULT = eNOTIFY_TOUCH_FOUND | eNOTIFY_TOUCH_LOST | eDETECT_DISCRETE_CONTACT;
}

@:include("PxFiltering.h")
@:native("physx::PxPairFlags")
private extern class PxPairFlagImpl {}

/**
Bitfield that contains a set of raised flags defined in PxPairFlag.

@see PxPairFlag
*/
extern abstract PxPairFlags(PxPairFlag) from PxPairFlag to PxPairFlag {}



/**
Collection of flags describing the filter actions to take for a collision pair.

@see PxFilterFlags PxSimulationFilterShader PxSimulationFilterCallback
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxFilterFlag", PxU16))
extern enum abstract PxFilterFlag(PxFilterFlagImpl)
{
    /**
    Ignore the collision pair as long as the bounding volumes of the pair objects overlap.

    Killed pairs will be ignored by the simulation and won't run through the filter again until one
    of the following occurs:

    - The bounding volumes of the two objects overlap again (after being separated)
    - The user enforces a re-filtering (see `PxScene.resetFiltering()`)

    @see PxScene::resetFiltering()
    */
    var eKILL = (1<<0);

    /**
    Ignore the collision pair as long as the bounding volumes of the pair objects overlap or until filtering relevant data changes for one of the collision objects.

    Suppressed pairs will be ignored by the simulation and won't make another filter request until one
    of the following occurs:

    - Same conditions as for killed pairs (see `eKILL)`
    - The filter data or the filter object attributes change for one of the collision objects

    @see PxFilterData PxFilterObjectAttributes
    */
    var eSUPPRESS = (1<<1);

    /**
    Invoke the filter callback (`PxSimulationFilterCallback.pairFound()`) for this collision pair.

    @see PxSimulationFilterCallback
    */
    var eCALLBACK = (1<<2);

    /**
    Track this collision pair with the filter callback mechanism.

    When the bounding volumes of the collision pair lose contact, the filter callback `PxSimulationFilterCallback.pairLost()`
    will be invoked. Furthermore, the filter status of the collision pair can be adjusted through `PxSimulationFilterCallback.statusChange()`
    once per frame (until a pairLost() notification occurs).

    @see PxSimulationFilterCallback
    */
    var eNOTIFY = (1<<3) | eCALLBACK;

    /** 
    Provided default to get standard behavior:

    The application configure the pair's collision properties once when bounding volume overlap is found and
    doesn't get asked again about that pair until overlap status or filter properties changes, or re-filtering is requested.

    No notification is provided when bounding volume overlap is lost

    The pair will not be killed or suppressed, so collision detection will be processed
    */
    var eDEFAULT = 0;
}

@:include("PxFiltering.h")
@:native("physx::PxFilterFlags")
private extern class PxFilterFlagImpl {}

/**
Bitfield that contains a set of raised flags defined in PxFilterFlag.

@see PxFilterFlag
*/
extern abstract PxFilterFlags(PxFilterFlag) from PxFilterFlag to PxFilterFlag {}



/**
PxFilterData is user-definable data which gets passed into the collision filtering shader and/or callback.

@see PxShape.setSimulationFilterData() PxShape.getSimulationFilterData()  PxSimulationFilterShader PxSimulationFilterCallback
*/
@:forward
extern abstract PxFilterData(PxFilterDataData)
{
    inline function new(w0:PxU32, w1:PxU32, w2:PxU32, w3:PxU32)
    {
        this = PxFilterDataData.create(w0, w1, w2, w3);
    }
    static inline function zero():PxFilterData
    {
        return null;
    }
}

@:include("PxFiltering.h")
@:native("physx::PxFilterData")
@:structAccess
private extern class PxFilterDataData
{
    var word0:PxU32;
    var word1:PxU32;
    var word2:PxU32;
    var word3:PxU32;

    function setToDefault():Void;
    @:native("physx::PxFilterData") static function create(w0:PxU32, w1:PxU32, w2:PxU32, w3:PxU32):PxFilterDataData;
}


/**
Identifies each type of filter object.

@see PxGetFilterObjectType()
*/
@:build(physx.hx.EnumBuilder.build("physx::PxFilterObjectType"))
extern enum abstract PxFilterObjectType(PxFilterObjectTypeImpl)
{
    /**
    A static rigid body
    @see PxRigidStatic
    */
    var eRIGID_STATIC;

    /**
    A dynamic rigid body
    @see PxRigidDynamic
    */
    var eRIGID_DYNAMIC;

    /**
    An articulation
    @see PxArticulation
    */
    var eARTICULATION;

    //brief internal use only!
    //eMAX_TYPE_COUNT = 16,

    //brief internal use only!
    //eUNDEFINED = eMAX_TYPE_COUNT-1	
}

@:include("PxFiltering.h")
@:native("physx::PxFilterObjectType::Enum")
private extern class PxFilterObjectTypeImpl {}


/**
Structure which gets passed into the collision filtering shader and/or callback providing additional information on objects of a collision pair

@see PxSimulationFilterShader PxSimulationFilterCallback getActorType() PxFilterObjectIsKinematic() PxFilterObjectIsTrigger()
*/
typedef PxFilterObjectAttributes = PxU32;


@:include("PxFiltering.h")
extern class PxFilterObject
{
    /**
    Extract filter object type from the filter attributes of a collision pair object
    
    @param [in]attr The filter attribute of a collision pair object
    @return The type of the collision pair object.
    
    @see PxFilterObjectType
    */
    @:native("physx::PxGetFilterObjectType")
    static function GetType(attr:PxFilterObjectAttributes):PxFilterObjectType;

    /**
    Specifies whether the collision object belongs to a kinematic rigid body

    @param [in]attr The filter attribute of a collision pair object
    @return True if the object belongs to a kinematic rigid body, else false

    @see PxRigidBodyFlag::eKINEMATIC
    */
    @:native("physx::PxFilterObjectIsKinematic")
    static function IsKinematic(attr:PxFilterObjectAttributes):Bool;

    /**
    Specifies whether the collision object is a trigger shape

    @param [in]attr The filter attribute of a collision pair object
    @return True if the object is a trigger shape, else false

    @see PxShapeFlag::eTRIGGER_SHAPE
    */
    @:native("physx::PxFilterObjectIsTrigger")
    static function IsTrigger(attr:PxFilterObjectAttributes):Bool;
}


/**
 * **You need to use meta tag `@:unreflective`, write a static function with this signature, and use cpp.Callable.fromStaticFunction()**
 * 
 * Filter method to specify how a pair of potentially colliding objects should be processed.
 * 
 * Collision filtering is a mechanism to specify how a pair of potentially colliding objects should be processed by the
 * simulation. A pair of objects is potentially colliding if the bounding volumes of the two objects overlap.
 * In short, a collision filter decides whether a collision pair should get processed, temporarily ignored or discarded.
 * If a collision pair should get processed, the filter can additionally specify how it should get processed, for instance,
 * whether contacts should get resolved, which callbacks should get invoked or which reports should be sent etc.
 * 
 * **Note**: A default implementation of a filter shader is provided in the PhysX extensions library, see `PxDefaultSimulationFilterShader`.
 * 
 * Return the PxFilterFlag flags and set the PxPairFlag flags to define what the simulation should do with the given collision pair.
 * 
 * This methods gets called when:
 * - The bounding volumes of two objects start to overlap.
 * - The bounding volumes of two objects overlap and the filter data or filter attributes of one of the objects changed
 * - A re-filtering was forced through `resetFiltering()` (see `PxScene.resetFiltering()`)
 * - Filtering is requested in scene queries
 * 
 * **Note**: Certain pairs of objects are always ignored and this method does not get called. This is the case for the
 * following pairs:
 * 
 * - Pair of static rigid actors
 * - A static rigid actor and a kinematic actor (unless one is a trigger or if explicitly enabled through `PxPairFilteringMode.eKEEP`)
 * - Two kinematic actors (unless one is a trigger or if explicitly enabled through `PxPairFilteringMode.eKEEP`)
 * - Two jointed rigid bodies and the joint was defined to disable collision
 * - Two articulation links if connected through an articulation joint
 * 
 * **Note**: This is a performance critical method and should be stateless. You should neither access external objects 
 * from within this method nor should you call external methods that are not inlined. If you need a more complex
 * logic to filter a collision pair then use the filter callback mechanism for this pair (see `PxSimulationFilterCallback`,
 * `PxFilterFlag.eCALLBACK`, `PxFilterFlag.eNOTIFY`).
 * 
 * @param attributes0 The filter attribute of the first object
 * @param filterData0 The custom filter data of the first object
 * @param attributes1 The filter attribute of the second object
 * @param filterData1 The custom filter data of the second object
 * @param pairFlags Flags giving additional information on how an accepted pair should get processed
 * @param constantBlock The constant global filter data (see `PxSceneDesc.filterShaderData`)
 * @param constantBlockSize Size of the global filter data (see `PxSceneDesc.filterShaderDataSize`)
 * @return Filter flags defining whether the pair should be discarded, temporarily ignored, processed and whether the
 * filter callback should get invoked for this pair.
 * 
 * @see PxSceneDesc.filterShader PxSimulationFilterCallback PxFilterData PxFilterObjectAttributes PxFilterFlag PxFilterFlags PxPairFlag PxPairFlags
*/
typedef PxSimulationFilterShader = cpp.Callable<
    (attributes0:PxFilterObjectAttributes, filterData0:PxFilterData,
     attributes1:PxFilterObjectAttributes, filterData1:PxFilterData,
     pairFlags:cpp.Reference<PxPairFlags>, constantBlock:cpp.ConstStar<cpp.Void>, constantBlockSize:PxU32)
        -> PxFilterFlags>;



@:native("::cpp::Reference<physx::PxSimulationFilterCallbackNative>")
private extern class PxSimulationFilterCallbackNative {}

/**
 * Filter callback to specify handling of collision pairs.
 * 
 * This class is provided to implement more complex and flexible collision pair filtering logic, for instance, taking
 * the state of the user application into account. Filter callbacks also give the user the opportunity to track collision
 * pairs and update their filter state.
 * 
 * You might want to check the documentation on `PxSimulationFilterShader` as well since it includes more general information
 * on filtering.
 * 
 * **Note:**
 * > SDK state should not be modified from within the callbacks. In particular objects should not
 * be created or destroyed. If state modification is needed then the changes should be stored to a buffer
 * and performed after the simulation step.
 * 
 * > The callbacks may execute in user threads or simulation threads, possibly simultaneously. The corresponding objects 
 * may have been deleted by the application earlier in the frame. It is the application's responsibility to prevent race conditions
 * arising from using the SDK API in the callback while an application thread is making write calls to the scene, and to ensure that
 * the callbacks are thread-safe. Return values which depend on when the callback is called during the frame will introduce nondeterminism 
 * into the simulation.
 * 
 * @see PxSceneDesc.filterCallback PxSimulationFilterShader
 */
@:headerInclude("PxFiltering.h")
@:headerNamespaceCode("
class PxSimulationFilterCallbackNative : public physx::PxSimulationFilterCallback
{
public:
    physx::PxSimulationFilterCallbackHx hxHandle;
    PxSimulationFilterCallbackNative(physx::PxSimulationFilterCallbackHx hxHandle):hxHandle{ hxHandle } {}
    PxFilterFlags pairFound(PxU32 pairID,
        PxFilterObjectAttributes attributes0, PxFilterData filterData0, const PxActor* a0, const PxShape* s0,
        PxFilterObjectAttributes attributes1, PxFilterData filterData1, const PxActor* a1, const PxShape* s1,
        PxPairFlags& pairFlags) override;
    void pairLost(PxU32 pairID,
        PxFilterObjectAttributes attributes0, PxFilterData filterData0,
        PxFilterObjectAttributes attributes1, PxFilterData filterData1,
        bool objectRemoved) override;
    bool statusChange(PxU32& pairID, PxPairFlags& pairFlags, PxFilterFlags& filterFlags) override;
};
")
@:cppNamespaceCode("
PxFilterFlags PxSimulationFilterCallbackNative::pairFound(PxU32 pairID,
    PxFilterObjectAttributes attributes0, PxFilterData filterData0, const PxActor* a0, const PxShape* s0,
    PxFilterObjectAttributes attributes1, PxFilterData filterData1, const PxActor* a1, const PxShape* s1,
    PxPairFlags& pairFlags)
{
    return hxHandle->pairFound(pairID, 
        attributes0, filterData0, a0, s0,
        attributes1, filterData1, a1, s1,
        pairFlags);
}
void PxSimulationFilterCallbackNative::pairLost(PxU32 pairID,
    PxFilterObjectAttributes attributes0, PxFilterData filterData0,
    PxFilterObjectAttributes attributes1, PxFilterData filterData1,
    bool objectRemoved)
{
    hxHandle->pairLost(pairID, 
        attributes0, filterData0,
        attributes1, filterData1,
        objectRemoved);
}
bool PxSimulationFilterCallbackNative::statusChange(PxU32& pairID, PxPairFlags& pairFlags, PxFilterFlags& filterFlags)
{
    return hxHandle->statusChange(pairID, pairFlags, filterFlags);
}
")
@:unreflective
class PxSimulationFilterCallbackHx
{
    @:allow(physx.PxSimulationFilterCallback) @:noCompletion
    private var _native:PxSimulationFilterCallbackNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxSimulationFilterCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxSimulationFilterCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * Filter method to specify how a pair of potentially colliding objects should be processed.
     *
     * This method gets called when the filter flags returned by the filter shader (see `PxSimulationFilterShader`)
     * indicate that the filter callback should be invoked (`PxFilterFlag.eCALLBACK` or `PxFilterFlag.eNOTIFY` set).
     * Return the `PxFilterFlag` flags and set the `PxPairFlag` flags to define what the simulation should do with the given 
     * collision pair.
     *
     * @param [in]pairID Unique ID of the collision pair used to issue filter status changes for the pair (see `statusChange()`)
     * @param [in]attributes0 The filter attribute of the first object
     * @param [in]filterData0 The custom filter data of the first object
     * @param [in]a0 Actor pointer of the first object
     * @param [in]s0 Shape pointer of the first object (NULL if the object has no shapes)
     * @param [in]attributes1 The filter attribute of the second object
     * @param [in]filterData1 The custom filter data of the second object
     * @param [in]a1 Actor pointer of the second object
     * @param [in]s1 Shape pointer of the second object (NULL if the object has no shapes)
     * @param [in,out]pairFlags In: Pair flags returned by the filter shader. Out: Additional information on how an accepted pair should get processed
     * @return Filter flags defining whether the pair should be discarded, temporarily ignored or processed and whether the pair
     *                should be tracked and send a report on pair deletion through the filter callback
     *
     * @see PxSimulationFilterShader PxFilterData PxFilterObjectAttributes PxFilterFlag PxPairFlag
     */
    function pairFound(pairID:PxU32,
        attributes0:PxFilterObjectAttributes, filterData0:PxFilterData, a0:PxActor, s0:PxShape,
        attributes1:PxFilterObjectAttributes, filterData1:PxFilterData, a1:PxActor, s1:PxShape,
        pairFlags:cpp.Reference<PxPairFlags>):PxFilterFlags
    { 
        return eDEFAULT; 
    }

    /**
     * Callback to inform that a tracked collision pair is gone.
     * 
     * This method gets called when a collision pair disappears or gets re-filtered. Only applies to
     * collision pairs which have been marked as filter callback pairs (`PxFilterFlag.eNOTIFY` set in `pairFound()`).
     * 
     * @param [in]pairID Unique ID of the collision pair that disappeared
     * @param [in]attributes0 The filter attribute of the first object
     * @param [in]filterData0 The custom filter data of the first object
     * @param [in]attributes1 The filter attribute of the second object
     * @param [in]filterData1 The custom filter data of the second object
     * @param [in]objectRemoved True if the pair was lost because one of the objects got removed from the scene
     * 
     * @see pairFound() PxSimulationFilterShader PxFilterData PxFilterObjectAttributes
     */
    function pairLost(pairID:PxU32,
        attributes0:PxFilterObjectAttributes, filterData0:PxFilterData,
        attributes1:PxFilterObjectAttributes, filterData1:PxFilterData,
        objectRemoved:Bool):Void 
    {
    }

    /**
     * Callback to give the opportunity to change the filter state of a tracked collision pair.
     * 
     * This method gets called once per simulation step to let the application change the filter and pair
     * flags of a collision pair that has been reported in `pairFound()` and requested callbacks by
     * setting `PxFilterFlag.eNOTIFY`. To request a change of filter status, the target pair has to be
     * specified by its ID, the new filter and pair flags have to be provided and the method should return true.
     * 
     * **Note:**
     * 
     * If this method changes the filter status of a collision pair and the pair should keep being tracked
     * by the filter callbacks then `PxFilterFlag.eNOTIFY` has to be set.
     * 
     * The application is responsible to ensure that this method does not get called for pairs that have been
     * reported as lost, see `pairLost()`.
     * 
     * @param [out]pairID ID of the collision pair for which the filter status should be changed
     * @param [out]pairFlags The new pairFlags to apply to the collision pair
     * @param [out]filterFlags The new filterFlags to apply to the collision pair
     * @return True if the changes should be applied. In this case the method will get called again. False if
     *         no more status changes should be done in the current simulation step. In that case the provided flags will be discarded.
     * 
     * @see pairFound() pairLost() PxFilterFlag PxPairFlag
     */
    function statusChange(pairID:cpp.Reference<PxU32>,
        pairFlags:cpp.Reference<PxPairFlags>, filterFlags:cpp.Reference<PxFilterFlags>):Bool
    {
        return false;
    }
}

/**
 * Assign with a Haxe class that extends `PxSimulationFilterCallbackHx`.
 */
@:noCompletion extern abstract PxSimulationFilterCallback(PxSimulationFilterCallbackNative)
{
    @:from static inline function from(hxHandle:PxSimulationFilterCallbackHx):PxSimulationFilterCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}



@:build(physx.hx.EnumBuilder.build("physx::PxPairFilteringMode"))
extern enum abstract PxPairFilteringMode(PxPairFilteringModeImpl)
{
    /**
    Output pair from BP, potentially send to user callbacks, create regular interaction object.

    Enable contact pair filtering between kinematic/static or kinematic/kinematic rigid bodies.
    
    By default contacts between these are suppressed (see `PxFilterFlag.eSUPPRESS)` and don't get reported to the filter mechanism.
    Use this mode if these pairs should go through the filtering pipeline nonetheless.

    **Note:** This mode is not mutable, and must be set in PxSceneDesc at scene creation.
    */
    var eKEEP;

    /**
    Output pair from BP, create interaction marker. Can be later switched to regular interaction.
    */
    var eSUPPRESS;

    /**
    Don't output pair from BP. Cannot be later switched to regular interaction, needs "resetFiltering" call.
    */
    var eKILL;

    /**
    Default is eSUPPRESS for compatibility with previous PhysX versions.
    */
    var eDEFAULT = eSUPPRESS;
}

@:include("PxFiltering.h")
@:native("physx::PxPairFilteringMode::Enum")
private extern class PxPairFilteringModeImpl {}