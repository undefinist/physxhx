package physx;

import physx.foundation.PxTransform;
import physx.foundation.PxSimpleTypes;

/**
\brief Collection of flags providing a mechanism to lock motion along/around a specific axis.

@see PxRigidDynamic.setRigidDynamicLockFlag(), PxRigidBody.getRigidDynamicLockFlags()
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxRigidDynamicLockFlag", PxU8))
extern enum abstract PxRigidDynamicLockFlag(PxRigidDynamicLockFlagImpl)
{
    var eLOCK_LINEAR_X = (1 << 0);
    var eLOCK_LINEAR_Y = (1 << 1);
    var eLOCK_LINEAR_Z = (1 << 2);
    var eLOCK_ANGULAR_X = (1 << 3);
    var eLOCK_ANGULAR_Y = (1 << 4);
	var eLOCK_ANGULAR_Z = (1 << 5);
}

@:include("PxRigidDynamic.h")
@:native("physx::PxRigidDynamicLockFlags")
private extern class PxRigidDynamicLockFlagImpl {}

extern abstract PxRigidDynamicLockFlags(PxRigidDynamicLockFlag) from PxRigidDynamicLockFlag to PxRigidDynamicLockFlag {}


/**
\brief PxRigidDynamic represents a dynamic rigid simulation object in the physics SDK.

<h3>Creation</h3>
Instances of this class are created by calling #PxPhysics::createRigidDynamic() and deleted with #release().


<h3>Visualizations</h3>
\li #PxVisualizationParameter::eACTOR_AXES
\li #PxVisualizationParameter::eBODY_AXES
\li #PxVisualizationParameter::eBODY_MASS_AXES
\li #PxVisualizationParameter::eBODY_LIN_VELOCITY
\li #PxVisualizationParameter::eBODY_ANG_VELOCITY

@see PxRigidBody  PxPhysics.createRigidDynamic()  release()
*/
@:include("PxRigidDynamic.h")
@:native("::cpp::Reference<physx::PxRigidDynamic>")
extern class PxRigidDynamic extends PxRigidBody
{
	// Runtime modifications


/************************************************************************************************/
/** @name Kinematic Actors
*/

	/**
	\brief Moves kinematically controlled dynamic actors through the game world.

	You set a dynamic actor to be kinematic using the PxRigidBodyFlag::eKINEMATIC flag
	with setRigidBodyFlag().
	
	The move command will result in a velocity that will move the body into 
	the desired pose. After the move is carried out during a single time step, 
	the velocity is returned to zero. Thus, you must continuously call 
	this in every time step for kinematic actors so that they move along a path.
	
	This function simply stores the move destination until the next simulation
	step is processed, so consecutive calls will simply overwrite the stored target variable.

	The motion is always fully carried out.	

	\note It is invalid to use this method if the actor has not been added to a scene already or if PxActorFlag::eDISABLE_SIMULATION is set.

	<b>Sleeping:</b> This call wakes the actor if it is sleeping and will set the wake counter to #PxSceneDesc::wakeCounterResetValue.

	\param[in] destination The desired pose for the kinematic actor, in the global frame. <b>Range:</b> rigid body transform.

	@see getKinematicTarget() PxRigidBodyFlag setRigidBodyFlag()
	*/
	function setKinematicTarget(destination:PxTransform):Void;

	/**
	\brief Get target pose of a kinematically controlled dynamic actor.

	\param[out] target Transform to write the target pose to. Only valid if the method returns true.
	\return True if the actor is a kinematically controlled dynamic and the target has been set, else False.

	@see setKinematicTarget() PxRigidBodyFlag setRigidBodyFlag()
	*/
	function getKinematicTarget(target:PxTransform):Bool;


/************************************************************************************************/
/** @name Sleeping
*/

	/**
	\brief Returns true if this body is sleeping.

	When an actor does not move for a period of time, it is no longer simulated in order to save time. This state
	is called sleeping. However, because the object automatically wakes up when it is either touched by an awake object,
	or one of its properties is changed by the user, the entire sleep mechanism should be transparent to the user.

	In general, a dynamic rigid actor is guaranteed to be awake if at least one of the following holds:

	\li The wake counter is positive (see #setWakeCounter()).
	\li The linear or angular velocity is non-zero.
	\li A non-zero force or torque has been applied.

	If a dynamic rigid actor is sleeping, the following state is guaranteed:

	\li The wake counter is zero.
	\li The linear and angular velocity is zero.
	\li There is no force update pending.

	When an actor gets inserted into a scene, it will be considered asleep if all the points above hold, else it will be treated as awake.
	
	If an actor is asleep after the call to PxScene::fetchResults() returns, it is guaranteed that the pose of the actor 
	was not changed. You can use this information to avoid updating the transforms of associated objects.

	\note A kinematic actor is asleep unless a target pose has been set (in which case it will stay awake until the end of the next 
	simulation step where no target pose has been set anymore). The wake counter will get set to zero or to the reset value 
	#PxSceneDesc::wakeCounterResetValue in the case where a target pose has been set to be consistent with the definitions above.

	\note It is invalid to use this method if the actor has not been added to a scene already.

	\return True if the actor is sleeping.

	@see isSleeping() wakeUp() putToSleep()  getSleepThreshold()
	*/
	function isSleeping():Bool;


    /**
	\brief Sets the mass-normalized kinetic energy threshold below which an actor may go to sleep.

	Actors whose kinetic energy divided by their mass is below this threshold will be candidates for sleeping.

	<b>Default:</b> 5e-5f * PxTolerancesScale::speed * PxTolerancesScale::speed

	\param[in] threshold Energy below which an actor may go to sleep. <b>Range:</b> [0, PX_MAX_F32)

	@see isSleeping() getSleepThreshold() wakeUp() putToSleep() PxTolerancesScale
	*/
	function setSleepThreshold(threshold:PxReal):Void;

	/**
	\brief Returns the mass-normalized kinetic energy below which an actor may go to sleep.

	\return The energy threshold for sleeping.

	@see isSleeping() wakeUp() putToSleep() setSleepThreshold()
	*/
	function getSleepThreshold():PxReal;

	 /**
	\brief Sets the mass-normalized kinetic energy threshold below which an actor may participate in stabilization.

	Actors whose kinetic energy divided by their mass is above this threshold will not participate in stabilization.

	This value has no effect if PxSceneFlag::eENABLE_STABILIZATION was not enabled on the PxSceneDesc.

	<b>Default:</b> 1e-5f * PxTolerancesScale::speed * PxTolerancesScale::speed

	\param[in] threshold Energy below which an actor may participate in stabilization. <b>Range:</b> [0,inf)

	@see  getStabilizationThreshold() PxSceneFlag::eENABLE_STABILIZATION
	*/
	function setStabilizationThreshold(threshold:PxReal):Void;

	/**
	\brief Returns the mass-normalized kinetic energy below which an actor may participate in stabilization.

	Actors whose kinetic energy divided by their mass is above this threshold will not participate in stabilization. 

	\return The energy threshold for participating in stabilization.

	@see setStabilizationThreshold() PxSceneFlag::eENABLE_STABILIZATION
	*/
	function getStabilizationThreshold():PxReal;


	/**
	\brief Reads the PxRigidDynamic lock flags.

	See the list of flags #PxRigidDynamicLockFlag

	\return The values of the PxRigidDynamicLock flags.

	@see PxRigidDynamicLockFlag setRigidDynamicLockFlag()
	*/
	function getRigidDynamicLockFlags():PxRigidDynamicLockFlags;

	/**
	\brief Raises or clears a particular rigid dynamic lock flag.

	See the list of flags #PxRigidDynamicLockFlag

	<b>Default:</b> no flags are set


	\param[in] flag		The PxRigidDynamicLockBody flag to raise(set) or clear. See #PxRigidBodyFlag.
	\param[in] value	The new boolean value for the flag.

	@see PxRigidDynamicLockFlag getRigidDynamicLockFlags()
	*/
	function setRigidDynamicLockFlag(flag:PxRigidDynamicLockFlag, value:Bool):Void;
	function setRigidDynamicLockFlags(flags:PxRigidDynamicLockFlags):Void;
	


	/**
	\brief Sets the wake counter for the actor.

	The wake counter value determines the minimum amount of time until the body can be put to sleep. Please note
	that a body will not be put to sleep if the energy is above the specified threshold (see #setSleepThreshold())
	or if other awake bodies are touching it.

	\note Passing in a positive value will wake the actor up automatically.

	\note It is invalid to use this method for kinematic actors since the wake counter for kinematics is defined
	based on whether a target pose has been set (see the comment in #isSleeping()).

	\note It is invalid to use this method if PxActorFlag::eDISABLE_SIMULATION is set.

	<b>Default:</b> 0.4 (which corresponds to 20 frames for a time step of 0.02)

	\param[in] wakeCounterValue Wake counter value. <b>Range:</b> [0, PX_MAX_F32)

	@see isSleeping() getWakeCounter()
	*/
	function setWakeCounter(wakeCounterValue:PxReal):Void;

	/**
	\brief Returns the wake counter of the actor.

	\return The wake counter of the actor.

	@see isSleeping() setWakeCounter()
	*/
	function getWakeCounter():PxReal;

	/**
	\brief Wakes up the actor if it is sleeping.

	The actor will get woken up and might cause other touching actors to wake up as well during the next simulation step.

	\note This will set the wake counter of the actor to the value specified in #PxSceneDesc::wakeCounterResetValue.

	\note It is invalid to use this method if the actor has not been added to a scene already or if PxActorFlag::eDISABLE_SIMULATION is set.

	\note It is invalid to use this method for kinematic actors since the sleep state for kinematics is defined
	based on whether a target pose has been set (see the comment in #isSleeping()).

	@see isSleeping() putToSleep()
	*/
	function wakeUp():Void;

	/**
	\brief Forces the actor to sleep. 
	
	The actor will stay asleep during the next simulation step if not touched by another non-sleeping actor.
	
	\note Any applied force will be cleared and the velocity and the wake counter of the actor will be set to 0.

	\note It is invalid to use this method if the actor has not been added to a scene already or if PxActorFlag::eDISABLE_SIMULATION is set.

	\note It is invalid to use this method for kinematic actors since the sleep state for kinematics is defined
	based on whether a target pose has been set (see the comment in #isSleeping()).

	@see isSleeping() wakeUp()
	*/
	function putToSleep():Void;

/************************************************************************************************/

    /**
	\brief Sets the solver iteration counts for the body. 
	
	The solver iteration count determines how accurately joints and contacts are resolved. 
	If you are having trouble with jointed bodies oscillating and behaving erratically, then
	setting a higher position iteration count may improve their stability.

	If intersecting bodies are being depenetrated too violently, increase the number of velocity 
	iterations. More velocity iterations will drive the relative exit velocity of the intersecting 
	objects closer to the correct value given the restitution.

	<b>Default:</b> 4 position iterations, 1 velocity iteration

	\param[in] minPositionIters Number of position iterations the solver should perform for this body. <b>Range:</b> [1,255]
	\param[in] minVelocityIters Number of velocity iterations the solver should perform for this body. <b>Range:</b> [1,255]

	@see getSolverIterationCounts()
	*/
	function setSolverIterationCounts(minPositionIters:PxU32, minVelocityIters:PxU32 = 1):Void;
    
    @:native("getSolverIterationCounts") private function _getSolverIterationCounts(minPositionIters:cpp.Reference<PxU32>, minVelocityIters:cpp.Reference<PxU32>):Void;
	/**
	\brief Retrieves the solver iteration counts.

	@see setSolverIterationCounts()
    */
    inline function getSolverIterationCounts():{minPositionIters:PxU32, minVelocityIters:PxU32}
    {
        var minPositionIters:PxU32 = 0, minVelocityIters:PxU32 = 0;
        _getSolverIterationCounts(minPositionIters, minVelocityIters);
        return { minPositionIters: minPositionIters, minVelocityIters: minVelocityIters };
    }

	/**
	\brief Retrieves the force threshold for contact reports.

	The contact report threshold is a force threshold. If the force between 
	two actors exceeds this threshold for either of the two actors, a contact report 
	will be generated according to the contact report threshold flags provided by
	the filter shader/callback.
	See #PxPairFlag.

	The threshold used for a collision between a dynamic actor and the static environment is 
    the threshold of the dynamic actor, and all contacts with static actors are summed to find 
    the total normal force.

	<b>Default:</b> PX_MAX_F32

	\return Force threshold for contact reports.

	@see setContactReportThreshold PxPairFlag PxSimulationFilterShader PxSimulationFilterCallback
	*/
	function getContactReportThreshold():PxReal;

	/**
	\brief Sets the force threshold for contact reports.

	See #getContactReportThreshold().

	\param[in] threshold Force threshold for contact reports. <b>Range:</b> [0, PX_MAX_F32)

	@see getContactReportThreshold PxPairFlag
	*/
	function setContactReportThreshold(threshold:PxReal):Void;
}