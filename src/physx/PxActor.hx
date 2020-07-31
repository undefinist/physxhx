package physx;

import physx.foundation.PxBase;
import physx.foundation.PxBounds3;
import physx.foundation.PxSimpleTypes;
import physx.PxClient;
import physx.PxActor;

typedef PxDominanceGroup = PxU8;

/**
Flags which control the behavior of an actor.

@see PxActorFlags PxActor PxActor.setActorFlag() PxActor.getActorFlags()
*/
@:build(physx.hx.PxEnumBuilder.buildFlags("physx::PxActorFlag", PxU8))
extern enum abstract PxActorFlag(PxActorFlagImpl)
{
    /**
    Enable debug renderer for this actor

    @see PxScene.getRenderBuffer() PxRenderBuffer PxVisualizationParameter
    */
    var eVISUALIZATION = (1<<0);

    /**
    Disables scene gravity for this actor
    */
    var eDISABLE_GRAVITY = (1<<1);

    /**
    Enables the sending of PxSimulationEventCallback::onWake() and PxSimulationEventCallback::onSleep() notify events

    @see PxSimulationEventCallback::onWake() PxSimulationEventCallback::onSleep()
    */
    var eSEND_SLEEP_NOTIFIES = (1<<2);

    /**
    Disables simulation for the actor.
    
    This is only supported by PxRigidStatic and PxRigidDynamic actors and can be used to reduce the memory footprint when rigid actors are
    used for scene queries only.

    Setting this flag will remove all constraints attached to the actor from the scene.

    If this flag is set, the following calls are forbidden:  
    PxRigidBody: setLinearVelocity(), setAngularVelocity(), addForce(), addTorque(), clearForce(), clearTorque()  
    PxRigidDynamic: setKinematicTarget(), setWakeCounter(), wakeUp(), putToSleep()

    @param Sleeping
    Raising this flag will set all velocities and the wake counter to 0, clear all forces, clear the kinematic target, put the actor
    to sleep and wake up all touching actors from the previous frame.
    */
    var eDISABLE_SIMULATION = (1<<3);
}

@:include("PxActor.h")
@:native("physx::PxActorFlags")
private extern class PxActorFlagImpl {}

/**
collection of set bits defined in PxActorFlag.

@see PxActorFlag
*/
extern abstract PxActorFlags(PxActorFlag) from PxActorFlag to PxActorFlag {}

/**
Identifies each type of actor.
@see PxActor 
*/
@:build(physx.hx.PxEnumBuilder.build("physx::PxActorType"))
extern enum abstract PxActorType(PxActorTypeImpl)
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
    An articulation link
    @see PxArticulationLink
    */
    var eARTICULATION_LINK;

    // /**
    // internal use only!
    // */
    // var eACTOR_COUNT;

    // var eACTOR_FORCE_DWORD = 0x7fffffff;
}

@:include("PxActor.h")
@:native("physx::PxActorType::Enum")
private extern class PxActorTypeImpl {}

/**
\brief PxActor is the base class for the main simulation objects in the physics SDK.

The actor is owned by and contained in a PxScene.

*/
@:keep @:structAccess
@:include("PxActor.h")
@:native("::cpp::Reference<physx::PxActor>")
extern class PxActor extends PxBase
{
	/**
	Deletes the actor.
	
	Do not keep a reference to the deleted instance.

	If the actor belongs to a #PxAggregate object, it is automatically removed from the aggregate.

	@see PxBase.release(), PxAggregate
	*/
	function release():Void;

	/**
	\brief Retrieves the type of actor.

	\return The actor type of the actor.

	@see PxActorType
	*/
	function getType():PxActorType;

	/**
	\brief Retrieves the scene which this actor belongs to.

	\return Owner Scene. NULL if not part of a scene.

	@see PxScene
	*/
	function getScene():PxScene;

	// Runtime modifications

	/**
	\brief Sets a name string for the object that can be retrieved with getName().
	
	This is for debugging and is not used by the SDK. The string is not copied by the SDK, 
	only the pointer is stored.

	\param[in] name String to set the objects name to.

	<b>Default:</b> NULL

	@see getName()
	*/
	function setName(name:cpp.ConstCharStar):Void;

	/**
	\brief Retrieves the name string set with setName().

	\return Name string associated with object.

	@see setName()
	*/
	function getName():cpp.ConstCharStar;

	/**
	\brief Retrieves the axis aligned bounding box enclosing the actor.

	\param[in] inflation  Scale factor for computed world bounds. Box extents are multiplied by this value.

	\return The actor's bounding box.

	@see PxBounds3
	*/
	function getWorldBounds(inflation:Float):PxBounds3;

	/**
	\brief Raises or clears a particular actor flag.
	
	See the list of flags #PxActorFlag

	<b>Sleeping:</b> Does <b>NOT</b> wake the actor up automatically.

	\param[in] flag  The PxActor flag to raise(set) or clear. See #PxActorFlag.
	\param[in] value The boolean value to assign to the flag.

	<b>Default:</b> PxActorFlag::eVISUALIZATION

	@see PxActorFlag getActorFlags() 
	*/
	function setActorFlag(flag:PxActorFlag, value:Bool):Void;
	/**
	\brief sets the actor flags
	
	See the list of flags #PxActorFlag
	@see PxActorFlag setActorFlag() 
	*/
	function setActorFlags(inFlags:PxActorFlags):Void;

	/**
	\brief Reads the PxActor flags.
	
	See the list of flags #PxActorFlag

	\return The values of the PxActor flags.

	@see PxActorFlag setActorFlag() 
	*/
	function getActorFlags():PxActorFlags;

	/**
	\brief Assigns dynamic actors a dominance group identifier.
	
	PxDominanceGroup is a 5 bit group identifier (legal range from 0 to 31).
	
	The PxScene::setDominanceGroupPair() lets you set certain behaviors for pairs of dominance groups.
	By default every dynamic actor is created in group 0.

	<b>Default:</b> 0

	<b>Sleeping:</b> Changing the dominance group does <b>NOT</b> wake the actor up automatically.

	\param[in] dominanceGroup The dominance group identifier. <b>Range:</b> [0..31]

	@see getDominanceGroup() PxDominanceGroup PxScene::setDominanceGroupPair()
	*/
	function setDominanceGroup(dominanceGroup:PxDominanceGroup):Void;
	
	/**
	\brief Retrieves the value set with setDominanceGroup().

	\return The dominance group of this actor.

	@see setDominanceGroup() PxDominanceGroup PxScene::setDominanceGroupPair()
	*/
    function getDominanceGroup():PxDominanceGroup;

	
	/**
	\brief Sets the owner client of an actor.

	This cannot be done once the actor has been placed into a scene.

	<b>Default:</b> PX_DEFAULT_CLIENT

	@see PxClientID PxScene::createClient() 
	*/
	function setOwnerClient(inClient:PxClientID):Void;

	/**
	\brief Returns the owner client that was specified with at creation time.

	This value cannot be changed once the object is placed into the scene.

	@see PxClientID PxScene::createClient()
	*/
	function getOwnerClient():PxClientID;

	/**
	\brief Retrieves the aggregate the actor might be a part of.

	\return The aggregate the actor is a part of, or NULL if the actor does not belong to an aggregate.

	@see PxAggregate
	*/
	function	getAggregate():PxAggregate;

	/**
	 * User can assign this to whatever, usually to create a 1:1 relationship with a user object.
	 */
	var userData:physx.hx.PxUserData;
}