package physx;

import physx.PxRigidBody;
import physx.PxConstraint;
import physx.PxFiltering;
import physx.foundation.PxTransform;
import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;


/**
\brief Extra data item types for contact pairs.

@see PxContactPairExtraDataItem.type
*/
extern enum abstract PxContactPairExtraDataType(PxContactPairExtraDataTypeImpl)
{
    @:native("physx::PxContactPairExtraDataType::ePRE_SOLVER_VELOCITY") var ePRE_SOLVER_VELOCITY;	//!< see #PxContactPairVelocity
    @:native("physx::PxContactPairExtraDataType::ePOST_SOLVER_VELOCITY") var ePOST_SOLVER_VELOCITY;	//!< see #PxContactPairVelocity
    @:native("physx::PxContactPairExtraDataType::eCONTACT_EVENT_POSE") var eCONTACT_EVENT_POSE;	//!< see #PxContactPairPose
    @:native("physx::PxContactPairExtraDataType::eCONTACT_PAIR_INDEX") var eCONTACT_PAIR_INDEX;  	//!< see #PxContactPairIndex
}

@:include("PxSimulationEventCallback.h")
@:native("physx::PxContactPairExtraDataType::Enum")
private extern class PxContactPairExtraDataTypeImpl {}


/**
\brief Base class for items in the extra data stream of contact pairs

@see PxContactPairHeader.extraDataStream
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairExtraDataItem>")
extern class PxContactPairExtraDataItem
{
    /**
    \brief The type of the extra data stream item
    */
    var type:PxContactPairExtraDataType;
}


/**
\brief Velocities of the contact pair rigid bodies

This struct is shared by multiple types of extra data items. The #type field allows to distinguish between them:
\li PxContactPairExtraDataType::ePRE_SOLVER_VELOCITY: see #PxPairFlag::ePRE_SOLVER_VELOCITY
\li PxContactPairExtraDataType::ePOST_SOLVER_VELOCITY: see #PxPairFlag::ePOST_SOLVER_VELOCITY

\note For static rigid bodies, the velocities will be set to zero.

@see PxContactPairHeader.extraDataStream
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairVelocity>")
extern class PxContactPairVelocity extends PxContactPairExtraDataItem
{
    /**
    \brief The linear velocity of the rigid body 0
    */
    @:native("linearVelocity[0]") var linearVelocity0:PxVec3;
    
    /**
    \brief The linear velocity of the rigid body 1
    */
    @:native("linearVelocity[1]") var linearVelocity1:PxVec3;
    
    /**
    \brief The angular velocity of the rigid body 0
    */
    @:native("angularVelocity[0]") var angularVelocity0:PxVec3;
    
    /**
    \brief The angular velocity of the rigid body 1
    */
    @:native("angularVelocity[1]") var angularVelocity1:PxVec3;
}


/**
\brief World space actor poses of the contact pair rigid bodies

@see PxContactPairHeader.extraDataStream PxPairFlag::eCONTACT_EVENT_POSE
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairPose>")
extern class PxContactPairPose extends PxContactPairExtraDataItem
{
    /**
    \brief The world space pose of the rigid body 0
    */
    @:native("globalPose[0]") var globalPose0:PxTransform;
    
    /**
    \brief The world space pose of the rigid body 1
    */
    @:native("globalPose[1]") var globalPose1:PxTransform;
}


