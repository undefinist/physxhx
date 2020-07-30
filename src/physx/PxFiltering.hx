package physx;

import physx.foundation.PxSimpleTypes;

/**
\brief Collection of flags describing the actions to take for a collision pair.

@see PxPairFlags PxSimulationFilterShader.filter() PxSimulationFilterCallback
*/
extern enum abstract PxPairFlag(PxPairFlagImpl)
{
    /**
    \brief Process the contacts of this collision pair in the dynamics solver.

    \note Only takes effect if the colliding actors are rigid bodies.
    */
    @:native("physx::PxPairFlag::eSOLVE_CONTACT") var eSOLVE_CONTACT;

    /**
    \brief Call contact modification callback for this collision pair

    \note Only takes effect if the colliding actors are rigid bodies.

    @see PxContactModifyCallback
    */
    @:native("physx::PxPairFlag::eMODIFY_CONTACTS") var eMODIFY_CONTACTS;

    /**
    \brief Call contact report callback or trigger callback when this collision pair starts to be in contact.

    If one of the two collision objects is a trigger shape (see #PxShapeFlag::eTRIGGER_SHAPE) 
    then the trigger callback will get called as soon as the other object enters the trigger volume. 
    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called when the actors of this collision pair start to be in contact.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    @:native("physx::PxPairFlag::eNOTIFY_TOUCH_FOUND") var eNOTIFY_TOUCH_FOUND;

    /**
    \brief Call contact report callback while this collision pair is in contact

    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called while the actors of this collision pair are in contact.

    \note Triggers do not support this event. Persistent trigger contacts need to be tracked separately by observing eNOTIFY_TOUCH_FOUND/eNOTIFY_TOUCH_LOST events.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note No report will get sent if the objects in contact are sleeping.

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    \note If this flag gets enabled while a pair is in touch already, there will be no eNOTIFY_TOUCH_PERSISTS events until the pair loses and regains touch.

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    @:native("physx::PxPairFlag::eNOTIFY_TOUCH_PERSISTS") var eNOTIFY_TOUCH_PERSISTS;

    /**
    \brief Call contact report callback or trigger callback when this collision pair stops to be in contact

    If one of the two collision objects is a trigger shape (see #PxShapeFlag::eTRIGGER_SHAPE) 
    then the trigger callback will get called as soon as the other object leaves the trigger volume. 
    If none of the two collision objects is a trigger shape then the contact report callback will get 
    called when the actors of this collision pair stop to be in contact.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note This event will also get triggered if one of the colliding objects gets deleted.

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    @:native("physx::PxPairFlag::eNOTIFY_TOUCH_LOST") var eNOTIFY_TOUCH_LOST;

    /**
    \brief Call contact report callback when this collision pair is in contact during CCD passes.

    If CCD with multiple passes is enabled, then a fast moving object might bounce on and off the same
    object multiple times. Hence, the same pair might be in contact multiple times during a simulation step.
    This flag will make sure that all the detected collision during CCD will get reported. For performance
    reasons, the system can not always tell whether the contact pair lost touch in one of the previous CCD 
    passes and thus can also not always tell whether the contact is new or has persisted. eNOTIFY_TOUCH_CCD
    just reports when the two collision objects were detected as being in contact during a CCD pass.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note Trigger shapes are not supported.

    \note Only takes effect if eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxSimulationEventCallback.onTrigger()
    */
    @:native("physx::PxPairFlag::eNOTIFY_TOUCH_CCD") var eNOTIFY_TOUCH_CCD;

    /**
    \brief Call contact report callback when the contact force between the actors of this collision pair exceeds one of the actor-defined force thresholds.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    @:native("physx::PxPairFlag::eNOTIFY_THRESHOLD_FORCE_FOUND") var eNOTIFY_THRESHOLD_FORCE_FOUND;

    /**
    \brief Call contact report callback when the contact force between the actors of this collision pair continues to exceed one of the actor-defined force thresholds.

    \note Only takes effect if the colliding actors are rigid bodies.

    \note If a pair gets re-filtered and this flag has previously been disabled, then the report will not get fired in the same frame even if the force threshold has been reached in the
    previous one (unless #eNOTIFY_THRESHOLD_FORCE_FOUND has been set in the previous frame).

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    @:native("physx::PxPairFlag::eNOTIFY_THRESHOLD_FORCE_PERSISTS") var eNOTIFY_THRESHOLD_FORCE_PERSISTS;

    /**
    \brief Call contact report callback when the contact force between the actors of this collision pair falls below one of the actor-defined force thresholds (includes the case where this collision pair stops being in contact).

    \note Only takes effect if the colliding actors are rigid bodies.

    \note If a pair gets re-filtered and this flag has previously been disabled, then the report will not get fired in the same frame even if the force threshold has been reached in the
    previous one (unless #eNOTIFY_THRESHOLD_FORCE_FOUND or #eNOTIFY_THRESHOLD_FORCE_PERSISTS has been set in the previous frame).

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact()
    */
    @:native("physx::PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST") var eNOTIFY_THRESHOLD_FORCE_LOST;

    /**
    \brief Provide contact points in contact reports for this collision pair.

    \note Only takes effect if the colliding actors are rigid bodies and if used in combination with the flags eNOTIFY_TOUCH_... or eNOTIFY_THRESHOLD_FORCE_...

    \note Only takes effect if eDETECT_DISCRETE_CONTACT or eDETECT_CCD_CONTACT is raised

    @see PxSimulationEventCallback.onContact() PxContactPair PxContactPair.extractContacts()
    */
    @:native("physx::PxPairFlag::eNOTIFY_CONTACT_POINTS") var eNOTIFY_CONTACT_POINTS;

    /**
    \brief This flag is used to indicate whether this pair generates discrete collision detection contacts. 

    \note Contacts are only responded to if eSOLVE_CONTACT is enabled.
    */
    @:native("physx::PxPairFlag::eDETECT_DISCRETE_CONTACT") var eDETECT_DISCRETE_CONTACT;
    
    /**
    \brief This flag is used to indicate whether this pair generates CCD contacts. 

    \note The contacts will only be responded to if eSOLVE_CONTACT is enabled on this pair.
    \note The scene must have PxSceneFlag::eENABLE_CCD enabled to use this feature.
    \note Non-static bodies of the pair should have PxRigidBodyFlag::eENABLE_CCD specified for this feature to work correctly.
    \note This flag is not supported with trigger shapes. However, CCD trigger events can be emulated using non-trigger shapes 
    and requesting eNOTIFY_TOUCH_FOUND and eNOTIFY_TOUCH_LOST and not raising eSOLVE_CONTACT on the pair.

    @see PxRigidBodyFlag::eENABLE_CCD
    @see PxSceneFlag::eENABLE_CCD
    */
    @:native("physx::PxPairFlag::eDETECT_CCD_CONTACT") var eDETECT_CCD_CONTACT;

    /**
    \brief Provide pre solver velocities in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the velocities of the rigid bodies before contacts have been solved
    will be provided in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    \note Usually it is not necessary to request these velocities as they will be available by querying the velocity from the provided
    PxRigidActor object directly. However, it might be the case that the velocity of a rigid body gets set while the simulation is running
    in which case the PxRigidActor would return this new velocity in the contact report callback and not the velocity the simulation used.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairVelocity, PxContactPairHeader.extraDataStream
    */
    @:native("physx::PxPairFlag::ePRE_SOLVER_VELOCITY") var ePRE_SOLVER_VELOCITY;
    
    /**
    \brief Provide post solver velocities in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the velocities of the rigid bodies after contacts have been solved
    will be provided in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairVelocity, PxContactPairHeader.extraDataStream
    */
    @:native("physx::PxPairFlag::ePOST_SOLVER_VELOCITY") var ePOST_SOLVER_VELOCITY;
    
    /**
    \brief Provide rigid body poses in contact reports for this collision pair.
    
    If the collision pair has contact reports enabled, the rigid body poses at the contact event will be provided 
    in the contact report callback unless the pair lost touch in which case no data will be provided.
    
    \note Usually it is not necessary to request these poses as they will be available by querying the pose from the provided
    PxRigidActor object directly. However, it might be the case that the pose of a rigid body gets set while the simulation is running
    in which case the PxRigidActor would return this new pose in the contact report callback and not the pose the simulation used.
    Another use case is related to CCD with multiple passes enabled, A fast moving object might bounce on and off the same 
    object multiple times. This flag can be used to request the rigid body poses at the time of impact for each such collision event.
    
    @see PxSimulationEventCallback.onContact(), PxContactPairPose, PxContactPairHeader.extraDataStream
    */
    @:native("physx::PxPairFlag::eCONTACT_EVENT_POSE") var eCONTACT_EVENT_POSE;

    //@:native("physx::PxPairFlag::eNEXT_FREE") var eNEXT_FREE;

    /**
    \brief Provided default flag to do simple contact processing for this collision pair.
    */
    @:native("physx::PxPairFlag::eCONTACT_DEFAULT") var eCONTACT_DEFAULT;

    /**
    \brief Provided default flag to get commonly used trigger behavior for this collision pair.
    */
    @:native("physx::PxPairFlag::eTRIGGER_DEFAULT") var eTRIGGER_DEFAULT;
    
    @:op(A | B)
    private inline function or(flag:PxPairFlag):PxPairFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxFiltering.h")
@:native("physx::PxPairFlags")
private extern class PxPairFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxPairFlag.

@see PxPairFlag
*/
extern abstract PxPairFlags(PxPairFlag) from PxPairFlag to PxPairFlag {}



/**
\brief Collection of flags describing the filter actions to take for a collision pair.

@see PxFilterFlags PxSimulationFilterShader PxSimulationFilterCallback
*/
extern enum abstract PxFilterFlag(PxFilterFlagImpl)
{
    /**
    \brief Ignore the collision pair as long as the bounding volumes of the pair objects overlap.

    Killed pairs will be ignored by the simulation and won't run through the filter again until one
    of the following occurs:

    \li The bounding volumes of the two objects overlap again (after being separated)
    \li The user enforces a re-filtering (see #PxScene::resetFiltering())

    @see PxScene::resetFiltering()
    */
    @:native("physx::PxFilterFlag::eKILL") var eKILL;

    /**
    \brief Ignore the collision pair as long as the bounding volumes of the pair objects overlap or until filtering relevant data changes for one of the collision objects.

    Suppressed pairs will be ignored by the simulation and won't make another filter request until one
    of the following occurs:

    \li Same conditions as for killed pairs (see #eKILL)
    \li The filter data or the filter object attributes change for one of the collision objects

    @see PxFilterData PxFilterObjectAttributes
    */
    @:native("physx::PxFilterFlag::eSUPPRESS") var eSUPPRESS;

    /**
    \brief Invoke the filter callback (#PxSimulationFilterCallback::pairFound()) for this collision pair.

    @see PxSimulationFilterCallback
    */
    @:native("physx::PxFilterFlag::eCALLBACK") var eCALLBACK;

    /**
    \brief Track this collision pair with the filter callback mechanism.

    When the bounding volumes of the collision pair lose contact, the filter callback #PxSimulationFilterCallback::pairLost()
    will be invoked. Furthermore, the filter status of the collision pair can be adjusted through #PxSimulationFilterCallback::statusChange()
    once per frame (until a pairLost() notification occurs).

    @see PxSimulationFilterCallback
    */
    @:native("physx::PxFilterFlag::eNOTIFY") var eNOTIFY;

    /**
    \brief Provided default to get standard behavior:

    The application configure the pair's collision properties once when bounding volume overlap is found and
    doesn't get asked again about that pair until overlap status or filter properties changes, or re-filtering is requested.

    No notification is provided when bounding volume overlap is lost

    The pair will not be killed or suppressed, so collision detection will be processed
    */
    @:native("physx::PxFilterFlag::eDEFAULT") var eDEFAULT;

    @:op(A | B)
    private inline function or(flag:PxFilterFlag):PxFilterFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxFiltering.h")
@:native("physx::PxFilterFlags")
private extern class PxFilterFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxFilterFlag.

@see PxFilterFlag
*/
extern abstract PxFilterFlags(PxFilterFlag) from PxFilterFlag to PxFilterFlag {}



/**
\brief PxFilterData is user-definable data which gets passed into the collision filtering shader and/or callback.

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
\brief Identifies each type of filter object.

@see PxGetFilterObjectType()
*/
extern enum abstract PxFilterObjectType(PxFilterObjectTypeImpl)
{
    /**
    \brief A static rigid body
    @see PxRigidStatic
    */
    @:native("physx::PxFilterObjectType::eRIGID_STATIC") var eRIGID_STATIC;

    /**
    \brief A dynamic rigid body
    @see PxRigidDynamic
    */
    @:native("physx::PxFilterObjectType::eRIGID_DYNAMIC") var eRIGID_DYNAMIC;

    /**
    \brief An articulation
    @see PxArticulation
    */
    @:native("physx::PxFilterObjectType::eARTICULATION") var eARTICULATION;

    //brief internal use only!
    //eMAX_TYPE_COUNT = 16,

    //brief internal use only!
    //eUNDEFINED = eMAX_TYPE_COUNT-1	
}

@:include("PxFiltering.h")
@:native("physx::PxFilterObjectType::Enum")
private extern class PxFilterObjectTypeImpl {}


/**
\brief Structure which gets passed into the collision filtering shader and/or callback providing additional information on objects of a collision pair

@see PxSimulationFilterShader PxSimulationFilterCallback getActorType() PxFilterObjectIsKinematic() PxFilterObjectIsTrigger()
*/
typedef PxFilterObjectAttributes = PxU32;


@:include("PxFiltering.h")
extern class PxFilterObject
{
    /**
    \brief Extract filter object type from the filter attributes of a collision pair object
    
    \param[in] attr The filter attribute of a collision pair object
    \return The type of the collision pair object.
    
    @see PxFilterObjectType
    */
    @:native("physx::PxGetFilterObjectType")
    static function GetType(attr:PxFilterObjectAttributes):PxFilterObjectType;

    /**
    \brief Specifies whether the collision object belongs to a kinematic rigid body

    \param[in] attr The filter attribute of a collision pair object
    \return True if the object belongs to a kinematic rigid body, else false

    @see PxRigidBodyFlag::eKINEMATIC
    */
    @:native("physx::PxFilterObjectIsKinematic")
    static function IsKinematic(attr:PxFilterObjectAttributes):Bool;

    /**
    \brief Specifies whether the collision object is a trigger shape

    \param[in] attr The filter attribute of a collision pair object
    \return True if the object is a trigger shape, else false

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
 * - A re-filtering was forced through `resetFiltering()` (see `PxScene::resetFiltering()`)
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

extern enum abstract PxPairFilteringMode(PxPairFilteringModeImpl)
{
    /**
    Output pair from BP, potentially send to user callbacks, create regular interaction object.

    Enable contact pair filtering between kinematic/static or kinematic/kinematic rigid bodies.
    
    By default contacts between these are suppressed (see #PxFilterFlag::eSUPPRESS) and don't get reported to the filter mechanism.
    Use this mode if these pairs should go through the filtering pipeline nonetheless.

    \note This mode is not mutable, and must be set in PxSceneDesc at scene creation.
    */
    @:native("physx::PxPairFilteringMode::eKEEP") var eKEEP;

    /**
    Output pair from BP, create interaction marker. Can be later switched to regular interaction.
    */
    @:native("physx::PxPairFilteringMode::eSUPPRESS") var eSUPPRESS;

    /**
    Don't output pair from BP. Cannot be later switched to regular interaction, needs "resetFiltering" call.
    */
    @:native("physx::PxPairFilteringMode::eKILL") var eKILL;

    /**
    Default is eSUPPRESS for compatibility with previous PhysX versions.
    */
    @:native("physx::PxPairFilteringMode::eDEFAULT") var eDEFAULT;
}

@:include("PxFiltering.h")
@:native("physx::PxPairFilteringMode::Enum")
private extern class PxPairFilteringModeImpl {}