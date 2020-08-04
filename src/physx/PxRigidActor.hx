package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxTransform;

@:include("PxRigidActor.h")
@:native("::cpp::Reference<physx::PxRigidActor>")
extern class PxRigidActor extends PxActor
{
    /**
     * Deletes the rigid actor object.
     * 
     * Also releases any shapes associated with the actor.
     * 
     * Releasing an actor will affect any objects that are connected to the actor (constraint shaders like joints etc.).
     * Such connected objects will be deleted upon scene deletion, or explicitly by the user by calling `release()`
     * on these objects. It is recommended to always remove all objects that reference actors before the actors
     * themselves are removed. It is not possible to retrieve list of dead connected objects.
     * 
     * **Sleeping:** This call will awaken any sleeping actors contacting the deleted actor (directly or indirectly).
     * 
     * Calls `PxActor.release()` so you might want to check the documentation of that method as well.
     * 
     * @see PxActor::release()
     */
    function release():Void;


//////////////////////////////////////////////////////////////////////////////////////////////////
/// @name Global Pose Manipulation
//

    /**
     * Retrieves the actors world space transform.
     * 
     * The `getGlobalPose()` method retrieves the actor's current actor space to world space transformation.
     * 
     * @return Global pose of object.
     * 
     * @see PxRigidDynamic.setGlobalPose() PxRigidStatic.setGlobalPose()
     */
    function getGlobalPose():PxTransform;

    /**
     * Method for setting an actor's pose in the world.
     * 
     * This method instantaneously changes the actor space to world space transformation. 
     * 
     * This method is mainly for dynamic rigid bodies (see `PxRigidDynamic).` Calling this method on static actors is 
     * likely to result in a performance penalty, since internal optimization structures for static actors may need to be 
     * recomputed. In addition, moving static actors will not interact correctly with dynamic actors or joints. 
     * 
     * To directly control an actor's position and have it correctly interact with dynamic bodies and joints, create a dynamic 
     * body with the `PxRigidBodyFlag.eKINEMATIC` flag, then use the `setKinematicTarget()` commands to define its path.
     * 
     * Even when moving dynamic actors, exercise restraint in making use of this method. Where possible, avoid:
     * 
     * - moving actors into other actors, thus causing overlap (an invalid physical state)
     * - moving an actor that is connected by a joint to another away from the other (thus causing joint error)
     * 
     * **Sleeping:** This call wakes dynamic actors if they are sleeping and the autowake parameter is true (default).
     * 
     * @param pose Transformation from the actors local frame to the global frame. **Range:** rigid body transform.
     * @param autowake Whether to wake the object if it is dynamic. Default `true`.
     *                 This parameter has no effect for static or kinematic actors.
     *                 If true and the current wake counter value is smaller than `PxSceneDesc.wakeCounterResetValue` it will get increased to the reset value.
     * 
     * @see getGlobalPose()
     */
    @:overload(function(pose:PxTransform):Void{})
    function setGlobalPose(pose:PxTransform, autowake:Bool):Void;


//////////////////////////////////////////////////////////////////////////////////////////////////
/// @name Shapes
//

    /** 
     * Attach a shared shape to an actor 
     * 
     * This call will increment the reference count of the shape.
     * 
     * **Note:** Mass properties of dynamic rigid actors will not automatically be recomputed 
     * to reflect the new mass distribution implied by the shape. Follow this call with a call to 
     * the PhysX extensions method `PxRigidBodyExt.updateMassAndInertia()` to do that.
     * 
     * Attaching a triangle mesh, heightfield or plane geometry shape configured as `eSIMULATION_SHAPE` is not supported for 
     * non-kinematic `PxRigidDynamic` instances.
     * 
     * **Sleeping:** Does **NOT** wake the actor up automatically.
     * 
     * @param shape the shape to attach.
     * 
     * @return True if success.
     */
    function attachShape(shape:PxShape):Bool;


    /**
     * Detach a shape from an actor. 
     * 
     * This will also decrement the reference count of the PxShape, and if the reference count is zero, will cause it to be deleted.
     * 
     * **Sleeping:** Does **NOT** wake the actor up automatically.
     * 
     * @param shape the shape to detach.
     * @param wakeOnLostTouch Specifies whether touching objects from the previous frame should get woken up in the next frame.
     *                        Only applies to `PxArticulation` and `PxRigidActor` types. Default `true`.
     */
    @:overload(function(shape:PxShape):Void{})
    function detachShape(shape:PxShape, wakeOnLostTouch:Bool):Void;


    /**
     * Returns the number of shapes assigned to the actor.
     * 
     * You can use `getShapes()` to retrieve the shape pointers.
     * 
     * @return Number of shapes associated with this actor.
     * 
     * @see PxShape getShapes()
     */
    function getNbShapes():PxU32;


    /**
     * Retrieve all the shape pointers belonging to the actor.
     * 
     * These are the shapes used by the actor for collision detection.
     * 
     * You can retrieve the number of shape pointers by calling `getNbShapes()`
     * 
     * **Note:** Removing shapes with `PxShape.release()` will invalidate the pointer of the released shape.
     * 
     * @param [out]userBuffer The buffer to store the shape pointers.
     * @param [in]startIndex Index of first shape pointer to be retrieved
     * @return Number of shape pointers written to the buffer.
     * 
     * @see PxShape getNbShapes() PxShape::release()
     */
    inline function getShapes(userBuffer:haxe.ds.Vector<PxShape>, startIndex:PxU32 = 0):PxU32
    {
        return untyped __cpp__("{0}->getShapes(reinterpret_cast<physx::PxShape**>({1}), {2}, {3})",
            this, cpp.Pointer.ofArray(cast userBuffer), userBuffer.length, startIndex);
    }


//////////////////////////////////////////////////////////////////////////////////////////////////
/// @name Constraints
//

    /**
     * Returns the number of constraint shaders attached to the actor.
     * 
     * You can use `getConstraints()` to retrieve the constraint shader pointers.
     * 
     * \return Number of constraint shaders attached to this actor.
     * 
     * @see PxConstraint getConstraints()
     */
    function getNbConstraints():PxU32;


    /**
     * Retrieve all the constraint shader pointers belonging to the actor.
     * 
     * You can retrieve the number of constraint shader pointers by calling `getNbConstraints()`
     * 
     * Note: Removing constraint shaders with `PxConstraint.release()` will invalidate the pointer of the released constraint.
     * 
     * @param [out]userBuffer The buffer to store the constraint shader pointers.
     * @param [in]startIndex Index of first constraint pointer to be retrieved
     * @return Number of constraint shader pointers written to the buffer.
     * 
     * @see PxConstraint getNbConstraints() PxConstraint::release()
     */
    inline function getConstraints(userBuffer:haxe.ds.Vector<PxConstraint>, startIndex:PxU32 = 0):PxU32
    {
        return untyped __cpp__("{0}->getConstraints(reinterpret_cast<physx::PxShape**>({1}), {2}, {3})",
            this, cpp.Pointer.ofArray(cast userBuffer), userBuffer.length, startIndex);
    }

}