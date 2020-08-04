package physx;

import physx.PxActor;
import physx.PxBroadPhase;
import physx.PxClient.PxClientID;
import physx.PxContactModifyCallback;
import physx.PxFiltering;
import physx.PxQueryFiltering;
import physx.PxQueryReport;
import physx.PxRigidActor;
import physx.PxSceneDesc;
import physx.PxSimulationEventCallback;
import physx.common.PxCollection;
import physx.common.PxRenderBuffer;
import physx.cudamanager.PxCudaContextManager;
import physx.foundation.PxBounds3;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxTransform;
import physx.foundation.PxVec3;
import physx.geometry.PxBVHStructure;
import physx.geometry.PxGeometry;
import physx.pvd.PxPvdSceneClient;
import physx.task.PxCpuDispatcher;
import physx.task.PxTask;

/**
\brief Expresses the dominance relationship of a contact.
For the time being only three settings are permitted:

(1, 1), (0, 1), and (1, 0).

@see getDominanceGroup() PxDominanceGroup PxScene::setDominanceGroupPair()
*/
@:forward
extern abstract PxDominanceGroupPair(PxDominanceGroupPairData)
{
    inline function new(a:PxU8, b:PxU8)
    {
        this = PxDominanceGroupPairData.create(a, b);
    }
}

@:include("PxScene.h")
@:native("physx::PxDominanceGroupPair")
@:structAccess
private extern class PxDominanceGroupPairData
{
    @:native("physx::PxDominanceGroupPair") static function create(a:PxU8, b:PxU8):PxDominanceGroupPairData;
    var dominance0:PxU8;
    var dominance1:PxU8;
}

/**
\brief Identifies each type of actor for retrieving actors from a scene.

**Note:** `PxArticulationLink` objects are not supported. Use the `PxArticulation` object to retrieve all its links.

@see PxScene::getActors(), PxScene::getNbActors()
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxActorTypeFlag", PxU16))
extern enum abstract PxActorTypeFlag(PxActorTypeFlagImpl)
{
    /**
    A static rigid body
    */
    var eRIGID_STATIC = (1 << 0);

    /**
    A dynamic rigid body
    */
    var eRIGID_DYNAMIC = (1 << 1);
}

@:include("PxScene.h")
@:native("physx::PxActorTypeFlags")
private extern class PxActorTypeFlagImpl {}

/**
\brief Collection of set bits defined in PxActorTypeFlag.

@see PxActorTypeFlag
*/
extern abstract PxActorTypeFlags(PxActorTypeFlag) from PxActorTypeFlag to PxActorTypeFlag {}

/**
 * Initialize with `= null`.
 * 
 * Single hit cache for scene queries.
 * 
 * If a cache object is supplied to a scene query, the cached actor/shape pair is checked for intersection first.
 * **Note:** Filters are not executed for the cached shape.
 * **Note:** If intersection is found, the hit is treated as blocking.
 * **Note:** Typically actor and shape from the last PxHitCallback.block query result is used as a cached actor/shape pair.
 * **Note:** Using past touching hits as cache will produce incorrect behavior since the cached hit will always be treated as blocking.
 * **Note:** Cache is only used if no touch buffer was provided, for single nearest blocking hit queries and queries using eANY_HIT flag.
 * **Note:** if non-zero touch buffer was provided, cache will be ignored
 * 
 * **Note:** It is the user's responsibility to ensure that the shape and actor are valid, so care must be taken
 * when deleting shapes to invalidate cached references.
 * 
 * The faceIndex field is an additional hint for a mesh or height field which is not currently used.
 * 
 * @see PxScene.raycast
*/
@:include("PxScene.h")
@:native("::cpp::Struct<physx::PxQueryCache>")
extern class PxQueryCache
{
    /**
     * Shape to test for intersection first
     */
    var shape:PxShape;
    /**
     * Actor to which the shape belongs
     */
    var actor:PxRigidActor;
    //var faceIndex:PxU32; //!< Triangle index to test first - NOT CURRENTLY SUPPORTED
}



