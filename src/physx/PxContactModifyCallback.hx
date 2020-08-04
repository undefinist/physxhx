package physx;

import physx.foundation.PxTransform;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;

/**
\brief An array of contact points, as passed to contact modification.

The word 'set' in the name does not imply that duplicates are filtered in any 
way.  This initial set of contacts does potentially get reduced to a smaller 
set before being passed to the solver.

You can use the accessors to read and write contact properties.  The number of 
contacts is immutable, other than being able to disable contacts using ignore().

@see PxContactModifyCallback, PxModifiableContact
*/
@:include("PxContactModifyCallback.h")
@:native("physx::PxContactSet")
@:structAccess
extern class PxContactSet
{
    /**
    \brief Get the position of a specific contact point in the set.

    @see PxModifiableContact.point
    */
    function getPoint(i:PxU32):PxVec3;

    /**
    \brief Alter the position of a specific contact point in the set.

    @see PxModifiableContact.point
    */
    function setPoint(i:PxU32, p:PxVec3):Void;

    /**
    \brief Get the contact normal of a specific contact point in the set.

    @see PxModifiableContact.normal
    */
    function getNormal(i:PxU32):PxVec3;

    /**
    \brief Alter the contact normal of a specific contact point in the set.

    **Note:** Changing the normal can cause contact points to be ignored.

    @see PxModifiableContact.normal
    */
    function setNormal(i:PxU32, n:PxVec3):Void;	
    
    /**
    \brief Get the separation of a specific contact point in the set.

    @see PxModifiableContact.separation
    */
    function getSeparation(i:PxU32):PxReal;

    /**
    \brief Alter the separation of a specific contact point in the set.

    @see PxModifiableContact.separation
    */
    function setSeparation(i:PxU32, s:PxReal):Void;

    /**
    \brief Get the target velocity of a specific contact point in the set.

    @see PxModifiableContact.targetVelocity

    */
    function getTargetVelocity(i:PxU32):PxVec3;

    /**
    \brief Alter the target velocity of a specific contact point in the set.

    @see PxModifiableContact.targetVelocity
    */
    function setTargetVelocity(i:PxU32, v:PxVec3):Void;

    /**
    \brief Get the face index with respect to the first shape of the pair for a specific contact point in the set.

    @see PxModifiableContact.internalFaceIndex0
    */
    function getInternalFaceIndex0(i:PxU32):PxU32;

    /**
    \brief Get the face index with respect to the second shape of the pair for a specific contact point in the set.

    @see PxModifiableContact.internalFaceIndex1
    */
    function getInternalFaceIndex1(i:PxU32):PxU32;
    
    /**
    \brief Get the maximum impulse for a specific contact point in the set.

    @see PxModifiableContact.maxImpulse
    */
    function getMaxImpulse(i:PxU32):PxReal;

    /**
    \brief Alter the maximum impulse for a specific contact point in the set.

    **Note:** Must be nonnegative. If set to zero, the contact point will be ignored

    @see PxModifiableContact.maxImpulse
    */
    function setMaxImpulse(i:PxU32, s:PxReal):Void;

    /**
    \brief Get the restitution coefficient for a specific contact point in the set.

    @see PxModifiableContact.restitution
    */
    function getRestitution(i:PxU32):PxReal;

    /**
    \brief Alter the restitution coefficient for a specific contact point in the set.

    **Note:** Valid ranges [0,1]

    @see PxModifiableContact.restitution
    */
    function setRestitution(i:PxU32, r:PxReal):Void;

    /**
    \brief Get the static friction coefficient for a specific contact point in the set.

    @see PxModifiableContact.staticFriction
    */
    function getStaticFriction(i:PxU32):PxReal;

    /**
    \brief Alter the static friction coefficient for a specific contact point in the set.

    @see PxModifiableContact.staticFriction
    */
    function setStaticFriction(i:PxU32, f:PxReal):Void;

    /**
    \brief Get the static friction coefficient for a specific contact point in the set.

    @see PxModifiableContact.dynamicFriction
    */
    function getDynamicFriction(i:PxU32):PxReal;

    /**
    \brief Alter the static dynamic coefficient for a specific contact point in the set.

    @see PxModifiableContact.dynamic
    */
    function setDynamicFriction(i:PxU32, f:PxReal):Void;

    /**
    \brief Ignore the contact point.

    If a contact point is ignored then no force will get applied at this point. This can be used to disable collision in certain areas of a shape, for example.
    */
    function ignore(i:PxU32):Void;

    /**
    \brief The number of contact points in the set.
    */
    function size():PxU32;

    /**
    \brief Returns the invMassScale of body 0

    A value < 1.0 makes this contact treat the body as if it had larger mass. A value of 0.f makes this contact
    treat the body as if it had infinite mass. Any value > 1.f makes this contact treat the body as if it had smaller mass.
    */
    function getInvMassScale0():PxReal;

    /**
    \brief Returns the invMassScale of body 1

    A value < 1.0 makes this contact treat the body as if it had larger mass. A value of 0.f makes this contact
    treat the body as if it had infinite mass. Any value > 1.f makes this contact treat the body as if it had smaller mass.
    */
    function getInvMassScale1():PxReal;

    /**
    \brief Returns the invInertiaScale of body 0

    A value < 1.0 makes this contact treat the body as if it had larger inertia. A value of 0.f makes this contact
    treat the body as if it had infinite inertia. Any value > 1.f makes this contact treat the body as if it had smaller inertia.
    */
    function getInvInertiaScale0():PxReal;

    /**
    \brief Returns the invInertiaScale of body 1

    A value < 1.0 makes this contact treat the body as if it had larger inertia. A value of 0.f makes this contact
    treat the body as if it had infinite inertia. Any value > 1.f makes this contact treat the body as if it had smaller inertia.
    */
    function getInvInertiaScale1():PxReal;

    /**
    \brief Sets the invMassScale of body 0

    This can be set to any value in the range [0, PX_MAX_F32). A value < 1.0 makes this contact treat the body as if it had larger mass. A value of 0.f makes this contact
    treat the body as if it had infinite mass. Any value > 1.f makes this contact treat the body as if it had smaller mass.
    */
    function setInvMassScale0(scale:PxReal):Void;

    /**
    \brief Sets the invMassScale of body 1

    This can be set to any value in the range [0, PX_MAX_F32). A value < 1.0 makes this contact treat the body as if it had larger mass. A value of 0.f makes this contact
    treat the body as if it had infinite mass. Any value > 1.f makes this contact treat the body as if it had smaller mass.
    */
    function setInvMassScale1(scale:PxReal):Void;

    /**
    \brief Sets the invInertiaScale of body 0

    This can be set to any value in the range [0, PX_MAX_F32). A value < 1.0 makes this contact treat the body as if it had larger inertia. A value of 0.f makes this contact
    treat the body as if it had infinite inertia. Any value > 1.f makes this contact treat the body as if it had smaller inertia.
    */
    function setInvInertiaScale0(scale:PxReal):Void;

    /**
    \brief Sets the invInertiaScale of body 1

    This can be set to any value in the range [0, PX_MAX_F32). A value < 1.0 makes this contact treat the body as if it had larger inertia. A value of 0.f makes this contact
    treat the body as if it had infinite inertia. Any value > 1.f makes this contact treat the body as if it had smaller inertia.
    */
    function setInvInertiaScale1(scale:PxReal):Void;
}

