package physx;

import physx.cudamanager.PxCudaContextManager;
import physx.PxBroadPhase;
import physx.foundation.PxBounds3;
import physx.task.PxCpuDispatcher;
import physx.foundation.PxSimpleTypes.PxReal;
import physx.foundation.PxSimpleTypes.PxU32;
import physx.common.PxTolerancesScale;
import physx.foundation.PxVec3;
import physx.PxSimulationEventCallback;
import physx.PxFiltering;
import physx.PxContactModifyCallback;

/**
\brief Pruning structure used to accelerate scene queries.

eNONE uses a simple data structure that consumes less memory than the alternatives,
but generally has slower query performance.

eDYNAMIC_AABB_TREE usually provides the fastest queries. However there is a
constant per-frame management cost associated with this structure. How much work should
be done per frame can be tuned via the #PxSceneDesc::dynamicTreeRebuildRateHint
parameter.

eSTATIC_AABB_TREE is typically used for static objects. It is the same as the
dynamic AABB tree, without the per-frame overhead. This can be a good choice for static
objects, if no static objects are added, moved or removed after the scene has been
created. If there is no such guarantee (e.g. when streaming parts of the world in and out),
then the dynamic version is a better choice even for static objects.
*/
extern enum abstract PxPruningStructureType(PxPruningStructureTypeImpl)
{
    @:native("physx::PxPruningStructureType::eNONE") var eNONE;					//!< Using a simple data structure
    @:native("physx::PxPruningStructureType::eDYNAMIC_AABB_TREE") var eDYNAMIC_AABB_TREE;		//!< Using a dynamic AABB tree
    @:native("physx::PxPruningStructureType::eSTATIC_AABB_TREE") var eSTATIC_AABB_TREE;		//!< Using a static AABB tree

    @:native("physx::PxPruningStructureType::eLAST") var eLAST;
}

@:include("PxSceneDesc.h")
@:native("physx::PxPruningStructureType::Enum")
private extern class PxPruningStructureTypeImpl {}


/**
\brief Scene query update mode

When PxScene::fetchResults is called it does scene query related work, with this enum it is possible to 
set what work is done during the fetchResults. 

FetchResults will sync changed bounds during simulation and update the scene query bounds in pruners, this work is mandatory.

eCOMMIT_ENABLED_BUILD_ENABLED does allow to execute the new AABB tree build step during fetchResults, additionally the pruner commit is
called where any changes are applied. During commit PhysX refits the dynamic scene query tree and if a new tree was built and 
the build finished the tree is swapped with current AABB tree. 

eCOMMIT_DISABLED_BUILD_ENABLED does allow to execute the new AABB tree build step during fetchResults. Pruner commit is not called,
this means that refit will then occur during the first scene query following fetchResults, or may be forced by the method PxScene::flushSceneQueryUpdates().

eCOMMIT_DISABLED_BUILD_DISABLED no further scene query work is executed. The scene queries update needs to be called manually, see PxScene::sceneQueriesUpdate.
It is recommended to call PxScene::sceneQueriesUpdate right after fetchResults as the pruning structures are not updated. 
*/
extern enum abstract PxSceneQueryUpdateMode(PxSceneQueryUpdateModeImpl)
{
    @:native("physx::PxSceneQueryUpdateMode::eBUILD_ENABLED_COMMIT_ENABLED") var eBUILD_ENABLED_COMMIT_ENABLED;		//!< Both scene query build and commit are executed.
    @:native("physx::PxSceneQueryUpdateMode::eBUILD_ENABLED_COMMIT_DISABLED") var eBUILD_ENABLED_COMMIT_DISABLED;		//!< Scene query build only is executed.
    @:native("physx::PxSceneQueryUpdateMode::eBUILD_DISABLED_COMMIT_DISABLED") var eBUILD_DISABLED_COMMIT_DISABLED;		//!< No work is done, no update of scene queries
}

@:include("PxSceneDesc.h")
@:native("physx::PxSceneQueryUpdateMode::Enum")
private extern class PxSceneQueryUpdateModeImpl {}


