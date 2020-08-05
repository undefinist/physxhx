package physx.extensions;

import physx.foundation.PxTransform;
import physx.PxScene;
import physx.PxQueryFiltering;
import physx.PxQueryReport;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;

@:include("extensions/PxRigidBodyExt.h")
extern class PxRigidBodyExt
{
    @:native("physx::PxRigidBodyExt::updateMassAndInertia")
    @:overload(function(body:PxRigidBody, shapeDensities:cpp.ConstPointer<PxReal>, shapeDensityCount:PxU32, massLocalPose:cpp.ConstPointer<PxVec3>, includeNonSimShapes:Bool):Bool {})
    private static function _updateMassAndInertia(body:PxRigidBody, density:PxReal, massLocalPose:cpp.ConstPointer<PxVec3>, includeNonSimShapes:Bool):Bool;

	/**
     * Computation of mass properties for a rigid body actor
     * 
     * To simulate a dynamic rigid actor, the SDK needs a mass and an inertia tensor. 
     * 
     * This method offers functionality to compute the necessary mass and inertia properties based on the shapes declared in
     * the PxRigidBody descriptor and some additionally specified parameters. For each shape, the shape geometry, 
     * the shape positioning within the actor and the specified shape density are used to compute the body's mass and 
     * inertia properties.
     * 
     * - Shapes without PxShapeFlag::eSIMULATION_SHAPE set are ignored unless includeNonSimShapes is true.
     * - Shapes with plane, triangle mesh or heightfield geometry and PxShapeFlag::eSIMULATION_SHAPE set are not allowed for PxRigidBody collision.
     * 
     * This method will set the mass, center of mass, and inertia tensor 
     * 
     * if no collision shapes are found, the inertia tensor is set to (1,1,1) and the mass to 1
     * 
     * if massLocalPose is non-NULL, the rigid body's center of mass parameter  will be set 
     * to the user provided value (massLocalPose) and the inertia tensor will be resolved at that point.
     * 
     * **Note:** If all shapes of the actor have the same density then the overloaded method updateMassAndInertia() with a single density parameter can be used instead.
     * 
     * @param [in,out]body The rigid body.
     * @param [in]shapeDensities The per shape densities. There must be one entry for each shape which has the PxShapeFlag::eSIMULATION_SHAPE set (or for all shapes if includeNonSimShapes is set to true). Other shapes are ignored. The density values must be greater than 0.
     * @param [in]shapeDensityCount The number of provided density values.
     * @param [in]massLocalPose The center of mass relative to the actor frame.  If set to null then (0,0,0) is assumed.
     * @param [in]includeNonSimShapes True if all kind of shapes (PxShapeFlag::eSCENE_QUERY_SHAPE, PxShapeFlag::eTRIGGER_SHAPE) should be taken into account.
     * @return Boolean. True on success else false.
     * 
     * @see PxRigidBody::setMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
	 */
    inline static function updateMassAndInertiaPerShape(body:PxRigidBody, shapeDensities:Array<PxReal>,
        ?massLocalPose:cpp.Struct<PxVec3>, includeNonSimShapes:Bool = false):Bool
    {
        return _updateMassAndInertia(body, cpp.Pointer.ofArray(shapeDensities), shapeDensities.length, 
            cpp.Pointer.addressOf(massLocalPose).reinterpret(), includeNonSimShapes);
    }
    
    /**
     * Computation of mass properties for a rigid body actor
     * 
     * See `updateMassAndInertiaPerShape` for details.
     * 
     * @param [in,out]body The rigid body.
     * @param [in]density The density of the body. Used to compute the mass of the body. The density must be greater than 0. 
     * @param [in]massLocalPose The center of mass relative to the actor frame.  If set to null then (0,0,0) is assumed.
     * @param [in]includeNonSimShapes True if all kind of shapes (PxShapeFlag::eSCENE_QUERY_SHAPE, PxShapeFlag::eTRIGGER_SHAPE) should be taken into account.
     * @return Boolean. True on success else false.
     * 
     * @see PxRigidBody::setMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
     */
    inline static function updateMassAndInertia(body:PxRigidBody, density:PxReal,
        ?massLocalPose:cpp.Struct<PxVec3>, includeNonSimShapes:Bool = false):Bool
    {
        return _updateMassAndInertia(body, density, 
            cpp.Pointer.addressOf(massLocalPose).reinterpret(), includeNonSimShapes);
    }



    @:native("physx::PxRigidBodyExt::setMassAndUpdateInertia")
    @:overload(function(body:PxRigidBody, shapeMasses:cpp.ConstPointer<PxReal>, shapeMassCount:PxU32, massLocalPose:cpp.ConstPointer<PxVec3>, includeNonSimShapes:Bool):Bool {})
    private static function _setMassAndUpdateInertia(body:PxRigidBody, mass:PxReal, massLocalPose:cpp.ConstPointer<PxVec3>, includeNonSimShapes:Bool):Bool;
    
	/**
     * Computation of mass properties for a rigid body actor
     * 
     * This method sets the mass, inertia and center of mass of a rigid body. The mass is set to the sum of all user-supplied
     * shape mass values, and the inertia and center of mass are computed according to the rigid body's shapes and the per shape mass input values.
     * 
     * If no collision shapes are found, the inertia tensor is set to (1,1,1)
     * 
     * **Note:** If a single mass value should be used for the actor as a whole then the overloaded method setMassAndUpdateInertia() with a single mass parameter can be used instead.
     * 
     * @see updateMassAndInertia for more details.
     * 
     * @param [in,out]body The rigid body for which to set the mass and centre of mass local pose properties.
     * @param [in]shapeMasses The per shape mass values. There must be one entry for each shape which has the PxShapeFlag::eSIMULATION_SHAPE set. Other shapes are ignored. The mass values must be greater than 0.
     * @param [in]shapeMassCount The number of provided mass values.
     * @param [in]massLocalPose The center of mass relative to the actor frame. If set to null then (0,0,0) is assumed.
     * @param [in]includeNonSimShapes True if all kind of shapes (PxShapeFlag::eSCENE_QUERY_SHAPE, PxShapeFlag::eTRIGGER_SHAPE) should be taken into account.
     * @return Boolean. True on success else false.
     * 
     * @see PxRigidBody::setCMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
	 */
    static inline function setMassAndUpdateInertiaPerShape(body:PxRigidBody, shapeMasses:Array<PxReal>,
        ?massLocalPose:cpp.Struct<PxVec3>, includeNonSimShapes:Bool = false):Bool
    {
        return _setMassAndUpdateInertia(body, cpp.Pointer.ofArray(shapeMasses), shapeMasses.length, 
            cpp.Pointer.addressOf(massLocalPose).reinterpret(), includeNonSimShapes);
    }

	/**
     * Computation of mass properties for a rigid body actor
     * 
     * This method sets the mass, inertia and center of mass of a rigid body. The mass is set to the user-supplied
     * value, and the inertia and center of mass are computed according to the rigid body's shapes and the input mass.
     * 
     * If no collision shapes are found, the inertia tensor is set to (1,1,1)
     * 
     * See `setMassAndUpdateInertiaPerShape` for more details.
     * 
     * @param [in,out]body The rigid body for which to set the mass and centre of mass local pose properties.
     * @param [in]mass The mass of the body. Must be greater than 0.
     * @param [in]massLocalPose The center of mass relative to the actor frame. If set to null then (0,0,0) is assumed.
     * @param [in]includeNonSimShapes True if all kind of shapes (PxShapeFlag::eSCENE_QUERY_SHAPE, PxShapeFlag::eTRIGGER_SHAPE) should be taken into account.
     * @return Boolean. True on success else false.
     * 
     * @see PxRigidBody::setCMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
	 */
    static inline function setMassAndUpdateInertia(body:PxRigidBody, mass:PxReal,
        ?massLocalPose:cpp.Struct<PxVec3>, includeNonSimShapes:Bool = false):Bool
    {
        return _setMassAndUpdateInertia(body, mass,
            cpp.Pointer.addressOf(massLocalPose).reinterpret(), includeNonSimShapes);
    }


    
	/**
     * Compute the mass, inertia tensor and center of mass from a list of shapes.
     * 
     * @param [in]shapes The array of shapes to compute the mass properties from.
     * @return The mass properties from the combined shapes.
     * 
     * @see PxRigidBody::setCMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
	 */
    static inline function computeMassPropertiesFromShapes(shapes:Array<PxShape>):PxMassProperties
    {
        return untyped __cpp__(
            "physx::PxRigidBodyExt::computeMassPropertiesFromShapes(reinterpret_cast<const PxShape* const*>({0}), {1})",
            cpp.Pointer.ofArray(shapes), shapes.length);
    }
    	

	/**
     * Applies a force (or impulse) defined in the global coordinate frame, acting at a particular 
     * point in global coordinates, to the actor. 
     * 
     * Note that if the force does not act along the center of mass of the actor, this
     * will also add the corresponding torque. Because forces are reset at the end of every timestep, 
     * you can maintain a total external force on an object by calling this once every frame.
     * 
     * **Note:** if this call is used to apply a force or impulse to an articulation link, only the link is updated, not the entire
     * articulation
     * 
     * `mode` determines if the force is to be conventional or impulsive. Only `eFORCE` and `eIMPULSE` are supported, as the 
     * force required to produce a given velocity change or acceleration is underdetermined given only the desired change at a
     * given point.
     * 
     * **Sleeping:** This call wakes the actor if it is sleeping and the wakeup parameter is true (default).
     * 
     * @param body The rigid body to apply the force to.
     * @param force Force/impulse to add, defined in the global frame. **Range:** force vector
     * @param pos Position in the global frame to add the force at. **Range:** position vector
     * @param mode Default `eFORCE`. The mode to use when applying the force/impulse(see #PxForceMode). 
     * @param wakeup Default `true`. Specify if the call should wake up the actor.
     * 
     * @see PxForceMode 
     * @see addForceAtLocalPos() addLocalForceAtPos() addLocalForceAtLocalPos()
	 */
    @:native("physx::PxRigidBodyExt::addForceAtPos")
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3):Void {})
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode):Void {})
	static function addForceAtPos(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode, wakeup:Bool):Void;	

	/**
     * Applies a force (or impulse) defined in the actor local coordinate frame, acting at a 
     * particular point in global coordinates, to the actor. 
     * 
     * Note that if the force does not act along the center of mass of the actor, this
     * will also add the corresponding torque. Because forces are reset at the end of every timestep, you can maintain a
     * total external force on an object by calling this once every frame.
     * 
     * **Note:** if this call is used to apply a force or impulse to an articulation link, only the link is updated, not the entire
     * articulation
     * 
     * `mode` determines if the force is to be conventional or impulsive. Only `eFORCE` and `eIMPULSE` are supported, as the 
     * force required to produce a given velocity change or acceleration is underdetermined given only the desired change at a
     * given point.
     * 
     * **Sleeping:** This call wakes the actor if it is sleeping and the wakeup parameter is true (default).
     * 
     * @param body The rigid body to apply the force to.
     * @param force Force/impulse to add, defined in the local frame. **Range:** force vector
     * @param pos Position in the global frame to add the force at. **Range:** position vector
     * @param mode Default `eFORCE`. The mode to use when applying the force/impulse(see #PxForceMode). 
     * @param wakeup Default `true`. Specify if the call should wake up the actor.
     * 
     * @see PxForceMode 
     * @see addForceAtLocalPos() addLocalForceAtPos() addLocalForceAtLocalPos()
	 */
    @:native("physx::PxRigidBodyExt::addLocalForceAtPos")
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3):Void {})
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode):Void {})
    static function addLocalForceAtPos(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode, wakeup:Bool):Void;
    
	/**
     * Applies a force (or impulse) defined in the actor local coordinate frame, acting at a 
     * particular point in local coordinates, to the actor. 
     * 
     * Note that if the force does not act along the center of mass of the actor, this
     * will also add the corresponding torque. Because forces are reset at the end of every timestep, you can maintain a
     * total external force on an object by calling this once every frame.
     * 
     * **Note:** if this call is used to apply a force or impulse to an articulation link, only the link is updated, not the entire
     * articulation
     * 
     * `mode` determines if the force is to be conventional or impulsive. Only `eFORCE` and `eIMPULSE` are supported, as the 
     * force required to produce a given velocity change or acceleration is underdetermined given only the desired change at a
     * given point.
     * 
     * **Sleeping:** This call wakes the actor if it is sleeping and the wakeup parameter is true (default).
     * 
     * @param body The rigid body to apply the force to.
     * @param force Force/impulse to add, defined in the local frame. **Range:** force vector
     * @param pos Position in the local frame to add the force at. **Range:** position vector
     * @param mode Default `eFORCE`. The mode to use when applying the force/impulse(see #PxForceMode). 
     * @param wakeup Default `true`. Specify if the call should wake up the actor.
     * 
     * @see PxForceMode 
     * @see addForceAtLocalPos() addLocalForceAtPos() addLocalForceAtLocalPos()
	 */
    @:native("physx::PxRigidBodyExt::addLocalForceAtLocalPos")
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3):Void {})
    @:overload(function(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode):Void {})
    static function addLocalForceAtLocalPos(body:PxRigidBody, force:PxVec3, pos:PxVec3, mode:PxForceMode, wakeup:Bool):Void;
    

    
	/**
     * Computes the velocity of a point given in world coordinates if it were attached to the 
     * specified body and moving with it.
     * 
     * @param [in]body The rigid body the point is attached to.
     * @param [in]pos Position we wish to determine the velocity for, defined in the global frame. **Range:** position vector
     * @return The velocity of point in the global frame.
     * 
     * @see getLocalPointVelocity()
	 */
    @:native("physx::PxRigidBodyExt::getVelocityAtPos")
	static function getVelocityAtPos(body:PxRigidBody, pos:PxVec3):PxVec3;

	/**
     * Computes the velocity of a point given in local coordinates if it were attached to the 
     * specified body and moving with it.
     * 
     * @param [in]body The rigid body the point is attached to.
     * @param [in]pos Position we wish to determine the velocity for, defined in the local frame. **Range:** position vector
     * @return The velocity of point in the local frame.
     * 
     * @see getLocalPointVelocity()
	 */
    @:native("physx::PxRigidBodyExt::getLocalVelocityAtLocalPos")
    static function getLocalVelocityAtLocalPos(body:PxRigidBody, pos:PxVec3):PxVec3;
    
	/**
     * Computes the velocity of a point (offset from the origin of the body) given in world coordinates if it were attached to the 
     * specified body and moving with it.
     * 
     * @param [in]body The rigid body the point is attached to.
     * @param [in]pos Position (offset from the origin of the body) we wish to determine the velocity for, defined in the global frame. **Range:** position vector
     * @return The velocity of point (offset from the origin of the body) in the global frame.
     * 
     * @see getLocalPointVelocity()
	 */
    @:native("physx::PxRigidBodyExt::getVelocityAtOffset")
    static function getVelocityAtOffset(body:PxRigidBody, pos:PxVec3):PxVec3;
    


	/**
     * Performs a linear sweep through space with the body's geometry objects.
     * 
     * **Note:** Supported geometries are: box, sphere, capsule, convex. Other geometry types will be ignored.
     * **Note:** If eTOUCH is returned from the filter callback, it will trigger an error and the hit will be discarded.
     * 
     * The function sweeps all shapes attached to a given rigid body through space and reports the nearest
     * object in the scene which intersects any of of the shapes swept paths.
     * Information about the closest intersection is written to a #PxSweepHit structure.
     * 
     * @param [in]body The rigid body to sweep.
     * @param [in]scene The scene object to process the query.
     * @param [in]unitDir Normalized direction of the sweep.
     * @param [in]distance Sweep distance. Needs to be larger than 0.
     * @param [in]outputFlags Specifies which properties should be written to the hit information.
     * @param [out]closestHit Closest hit result.
     * @param [out]shapeIndex Index of the body shape that caused the closest hit.
     * @param [in]filterData If any word in filterData.data is non-zero then filterData.data will be used for filtering,
     * 						otherwise shape->getQueryFilterData() will be used instead.
     * @param [in]filterCall Custom filtering logic (optional). Only used if the corresponding #PxQueryFlag flags are set. If NULL, all hits are assumed to be blocking.
     * @param [in]cache		Cached hit shape (optional). Ray is tested against cached shape first then against the scene.
     * 						Note: Filtering is not executed for a cached shape if supplied; instead, if a hit is found, it is assumed to be a blocking hit.
     * @param [in]inflation	This parameter creates a skin around the swept geometry which increases its extents for sweeping. The sweep will register a hit as soon as the skin touches a shape, and will return the corresponding distance and normal.
     * 
     * @return True if a blocking hit was found.
     * 
     * @see PxScene PxQueryFlags PxFilterData PxBatchQueryPreFilterShader PxBatchQueryPostFilterShader PxSweepHit
	 */
    @:native("physx::PxRigidBodyExt::linearSweepSingle")
    @:overload(function(body:PxRigidBody, scene:PxScene, unitDir:PxVec3, distance:PxReal,
                        outputFlags:PxHitFlags,
                        closestHit:cpp.Reference<PxSweepHit>, shapeIndex:cpp.Reference<PxU32>):Bool {})
	static function linearSweepSingle(
        body:PxRigidBody, scene:PxScene, unitDir:PxVec3, distance:PxReal,
        outputFlags:PxHitFlags,
        closestHit:cpp.Reference<PxSweepHit>, shapeIndex:cpp.Reference<PxU32>,
        filterData:PxQueryFilterData, ?filterCall:PxQueryFilterCallback,
        ?cache:cpp.ConstPointer<PxQueryCache>, inflation:PxReal = 0):Bool;

    /**
     * Performs a linear sweep through space with the body's geometry objects, returning all overlaps.
     * 
     * **Note:** Supported geometries are: box, sphere, capsule, convex. Other geometry types will be ignored.
     * 
     * This function sweeps all shapes attached to a given rigid body through space and reports all
     * objects in the scene that intersect any of the shapes' swept paths until there are no more objects to report
     * or a blocking hit is encountered.
     * 
     * @param [in]body The rigid body to sweep.
     * @param [in]scene The scene object to process the query.
     * @param [in]unitDir Normalized direction of the sweep.
     * @param [in]distance Sweep distance. Needs to be larger than 0.
     * @param [in]outputFlags		Specifies which properties should be written to the hit information.
     * @param [out]touchHitBuffer	Raycast hit information buffer. If the buffer overflows, an arbitrary subset of touch hits
     *     is returned (typically the query should be restarted with a larger buffer).
     * @param [out]touchHitShapeIndices After the query is completed, touchHitShapeIndices[i] will contain the body index that caused the hit stored in hitBuffer[i]
     * @param [in]touchHitBufferSize	Size of both touch hit buffers in elements.
     * @param [out]block	Closest blocking hit is returned via this reference.
     * @param [out]blockingShapeIndex	Set to -1 if if a blocking hit was not found, otherwise set to closest blocking hit shape index. The touching hits are reported separately in hitBuffer.
     * @param [out]overflow	Set to true if touchHitBuffer didn't have enough space for all results. Touch hits will be incomplete if overflow occurred. Possible solution is to restart the query with a larger buffer.
     * @param [in]filterData	If any word in filterData.data is non-zero then filterData.data will be used for filtering,
     * otherwise shape->getQueryFilterData() will be used instead.
     * @param [in]filterCall	Custom filtering logic (optional). Only used if the corresponding #PxQueryFlag flags are set. If NULL, all hits are assumed to be blocking.
     * @param [in]cache		Cached hit shape (optional). Ray is tested against cached shape first then against the scene.
     * Note: Filtering is not executed for a cached shape if supplied; instead, if a hit is found, it is assumed to be a blocking hit.
     * @param [in]inflation	This parameter creates a skin around the swept geometry which increases its extents for sweeping. The sweep will register a hit as soon as the skin touches a shape, and will return the corresponding distance and normal.
     * 
     * @return the number of touching hits. If overflow is set to true, the results are incomplete. In case of overflow there are also no guarantees that all touching hits returned are closer than the blocking hit.
     * 
     * @see PxScene PxQueryFlags PxFilterData PxBatchQueryPreFilterShader PxBatchQueryPostFilterShader PxSweepHit
     */
    @:native("physx::PxRigidBodyExt::linearSweepMultiple")
    @:overload(function(body:PxRigidBody, scene:PxScene, unitDir:PxVec3, distance:PxReal,
                        outputFlags:PxHitFlags,
                        touchHitBuffer:cpp.Pointer<PxSweepHit>, touchHitShapeIndices:cpp.Pointer<PxU32>, touchHitBufferSize:PxU32,
                        block:cpp.Reference<PxSweepHit>, blockingShapeIndex:cpp.Reference<PxI32>, overflow:cpp.Reference<Bool>):Bool {})
	static function linearSweepMultiple(
        body:PxRigidBody, scene:PxScene, unitDir:PxVec3, distance:PxReal,
        outputFlags:PxHitFlags,
        touchHitBuffer:cpp.Pointer<PxSweepHit>, touchHitShapeIndices:cpp.Pointer<PxU32>, touchHitBufferSize:PxU32,
        block:cpp.Reference<PxSweepHit>, blockingShapeIndex:cpp.Reference<PxI32>, overflow:cpp.Reference<Bool>,
        filterData:PxQueryFilterData, ?filterCall:PxQueryFilterCallback,
        ?cache:cpp.ConstPointer<PxQueryCache>, inflation:PxReal = 0):PxU32;



	/**
     * Compute the change to linear and angular velocity that would occur if an impulsive force and torque were to be applied to a specified rigid body. 
     * 
     * The rigid body is left unaffected unless a subsequent independent call is executed that actually applies the computed changes to velocity and angular velocity.
     * 
     * **Note:** if this call is used to determine the velocity delta for an articulation link, only the mass properties of the link are taken into account.
     * 
     * @see PxRigidBody::getLinearVelocity, PxRigidBody::setLinearVelocity,  PxRigidBody::getAngularVelocity, PxRigidBody::setAngularVelocity 
     * 
     * @param [in]body The body under consideration.
     * @param [in]impulsiveForce The impulsive force that would be applied to the specified rigid body.
     * @param [in]impulsiveTorque The impulsive torque that would be applied to the specified rigid body.
     * @param [out]deltaLinearVelocity The change in linear velocity that would arise if impulsiveForce was to be applied to the specified rigid body.
     * @param [out]deltaAngularVelocity The change in angular velocity that would arise if impulsiveTorque was to be applied to the specified rigid body.
	 */
    @:native("physx::PxRigidBodyExt::computeVelocityDeltaFromImpulse")
    static function computeVelocityDeltaFromImpulse(body:PxRigidBody, impulsiveForce:PxVec3, impulsiveTorque:PxVec3,
        deltaLinearVelocity:cpp.Reference<PxVec3>, deltaAngularVelocity:cpp.Reference<PxVec3>):Void;

	/**
     * Computes the linear and angular velocity change vectors for a given impulse at a world space position taking a mass and inertia scale into account
     * 
     * This function is useful for extracting the respective linear and angular velocity changes from a contact or joint when the mass/inertia ratios have been adjusted.
     * 
     * **Note:** if this call is used to determine the velocity delta for an articulation link, only the mass properties of the link are taken into account.
     * 
     * @param [in]body The rigid body
     * @param [in]globalPose The body's world space transform
     * @param [in]point The point in world space where the impulse is applied
     * @param [in]impulse The impulse vector in world space
     * @param [in]invMassScale The inverse mass scale
     * @param [in]invInertiaScale The inverse inertia scale
     * @param [out]deltaLinearVelocity The linear velocity change
     * @param [out]deltaAngularVelocity The angular velocity change
	 */
    @:native("physx::PxRigidBodyExt::computeVelocityDeltaFromImpulse")
    static function computeVelocityDeltaFromImpulseAt(body:PxRigidBody, globalPose:PxTransform, point:PxVec3, impulse:PxVec3,
        invMassScale:PxReal, invInertiaScale:PxReal, deltaLinearVelocity:cpp.Reference<PxVec3>, deltaAngularVelocity:cpp.Reference<PxVec3>):Void;

	/**
     * Computes the linear and angular impulse vectors for a given impulse at a world space position taking a mass and inertia scale into account
     * 
     * This function is useful for extracting the respective linear and angular impulses from a contact or joint when the mass/inertia ratios have been adjusted.
     * 
     * @param [in]body The rigid body
     * @param [in]globalPose The body's world space transform
     * @param [in]point The point in world space where the impulse is applied
     * @param [in]impulse The impulse vector in world space
     * @param [in]invMassScale The inverse mass scale
     * @param [in]invInertiaScale The inverse inertia scale
     * @param [out]linearImpulse The linear impulse
     * @param [out]angularImpulse The angular impulse
	 */
    @:native("physx::PxRigidBodyExt::computeLinearAngularImpulse")
    static function computeLinearAngularImpulse(body:PxRigidBody, globalPose:PxTransform, point:PxVec3, impulse:PxVec3,
        invMassScale:PxReal, invInertiaScale:PxReal, linearImpulse:cpp.Reference<PxVec3>, angularImpulse:cpp.Reference<PxVec3>):Void;
    
}