/**
\brief An array of instances of this class is passed to PxContactModifyCallback::onContactModify().

@see PxContactModifyCallback
*/
@:include("PxContactModifyCallback.h")
@:native("physx::PxContactModifyPair")
@:structAccess
extern class PxContactModifyPair
{
    /**
    \brief The actors which make up the pair in contact. 
    
    Note that these are the actors as seen by the simulation, and may have been deleted since the simulation step started.
    */
    @:native("actor[0]") var actor0:PxRigidActor;
    /**
    \brief The actors which make up the pair in contact. 
    
    Note that these are the actors as seen by the simulation, and may have been deleted since the simulation step started.
    */
    @:native("actor[1]") var actor1:PxRigidActor;
    
    /**
    \brief The shapes which make up the pair in contact. 
    
    Note that these are the shapes as seen by the simulation, and may have been deleted since the simulation step started.
    */
    @:native("shape[0]") var shape0:PxShape;
    /**
    \brief The shapes which make up the pair in contact. 
    
    Note that these are the shapes as seen by the simulation, and may have been deleted since the simulation step started.
    */
    @:native("shape[1]") var shape1:PxShape;
    
    /**
    \brief The shape to world transforms of the two shapes. 
    
    These are the transforms as the simulation engine sees them, and may have been modified by the application
    since the simulation step started.
    */
    @:native("transform[0]") var transform0:PxTransform;
    /**
    \brief The shape to world transforms of the two shapes. 
    
    These are the transforms as the simulation engine sees them, and may have been modified by the application
    since the simulation step started.
    */
    @:native("transform[1]") var transform1:PxTransform;
    
    /**
    \brief An array of contact points between these two shapes.
    */
    var contacts:PxContactSet;
}



@:native("::cpp::Reference<physx::PxContactModifyCallbackNative>")
private extern class PxContactModifyCallbackNative {}
@:native("::cpp::Reference<physx::PxCCDContactModifyCallbackNative>")
private extern class PxCCDContactModifyCallbackNative {}

/**
 * A base class that the user can extend in order to modify contact constraints.
 * 
 * **Threading:** It is **necessary** to make this class thread safe as it will be called in the context of the
 * simulation thread. It might also be necessary to make it reentrant, since some calls can be made by multi-threaded
 * parts of the physics engine.
 * 
 * You can enable the use of this contact modification callback by raising the flag `PxPairFlag.eMODIFY_CONTACTS` in
 * the filter shader/callback (see `PxSimulationFilterShader`) for a pair of rigid body objects.
 * 
 * Please note: 
 * + Raising the contact modification flag will not wake the actors up automatically.
 * + It is not possible to turn off the performance degradation by simply removing the callback from the scene, the
 *   filter shader/callback has to be used to clear the contact modification flag.
 * + The contacts will only be reported as long as the actors are awake. There will be no callbacks while the actors are sleeping.
 * 
 * @see PxScene.setContactModifyCallback() PxScene.getContactModifyCallback()
 */