/**
\brief Enum for selecting the friction algorithm used for simulation.

#PxFrictionType::ePATCH selects the patch friction model which typically leads to the most stable results at low solver iteration counts and is also quite inexpensive, as it uses only
up to four scalar solver constraints per pair of touching objects.  The patch friction model is the same basic strong friction algorithm as PhysX 3.2 and before.  

#PxFrictionType::eONE_DIRECTIONAL is a simplification of the Coulomb friction model, in which the friction for a given point of contact is applied in the alternating tangent directions of
the contact's normal.  This simplification allows us to reduce the number of iterations required for convergence but is not as accurate as the two directional model.

#PxFrictionType::eTWO_DIRECTIONAL is identical to the one directional model, but it applies friction in both tangent directions simultaneously.  This hurts convergence a bit so it 
requires more solver iterations, but is more accurate.  Like the one directional model, it is applied at every contact point, which makes it potentially more expensive
than patch friction for scenarios with many contact points.

#PxFrictionType::eFRICTION_COUNT is the total numer of friction models supported by the SDK.
*/
extern enum abstract PxFrictionType(PxFrictionTypeImpl)
{
    @:native("physx::PxFrictionType::ePATCH") var ePATCH;				//!< Select default patch-friction model.
    @:native("physx::PxFrictionType::eONE_DIRECTIONAL") var eONE_DIRECTIONAL;	//!< Select one directional per-contact friction model.
    @:native("physx::PxFrictionType::eTWO_DIRECTIONAL") var eTWO_DIRECTIONAL;	//!< Select two directional per-contact friction model.
    @:native("physx::PxFrictionType::eFRICTION_COUNT") var eFRICTION_COUNT;		//!< The total number of friction models supported by the SDK.
}

@:include("PxSceneDesc.h")
@:native("physx::PxFrictionType::Enum")
private extern class PxFrictionTypeImpl {}


/**
\brief Enum for selecting the type of solver used for the simulation.

#PxSolverType::ePGS selects the default iterative sequential impulse solver. This is the same kind of solver used in PhysX 3.4 and earlier releases.

#PxSolverType::eTGS selects a non linear iterative solver. This kind of solver can lead to improved convergence and handle large mass ratios, long chains and jointed systems better. It is slightly more expensive than the default solver and can introduce more energy to correct joint and contact errors.
*/
extern enum abstract PxSolverType(PxSolverTypeImpl)
{
    @:native("physx::PxSolverType::ePGS") var ePGS;			//!< Default Projected Gauss-Seidel iterative solver
    @:native("physx::PxSolverType::eTGS") var eTGS;			//!< Temporal Gauss-Seidel solver
}

@:include("PxSceneDesc.h")
@:native("physx::PxSolverType::Enum")
private extern class PxSolverTypeImpl {}