/**
\brief Marker for the beginning of a new item set in the extra data stream.

If CCD with multiple passes is enabled, then a fast moving object might bounce on and off the same
object multiple times. Also, different shapes of the same actor might gain and lose contact with an other
object over multiple passes. This marker allows to seperate the extra data items for each collision case, as well as
distinguish the shape pair reports of different CCD passes.

Example:
Let us assume that an actor a0 with shapes s0_0 and s0_1 hits another actor a1 with shape s1.
First s0_0 will hit s1, then a0 will slightly rotate and s0_1 will hit s1 while s0_0 will lose contact with s1.
Furthermore, let us say that contact event pose information is requested as extra data.
The extra data stream will look like this:

PxContactPairIndexA | PxContactPairPoseA | PxContactPairIndexB | PxContactPairPoseB

The corresponding array of PxContactPair events (see #PxSimulationEventCallback.onContact()) will look like this:

PxContactPair(touch_found: s0_0, s1) | PxContactPair(touch_lost: s0_0, s1) | PxContactPair(touch_found: s0_1, s1)
 
The #index of PxContactPairIndexA will point to the first entry in the PxContactPair array, for PxContactPairIndexB,
#index will point to the third entry.

@see PxContactPairHeader.extraDataStream
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairIndex>")
extern class PxContactPairIndex extends PxContactPairExtraDataItem
{
    /**
    \brief The next item set in the extra data stream refers to the contact pairs starting at #index in the reported PxContactPair array.
    */
    var index:PxU16;
}