@:headerInclude("PxContactModifyCallback.h")
@:headerNamespaceCode("
class PxContactModifyCallbackNative : public physx::PxContactModifyCallback
{
public:
    physx::PxContactModifyCallbackHx hxHandle;
    PxContactModifyCallbackNative(physx::PxContactModifyCallbackHx hxHandle):hxHandle{ hxHandle } {}
    void onContactModify(PxContactModifyPair* const pairs, PxU32 count) override;
};
")
@:cppNamespaceCode("
void PxContactModifyCallbackNative::onContactModify(PxContactModifyPair* const pairs, PxU32 count) { hxHandle->_onContactModify(pairs, count); }
")
class PxContactModifyCallbackHx
{
    @:allow(physx.PxContactModifyCallback) @:noCompletion
    private var _native:PxContactModifyCallbackNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxContactModifyCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxContactModifyCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * \brief Passes modifiable arrays of contacts to the application.
     * 
     * The initial contacts are as determined fresh each frame by collision detection.
     * 
     * The number of contacts can not be changed, so you cannot add your own contacts. You may however
     * disable contacts using `PxContactSet.ignore()`.
     * 
     * @see PxContactModifyPair
     */
    function onContactModify(pairs:haxe.ds.Vector<PxContactModifyPair>) {};
    function _onContactModify(pairs:cpp.Pointer<PxContactModifyPair>, count:PxU32):Void
    {
        onContactModify(pairs.toUnmanagedVector(count));
    }
}

/**
 * A base class that the user can extend in order to modify CCD contact constraints.
 * 
 * **Threading:** It is **necessary** to make this class thread safe as it will be called in the context of the
 * simulation thread. It might also be necessary to make it reentrant, since some calls can be made by multi-threaded
 * parts of the physics engine.
 * 
 * You can enable the use of this contact modification callback by raising the flag `PxPairFlag.eMODIFY_CONTACTS` in
 * the filter shader/callback (see `PxSimulationFilterShader`) for a pair of rigid body objects.
 * 
 * Please note: 
 * + Raising the contact modification flag will not wake the actors up automatically.
 * + It is not possible to turn off the performance degradation by simply removing the callback from the scene, the
 *   filter shader/callback has to be used to clear the contact modification flag.
 * + The contacts will only be reported as long as the actors are awake. There will be no callbacks while the actors are sleeping.
 * 
 * @see PxScene.setCCDContactModifyCallback() PxScene.getCCDContactModifyCallback()
 */
@:headerInclude("PxContactModifyCallback.h")
@:headerNamespaceCode("
class PxCCDContactModifyCallbackNative : public physx::PxCCDContactModifyCallback
{
public:
    physx::PxCCDContactModifyCallbackHx hxHandle;
    PxCCDContactModifyCallbackNative(physx::PxCCDContactModifyCallbackHx hxHandle):hxHandle{ hxHandle } {}
    void onCCDContactModify(PxContactModifyPair* const pairs, PxU32 count) override;
};
")
@:cppNamespaceCode("
void PxCCDContactModifyCallbackNative::onCCDContactModify(PxContactModifyPair* const pairs, PxU32 count) { hxHandle->_onCCDContactModify(pairs, count); }
")
class PxCCDContactModifyCallbackHx
{
    @:allow(physx.PxCCDContactModifyCallback) @:noCompletion
    private var _native:PxCCDContactModifyCallbackNative;
    
    function new()
    {
        _native = untyped __cpp__("new PxCCDContactModifyCallbackNative(this)");
        cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(_release));
    }

    private static function _release(self:PxCCDContactModifyCallbackHx):Void
    {
        untyped __cpp__("delete self->_native.ptr");
    }

    /**
     * \brief Passes modifiable arrays of contacts to the application.
     * 
     * The initial contacts are as determined fresh each frame by collision detection.
     * 
     * The number of contacts can not be changed, so you cannot add your own contacts. You may however
     * disable contacts using `PxContactSet.ignore()`.
     * 
     * @see PxContactModifyPair
     */
    function onCCDContactModify(pairs:haxe.ds.Vector<PxContactModifyPair>) {};
    function _onCCDContactModify(pairs:cpp.Pointer<PxContactModifyPair>, count:PxU32):Void
    {
        onCCDContactModify(pairs.toUnmanagedVector(count));
    }
}

/**
 * Assign with a Haxe class that extends `PxContactModifyCallbackHx`.
 */
@:noCompletion extern abstract PxContactModifyCallback(PxContactModifyCallbackNative)
{
    @:from static inline function from(hxHandle:PxContactModifyCallbackHx):PxContactModifyCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}

/**
 * Assign with a Haxe class that extends `PxCCDContactModifyCallbackHx`.
 */
@:noCompletion extern abstract PxCCDContactModifyCallback(PxCCDContactModifyCallbackNative)
{
    @:from static inline function from(hxHandle:PxCCDContactModifyCallbackHx):PxCCDContactModifyCallback
    {
        return hxHandle == null ? null : cast hxHandle._native;
    }
}