/**
\brief flags for configuring properties of the scene

@see PxScene
*/
extern enum abstract PxSceneFlag(PxSceneFlagImpl)
{
    /**
    \brief Enable Active Actors Notification.

    This flag enables the Active Actor Notification feature for a scene.  This
    feature defaults to disabled.  When disabled, the function
    PxScene::getActiveActors() will always return a NULL list.

    \note There may be a performance penalty for enabling the Active Actor Notification, hence this flag should
    only be enabled if the application intends to use the feature.

    <b>Default:</b> False
    */
    @:native("physx::PxSceneFlag::eENABLE_ACTIVE_ACTORS") var eENABLE_ACTIVE_ACTORS;

    /**
    \brief Enables a second broad phase check after integration that makes it possible to prevent objects from tunneling through eachother.

    PxPairFlag::eDETECT_CCD_CONTACT requires this flag to be specified.

    \note For this feature to be effective for bodies that can move at a significant velocity, the user should raise the flag PxRigidBodyFlag::eENABLE_CCD for them.
    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    <b>Default:</b> False

    @see PxRigidBodyFlag::eENABLE_CCD, PxPairFlag::eDETECT_CCD_CONTACT, eDISABLE_CCD_RESWEEP
    */
    @:native("physx::PxSceneFlag::eENABLE_CCD") var eENABLE_CCD;

    /**
    \brief Enables a simplified swept integration strategy, which sacrifices some accuracy for improved performance.

    This simplified swept integration approach makes certain assumptions about the motion of objects that are not made when using a full swept integration. 
    These assumptions usually hold but there are cases where they could result in incorrect behavior between a set of fast-moving rigid bodies. A key issue is that
    fast-moving dynamic objects may tunnel through each-other after a rebound. This will not happen if this mode is disabled. However, this approach will be potentially 
    faster than a full swept integration because it will perform significantly fewer sweeps in non-trivial scenes involving many fast-moving objects. This approach 
    should successfully resist objects passing through the static environment.

    PxPairFlag::eDETECT_CCD_CONTACT requires this flag to be specified.

    \note This scene flag requires eENABLE_CCD to be enabled as well. If it is not, this scene flag will do nothing.
    \note For this feature to be effective for bodies that can move at a significant velocity, the user should raise the flag PxRigidBodyFlag::eENABLE_CCD for them.
    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    <b>Default:</b> False

    @see PxRigidBodyFlag::eENABLE_CCD, PxPairFlag::eDETECT_CCD_CONTACT, eENABLE_CCD
    */
    @:native("physx::PxSceneFlag::eDISABLE_CCD_RESWEEP") var eDISABLE_CCD_RESWEEP;

    /**
    \brief Enable adaptive forces to accelerate convergence of the solver. 
    
    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    <b>Default:</b> false
    */
    @:native("physx::PxSceneFlag::eADAPTIVE_FORCE") var eADAPTIVE_FORCE;

    /**
    \brief Enable GJK-based distance collision detection system.
    
    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    <b>Default:</b> true
    */
    @:native("physx::PxSceneFlag::eENABLE_PCM") var eENABLE_PCM;

    /**
    \brief Disable contact report buffer resize. Once the contact buffer is full, the rest of the contact reports will 
    not be buffered and sent.

    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.
    
    <b>Default:</b> false
    */
    @:native("physx::PxSceneFlag::eDISABLE_CONTACT_REPORT_BUFFER_RESIZE") var eDISABLE_CONTACT_REPORT_BUFFER_RESIZE;

    /**
    \brief Disable contact cache.
    
    Contact caches are used internally to provide faster contact generation. You can disable all contact caches
    if memory usage for this feature becomes too high.

    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    <b>Default:</b> false
    */
    @:native("physx::PxSceneFlag::eDISABLE_CONTACT_CACHE") var eDISABLE_CONTACT_CACHE;

    /**
    \brief Require scene-level locking

    When set to true this requires that threads accessing the PxScene use the
    multi-threaded lock methods.
    
    \note This flag is not mutable, and must be set in PxSceneDesc at scene creation.

    @see PxScene::lockRead
    @see PxScene::unlockRead
    @see PxScene::lockWrite
    @see PxScene::unlockWrite
    
    <b>Default:</b> false
    */
    @:native("physx::PxSceneFlag::eREQUIRE_RW_LOCK") var eREQUIRE_RW_LOCK;

    /**
    \brief Enables additional stabilization pass in solver

    When set to true, this enables additional stabilization processing to improve that stability of complex interactions between large numbers of bodies.

    Note that this flag is not mutable and must be set in PxSceneDesc at scene creation. Also, this is an experimental feature which does result in some loss of momentum.
    */
    @:native("physx::PxSceneFlag::eENABLE_STABILIZATION") var eENABLE_STABILIZATION;

    /**
    \brief Enables average points in contact manifolds

    When set to true, this enables additional contacts to be generated per manifold to represent the average point in a manifold. This can stabilize stacking when only a small
    number of solver iterations is used.

    Note that this flag is not mutable and must be set in PxSceneDesc at scene creation.
    */
    @:native("physx::PxSceneFlag::eENABLE_AVERAGE_POINT") var eENABLE_AVERAGE_POINT;

    /**
    \brief Do not report kinematics in list of active actors.

    Since the target pose for kinematics is set by the user, an application can track the activity state directly and use
    this flag to avoid that kinematics get added to the list of active actors.

    \note This flag has only an effect in combination with eENABLE_ACTIVE_ACTORS.

    @see eENABLE_ACTIVE_ACTORS

    <b>Default:</b> false
    */
    @:native("physx::PxSceneFlag::eEXCLUDE_KINEMATICS_FROM_ACTIVE_ACTORS") var eEXCLUDE_KINEMATICS_FROM_ACTIVE_ACTORS;

    /*\brief Enables the GPU dynamics pipeline

    When set to true, a CUDA ARCH 3.0 or above-enabled NVIDIA GPU is present and the CUDA context manager has been configured, this will run the GPU dynamics pipelin instead of the CPU dynamics pipeline.

    Note that this flag is not mutable and must be set in PxSceneDesc at scene creation.
    */
    @:native("physx::PxSceneFlag::eENABLE_GPU_DYNAMICS") var eENABLE_GPU_DYNAMICS;

    /**
    \brief Provides improved determinism at the expense of performance. 

    By default, PhysX provides limited determinism guarantees. Specifically, PhysX guarantees that the exact scene (same actors created in the same order) and simulated using the same 
    time-stepping scheme should provide the exact same behaviour.

    However, if additional actors are added to the simulation, this can affect the behaviour of the existing actors in the simulation, even if the set of new actors do not interact with 
    the existing actors.

    This flag provides an additional level of determinism that guarantees that the simulation will not change if additional actors are added to the simulation, provided those actors do not interfere
    with the existing actors in the scene. Determinism is only guaranteed if the actors are inserted in a consistent order each run in a newly-created scene and simulated using a consistent time-stepping
    scheme.

    Note that this flag is not mutable and must be set at scene creation.

    Note that enabling this flag can have a negative impact on performance.

    Note that this feature is not currently supported on GPU.

    <b>Default</b> false
    */
    @:native("physx::PxSceneFlag::eENABLE_ENHANCED_DETERMINISM") var eENABLE_ENHANCED_DETERMINISM;

    /**
    \brief Controls processing friction in all solver iterations

    By default, PhysX processes friction only in the final 3 position iterations, and all velocity
    iterations. This flag enables friction processing in all position and velocity iterations.

    The default behaviour provides a good trade-off between performance and stability and is aimed
    primarily at game development.

    When simulating more complex frictional behaviour, such as grasping of complex geometries with
    a robotic manipulator, better results can be achieved by enabling friction in all solver iterations.

    \note This flag only has effect with the default solver. The TGS solver always performs friction per-iteration.
    */
    @:native("physx::PxSceneFlag::eENABLE_FRICTION_EVERY_ITERATION") var eENABLE_FRICTION_EVERY_ITERATION;

    @:native("physx::PxSceneFlag::eMUTABLE_FLAGS") var eMUTABLE_FLAGS;

    @:op(A | B)
    private inline function or(flag:PxSceneFlag):PxSceneFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxSceneDesc.h")
@:native("physx::PxSceneFlags")
private extern class PxSceneFlagImpl {}

/**
\brief collection of set bits defined in PxSceneFlag.

@see PxSceneFlag
*/
extern abstract PxSceneFlags(PxSceneFlag) from PxSceneFlag to PxSceneFlag {}


/**
\brief Class used to retrieve limits(e.g. maximum number of bodies) for a scene. The limits
are used as a hint to the size of the scene, not as a hard limit (i.e. it will be possible
to create more objects than specified in the scene limits).

0 indicates no limit. Using limits allows the SDK to preallocate various arrays, leading to
less re-allocations and faster code at runtime.
*/
@:include("PxSceneDesc.h")
@:native("::cpp::Struct<physx::PxSceneLimits>")
extern class PxSceneLimits
{
    var	maxNbActors:PxU32;				//!< Expected maximum number of actors
    var	maxNbBodies:PxU32;				//!< Expected maximum number of dynamic rigid bodies
    var	maxNbStaticShapes:PxU32;		//!< Expected maximum number of static shapes
    var	maxNbDynamicShapes:PxU32;		//!< Expected maximum number of dynamic shapes
    var	maxNbAggregates:PxU32;			//!< Expected maximum number of aggregates
    var	maxNbConstraints:PxU32;			//!< Expected maximum number of constraint shaders
    var	maxNbRegions:PxU32;				//!< Expected maximum number of broad-phase regions
    var	maxNbBroadPhaseOverlaps:PxU32;	//!< Expected maximum number of broad-phase overlaps

    /**
    \brief (re)sets the structure to the default
    */
    function setToDefault():Void;

    /**
    \brief Returns true if the descriptor is valid.
    \return true if the current settings are valid.
    */
    function isValid():Bool;
}


//#if PX_SUPPORT_GPU_PHYSX
/**
\brief Sizes of pre-allocated buffers use for GPU dynamics
*/
@:include("PxSceneDesc.h")
@:native("::cpp::Struct<physx::PxgDynamicsMemoryConfig>")
extern class PxgDynamicsMemoryConfig
{
    var constraintBufferCapacity:PxU32;	//!< Capacity of constraint buffer allocated in GPU global memory
    var contactBufferCapacity:PxU32;	//!< Capacity of contact buffer allocated in GPU global memory
    var tempBufferCapacity:PxU32;		//!< Capacity of temp buffer allocated in pinned host memory.
    var contactStreamSize:PxU32;		//!< Size of contact stream buffer allocated in pinned host memory. This is double-buffered so total allocation size = 2* contactStreamCapacity * sizeof(PxContact).
    var patchStreamSize:PxU32;			//!< Size of the contact patch stream buffer allocated in pinned host memory. This is double-buffered so total allocation size = 2 * patchStreamCapacity * sizeof(PxContactPatch).
    var forceStreamCapacity:PxU32;		//!< Capacity of force buffer allocated in pinned host memory.
    var heapCapacity:PxU32;				//!< Initial capacity of the GPU and pinned host memory heaps. Additional memory will be allocated if more memory is required.
    var foundLostPairsCapacity:PxU32;	//!< Capacity of found and lost buffers allocated in GPU global memory. This is used for the found/lost pair reports in the BP. 
}

//#endif

@:forward
extern abstract PxSceneDesc(PxSceneDescData) 
{
    /**
    constructor sets to default.

    @param scale scale values for the tolerances in the scene, these must be the same values passed into
    PxCreatePhysics(). The affected tolerances are bounceThresholdVelocity and frictionOffsetThreshold.

    @see PxCreatePhysics() PxTolerancesScale bounceThresholdVelocity frictionOffsetThreshold
    */	
    inline function new(scale:PxTolerancesScale)
    {
        this = cast PxSceneDescData.create(scale);
    }
}

/**
\brief Descriptor class for scenes. See #PxScene.

This struct must be initialized with the same PxTolerancesScale values used to initialize PxPhysics.

@see PxScene PxPhysics.createScene PxTolerancesScale
*/
@:include("PxSceneDesc.h")
@:native("physx::PxSceneDesc")
@:structAccess
private extern class PxSceneDescData
{
    /**
    \brief Gravity vector.

    **Range:** force vector  
    **Default:** Zero

    @see PxScene.setGravity()

    When setting gravity, you should probably also set bounce threshold.
    */
    var gravity:PxVec3;

    /**
    \brief Possible notification callback.

    **Default:** NULL

    @see PxSimulationEventCallback PxScene.setSimulationEventCallback() PxScene.getSimulationEventCallback()
    */
    var simulationEventCallback:PxSimulationEventCallback;

    /**
    \brief Possible asynchronous callback for contact modification.

    **Default:** NULL

    @see PxContactModifyCallback PxScene.setContactModifyCallback() PxScene.getContactModifyCallback()
    */
    var contactModifyCallback:PxContactModifyCallback;

    /**
    \brief Possible asynchronous callback for contact modification.

    **Default:** NULL

    @see PxContactModifyCallback PxScene.setContactModifyCallback() PxScene.getContactModifyCallback()
    */
    var ccdContactModifyCallback:PxCCDContactModifyCallback;

    /**
    \brief Shared global filter data which will get passed into the filter shader.

    \note The provided data will get copied to internal buffers and this copy will be used for filtering calls.

    **Default:** NULL

    @see PxSimulationFilterShader PxScene::setFilterShaderData()
    */
    var filterShaderData:cpp.ConstPointer<cpp.Void>;

    /**
    \brief Size (in bytes) of the shared global filter data #filterShaderData.

    **Default:** 0

    @see PxSimulationFilterShader filterShaderData
    */
    var filterShaderDataSize:PxU32;

    /**
     * The custom filter shader to use for collision filtering.
     *
     * **Note:** This parameter is compulsory. If you don't want to define your own filter shader you can
     * use the default shader `PxDefaultSimulationFilterShader` which can be found in the PhysX extensions 
     * library.
     * 
     * To define your own filter shader, write a static function of the signature, and with tag `@:unreflective`, i.e. :
     * ```haxe
     * @:unreflective static function customFilterShader(
     *     attributes0:PxFilterObjectAttributes, filterData0:PxFilterData,
     *     attributes1:PxFilterObjectAttributes, filterData1:PxFilterData,
     *     pairFlags:cpp.Reference<PxPairFlags>, constantBlock:cpp.ConstStar<cpp.Void>, constantBlockSize:PxU32)
     *         : PxFilterFlags 
     * { 
     *     //... 
     * }
     * ```
     * and assign with `cpp.Callable.fromStaticFunction(customFilterShader)`.
     *
     * @see PxSimulationFilterShader
     */
    var filterShader:PxSimulationFilterShader;

    /**
    \brief A custom collision filter callback which can be used to implement more complex filtering operations which need
    access to the simulation state, for example.

    **Default:** NULL

    @see PxSimulationFilterCallback
    */
    var filterCallback:PxSimulationFilterCallback;

    /**
    \brief Filtering mode for kinematic-kinematic pairs in the broadphase.

    **Default:** PxPairFilteringMode::eDEFAULT

    @see PxPairFilteringMode
    */
    var kineKineFilteringMode:PxPairFilteringMode;

    /**
    \brief Filtering mode for static-kinematic pairs in the broadphase.

    **Default:** PxPairFilteringMode::eDEFAULT

    @see PxPairFilteringMode
    */
    var staticKineFilteringMode:PxPairFilteringMode;

    /**
    \brief Selects the broad-phase algorithm to use.

    **Default:** PxBroadPhaseType::eABP

    @see PxBroadPhaseType
    */
    var broadPhaseType:PxBroadPhaseType;

    /**
    \brief Broad-phase callback

    **Default:** NULL

    @see PxBroadPhaseCallback
    */
    var broadPhaseCallback:PxBroadPhaseCallback;

    /**
    \brief Expected scene limits.

    @see PxSceneLimits
    */
    var limits:PxSceneLimits;

    /**
    \brief Selects the friction algorithm to use for simulation.

    \note frictionType cannot be modified after the first call to any of PxScene::simulate, PxScene::solve and PxScene::collide

    @see PxFrictionType
    **Default:** PxFrictionType::ePATCH

    @see PxScene::setFrictionType, PxScene::getFrictionType
    */
    var frictionType:PxFrictionType;

    /**
    \brief Selects the solver algorithm to use.

    **Default:** PxSolverType::ePGS

    @see PxSolverType
    */
    var solverType:PxSolverType;

    /**
    \brief A contact with a relative velocity below this will not bounce. A typical value for simulation.
    stability is about 0.2 * gravity.

    **Range:** [0, PX_MAX_F32)  
    **Default:** 0.2 * PxTolerancesScale::speed

    @see PxMaterial
    */
    var bounceThresholdVelocity:PxReal; 

    /**
    \brief A threshold of contact separation distance used to decide if a contact point will experience friction forces.

    \note If the separation distance of a contact point is greater than the threshold then the contact point will not experience friction forces. 

    \note If the aggregated contact offset of a pair of shapes is large it might be desirable to neglect friction
    for contact points whose separation distance is sufficiently large that the shape surfaces are clearly separated. 
    
    \note This parameter can be used to tune the separation distance of contact points at which friction starts to have an effect.  

    **Range:** [0, PX_MAX_F32)  
    **Default:** 0.04 * PxTolerancesScale::length
    */
    var frictionOffsetThreshold:PxReal;

    /**
    \brief A threshold for speculative CCD. Used to control whether bias, restitution or a combination of the two are used to resolve the contacts.

    \note This only has any effect on contacting pairs where one of the bodies has PxRigidBodyFlag::eENABLE_SPECULATIVE_CCD raised.

    **Range:** [0, PX_MAX_F32)  
    **Default:** 0.04 * PxTolerancesScale::length
    */

    var ccdMaxSeparation:PxReal;

    /**
    \brief A slop value used to zero contact offsets from the body's COM on an axis if the offset along that axis is smaller than this threshold. Can be used to compensate
    for small numerical errors in contact generation.

    **Range:** [0, PX_MAX_F32)  
    **Default:** 0.0
    */

    var solverOffsetSlop:PxReal;

    /**
    \brief Flags used to select scene options.

    @see PxSceneFlag PxSceneFlags
    */
    var flags:PxSceneFlags;

    /**
    \brief The CPU task dispatcher for the scene.

    See PxCpuDispatcher, PxScene::getCpuDispatcher
    */
    var cpuDispatcher:PxCpuDispatcher;

    /**
    \brief The CUDA context manager for the scene.

    **Platform specific:** Applies to PC GPU only.

    See PxCudaContextManager, PxScene::getCudaContextManager
    */
    var cudaContextManager:PxCudaContextManager;

    /**
    \brief Defines the structure used to store static objects.

    \note Only PxPruningStructureType::eSTATIC_AABB_TREE and PxPruningStructureType::eDYNAMIC_AABB_TREE are allowed here.
    */
    var staticStructure:PxPruningStructureType;

    /**
    \brief Defines the structure used to store dynamic objects.
    */
    var dynamicStructure:PxPruningStructureType;

    /**
    \brief Hint for how much work should be done per simulation frame to rebuild the pruning structure.

    This parameter gives a hint on the distribution of the workload for rebuilding the dynamic AABB tree
    pruning structure #PxPruningStructureType::eDYNAMIC_AABB_TREE. It specifies the desired number of simulation frames
    the rebuild process should take. Higher values will decrease the workload per frame but the pruning
    structure will get more and more outdated the longer the rebuild takes (which can make
    scene queries less efficient).

    \note Only used for #PxPruningStructureType::eDYNAMIC_AABB_TREE pruning structure.

    \note This parameter gives only a hint. The rebuild process might still take more or less time depending on the
    number of objects involved.

    **Range:** [4, PX_MAX_U32)  
    **Default:** 100
    */
    var dynamicTreeRebuildRateHint:PxU32;

    /**
    \brief Defines the scene query update mode.
    **Default:** PxSceneQueryUpdateMode::eBUILD_ENABLED_COMMIT_ENABLED
    */
    var sceneQueryUpdateMode:PxSceneQueryUpdateMode;

    /**
    \brief Will be copied to PxScene::userData.

    **Default:** NULL
    */
    var userData:physx.hx.PxUserData;

    /**
    \brief Defines the number of actors required to spawn a separate rigid body solver island task chain.

    This parameter defines the minimum number of actors required to spawn a separate rigid body solver task chain. Setting a low value 
    will potentially cause more task chains to be generated. This may result in the overhead of spawning tasks can become a limiting performance factor. 
    Setting a high value will potentially cause fewer islands to be generated. This may reduce thread scaling (fewer task chains spawned) and may 
    detrimentally affect performance if some bodies in the scene have large solver iteration counts because all constraints in a given island are solved by the 
    maximum number of solver iterations requested by any body in the island.

    Note that a rigid body solver task chain is spawned as soon as either a sufficient number of rigid bodies or articulations are batched together.

    **Default:** 128

    @see PxScene.setSolverBatchSize() PxScene.getSolverBatchSize()
    */
    var solverBatchSize:PxU32;

    /**
    \brief Defines the number of articulations required to spawn a separate rigid body solver island task chain.

    This parameter defines the minimum number of articulations required to spawn a separate rigid body solver task chain. Setting a low value
    will potentially cause more task chains to be generated. This may result in the overhead of spawning tasks can become a limiting performance factor.
    Setting a high value will potentially cause fewer islands to be generated. This may reduce thread scaling (fewer task chains spawned) and may
    detrimentally affect performance if some bodies in the scene have large solver iteration counts because all constraints in a given island are solved by the
    maximum number of solver iterations requested by any body in the island.

    Note that a rigid body solver task chain is spawned as soon as either a sufficient number of rigid bodies or articulations are batched together. 

    **Default:** 128

    @see PxScene.setSolverArticulationBatchSize() PxScene.getSolverArticulationBatchSize()
    */
    var solverArticulationBatchSize:PxU32;

    /**
    \brief Setting to define the number of 16K blocks that will be initially reserved to store contact, friction, and contact cache data.
    This is the number of 16K memory blocks that will be automatically allocated from the user allocator when the scene is instantiated. Further 16k
    memory blocks may be allocated during the simulation up to maxNbContactDataBlocks.

    \note This value cannot be larger than maxNbContactDataBlocks because that defines the maximum number of 16k blocks that can be allocated by the SDK.

    **Default:** 0

    **Range:** [0, PX_MAX_U32]  

    @see PxPhysics::createScene PxScene::setNbContactDataBlocks 
    */
    var nbContactDataBlocks:PxU32;

    /**
    \brief Setting to define the maximum number of 16K blocks that can be allocated to store contact, friction, and contact cache data.
    As the complexity of a scene increases, the SDK may require to allocate new 16k blocks in addition to the blocks it has already 
    allocated. This variable controls the maximum number of blocks that the SDK can allocate.

    In the case that the scene is sufficiently complex that all the permitted 16K blocks are used, contacts will be dropped and 
    a warning passed to the error stream.

    If a warning is reported to the error stream to indicate the number of 16K blocks is insufficient for the scene complexity 
    then the choices are either (i) re-tune the number of 16K data blocks until a number is found that is sufficient for the scene complexity,
    (ii) to simplify the scene or (iii) to opt to not increase the memory requirements of physx and accept some dropped contacts.
    
    **Default:** 65536

    **Range:** [0, PX_MAX_U32]  

    @see nbContactDataBlocks PxScene::setNbContactDataBlocks 
    */
    var maxNbContactDataBlocks:PxU32;

    /**
    \brief The maximum bias coefficient used in the constraint solver

    When geometric errors are found in the constraint solver, either as a result of shapes penetrating
    or joints becoming separated or violating limits, a bias is introduced in the solver position iterations
    to correct these errors. This bias is proportional to 1/dt, meaning that the bias becomes increasingly 
    strong as the time-step passed to PxScene::simulate(...) becomes smaller. This coefficient allows the
    application to restrict how large the bias coefficient is, to reduce how violent error corrections are.
    This can improve simulation quality in cases where either variable time-steps or extremely small time-steps
    are used.
    
    **Default:** PX_MAX_F32

    ** Range** [0, PX_MAX_F32]   

    */
    var maxBiasCoefficient:PxReal;

    /**
    \brief Size of the contact report stream (in bytes).
    
    The contact report stream buffer is used during the simulation to store all the contact reports. 
    If the size is not sufficient, the buffer will grow by a factor of two.
    It is possible to disable the buffer growth by setting the flag PxSceneFlag::eDISABLE_CONTACT_REPORT_BUFFER_RESIZE.
    In that case the buffer will not grow but contact reports not stored in the buffer will not get sent in the contact report callbacks.

    **Default:** 8192

    **Range:** (0, PX_MAX_U32]  
    
    */
    var contactReportStreamBufferSize:PxU32;

    /**
    \brief Maximum number of CCD passes 

    The CCD performs multiple passes, where each pass every object advances to its time of first impact. This value defines how many passes the CCD system should perform.
    
    \note The CCD system is a multi-pass best-effort conservative advancement approach. After the defined number of passes has been completed, any remaining time is dropped.
    \note This defines the maximum number of passes the CCD can perform. It may perform fewer if additional passes are not necessary.

    **Default:** 1
    **Range:** [1, PX_MAX_U32]  
    */
    var ccdMaxPasses:PxU32;

    /**
    \brief CCD threshold

    CCD performs sweeps against shapes if and only if the relative motion of the shapes is fast-enough that a collision would be missed
    by the discrete contact generation. However, in some circumstances, e.g. when the environment is constructed from large convex shapes, this 
    approach may produce undesired simulation artefacts. This parameter defines the minimum relative motion that would be required to force CCD between shapes.
    The smaller of this value and the sum of the thresholds calculated for the shapes involved will be used.

    \note It is not advisable to set this to a very small value as this may lead to CCD "jamming" and detrimentally effect performance. This value should be at least larger than the translation caused by a single frame's gravitational effect

    **Default:** PX_MAX_F32
    **Range:** [Eps, PX_MAX_F32]  
    */

    var ccdThreshold:PxReal;

    /**
    \brief The wake counter reset value

    Calling wakeUp() on objects which support sleeping will set their wake counter value to the specified reset value.

    **Range:** (0, PX_MAX_F32)  
    **Default:** 0.4 (which corresponds to 20 frames for a time step of 0.02)

    @see PxRigidDynamic::wakeUp() PxArticulationBase::wakeUp()
    */
    var wakeCounterResetValue:PxReal;

    /**
    \brief The bounds used to sanity check user-set positions of actors and articulation links

    These bounds are used to check the position values of rigid actors inserted into the scene, and positions set for rigid actors
    already within the scene.

    **Range:** any valid PxBounds3    
    **Default:** (-PX_MAX_BOUNDS_EXTENTS, PX_MAX_BOUNDS_EXTENTS) on each axis
    */
    var sanityBounds:PxBounds3;

    /**
    \brief The pre-allocations performed in the GPU dynamics pipeline.
    */
    var gpuDynamicsConfig:PxgDynamicsMemoryConfig;

    /**
    \brief Limitation for the partitions in the GPU dynamics pipeline.
    This variable must be power of 2.
    A value greater than 32 is currently not supported.
    **Range:** (1, 32)  
    */
    var gpuMaxNumPartitions:PxU32;

    /**
    \brief Defines which compute version the GPU dynamics should target. DO NOT MODIFY
    */
    var gpuComputeVersion:PxU32;
    
    /**
    \brief constructor sets to default.

    \param[in] scale scale values for the tolerances in the scene, these must be the same values passed into
    PxCreatePhysics(). The affected tolerances are bounceThresholdVelocity and frictionOffsetThreshold.

    @see PxCreatePhysics() PxTolerancesScale bounceThresholdVelocity frictionOffsetThreshold
    */	
    @:native("physx::PxSceneDesc") static function create(scale:PxTolerancesScale):PxSceneDesc;
}