/** 
 \brief A scene is a collection of bodies and constraints which can interact.

 The scene simulates the behavior of these objects over time. Several scenes may exist 
 at the same time, but each body or constraint is specific to a scene 
 -- they may not be shared.

 @see PxSceneDesc PxPhysics.createScene() release()
*/
@:include("PxScene.h")
@:native("::cpp::Reference<physx::PxScene>")
extern class PxScene
{
    /**
    \brief Deletes the scene.

    Removes any actors and constraint shaders from this scene
    (if the user hasn't already done so).

    Be sure	to not keep a reference to this object after calling release.
    Avoid release calls while the scene is simulating (in between simulate() and fetchResults() calls).
    
    @see PxPhysics.createScene() 
    */
    function release():Void;

    /**
    \brief Sets a scene flag. You can only set one flag at a time.

    **Note:** Not all flags are mutable and changing some will result in an error. Please check `PxSceneFlag` to see which flags can be changed.

    @see PxSceneFlag
    */
    function setFlag(flag:PxSceneFlag, value:Bool):Void;

    /**
    \brief Get the scene flags.

    \return The scene flags. See `PxSceneFlag`

    @see PxSceneFlag
    */
    function getFlags():PxSceneFlags;
    
    /**
    \brief Set new scene limits. 

    **Note:** Increase the maximum capacity of various data structures in the scene. The new capacities will be 
    at least as large as required to deal with the objects currently in the scene. Further, these values 
    are for preallocation and do not represent hard limits.

    \param[in] limits Scene limits.
    @see PxSceneLimits
    */
    function setLimits(limits:PxSceneLimits):Void;

    /**
    \brief Get current scene limits.
    \return Current scene limits.
    @see PxSceneLimits
    */
    function getLimits():PxSceneLimits;

    /**
    \brief Call this method to retrieve the Physics SDK.

    \return The physics SDK this scene is associated with.

    @see PxPhysics
    */
    function getPhysics():PxPhysics;

    /**
    \brief Retrieves the scene's internal timestamp, increased each time a simulation step is completed.

    \return scene timestamp
    */
    function getTimestamp():PxU32;
    
    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Add/Remove Contained Objects
    //
    //@{

    /**
    \brief Adds an articulation to this scene.

    **Note:** If the articulation is already assigned to a scene (see `PxArticulation.getScene),` the call is ignored and an error is issued.

    \param[in] articulation Articulation to add to scene. See `PxArticulation`

    @see PxArticulation
    */
    function addArticulation(articulation:PxArticulationBase):Void;

    /**
    \brief Removes an articulation from this scene.

    **Note:** If the articulation is not part of this scene (see `PxArticulation.getScene),` the call is ignored and an error is issued. 
    
    **Note:** If the articulation is in an aggregate it will be removed from the aggregate.

    \param[in] articulation Articulation to remove from scene. See `PxArticulation`
    \param[in] wakeOnLostTouch Specifies whether touching objects from the previous frame should get woken up in the next frame. Only applies to PxArticulation and PxRigidActor types.

    @see PxArticulation, PxAggregate
    */
    function removeArticulation(articulation:PxArticulationBase, wakeOnLostTouch:Bool):Void;


    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////


    /**
    \brief Adds an actor to this scene.
    
    **Note:** If the actor is already assigned to a scene (see `PxActor.getScene),` the call is ignored and an error is issued.
    **Note:** If the actor has an invalid constraint, in checked builds the call is ignored and an error is issued.

    **Note:** You can not add individual articulation links (see `PxArticulationLink)` to the scene. Use `addArticulation()` instead.

    **Note:** If the actor is a PxRigidActor then each assigned PxConstraint object will get added to the scene automatically if
    it connects to another actor that is part of the scene already. 

    **Note:** When BVHStructure is provided the actor shapes are grouped together. 
    The scene query pruning structure inside PhysX SDK will store/update one
    bound per actor. The scene queries against such an actor will query actor
    bounds and then make a local space query against the provided BVH structure, which is in
    actor's local space.

    \param[in] actor Actor to add to scene.
    \param[in] bvhStructure BVHStructure for actor shapes.

    @see PxActor, PxConstraint::isValid(), PxBVHStructure
    */
    function addActor(actor:PxActor, bvhStructure:PxBVHStructure = null):Void;

    /**
    \brief Adds actors to this scene.	

    **Note:** If one of the actors is already assigned to a scene (see `PxActor.getScene),` the call is ignored and an error is issued.

    **Note:** You can not add individual articulation links (see `PxArticulationLink)` to the scene. Use `addArticulation()` instead.

    **Note:** If an actor in the array contains an invalid constraint, in checked builds the call is ignored and an error is issued.
    **Note:** If an actor in the array is a PxRigidActor then each assigned PxConstraint object will get added to the scene automatically if
    it connects to another actor that is part of the scene already.

    **Note:** this method is optimized for high performance, and does not support buffering. It may not be called during simulation.

    \param[in] actors Array of actors to add to scene.
    \param[in] nbActors Number of actors in the array.

    @see PxActor, PxConstraint::isValid()
    */
    inline function addActors(actors:Array<PxActor>, nbActors:PxU32):Void
    {
        var p:cpp.ConstPointer<PxActor> = cpp.Pointer.ofArray(actors);
        untyped __cpp__("{0}.addActors(reinterpret_cast<PxActor*const*>({1}), {2})", this, p, nbActors);
    }
    
    /**
    \brief Removes an actor from this scene.

    **Note:** If the actor is not part of this scene (see `PxActor.getScene),` the call is ignored and an error is issued.

    **Note:** You can not remove individual articulation links (see `PxArticulationLink)` from the scene. Use `removeArticulation()` instead.

    **Note:** If the actor is a PxRigidActor then all assigned PxConstraint objects will get removed from the scene automatically.

    **Note:** If the actor is in an aggregate it will be removed from the aggregate.

    \param[in] actor Actor to remove from scene.
    \param[in] wakeOnLostTouch Specifies whether touching objects from the previous frame should get woken up in the next frame. Only applies to PxArticulation and PxRigidActor types. Default `true`.

    @see PxActor, PxAggregate
    */
    @:overload(function(actor:PxActor):Void {})
    function removeActor(actor:PxActor, wakeOnLostTouch:Bool):Void;

    /**
    \brief Removes actors from this scene.

    **Note:** If some actor is not part of this scene (see `PxActor.getScene),` the actor remove is ignored and an error is issued.

    **Note:** You can not remove individual articulation links (see `PxArticulationLink)` from the scene. Use `removeArticulation()` instead.

    **Note:** If the actor is a PxRigidActor then all assigned PxConstraint objects will get removed from the scene automatically.

    \param[in] actors Array of actors to add to scene.
    \param[in] nbActors Number of actors in the array.
    \param[in] wakeOnLostTouch Specifies whether touching objects from the previous frame should get woken up in the next frame. Only applies to PxArticulation and PxRigidActor types.

    @see PxActor
    */
    inline function removeActors(actors:Array<PxActor>, nbActors:PxU32, wakeOnLostTouch:Bool = true):Void
    {
        var p:cpp.ConstPointer<PxActor> = cpp.Pointer.ofArray(actors);
        untyped __cpp__("{0}.addActors(reinterpret_cast<PxActor*const*>({1}), {2}, {3})", this, p, nbActors, wakeOnLostTouch);
    }

    /**
    \brief Adds an aggregate to this scene.
    
    **Note:** If the aggregate is already assigned to a scene (see `PxAggregate.getScene),` the call is ignored and an error is issued.
    **Note:** If the aggregate contains an actor with an invalid constraint, in checked builds the call is ignored and an error is issued.

    **Note:** If the aggregate already contains actors, those actors are added to the scene as well.

    \param[in] aggregate Aggregate to add to scene.
    
    @see PxAggregate, PxConstraint::isValid()
    */
    function addAggregate(aggregate:PxAggregate):Void;

    /**
    \brief Removes an aggregate from this scene.

    **Note:** If the aggregate is not part of this scene (see `PxAggregate.getScene),` the call is ignored and an error is issued.

    **Note:** If the aggregate contains actors, those actors are removed from the scene as well.

    \param[in] aggregate Aggregate to remove from scene.
    \param[in] wakeOnLostTouch Specifies whether touching objects from the previous frame should get woken up in the next frame. Only applies to PxArticulation and PxRigidActor types. Default `true`.

    @see PxAggregate
    */
    @:overload(function(aggregate:PxAggregate):Void {})
    function removeAggregate(aggregate:PxAggregate, wakeOnLostTouch:Bool):Void;

    /**
    \brief Adds objects in the collection to this scene.

    This function adds the following types of objects to this scene: PxActor, PxAggregate, PxArticulation. 
    This method is typically used after deserializing the collection in order to populate the scene with deserialized objects.

    **Note:** If the collection contains an actor with an invalid constraint, in checked builds the call is ignored and an error is issued.

    \param[in] collection Objects to add to this scene. See `PxCollection`

    @see PxCollection, PxConstraint::isValid()
    */
    function addCollection(collection:PxCollection):Void;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Contained Object Retrieval
    //
    //@{

    /**
    \brief Retrieve the number of actors of certain types in the scene.

    \param[in] types Combination of actor types.
    \return the number of actors.

    @see getActors()
    */
    function getNbActors(types:PxActorTypeFlags):PxU32;

    /**
    \brief Retrieve an array of all the actors of certain types in the scene.

    @param types Combination of actor types to retrieve.
    @return Array of actors.

    @see getNbActors()
    */
    inline function getActors(types:PxActorTypeFlags):Array<PxActor>
    {
        var sz = getNbActors(types);
        var arr:Array<PxActor> = [];
        arr.resize(sz);
        var p = cpp.Pointer.ofArray(arr);
        untyped __cpp__("{0}.getActors({1},reinterpret_cast<PxActor**>({2}),{3})", this, types, p, sz);
        return arr;
    }

    /**
    \brief Queries the PxScene for a list of the PxActors whose transforms have been 
    updated during the previous simulation step

    **Note:** PxSceneFlag::eENABLE_ACTIVE_ACTORS must be set.

    **Note:** Do not use this method while the simulation is running. Calls to this method while the simulation is running will be ignored and NULL will be returned.

    \param[out] nbActorsOut The number of actors returned.

    \return A pointer to the list of active PxActors generated during the last call to fetchResults().

    @see PxActor
    */
    inline function getActiveActors():Array<PxActor>
    {
        var nb:PxU32 = 0;
        var actors:cpp.Pointer<PxActor> = untyped __cpp__("reinterpret_cast<PxActor**>({0}.getActiveActors({1}))", this, nb);
        return actors.toUnmanagedArray(nb);
    }

    /**
    \brief Returns the number of articulations in the scene.

    \return the number of articulations in this scene.

    @see getArticulations()
    */
    function getNbArticulations():PxU32;

    /**
    \brief Retrieve all the articulations in the scene.

    \param[out] userBuffer The buffer to receive articulations pointers.
    \param[in] bufferSize Size of provided user buffer.
    \param[in] startIndex Index of first articulations pointer to be retrieved
    \return Number of articulations written to the buffer.

    @see getNbArticulations()
    */
    inline function getArticulations():Array<PxArticulationBase>
    {
        var sz = getNbArticulations();
        var arr:Array<PxArticulationBase> = [];
        arr.resize(sz);
        var p = cpp.Pointer.ofArray(arr);
        untyped __cpp__("{0}.getArticulations(reinterpret_cast<PxArticulationBase**>({1}),{2})", this, p, sz);
        return arr;
    }

    /**
    \brief Returns the number of constraint shaders in the scene.

    \return the number of constraint shaders in this scene.

    @see getConstraints()
    */
    function getNbConstraints():PxU32;

    /**
    \brief Retrieve all the constraint shaders in the scene.

    \param[out] userBuffer The buffer to receive constraint shader pointers.
    \param[in] bufferSize Size of provided user buffer.
    \param[in] startIndex Index of first constraint pointer to be retrieved
    \return Number of constraint shaders written to the buffer.

    @see getNbConstraints()
    */
    inline function getConstraints():Array<PxConstraint>
    {
        var sz = getNbArticulations();
        var arr:Array<PxConstraint> = [];
        arr.resize(sz);
        var p = cpp.Pointer.ofArray(arr);
        untyped __cpp__("{0}.getConstraints(reinterpret_cast<PxConstraint**>({1}),{2})", this, p, sz);
        return arr;
    }


    /**
    \brief Returns the number of aggregates in the scene.

    \return the number of aggregates in this scene.

    @see getAggregates()
    */
    function getNbAggregates():PxU32;

    /**
    \brief Retrieve all the aggregates in the scene.

    \param[out] userBuffer The buffer to receive aggregates pointers.
    \param[in] bufferSize Size of provided user buffer.
    \param[in] startIndex Index of first aggregate pointer to be retrieved
    \return Number of aggregates written to the buffer.

    @see getNbAggregates()
    */
    inline function getAggregates():Array<PxAggregate>
    {
        var sz = getNbAggregates();
        var arr:Array<PxAggregate> = [];
        arr.resize(sz);
        var p = cpp.Pointer.ofArray(arr);
        untyped __cpp__("{0}.getAggregates(reinterpret_cast<PxAggregate**>({1}),{2})", this, p, sz);
        return arr;
    }

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Dominance
    //
    //@{

    /**
    \brief Specifies the dominance behavior of contacts between two actors with two certain dominance groups.
    
    It is possible to assign each actor to a dominance groups using `PxActor.setDominanceGroup()`.

    With dominance groups one can have all contacts created between actors act in one direction only. This is useful, for example, if you
    want an object to push debris out of its way and be unaffected,while still responding physically to forces and collisions
    with non-debris objects.
    
    Whenever a contact between two actors (a0, a1) needs to be solved, the groups (g0, g1) of both
    actors are retrieved. Then the PxDominanceGroupPair setting for this group pair is retrieved with getDominanceGroupPair(g0, g1).
    
    In the contact, PxDominanceGroupPair::dominance0 becomes the dominance setting for a0, and 
    PxDominanceGroupPair::dominance1 becomes the dominance setting for a1. A dominanceN setting of 1.0f, the default, 
    will permit aN to be pushed or pulled by a(1-N) through the contact. A dominanceN setting of 0.0f, will however 
    prevent aN to be pushed by a(1-N) via the contact. Thus, a PxDominanceGroupPair of (1.0f, 0.0f) makes 
    the interaction one-way.
    
    
    The matrix sampled by getDominanceGroupPair(g1, g2) is initialised by default such that:
    
    if g1 == g2, then (1.0f, 1.0f) is returned
    if g1 <  g2, then (0.0f, 1.0f) is returned
    if g1 >  g2, then (1.0f, 0.0f) is returned
    
    In other words, we permit actors in higher groups to be pushed around by actors in lower groups by default.
        
    These settings should cover most applications, and in fact not overriding these settings may likely result in higher performance.
    
    It is not possible to make the matrix asymetric, or to change the diagonal. In other words: 
    
    * it is not possible to change (g1, g2) if (g1==g2)	
    * if you set 
    
    (g1, g2) to X, then (g2, g1) will implicitly and automatically be set to ~X, where:
    
    ~(1.0f, 1.0f) is (1.0f, 1.0f)
    ~(0.0f, 1.0f) is (1.0f, 0.0f)
    ~(1.0f, 0.0f) is (0.0f, 1.0f)
    
    These two restrictions are to make sure that contacts between two actors will always evaluate to the same dominance
    setting, regardless of the order of the actors.
    
    Dominance settings are currently specified as floats 0.0f or 1.0f because in the future we may permit arbitrary 
    fractional settings to express 'partly-one-way' interactions.
        
    **Sleeping:** Does **NOT** wake actors up automatically.

    @see getDominanceGroupPair() PxDominanceGroup PxDominanceGroupPair PxActor::setDominanceGroup() PxActor::getDominanceGroup()
    */
    function setDominanceGroupPair(group1:PxDominanceGroup, group2:PxDominanceGroup, dominance:PxDominanceGroupPair):Void;

    /**
    \brief Samples the dominance matrix.

    @see setDominanceGroupPair() PxDominanceGroup PxDominanceGroupPair PxActor::setDominanceGroup() PxActor::getDominanceGroup()
    */
    function getDominanceGroupPair(group1:PxDominanceGroup, group2:PxDominanceGroup):PxDominanceGroupPair;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Dispatcher
    //
    //@{

    /**
    \brief Return the cpu dispatcher that was set in PxSceneDesc::cpuDispatcher when creating the scene with PxPhysics::createScene

    @see PxSceneDesc::cpuDispatcher, PxPhysics::createScene
    */
    function getCpuDispatcher():PxCpuDispatcher;

    /**
    \brief Return the CUDA context manager that was set in PxSceneDesc::cudaContextManager when creating the scene with PxPhysics::createScene

    **Platform specific:** Applies to PC GPU only.

    @see PxSceneDesc::cudaContextManager, PxPhysics::createScene
    */
    function getCudaContextManager():PxCudaContextManager;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Multiclient
    //
    //@{
        
    /**
    \brief Reserves a new client ID.
    
    PX_DEFAULT_CLIENT is always available as the default clientID.
    Additional clients are returned by this function. Clients cannot be released once created. 
    An error is reported when more than a supported number of clients (currently 128) are created. 

    @see PxClientID
    */
    function createClient():PxClientID;

    //@}

    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Callbacks
    //
    //@{

    /**
    \brief Sets a user notify object which receives special simulation events when they occur.

    **Note:** Do not set the callback while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[in] callback User notification callback. See `PxSimulationEventCallback.`

    @see PxSimulationEventCallback getSimulationEventCallback
    */
    function setSimulationEventCallback(callback:PxSimulationEventCallback):Void;

    /**
    \brief Retrieves the simulationEventCallback pointer set with setSimulationEventCallback().

    \return The current user notify pointer. See `PxSimulationEventCallback.`

    @see PxSimulationEventCallback setSimulationEventCallback()
    */
    function getSimulationEventCallback():PxSimulationEventCallback;

    /**
    \brief Sets a user callback object, which receives callbacks on all contacts generated for specified actors.

    **Note:** Do not set the callback while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[in] callback Asynchronous user contact modification callback. See `PxContactModifyCallback.`
    */
    function setContactModifyCallback(callback:PxContactModifyCallback):Void;

    /**
    \brief Sets a user callback object, which receives callbacks on all CCD contacts generated for specified actors.

    **Note:** Do not set the callback while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[in] callback Asynchronous user contact modification callback. See `PxCCDContactModifyCallback.`
    */
    function setCCDContactModifyCallback(callback:PxCCDContactModifyCallback):Void;

    /**
    \brief Retrieves the PxContactModifyCallback pointer set with setContactModifyCallback().

    \return The current user contact modify callback pointer. See `PxContactModifyCallback.`

    @see PxContactModifyCallback setContactModifyCallback()
    */
    function getContactModifyCallback():PxContactModifyCallback;

    /**
    \brief Retrieves the PxCCDContactModifyCallback pointer set with setContactModifyCallback().

    \return The current user contact modify callback pointer. See `PxContactModifyCallback.`

    @see PxContactModifyCallback setContactModifyCallback()
    */
    function getCCDContactModifyCallback():PxCCDContactModifyCallback;

    /**
    \brief Sets a broad-phase user callback object.

    **Note:** Do not set the callback while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[in] callback	Asynchronous broad-phase callback. See `PxBroadPhaseCallback.`
    */
    function setBroadPhaseCallback(callback:PxBroadPhaseCallback):Void;

    /**
    \brief Retrieves the PxBroadPhaseCallback pointer set with setBroadPhaseCallback().

    \return The current broad-phase callback pointer. See `PxBroadPhaseCallback.`

    @see PxBroadPhaseCallback setBroadPhaseCallback()
    */
    function getBroadPhaseCallback():PxBroadPhaseCallback;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Collision Filtering
    //
    //@{

    /**
    \brief Sets the shared global filter data which will get passed into the filter shader.

    **Note:** It is the user's responsibility to ensure that changing the shared global filter data does not change the filter output value for existing pairs. 
          If the filter output for existing pairs does change nonetheless then such a change will not take effect until the pair gets refiltered. 
          resetFiltering() can be used to explicitly refilter the pairs of specific objects.

    **Note:** The provided data will get copied to internal buffers and this copy will be used for filtering calls.

    **Note:** Do not use this method while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[in] data The shared global filter shader data.
    \param[in] dataSize Size of the shared global filter shader data (in bytes).

    @see getFilterShaderData() PxSceneDesc.filterShaderData PxSimulationFilterShader
    */
    function setFilterShaderData(data:cpp.ConstPointer<cpp.Void>, dataSize:PxU32):Void;

    /**
    \brief Gets the shared global filter data in use for this scene.

    **Note:** The reference points to a copy of the original filter data specified in `PxSceneDesc.filterShaderData` or provided by `setFilterShaderData()`.

    \return Shared filter data for filter shader.

    @see getFilterShaderDataSize() setFilterShaderData() PxSceneDesc.filterShaderData PxSimulationFilterShader
    */
    function getFilterShaderData():cpp.ConstPointer<cpp.Void>;

    /**
    \brief Gets the size of the shared global filter data (`PxSceneDesc.filterShaderData)`

    \return Size of shared filter data [bytes].

    @see getFilterShaderData() PxSceneDesc.filterShaderDataSize PxSimulationFilterShader
    */
    function getFilterShaderDataSize():PxU32;

    /**
    \brief Gets the custom collision filter shader in use for this scene.

    \return Filter shader class that defines the collision pair filtering.

    @see PxSceneDesc.filterShader PxSimulationFilterShader
    */
    function getFilterShader():PxSimulationFilterShader;

    /**
    \brief Gets the custom collision filter callback in use for this scene.

    \return Filter callback class that defines the collision pair filtering.

    @see PxSceneDesc.filterCallback PxSimulationFilterCallback
    */
    function getFilterCallback():PxSimulationFilterCallback;

    /**
    \brief Marks the object to reset interactions and re-run collision filters in the next simulation step.
    
    This call forces the object to remove all existing collision interactions, to search anew for existing contact
    pairs and to run the collision filters again for found collision pairs.

    **Note:** The operation is supported for PxRigidActor objects only.

    **Note:** All persistent state of existing interactions will be lost and can not be retrieved even if the same collison pair
    is found again in the next step. This will mean, for example, that you will not get notified about persistent contact
    for such an interaction (see `PxPairFlag.eNOTIFY_TOUCH_PERSISTS),` the contact pair will be interpreted as newly found instead.

    **Note:** Lost touch contact reports will be sent for every collision pair which includes this shape, if they have
    been requested through `PxPairFlag::eNOTIFY_TOUCH_LOST` or `PxPairFlag.eNOTIFY_THRESHOLD_FORCE_LOST.`

    **Note:** This is an expensive operation, don't use it if you don't have to.

    **Note:** Can be used to retrieve collision pairs that were killed by the collision filters (see `PxFilterFlag.eKILL)`

    **Note:** It is invalid to use this method if the actor has not been added to a scene already.

    **Note:** It is invalid to use this method if PxActorFlag::eDISABLE_SIMULATION is set.

    **Sleeping:** Does wake up the actor.

    \param[in] actor The actor for which to re-evaluate interactions.

    @see PxSimulationFilterShader PxSimulationFilterCallback
    */
    function resetFiltering(actor:PxActor):Void;

    @:native("resetFiltering") private function _resetFilteringX(actor:PxRigidActor, shapes:cpp.ConstPointer<PxShape>, shapeCount:PxU32):Void;
    /**
    \brief Marks the object to reset interactions and re-run collision filters for specified shapes in the next simulation step.
    
    This is a specialization of the resetFiltering(PxActor& actor) method and allows to reset interactions for specific shapes of
    a PxRigidActor.

    **Sleeping:** Does wake up the actor.

    \param[in] actor The actor for which to re-evaluate interactions.
    \param[in] shapes The shapes for which to re-evaluate interactions.
    \param[in] shapeCount Number of shapes in the list.

    @see PxSimulationFilterShader PxSimulationFilterCallback
    */
    inline function resetFilteringX(actor:PxRigidActor, shapes:Array<PxShape>):Void
    {
        _resetFilteringX(actor, cpp.Pointer.ofArray(shapes), shapes.length);
    }

    /**
    \brief Gets the pair filtering mode for kinematic-kinematic pairs.

    \return Filtering mode for kinematic-kinematic pairs.

    @see PxPairFilteringMode PxSceneDesc
    */
    function getKinematicKinematicFilteringMode():PxPairFilteringMode;

    /**
    \brief Gets the pair filtering mode for static-kinematic pairs.

    \return Filtering mode for static-kinematic pairs.

    @see PxPairFilteringMode PxSceneDesc
    */
    function getStaticKinematicFilteringMode():PxPairFilteringMode;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Simulation
    //@{

    /**
    Advances the simulation by an elapsedTime time.
    
    Large elapsedTime values can lead to instabilities. In such cases elapsedTime
    should be subdivided into smaller time intervals and simulate() should be called
    multiple times for each interval.

    Calls to simulate() should pair with calls to fetchResults():  
    Each fetchResults() invocation corresponds to exactly one simulate()
    invocation; calling simulate() twice without an intervening fetchResults()
    or fetchResults() twice without an intervening simulate() causes an error
    condition.

    ```haxe
    scene.simulate();
    // ...do some processing until physics is computed...
    scene.fetchResults();
    // ...now results of run may be retrieved.
    ```

    @param elapsedTime Amount of time to advance simulation by. The parameter has to be larger than 0, else the resulting behavior will be undefined. **Range:** (0, PX_MAX_F32)
    @param completionTask if non-NULL, this task will have its refcount incremented in simulate(), then
    decremented when the scene is ready to have fetchResults called. So the task will not run until the
    application also calls removeReference().
    @param scratchMemBlock a memory region for physx to use for temporary data during simulation. This block may be reused by the application
    after fetchResults returns. Must be aligned on a 16-byte boundary
    @param scratchMemBlockSize the size of the scratch memory block. Must be a multiple of 16K.
    @param controlSimulation default `true`. If true, the scene controls its PxTaskManager simulation state. Leave
    true unless the application is calling the PxTaskManager start/stopSimulation() methods itself.

    @see fetchResults() checkResults()
    */
    @:overload(function(elapsedTime:PxReal, completionTask:PxBaseTask,
                        scratchMemBlock:cpp.Pointer<cpp.Void>, scratchMemBlockSize:PxU32, controlSimulation:Bool):Void {})
    function simulate(elapsedTime:PxReal, ?completionTask:PxBaseTask,
                      ?scratchMemBlock:cpp.Pointer<cpp.Void>, scratchMemBlockSize:PxU32 = 0):Void;


    /**
     \brief Performs dynamics phase of the simulation pipeline.
    
    **Note:** Calls to advance() should follow calls to fetchCollision(). An error message will be issued if this sequence is not followed.

    \param[in] completionTask if non-NULL, this task will have its refcount incremented in advance(), then
    decremented when the scene is ready to have fetchResults called. So the task will not run until the
    application also calls removeReference().

    */
    function advance(?completionTask:PxBaseTask):Void;

    /**
    \brief Performs collision detection for the scene over elapsedTime
    
    **Note:** Calls to collide() should be the first method called to simulate a frame.


    \param[in] elapsedTime Amount of time to advance simulation by. The parameter has to be larger than 0, else the resulting behavior will be undefined. **Range:** (0, PX_MAX_F32)
    \param[in] completionTask if non-NULL, this task will have its refcount incremented in collide(), then
    decremented when the scene is ready to have fetchResults called. So the task will not run until the
    application also calls removeReference().
    \param[in] scratchMemBlock a memory region for physx to use for temporary data during simulation. This block may be reused by the application
    after fetchResults returns. Must be aligned on a 16-byte boundary
    \param[in] scratchMemBlockSize the size of the scratch memory block. Must be a multiple of 16K.
    \param[in] controlSimulation if true, the scene controls its PxTaskManager simulation state. Leave
    true unless the application is calling the PxTaskManager start/stopSimulation() methods itself.

    */
    @:overload(function(elapsedTime:PxReal, completionTask:PxBaseTask,
                        scratchMemBlock:cpp.Pointer<cpp.Void>, scratchMemBlockSize:PxU32, controlSimulation:Bool):Void {})
    function collide(elapsedTime:PxReal, ?completionTask:PxBaseTask,
                      ?scratchMemBlock:cpp.Pointer<cpp.Void>, scratchMemBlockSize:PxU32 = 0):Void;
    
    /**
    This checks to see if the simulation run has completed.

    This does not cause the data available for reading to be updated with the results of the simulation, it is simply a status check.
    The bool will allow it to either return immediately or block waiting for the condition to be met so that it can return true
    
    @param block When set to true will block until the condition is met.
    @return True if the results are available.

    @see simulate() fetchResults()
    */
    function checkResults(block:Bool = false):Bool;

    /**
    This method must be called after collide() and before advance(). It will wait for the collision phase to finish. If the user makes an illegal simulation call, the SDK will issue an error
    message.

    @param block When set to true will block until the condition is met, which is collision must finish running.
    */
    function fetchCollision(block:Bool = false):Bool;

    /**
    This is the big brother to checkResults() it basically does the following:
    
    ```haxe
    if ( checkResults(block) )
    {
        fire appropriate callbacks
        swap buffers
        return true
    }
    else
        return false
    ```

    @param block When set to true will block until results are available.
    @param errorState Used to retrieve hardware error codes. A non zero value indicates an error.
    @return True if the results have been fetched.

    @see simulate() checkResults()
    */
    function fetchResults(block:Bool = false, ?errorState:cpp.Pointer<PxU32>):Bool;


    @:native("fetchResultsStart") private function _fetchResultsStart(contactPairs:cpp.Reference<cpp.ConstPointer<PxContactPairHeader>>, nbContactPairs:cpp.Reference<PxU32>, block:Bool = false):Bool;
    /**
    This call performs the first section of fetchResults (callbacks fired before swapBuffers), and returns a pointer to a 
    to the contact streams output by the simulation. It can be used to process contact pairs in parallel, which is often a limiting factor
    for fetchResults() performance. 

    After calling this function and processing the contact streams, call fetchResultsFinish(). Note that writes to the simulation are not
    permitted between the start of fetchResultsStart() and the end of fetchResultsFinish().

    @param block When set to true will block until results are available.
    @return Contact pairs and number of pairs if results have been fetched, otherwise returns `null`.

    @see simulate() checkResults() fetchResults() fetchResultsFinish()
    */
    inline function fetchResultsStart(block:Bool = false):{contactPairs:cpp.ConstPointer<PxContactPairHeader>, nbContactPairs:PxU32}
    {
        var p:cpp.ConstPointer<PxContactPairHeader> = null;
        var n:PxU32 = 0;
        if(_fetchResultsStart(p, n, block))
            return { contactPairs: p, nbContactPairs: n };
        else
            return null;
    }


    /**
    This call processes all event callbacks in parallel. It takes a continuation task, which will be executed once all callbacks have been processed.

    This is a utility function to make it easier to process callbacks in parallel using the PhysX task system. It can only be used in conjunction with 
    fetchResultsStart(...) and fetchResultsFinish(...)

    \param[in] continuation The task that will be executed once all callbacks have been processed.
    */
    function processCallbacks(continuation:PxBaseTask):Void;


    /**
    This call performs the second section of fetchResults: the buffer swap and subsequent callbacks.

    It must be called after fetchResultsStart() returns and contact reports have been processed.

    Note that once fetchResultsFinish() has been called, the contact streams returned in fetchResultsStart() will be invalid.

    \param[out] errorState Used to retrieve hardware error codes. A non zero value indicates an error.

    @see simulate() checkResults() fetchResults() fetchResultsStart()
    */
    function fetchResultsFinish(?errorState:cpp.Pointer<PxU32>):Void;


    /**
    \brief Clear internal buffers and free memory.

    This method can be used to clear buffers and free internal memory without having to destroy the scene. Can be useful if
    the physics data gets streamed in and a checkpoint with a clean state should be created.

    **Note:** It is not allowed to call this method while the simulation is running. The call will fail.
    
    \param[in] sendPendingReports When set to true pending reports will be sent out before the buffers get cleaned up (for instance lost touch contact/trigger reports due to deleted objects).
    */
    function flushSimulation(sendPendingReports:Bool = false):Void;
    
    /**
    \brief Sets a constant gravity for the entire scene.

    **Sleeping:** Does **NOT** wake the actor up automatically.

    \param[in] vec A new gravity vector(e.g. PxVec3(0.0f,-9.8f,0.0f) ) **Range:** force vector

    @see PxSceneDesc.gravity getGravity()
    */
    function setGravity(vec:PxVec3):Void;

    /**
    \brief Retrieves the current gravity setting.

    \return The current gravity for the scene.

    @see setGravity() PxSceneDesc.gravity
    */
    function getGravity():PxVec3;

    /**
    \brief Set the bounce threshold velocity.  Collision speeds below this threshold will not cause a bounce.

    @see PxSceneDesc::bounceThresholdVelocity, getBounceThresholdVelocity
    */
    function setBounceThresholdVelocity(t:PxReal):Void;

    /**
    \brief Return the bounce threshold velocity.

    @see PxSceneDesc.bounceThresholdVelocity, setBounceThresholdVelocity
    */
    function getBounceThresholdVelocity():PxReal;


    /**
    \brief Sets the maximum number of CCD passes

    \param[in] ccdMaxPasses Maximum number of CCD passes

    @see PxSceneDesc.ccdMaxPasses getCCDMaxPasses()

    */
    function setCCDMaxPasses(ccdMaxPasses:PxU32):Void;

    /**
    \brief Gets the maximum number of CCD passes.

    \return The maximum number of CCD passes.

    @see PxSceneDesc::ccdMaxPasses setCCDMaxPasses()

    */
    function getCCDMaxPasses():PxU32;	

    /**
    \brief Return the value of frictionOffsetThreshold that was set in PxSceneDesc when creating the scene with PxPhysics::createScene

    @see PxSceneDesc::frictionOffsetThreshold,  PxPhysics::createScene
    */
    function getFrictionOffsetThreshold():PxReal;

    /**
    \brief Set the friction model.
    @see PxFrictionType, PxSceneDesc::frictionType
    */
    function setFrictionType(frictionType:PxFrictionType):Void;

    /**
    \brief Return the friction model.
    @see PxFrictionType, PxSceneDesc::frictionType
    */
    function getFrictionType():PxFrictionType;

    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Visualization and Statistics
    //
    //@{

    /**
    \brief Function that lets you set debug visualization parameters.

    Returns false if the value passed is out of range for usage specified by the enum.

    \param[in] param	Parameter to set. See `PxVisualizationParameter`
    \param[in] value	The value to set, see `PxVisualizationParameter` for allowable values. Setting to zero disables visualization for the specified property, setting to a positive value usually enables visualization and defines the scale factor.
    \return False if the parameter is out of range.

    @see getVisualizationParameter PxVisualizationParameter getRenderBuffer()
    */
    function setVisualizationParameter(param:PxVisualizationParameter, value:PxReal):Bool;

    /**
    \brief Function that lets you query debug visualization parameters.

    \param[in] paramEnum The Parameter to retrieve.
    \return The value of the parameter.

    @see setVisualizationParameter PxVisualizationParameter
    */
    function getVisualizationParameter(paramEnum:PxVisualizationParameter):PxReal;


    /**
    \brief Defines a box in world space to which visualization geometry will be (conservatively) culled. Use a non-empty culling box to enable the feature, and an empty culling box to disable it.
    
    \param[in] box the box to which the geometry will be culled. Empty box to disable the feature.
    @see setVisualizationParameter getVisualizationCullingBox getRenderBuffer()
    */
    function setVisualizationCullingBox(box:PxBounds3):Void;

    /**
    \brief Retrieves the visualization culling box.

    \return the box to which the geometry will be culled.
    @see setVisualizationParameter setVisualizationCullingBox 
    */
    function getVisualizationCullingBox():PxBounds3;
    
    /**
    \brief Retrieves the render buffer.
    
    This will contain the results of any active visualization for this scene.

    **Note:** Do not use this method while the simulation is running. Calls to this method while result in undefined behaviour.

    \return The render buffer.

    @see PxRenderBuffer
    */
    function getRenderBuffer():PxRenderBuffer;
    
    @:native("getSimulationStatistics") private function _getSimulationStatistics(stats:cpp.Reference<PxSimulationStatistics>):Void;
    /**
    \brief Call this method to retrieve statistics for the current simulation step.

    **Note:** Do not use this method while the simulation is running. Calls to this method while the simulation is running will be ignored.

    \param[out] stats Used to retrieve statistics for the current simulation step.

    @see PxSimulationStatistics
    */
    inline function getSimulationStatistics():PxSimulationStatistics
    {
        var stats:PxSimulationStatistics = null;
        _getSimulationStatistics(stats);
        return stats;
    }
    
    
    //@}
    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Scene Query
    //
    //@{

    /**
    \brief Return the value of PxSceneDesc::staticStructure that was set when creating the scene with PxPhysics::createScene

    @see PxSceneDesc::staticStructure, PxPhysics::createScene
    */
    function getStaticStructure():PxPruningStructureType;

    /**
    \brief Return the value of PxSceneDesc::dynamicStructure that was set when creating the scene with PxPhysics::createScene

    @see PxSceneDesc::dynamicStructure, PxPhysics::createScene
    */
    function getDynamicStructure():PxPruningStructureType;

    /**
    \brief Flushes any changes to the scene query representation.

    This method updates the state of the scene query representation to match changes in the scene state.

    By default, these changes are buffered until the next query is submitted. Calling this function will not change
    the results from scene queries, but can be used to ensure that a query will not perform update work in the course of 
    its execution.
    
    A thread performing updates will hold a write lock on the query structure, and thus stall other querying threads. In multithread
    scenarios it can be useful to explicitly schedule the period where this lock may be held for a significant period, so that
    subsequent queries issued from multiple threads will not block.
    
    */
    function flushQueryUpdates():Void;

    // /**
    // \brief Creates a BatchQuery object. 

    // Scene queries like raycasts, overlap tests and sweeps are batched in this object and are then executed at once. See `PxBatchQuery.`

    // \deprecated The batched query feature has been deprecated in PhysX version 3.4

    // \param[in] desc The descriptor of scene query. Scene Queries need to register a callback. See `PxBatchQueryDesc.`

    // @see PxBatchQuery PxBatchQueryDesc
    // */
    // PX_DEPRECATED virtual	PxBatchQuery*		createBatchQuery(const PxBatchQueryDesc& desc) = 0;

    /**
    \brief Sets the rebuild rate of the dynamic tree pruning structures.

    \param[in] dynamicTreeRebuildRateHint Rebuild rate of the dynamic tree pruning structures.

    @see PxSceneDesc.dynamicTreeRebuildRateHint getDynamicTreeRebuildRateHint() forceDynamicTreeRebuild()
    */
    function setDynamicTreeRebuildRateHint(dynamicTreeRebuildRateHint:PxU32):Void;

    /**
    \brief Retrieves the rebuild rate of the dynamic tree pruning structures.

    \return The rebuild rate of the dynamic tree pruning structures.

    @see PxSceneDesc.dynamicTreeRebuildRateHint setDynamicTreeRebuildRateHint() forceDynamicTreeRebuild()
    */
    function getDynamicTreeRebuildRateHint():Void;

    /**
    \brief Forces dynamic trees to be immediately rebuilt.

    \param[in] rebuildStaticStructure	True to rebuild the dynamic tree containing static objects
    \param[in] rebuildDynamicStructure	True to rebuild the dynamic tree containing dynamic objects

    @see PxSceneDesc.dynamicTreeRebuildRateHint setDynamicTreeRebuildRateHint() getDynamicTreeRebuildRateHint()
    */
    function forceDynamicTreeRebuild(rebuildStaticStructure:Bool, rebuildDynamicStructure:Bool):Void;

    /**
    \brief Sets scene query update mode	

    \param[in] updateMode	Scene query update mode.

    @see PxSceneQueryUpdateMode::Enum
    */
    function setSceneQueryUpdateMode(updateMode:PxSceneQueryUpdateMode):Void;

    /**
    \brief Gets scene query update mode	

    \return Current scene query update mode.

    @see PxSceneQueryUpdateMode::Enum
    */
    function getSceneQueryUpdateMode():PxSceneQueryUpdateMode;

    /**
    \brief Executes scene queries update tasks.
    This function will refit dirty shapes within the pruner and will execute a task to build a new AABB tree, which is
    build on a different thread. The new AABB tree is built based on the dynamic tree rebuild hint rate. Once
    the new tree is ready it will be commited in next fetchQueries call, which must be called after.

    **Note:** If PxSceneQueryUpdateMode::eBUILD_DISABLED_COMMIT_DISABLED is used, it is required to update the scene queries
    using this function.

    \param[in] completionTask if non-NULL, this task will have its refcount incremented in sceneQueryUpdate(), then
    decremented when the scene is ready to have fetchQueries called. So the task will not run until the
    application also calls removeReference().
    \param[in] controlSimulation if true, the scene controls its PxTaskManager simulation state. Default `true`. Leave
    true unless the application is calling the PxTaskManager start/stopSimulation() methods itself.

    @see PxSceneQueryUpdateMode::eBUILD_DISABLED_COMMIT_DISABLED
    */
    @:overload(function(?completionTask:PxBaseTask):Void {})
    function sceneQueriesUpdate(?completionTask:PxBaseTask, controlSimulation:Bool):Void;

    /**
    \brief This checks to see if the scene queries update has completed.

    This does not cause the data available for reading to be updated with the results of the scene queries update, it is simply a status check.
    The bool will allow it to either return immediately or block waiting for the condition to be met so that it can return true
    
    \param[in] block When set to true will block until the condition is met.
    \return True if the results are available.

    @see sceneQueriesUpdate() fetchResults()
    */
    function checkQueries(block:Bool = false):Bool;

    /**
    This method must be called after sceneQueriesUpdate. It will wait for the scene queries update to finish. If the user makes an illegal scene queries update call, 
    the SDK will issue an error	message.

    If a new AABB tree build finished, then during fetchQueries the current tree within the pruning structure is swapped with the new tree. 

    \param[in] block When set to true will block until the condition is met, which is tree built task must finish running.
    */
    function fetchQueries(block:Bool = false):Bool;


    /**
     * Performs a raycast against objects in the scene, returns results in a `PxRaycastBuffer` object
     * or via a custom user callback implementation inheriting from `PxRaycastCallbackHx`.
     * 
     * **Note:** Touching hits are not ordered.
     *           Shooting a ray from within an object leads to different results depending on the shape type.
     *           Please check the details in user guide article SceneQuery. User can ignore such objects by employing one of the provided filter mechanisms.
     * 
     * @param [in]origin		Origin of the ray.
     * @param [in]unitDir		Normalized direction of the ray.
     * @param [in]distance		Length of the ray. Has to be in the [0, inf) range.
     * @param [out]hitCall		Raycast hit buffer or callback object used to report raycast hits.
     * @param [in]hitFlags		Default `PxHitFlag.eDEFAULT`. Specifies which properties per hit should be computed and returned via the hit callback.
     * @param [in]filterData	Filtering data passed to the filter shader. See `PxQueryFilterData`, `PxBatchQueryPreFilterShader`, `PxBatchQueryPostFilterShader`
     * @param [in]filterCall	Custom filtering logic (optional). Only used if the corresponding `PxQueryFlag` flags are set. If NULL, all hits are assumed to be blocking.
     * @param [in]cache		Cached hit shape (optional). Ray is tested against cached shape first. If no hit is found the ray gets queried against the scene.
     * 						Note: Filtering is not executed for a cached shape if supplied; instead, if a hit is found, it is assumed to be a blocking hit.
     * 						Note: Using past touching hits as cache will produce incorrect behavior since the cached hit will always be treated as blocking.
     * 
     * @return True if any touching or blocking hits were found or any hit was found in case `PxQueryFlag.eANY_HIT` was specified.
     * 
     * @see PxRaycastCallback PxRaycastBuffer PxQueryFilterData PxQueryFilterCallback PxQueryCache PxRaycastHit PxQueryFlag PxQueryFlag.eANY_HIT 
     */
    @:overload(function(origin:PxVec3, unitDir:PxVec3, distance:PxReal,
                        hitCall:PxRaycastCallback):Bool {})
    function raycast(origin:PxVec3, unitDir:PxVec3, distance:PxReal,
                     hitCall:PxRaycastCallback, hitFlags:PxHitFlags,
                     filterData:PxQueryFilterData, ?filterCall:PxQueryFilterCallback,
                     ?cache:cpp.ConstPointer<PxQueryCache>):Bool;


    /**
     * Performs a sweep test against objects in the scene, returns results in a `PxSweepBuffer` object
     * or via a custom user callback implementation inheriting from `PxSweepCallbackHx`.
     * 
     * **Note:** Touching hits are not ordered.
     *           If a shape from the scene is already overlapping with the query shape in its starting position,
     *           the hit is returned unless `eASSUME_NO_INITIAL_OVERLAP` was specified.
     * 
     * @param [in]geometry		Geometry of object to sweep (supported types are: box, sphere, capsule, convex).
     * @param [in]pose			Pose of the sweep object.
     * @param [in]unitDir		Normalized direction of the sweep.
     * @param [in]distance		Sweep distance. Needs to be in [0, inf) range and >0 if `eASSUME_NO_INITIAL_OVERLAP` was specified. Will be clamped to `PX_MAX_SWEEP_DISTANCE`.
     * @param [out]hitCall		Sweep hit buffer or callback object used to report sweep hits.
     * @param [in]hitFlags		Default `PxHitFlag.eDEFAULT`. Specifies which properties per hit should be computed and returned via the hit callback.
     * @param [in]filterData	Filtering data and simple logic.
     * @param [in]filterCall	Custom filtering logic (optional). Only used if the corresponding `PxQueryFlag` flags are set. If NULL, all hits are assumed to be blocking.
     * @param [in]cache 		Cached hit shape (optional). Sweep is performed against cached shape first. If no hit is found the sweep gets queried against the scene.
     * 					    	Note: Filtering is not executed for a cached shape if supplied; instead, if a hit is found, it is assumed to be a blocking hit.
     * 					    	Note: Using past touching hits as cache will produce incorrect behavior since the cached hit will always be treated as blocking.
     * @param [in]inflation	    This parameter creates a skin around the swept geometry which increases its extents for sweeping.
     *                          The sweep will register a hit as soon as the skin touches a shape, and will return the corresponding distance and normal.
     * 						    Note: `ePRECISE_SWEEP` doesn't support inflation. Therefore the sweep will be performed with zero inflation.	
     * 
     * @return True if any touching or blocking hits were found or any hit was found in case `PxQueryFlag.eANY_HIT` was specified.
     * 
     * @see PxSweepCallback PxSweepBuffer PxQueryFilterData PxQueryFilterCallback PxSweepHit PxQueryCache
     */
    @:overload(function(geometry:PxGeometry, pose:PxTransform, unitDir:PxVec3, distance:PxReal,
                        hitCall:PxRaycastCallback):Bool {})
    function sweep(geometry:PxGeometry, pose:PxTransform, unitDir:PxVec3, distance:PxReal,
                   hitCall:PxSweepCallback, hitFlags:PxHitFlags,
                   filterData:PxQueryFilterData, ?filterCall:PxQueryFilterCallback,
                   ?cache:cpp.ConstPointer<PxQueryCache>, inflation:PxReal = 0):Bool;


    /**
     * Performs an overlap test of a given geometry against objects in the scene, returns results in a `PxOverlapBuffer` object
     * or via a custom user callback implementation inheriting from `PxOverlapCallbackHx`.
     * 
     * **Note:** Filtering: returning `eBLOCK` from user filter for overlap queries will result in undefined behavior and cause a warning (see `PxQueryHitType`).
     * 
     * **Note:** If the `PxQueryFlag.eNO_BLOCK` flag is set, the `eBLOCK` will instead be automatically converted to an `eTOUCH` and the warning suppressed.
     * 
     * @param [in]geometry		Geometry of object to check for overlap (supported types are: box, sphere, capsule, convex).
     * @param [in]pose			Pose of the object.
     * @param [out]hitCall		Overlap hit buffer or callback object used to report overlap hits.
     * @param [in]filterData	Filtering data and simple logic. See `PxQueryFilterData` `PxQueryFilterCallback`
     * @param [in]filterCall	Custom filtering logic (optional). Only used if the corresponding `PxQueryFlag` flags are set. If NULL, all hits are assumed to overlap.
     * 
     * @return True if any touching or blocking hits were found or any hit was found in case `PxQueryFlag.eANY_HIT` was specified.
     * 
     * @see PxOverlapCallback PxOverlapBuffer PxHitFlags PxQueryFilterData PxQueryFilterCallback
     */
    @:overload(function(geometry:PxGeometry, pose:PxTransform, hitCall:PxSweepCallback):Bool {})
    function overlap(geometry:PxGeometry, pose:PxTransform, hitCall:PxSweepCallback,
                     filterData:PxQueryFilterData, ?filterCall:PxQueryFilterCallback):Bool;


    /**
    \brief Retrieves the scene's internal scene query timestamp, increased each time a change to the
    static scene query structure is performed.

    \return scene query static timestamp
    */
    function getSceneQueryStaticTimestamp():PxU32;
    
    //@}
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    
    // @name Broad-phase
    //
    //@{

    /**
    \brief Returns broad-phase type.

    \return Broad-phase type
    */
    function getBroadPhaseType():PxBroadPhaseType;

    /**
    \brief Gets broad-phase caps.

    \param[out]	caps	Broad-phase caps
    \return True if success
    */
    function getBroadPhaseCaps(caps:PxBroadPhaseCaps):Bool;

    /**
    \brief Returns number of regions currently registered in the broad-phase.

    \return Number of regions
    */
    function getNbBroadPhaseRegions():PxU32;

    @:native("getBroadPhaseRegions") private function _getBroadPhaseRegions(userBuffer:cpp.Pointer<PxBroadPhaseRegionInfo>, bufferSize:PxU32, startIndex:PxU32 = 0):PxU32;
    /**
    Gets broad-phase regions.

    @param	startIndex	Index of first desired region, in [0 ; getNbRegions()[
    @return Number of written out regions
    */
    inline function getBroadPhaseRegions(startIndex:PxU32 = 0):Array<PxBroadPhaseRegionInfo>
    {
        var buf:Array<PxBroadPhaseRegionInfo> = [];
        var len = getNbBroadPhaseRegions();
        buf.resize(len);
        _getBroadPhaseRegions(cpp.Pointer.ofArray(buf), len, startIndex);
        return buf;
    }

    /**
    \brief Adds a new broad-phase region.

    Note that by default, objects already existing in the SDK that might touch this region will not be automatically
    added to the region. In other words the newly created region will be empty, and will only be populated with new
    objects when they are added to the simulation, or with already existing objects when they are updated.

    It is nonetheless possible to override this default behavior and let the SDK populate the new region automatically
    with already existing objects overlapping the incoming region. This has a cost though, and it should only be used
    when the game can not guarantee that all objects within the new region will be added to the simulation after the
    region itself.

    \param[in]	region			User-provided region data
    \param[in]	populateRegion	Automatically populate new region with already existing objects overlapping it
    \return Handle for newly created region, or 0xffffffff in case of failure.
    */
    function addBroadPhaseRegion(region:PxBroadPhaseRegion, populateRegion:Bool = false):PxU32;

    /**
    \brief Removes a new broad-phase region.

    If the region still contains objects, and if those objects do not overlap any region any more, they are not
    automatically removed from the simulation. Instead, the PxBroadPhaseCallback::onObjectOutOfBounds notification
    is used for each object. Users are responsible for removing the objects from the simulation if this is the
    desired behavior.

    If the handle is invalid, or if a valid handle is removed twice, an error message is sent to the error stream.

    \param[in]	handle	Region's handle, as returned by PxScene::addBroadPhaseRegion.
    \return True if success
    */
    function removeBroadPhaseRegion(handle:PxU32):Bool;

    //@}

    //////////////////////////////////////////////////////////////////////////////////////////////////

    // @name Threads and Memory
    //
    //@{

    /**
    \brief Get the task manager associated with this scene

    \return the task manager associated with the scene
    */
//virtual PxTaskManager*			getTaskManager() const = 0;


    /**
    \brief Lock the scene for reading from the calling thread.

    When the PxSceneFlag::eREQUIRE_RW_LOCK flag is enabled lockRead() must be 
    called before any read calls are made on the scene.

    Multiple threads may read at the same time, no threads may read while a thread is writing.
    If a call to lockRead() is made while another thread is holding a write lock 
    then the calling thread will be blocked until the writing thread calls unlockWrite().

    **Note:** Lock upgrading is *not* supported, that means it is an error to
    call lockRead() followed by lockWrite().

    **Note:** Recursive locking is supported but each lockRead() call must be paired with an unlockRead().

    \param file String representing the calling file, for debug purposes
    \param line The source file line number, for debug purposes
    */
    function lockRead(?file:cpp.ConstCharStar, line:PxU32 = 0):Void;

    /** 
    \brief Unlock the scene from reading.

    **Note:** Each unlockRead() must be paired with a lockRead() from the same thread.
    */
    function unlockRead():Void;

    /**
    \brief Lock the scene for writing from this thread.

    When the PxSceneFlag::eREQUIRE_RW_LOCK flag is enabled lockWrite() must be 
    called before any write calls are made on the scene.

    Only one thread may write at a time and no threads may read while a thread is writing.
    If a call to lockWrite() is made and there are other threads reading then the 
    calling thread will be blocked until the readers complete.

    Writers have priority. If a thread is blocked waiting to write then subsequent calls to 
    lockRead() from other threads will be blocked until the writer completes.

    **Note:** If multiple threads are waiting to write then the thread that is first
    granted access depends on OS scheduling.

    **Note:** Recursive locking is supported but each lockWrite() call must be paired 
    with an unlockWrite().	

    **Note:** If a thread has already locked the scene for writing then it may call
    lockRead().

    \param file String representing the calling file, for debug purposes
    \param line The source file line number, for debug purposes
    */
    function lockWrite(?file:cpp.ConstCharStar, line:PxU32 = 0):Void;

    /**
    \brief Unlock the scene from writing.

    **Note:** Each unlockWrite() must be paired with a lockWrite() from the same thread.
    */
    function unlockWrite():Void;
    

    /**
    \brief set the cache blocks that can be used during simulate(). 
    
    Each frame the simulation requires memory to store contact, friction, and contact cache data. This memory is used in blocks of 16K.
    Each frame the blocks used by the previous frame are freed, and may be retrieved by the application using PxScene::flushSimulation()

    This call will force allocation of cache blocks if the numBlocks parameter is greater than the currently allocated number
    of blocks, and less than the max16KContactDataBlocks parameter specified at scene creation time.

    \param[in] numBlocks The number of blocks to allocate.	

    @see PxSceneDesc.nbContactDataBlocks PxSceneDesc.maxNbContactDataBlocks flushSimulation() getNbContactDataBlocksUsed getMaxNbContactDataBlocksUsed
    */
    function setNbContactDataBlocks(numBlocks:PxU32):Void;
    

    /**
    \brief get the number of cache blocks currently used by the scene 

    This function may not be called while the scene is simulating

    \return the number of cache blocks currently used by the scene

    @see PxSceneDesc.nbContactDataBlocks PxSceneDesc.maxNbContactDataBlocks flushSimulation() setNbContactDataBlocks() getMaxNbContactDataBlocksUsed()
    */
    function getNbContactDataBlocksUsed():PxU32;

    /**
    \brief get the maximum number of cache blocks used by the scene 

    This function may not be called while the scene is simulating

    \return the maximum number of cache blocks everused by the scene

    @see PxSceneDesc.nbContactDataBlocks PxSceneDesc.maxNbContactDataBlocks flushSimulation() setNbContactDataBlocks() getNbContactDataBlocksUsed()
    */
    function getMaxNbContactDataBlocksUsed():PxU32;


    /**
    \brief Return the value of PxSceneDesc::contactReportStreamBufferSize that was set when creating the scene with PxPhysics::createScene

    @see PxSceneDesc::contactReportStreamBufferSize, PxPhysics::createScene
    */
    function getContactReportStreamBufferSize():PxU32;

    
    /**
    \brief Sets the number of actors required to spawn a separate rigid body solver thread.

    \param[in] solverBatchSize Number of actors required to spawn a separate rigid body solver thread.

    @see PxSceneDesc.solverBatchSize getSolverBatchSize()
    */
    function setSolverBatchSize(solverBatchSize:PxU32):Void;

    /**
    \brief Retrieves the number of actors required to spawn a separate rigid body solver thread.

    \return Current number of actors required to spawn a separate rigid body solver thread.

    @see PxSceneDesc.solverBatchSize setSolverBatchSize()
    */
    function getSolverBatchSize():PxU32;

    /**
    \brief Sets the number of articulations required to spawn a separate rigid body solver thread.

    \param[in] solverBatchSize Number of articulations required to spawn a separate rigid body solver thread.

    @see PxSceneDesc.solverBatchSize getSolverArticulationBatchSize()
    */
    function setSolverArticulationBatchSize(solverBatchSize:PxU32):Void;

    /**
    \brief Retrieves the number of articulations required to spawn a separate rigid body solver thread.

    \return Current number of articulations required to spawn a separate rigid body solver thread.

    @see PxSceneDesc.solverBatchSize setSolverArticulationBatchSize()
    */
    function getSolverArticulationBatchSize():PxU32;
    

    //@}

    /**
    \brief Returns the wake counter reset value.

    \return Wake counter reset value

    @see PxSceneDesc.wakeCounterResetValue
    */
    function getWakeCounterResetValue():PxReal;

    /**
    \brief Shift the scene origin by the specified vector.

    The poses of all objects in the scene and the corresponding data structures will get adjusted to reflect the new origin location
    (the shift vector will get subtracted from all object positions).

    **Note:** It is the user's responsibility to keep track of the summed total origin shift and adjust all input/output to/from PhysX accordingly.

    **Note:** Do not use this method while the simulation is running. Calls to this method while the simulation is running will be ignored.

    **Note:** Make sure to propagate the origin shift to other dependent modules (for example, the character controller module etc.).

    **Note:** This is an expensive operation and we recommend to use it only in the case where distance related precision issues may arise in areas far from the origin.

    \param[in] shift Translation vector to shift the origin by.
    */
    function shiftOrigin(shift:PxVec3):Void;

    /**
    \brief Returns the Pvd client associated with the scene.
    \return the client, NULL if no PVD supported.
    */
    function getScenePvdClient():PxPvdSceneClient;

    /**
     * User can assign this to whatever, usually to create a 1:1 relationship with a user object.
     */
    var userData:physx.hx.PxUserData;
}