/**
\brief A class to iterate over a contact pair extra data stream.

@see PxContactPairHeader.extraDataStream
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairExtraDataIterator>")
extern class PxContactPairExtraDataIterator
{
}


/**
\brief Collection of flags providing information on contact report pairs.

@see PxContactPairHeader
*/
extern enum abstract PxContactPairHeaderFlag(PxContactPairHeaderFlagImpl)
{
    @:native("physx::PxContactPairHeaderFlag::eREMOVED_ACTOR_0") var eREMOVED_ACTOR_0;			//!< The actor with index 0 has been removed from the scene.
    @:native("physx::PxContactPairHeaderFlag::eREMOVED_ACTOR_1") var eREMOVED_ACTOR_1;			//!< The actor with index 1 has been removed from the scene.

    @:op(A | B)
    private inline function or(flag:PxContactPairHeaderFlag):PxContactPairHeaderFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxSimulationEventCallback.h")
@:native("physx::PxContactPairHeaderFlags")
private extern class PxContactPairHeaderFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxContactPairHeaderFlag.

@see PxContactPairHeaderFlag
*/
extern abstract PxContactPairHeaderFlags(PxContactPairHeaderFlag) from PxContactPairHeaderFlag to PxContactPairHeaderFlag {}


/**
\brief An Instance of this class is passed to PxSimulationEventCallback.onContact().

@see PxSimulationEventCallback.onContact()
*/
@:include("PxSimulationEventCallback.h")
@:native("::cpp::Struct<physx::PxContactPairHeader>")
extern class PxContactPairHeader
{
    /**
    \brief The first actor of the notification shape pairs.

    \note The actor pointers might reference deleted actors. This will be the case if PxPairFlag::eNOTIFY_TOUCH_LOST
          or PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST events were requested for the pair and one of the involved actors 
          gets deleted or removed from the scene. Check the #flags member to see whether that is the case.
          Do not dereference a pointer to a deleted actor. The pointer to a deleted actor is only provided 
          such that user data structures which might depend on the pointer value can be updated.

    @see PxActor
    */
    @:native("actors[0]") var actor0:PxRigidActor;
    
    /**
    \brief The second actor of the notification shape pairs.

    \note The actor pointers might reference deleted actors. This will be the case if PxPairFlag::eNOTIFY_TOUCH_LOST
          or PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST events were requested for the pair and one of the involved actors 
          gets deleted or removed from the scene. Check the #flags member to see whether that is the case.
          Do not dereference a pointer to a deleted actor. The pointer to a deleted actor is only provided 
          such that user data structures which might depend on the pointer value can be updated.

    @see PxActor
    */
    @:native("actors[1]") var actor1:PxRigidActor;

    /**
    \brief Stream containing extra data as requested in the PxPairFlag flags of the simulation filter.

    This pointer is only valid if any kind of extra data information has been requested for the contact report pair (see #PxPairFlag::ePOST_SOLVER_VELOCITY etc.),
    else it will be NULL.
    
    @see PxPairFlag
    */
    var extraDataStream:cpp.ConstPointer<PxU8>;
    
    /**
    \brief Size of the extra data stream [bytes] 
    */
    var extraDataStreamSize:PxU16;

    /**
    \brief Additional information on the contact report pair.

    @see PxContactPairHeaderFlag
    */
    var flags:PxContactPairHeaderFlags;

    /**
    \brief pointer to the contact pairs
    */
    var pairs:cpp.ConstPointer<PxContactPair>;

    /**
    \brief number of contact pairs
    */
    var nbPairs:PxU32;
}


/**
\brief Collection of flags providing information on contact report pairs.

@see PxContactPair
*/
extern enum abstract PxContactPairFlag(PxContactPairFlagImpl)
{
    /**
    \brief The shape with index 0 has been removed from the actor/scene.
    */
    @:native("physx::PxContactPairFlag::eREMOVED_SHAPE_0") var eREMOVED_SHAPE_0;

    /**
    \brief The shape with index 1 has been removed from the actor/scene.
    */
    @:native("physx::PxContactPairFlag::eREMOVED_SHAPE_1") var eREMOVED_SHAPE_1;

    /**
    \brief First actor pair contact.

    The provided shape pair marks the first contact between the two actors, no other shape pair has been touching prior to the current simulation frame.

    \note: This info is only available if #PxPairFlag::eNOTIFY_TOUCH_FOUND has been declared for the pair.
    */
    @:native("physx::PxContactPairFlag::eACTOR_PAIR_HAS_FIRST_TOUCH") var eACTOR_PAIR_HAS_FIRST_TOUCH;

    /**
    \brief All contact between the actor pair was lost.

    All contact between the two actors has been lost, no shape pairs remain touching after the current simulation frame.
    */
    @:native("physx::PxContactPairFlag::eACTOR_PAIR_LOST_TOUCH") var eACTOR_PAIR_LOST_TOUCH;

    /**
    \brief Internal flag, used by #PxContactPair.extractContacts()

    The applied contact impulses are provided for every contact point. 
    This is the case if #PxPairFlag::eSOLVE_CONTACT has been set for the pair.
    */
    @:native("physx::PxContactPairFlag::eINTERNAL_HAS_IMPULSES") var eINTERNAL_HAS_IMPULSES;

    /**
    \brief Internal flag, used by #PxContactPair.extractContacts()

    The provided contact point information is flipped with regards to the shapes of the contact pair. This mainly concerns the order of the internal triangle indices.
    */
    @:native("physx::PxContactPairFlag::eINTERNAL_CONTACTS_ARE_FLIPPED") var eINTERNAL_CONTACTS_ARE_FLIPPED;
    
    @:op(A | B)
    private inline function or(flag:PxContactPairFlag):PxContactPairFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxSimulationEventCallback.h")
@:native("physx::PxContactPairFlags")
private extern class PxContactPairFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxContactPairFlag.

@see PxContactPairFlag
*/
extern abstract PxContactPairFlags(PxContactPairFlag) from PxContactPairFlag to PxContactPairFlag {}


/**
\brief A contact point as used by contact notification
*/
@:include("PxSimulationEventCallback.h")
@:native("physx::PxContactPairPoint")
extern class PxContactPairPoint
{
    /**
    \brief The position of the contact point between the shapes, in world space. 
    */
    var position:PxVec3;

    /**
    \brief The separation of the shapes at the contact point.  A negative separation denotes a penetration.
    */
    var separation:PxReal;

    /**
    \brief The normal of the contacting surfaces at the contact point. The normal direction points from the second shape to the first shape.
    */
    var normal:PxVec3;

    /**
    \brief The surface index of shape 0 at the contact point.  This is used to identify the surface material.
    */
    var internalFaceIndex0:PxU32;

    /**
    \brief The impulse applied at the contact point, in world space. Divide by the simulation time step to get a force value.
    */
    var impulse:PxVec3;

    /**
    \brief The surface index of shape 1 at the contact point.  This is used to identify the surface material.
    */
    var internalFaceIndex1:PxU32;
}


/**
\brief Contact report pair information.

Instances of this class are passed to PxSimulationEventCallback.onContact(). If contact reports have been requested for a pair of shapes (see #PxPairFlag),
then the corresponding contact information will be provided through this structure.

@see PxSimulationEventCallback.onContact()
*/
@:include("PxSimulationEventCallback.h")
@:native("physx::PxContactPair")
extern class PxContactPair
{
    /**
    \brief The first shape of the pair.

    \note The shape pointers might reference deleted shapes. This will be the case if #PxPairFlag::eNOTIFY_TOUCH_LOST
          or #PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST events were requested for the pair and one of the involved shapes 
          gets deleted. Check the #flags member to see whether that is the case. Do not dereference a pointer to a 
          deleted shape. The pointer to a deleted shape is only provided such that user data structures which might 
          depend on the pointer value can be updated.

    @see PxShape
    */
    @:native("shape[0]") var shape0:PxShape;
    
    /**
    \brief The second shape of the pair.

    \note The shape pointers might reference deleted shapes. This will be the case if #PxPairFlag::eNOTIFY_TOUCH_LOST
          or #PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST events were requested for the pair and one of the involved shapes 
          gets deleted. Check the #flags member to see whether that is the case. Do not dereference a pointer to a 
          deleted shape. The pointer to a deleted shape is only provided such that user data structures which might 
          depend on the pointer value can be updated.

    @see PxShape
    */
    @:native("shape[1]") var shape1:PxShape;

    /**
    \brief Pointer to first patch header in contact stream containing contact patch data

    This pointer is only valid if contact point information has been requested for the contact report pair (see #PxPairFlag::eNOTIFY_CONTACT_POINTS).
    Use #extractContacts() as a reference for the data layout of the stream.
    */
    var contactPatches:cpp.ConstPointer<PxU8>;

    /**
    \brief Pointer to first contact point in contact stream containing contact data

    This pointer is only valid if contact point information has been requested for the contact report pair (see #PxPairFlag::eNOTIFY_CONTACT_POINTS).
    Use #extractContacts() as a reference for the data layout of the stream.
    */
    var contactPoints:cpp.ConstPointer<PxU8>;

    /**
    \brief Buffer containing applied impulse data.

    This pointer is only valid if contact point information has been requested for the contact report pair (see #PxPairFlag::eNOTIFY_CONTACT_POINTS).
    Use #extractContacts() as a reference for the data layout of the stream.
    */
    var contactImpulses:cpp.ConstPointer<PxReal>;

    /**
    \brief Size of the contact stream [bytes] including force buffer
    */
    var requiredBufferSize:PxU32;

    /**
    \brief Number of contact points stored in the contact stream
    */
    var contactCount:PxU8;

    /**
    \brief Number of contact patches stored in the contact stream
    */

    var patchCount:PxU8;

    /**
    \brief Size of the contact stream [bytes] not including force buffer
    */

    var contactStreamSize:PxU16;

    /**
    \brief Additional information on the contact report pair.

    @see PxContactPairFlag
    */
    var flags:PxContactPairFlags;

    /**
    \brief Flags raised due to the contact.

    The events field is a combination of:

    <ul>
    <li>PxPairFlag::eNOTIFY_TOUCH_FOUND,</li>
    <li>PxPairFlag::eNOTIFY_TOUCH_PERSISTS,</li>
    <li>PxPairFlag::eNOTIFY_TOUCH_LOST,</li>
    <li>PxPairFlag::eNOTIFY_TOUCH_CCD,</li>
    <li>PxPairFlag::eNOTIFY_THRESHOLD_FORCE_FOUND,</li>
    <li>PxPairFlag::eNOTIFY_THRESHOLD_FORCE_PERSISTS,</li>
    <li>PxPairFlag::eNOTIFY_THRESHOLD_FORCE_LOST</li>
    </ul>

    See the documentation of #PxPairFlag for an explanation of each.

    \note eNOTIFY_TOUCH_CCD can get raised even if the pair did not request this event. However, in such a case it will only get
    raised in combination with one of the other flags to point out that the other event occured during a CCD pass.

    @see PxPairFlag
    */
    var events:PxPairFlags;

    //PxU32					internalData[2];	// For internal use only

    /**
    \brief Extracts the contact points from the stream and stores them in a convenient format.
    
    @return Array of contact pair points

    @see PxContactPairPoint
    */
    inline function extractContacts():Array<PxContactPairPoint>
    {
        var arr:Array<PxContactPairPoint> = [];
        arr.resize(contactCount);
        _extractContacts(cpp.Pointer.ofArray(arr), contactCount);
        return arr;
    }
    private function _extractContacts(userBuffer:cpp.Pointer<PxContactPairPoint>, bufferSize:PxU32):PxU32;

    /**
    \brief Helper method to clone the contact pair and copy the contact data stream into a user buffer.
    
    The contact data stream is only accessible during the contact report callback. This helper function provides copy functionality
    to buffer the contact stream information such that it can get accessed at a later stage.

    \param[out] newPair The contact pair info will get copied to this instance. The contact data stream pointer of the copy will be redirected to the provided user buffer. Use NULL to skip the contact pair copy operation.
    \param[out] bufferMemory Memory block to store the contact data stream to. At most #requiredBufferSize bytes will get written to the buffer.
    */
    function bufferContacts(newPair:cpp.Pointer<PxContactPair>, bufferMemory:cpp.Pointer<PxU8>):Void;

    function getInternalFaceIndices():cpp.Pointer<PxU32>;
}


/**
\brief Collection of flags providing information on trigger report pairs.

@see PxTriggerPair
*/
extern enum abstract PxTriggerPairFlag(PxTriggerPairFlagImpl)
{
    @:native("physx::PxTriggerPairFlag::eREMOVED_SHAPE_TRIGGER") var eREMOVED_SHAPE_TRIGGER;					//!< The trigger shape has been removed from the actor/scene.
    @:native("physx::PxTriggerPairFlag::eREMOVED_SHAPE_OTHER") var eREMOVED_SHAPE_OTHER;					//!< The shape causing the trigger event has been removed from the actor/scene.
    //var eNEXT_FREE							= (1<<2);					//!< For internal use only.

    @:op(A | B)
    private inline function or(flag:PxTriggerPairFlag):PxTriggerPairFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("PxSimulationEventCallback.h")
@:native("physx::PxTriggerPairFlags")
private extern class PxTriggerPairFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxTriggerPairFlag.

@see PxTriggerPairFlag
*/
extern abstract PxTriggerPairFlags(PxTriggerPairFlag) from PxTriggerPairFlag to PxTriggerPairFlag {}


/**
\brief Descriptor for a trigger pair.

An array of these structs gets passed to the PxSimulationEventCallback::onTrigger() report.

\note The shape pointers might reference deleted shapes. This will be the case if #PxPairFlag::eNOTIFY_TOUCH_LOST
      events were requested for the pair and one of the involved shapes gets deleted. Check the #flags member to see
      whether that is the case. Do not dereference a pointer to a deleted shape. The pointer to a deleted shape is 
      only provided such that user data structures which might depend on the pointer value can be updated.

@see PxSimulationEventCallback.onTrigger()
*/
@:include("PxSimulationEventCallback.h")
@:native("physx::PxTriggerPair")
extern class PxTriggerPair
{
    var triggerShape:PxShape;	    //!< The shape that has been marked as a trigger.
    var triggerActor:PxRigidActor;	//!< The actor to which triggerShape is attached
    var otherShape:PxShape;		    //!< The shape causing the trigger event. \deprecated (see #PxSimulationEventCallback::onTrigger()) If collision between trigger shapes is enabled, then this member might point to a trigger shape as well.
    var otherActor:PxRigidActor;	//!< The actor to which otherShape is attached
    var status:PxPairFlag;			//!< Type of trigger event (eNOTIFY_TOUCH_FOUND or eNOTIFY_TOUCH_LOST). eNOTIFY_TOUCH_PERSISTS events are not supported.
    var flags:PxTriggerPairFlags;	//!< Additional information on the pair (see #PxTriggerPairFlag)
}


/**
\brief Descriptor for a broken constraint.

An array of these structs gets passed to the PxSimulationEventCallback::onConstraintBreak() report.

@see PxConstraint PxSimulationEventCallback.onConstraintBreak()
*/
@:include("PxSimulationEventCallback.h")
@:native("physx::PxConstraintInfo")
extern class PxConstraintInfo
{
    var constraint:PxConstraint;				//!< The broken constraint.
    var externalReference:Dynamic;		//!< The external object which owns the constraint (see #PxConstraintConnector::getExternalReference())
    var type:PxU32;					//!< Unique type ID of the external object. Allows to cast the provided external reference to the appropriate type
}



@:include("physx/PxSimulationEventCallbackHx.h")
@:native("::cpp::Reference<physx::PxSimulationEventCallbackNative>")
private extern class PxSimulationEventCallbackNative
{
    var hxHandle:PxSimulationEventCallbackHx;
}

/**
\brief An interface class that the user can implement in order to receive simulation events.

With the exception of onAdvance(), the events get sent during the call to either #PxScene::fetchResults() or 
#PxScene::flushSimulation() with sendPendingReports=true. onAdvance() gets called while the simulation
is running (that is between PxScene::simulate(), onAdvance() and PxScene::fetchResults()).

\note SDK state should not be modified from within the callbacks. In particular objects should not
be created or destroyed. If state modification is needed then the changes should be stored to a buffer
and performed after the simulation step.

<b>Threading:</b> With the exception of onAdvance(), it is not necessary to make these callbacks thread safe as 
they will only be called in the context of the user thread.

@see PxScene.setSimulationEventCallback() PxScene.getSimulationEventCallback()
*/

@:headerInclude("PxSimulationEventCallback.h")
@:headerNamespaceCode("
class PxSimulationEventCallbackNative : public physx::PxSimulationEventCallback
{
public:
    physx::PxSimulationEventCallbackHx hxHandle;
    PxSimulationEventCallbackNative(physx::PxSimulationEventCallbackHx hxHandle):hxHandle{ hxHandle } {}
    void onConstraintBreak(PxConstraintInfo* constraints, PxU32 count);
    void onWake(PxActor** actors, PxU32 count);
    void onSleep(PxActor** actors, PxU32 count);
    void onTrigger(PxTriggerPair* pairs, PxU32 count);
    void onAdvance(const PxRigidBody*const* bodyBuffer, const PxTransform* poseBuffer, const PxU32 count);
    void onContact(const PxContactPairHeader& pairHeader, const PxContactPair* pairs, PxU32 nbPairs);
};
")
@:cppNamespaceCode("
void PxSimulationEventCallbackNative::onConstraintBreak(PxConstraintInfo* constraints, PxU32 count) { hxHandle->_onConstraintBreak(constraints, count); }
void PxSimulationEventCallbackNative::onWake(PxActor** actors, PxU32 count) { hxHandle->_onWake(reinterpret_cast<::cpp::Reference<PxActor>*>(actors), count); }
void PxSimulationEventCallbackNative::onSleep(PxActor** actors, PxU32 count) { hxHandle->_onSleep(reinterpret_cast<::cpp::Reference<PxActor>*>(actors), count); }
void PxSimulationEventCallbackNative::onContact(const PxContactPairHeader& pairHeader, const PxContactPair* pairs, PxU32 nbPairs) { hxHandle->_onContact(pairHeader, pairs, nbPairs); }
void PxSimulationEventCallbackNative::onTrigger(PxTriggerPair* pairs, PxU32 count) { hxHandle->_onTrigger(pairs, count); }
void PxSimulationEventCallbackNative::onAdvance(const PxRigidBody*const* bodyBuffer, const PxTransform* poseBuffer, const PxU32 count) {  }
")
class PxSimulationEventCallbackHx
{
    @:allow(physx.PxSimulationEventCallback)
    private var _native:PxSimulationEventCallbackNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxSimulationEventCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxSimulationEventCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }


    
	/**
	\brief This is called when a breakable constraint breaks.
	
	\note The user should not release the constraint shader inside this call!

	\note No event will get reported if the constraint breaks but gets deleted while the time step is still being simulated.

	\param[in] constraints - The constraints which have been broken.
	\param[in] count       - The number of constraints

	@see PxConstraint PxConstraintDesc.linearBreakForce PxConstraintDesc.angularBreakForce
	*/
    public function onConstraintBreak(constraints:Array<PxConstraintInfo>):Void {}
    @:noCompletion @:noDoc final private function _onConstraintBreak(constraints:cpp.Pointer<PxConstraintInfo>, count:PxU32):Void
    {
        onConstraintBreak(constraints.toUnmanagedArray(count));
    }

	/**
	\brief This is called with the actors which have just been woken up.

	\note Only supported by rigid bodies yet.
	\note Only called on actors for which the PxActorFlag eSEND_SLEEP_NOTIFIES has been set.
	\note Only the latest sleep state transition happening between fetchResults() of the previous frame and fetchResults() of the current frame
	will get reported. For example, let us assume actor A is awake, then A->putToSleep() gets called, then later A->wakeUp() gets called.
	At the next simulate/fetchResults() step only an onWake() event will get triggered because that was the last transition.
	\note If an actor gets newly added to a scene with properties such that it is awake and the sleep state does not get changed by 
	the user or simulation, then an onWake() event will get sent at the next simulate/fetchResults() step.

	\param[in] actors - The actors which just woke up.
	\param[in] count  - The number of actors

	@see PxScene.setSimulationEventCallback() PxSceneDesc.simulationEventCallback PxActorFlag PxActor.setActorFlag()
	*/
    public function onWake(actors:Array<PxActor>):Void {}
    @:noCompletion @:noDoc final private function _onWake(actors:cpp.Pointer<PxActor>, count:PxU32):Void
    {
        onWake(actors.toUnmanagedArray(count));
    }

	/**
	\brief This is called with the actors which have just been put to sleep.

	\note Only supported by rigid bodies yet.
	\note Only called on actors for which the PxActorFlag eSEND_SLEEP_NOTIFIES has been set.
	\note Only the latest sleep state transition happening between fetchResults() of the previous frame and fetchResults() of the current frame
	will get reported. For example, let us assume actor A is asleep, then A->wakeUp() gets called, then later A->putToSleep() gets called.
	At the next simulate/fetchResults() step only an onSleep() event will get triggered because that was the last transition (assuming the simulation
	does not wake the actor up).
	\note If an actor gets newly added to a scene with properties such that it is asleep and the sleep state does not get changed by 
	the user or simulation, then an onSleep() event will get sent at the next simulate/fetchResults() step.

	\param[in] actors - The actors which have just been put to sleep.
	\param[in] count  - The number of actors

	@see PxScene.setSimulationEventCallback() PxSceneDesc.simulationEventCallback PxActorFlag PxActor.setActorFlag()
	*/
    public function onSleep(actors:Array<PxActor>):Void {}
    @:noCompletion @:noDoc final private function _onSleep(actors:cpp.Pointer<PxActor>, count:PxU32):Void
    {
        onSleep(actors.toUnmanagedArray(count));
    }

	/**
	\brief This is called when certain contact events occur.

	The method will be called for a pair of actors if one of the colliding shape pairs requested contact notification.
	You request which events are reported using the filter shader/callback mechanism (see #PxSimulationFilterShader,
	#PxSimulationFilterCallback, #PxPairFlag).
	
	Do not keep references to the passed objects, as they will be 
	invalid after this function returns.

	\param[in] pairHeader Information on the two actors whose shapes triggered a contact report.
	\param[in] pairs The contact pairs of two actors for which contact reports have been requested. See #PxContactPair.
	\param[in] nbPairs The number of provided contact pairs.

	@see PxScene.setSimulationEventCallback() PxSceneDesc.simulationEventCallback PxContactPair PxPairFlag PxSimulationFilterShader PxSimulationFilterCallback
	*/
	public function onContact(pairHeader:PxContactPairHeader, pairs:Array<PxContactPair>):Void {}
    @:noCompletion @:noDoc final private function _onContact(pairHeader:PxContactPairHeader, pairs:cpp.Pointer<PxContactPair>, nbPairs:PxU32):Void
    {
        onContact(pairHeader, pairs.toUnmanagedArray(nbPairs));
    }

	/**
	\brief This is called with the current trigger pair events.

	Shapes which have been marked as triggers using PxShapeFlag::eTRIGGER_SHAPE will send events
	according to the pair flag specification in the filter shader (see #PxPairFlag, #PxSimulationFilterShader).

	\note Trigger shapes will no longer send notification events for interactions with other trigger shapes.

	\param[in] pairs - The trigger pair events.
	\param[in] count - The number of trigger pair events.

	@see PxScene.setSimulationEventCallback() PxSceneDesc.simulationEventCallback PxPairFlag PxSimulationFilterShader PxShapeFlag PxShape.setFlag()
	*/
    public function onTrigger(pairs:Array<PxTriggerPair>):Void {}
    @:noCompletion @:noDoc final private function _onTrigger(pairs:cpp.Pointer<PxTriggerPair>, count:PxU32):Void
    {
        onTrigger(pairs.toUnmanagedArray(count));
    }

	// /**
	// \brief Provides early access to the new pose of moving rigid bodies.

	// When this call occurs, rigid bodies having the #PxRigidBodyFlag::eENABLE_POSE_INTEGRATION_PREVIEW 
	// flag set, were moved by the simulation and their new poses can be accessed through the provided buffers.
	
	// \note The provided buffers are valid and can be read until the next call to #PxScene::simulate() or #PxScene::collide().
	
	// \note Buffered user changes to the rigid body pose will not yet be reflected in the provided data. More important,
	// the provided data might contain bodies that have been deleted while the simulation was running. It is the user's
	// responsibility to detect and avoid dereferencing such bodies.

	// \note This callback gets triggered while the simulation is running. If the provided rigid body references are used to
	// read properties of the object, then the callback has to guarantee no other thread is writing to the same body at the same
	// time.
	
	// \note The code in this callback should be lightweight as it can block the simulation, that is, the
	// #PxScene::fetchResults() call.

	// \param[in] bodyBuffer The rigid bodies that moved and requested early pose reporting.
	// \param[in] poseBuffer The integrated rigid body poses of the bodies listed in bodyBuffer.
	// \param[in] count The number of entries in the provided buffers.

	// @see PxScene.setSimulationEventCallback() PxSceneDesc.simulationEventCallback PxRigidBodyFlag::eENABLE_POSE_INTEGRATION_PREVIEW
	// */
    // public function onAdvance(bodyBuffer:Array<PxRigidBodyConst>, poseBuffer:Array<PxTransformConst>):Void {}
    // @:noCompletion @:noDoc final private function _onAdvance(bodyBuffer:cpp.ConstPointer<PxRigidBodyConst>, poseBuffer:cpp.ConstPointer<PxTransform>, count:PxU32):Void
    // {
    //     onAdvance(bodyBuffer, poseBuffer, count);
    // }
}

/**
 * Assign with a Haxe class that extends `PxSimulationEventCallbackHx`.
 */
abstract PxSimulationEventCallback(PxSimulationEventCallbackNative)
{
    inline function new(native:PxSimulationEventCallbackNative)
    {
        this = native;
    }

    @:from static function from(haxeDelegate:PxSimulationEventCallbackHx)
    {
        return new PxSimulationEventCallback(cast haxeDelegate._native);
    }
}