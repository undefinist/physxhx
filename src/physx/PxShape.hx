package physx;

import physx.foundation.PxBase;
import physx.foundation.PxSimpleTypes;
import physx.geometry.PxGeometry;
import physx.geometry.PxGeometryHelpers;
import physx.geometry.PxBoxGeometry;
import physx.geometry.PxCapsuleGeometry;
import physx.geometry.PxConvexMeshGeometry;
import physx.geometry.PxHeightFieldGeometry;
import physx.geometry.PxPlaneGeometry;
import physx.geometry.PxSphereGeometry;
import physx.geometry.PxTriangleMeshGeometry;
import physx.foundation.PxTransform;
import physx.PxFiltering;

/**
\brief Flags which affect the behavior of PxShapes.

@see PxShape PxShape.setFlag()
*/
extern enum abstract PxShapeFlag(PxShapeFlagImpl)
{
    /**
    \brief The shape will partake in collision in the physical simulation.

    \note It is illegal to raise the eSIMULATION_SHAPE and eTRIGGER_SHAPE flags.
    In the event that one of these flags is already raised the sdk will reject any 
    attempt to raise the other.  To raise the eSIMULATION_SHAPE first ensure that 
    eTRIGGER_SHAPE is already lowered.

    \note This flag has no effect if simulation is disabled for the corresponding actor (see #PxActorFlag::eDISABLE_SIMULATION).

    @see PxSimulationEventCallback.onContact() PxScene.setSimulationEventCallback() PxShape.setFlag(), PxShape.setFlags()
    */
    @:native("physx::PxShapeFlag::eSIMULATION_SHAPE") var eSIMULATION_SHAPE;

    /**
    \brief The shape will partake in scene queries (ray casts, overlap tests, sweeps, ...).
    */
    @:native("physx::PxShapeFlag::eSCENE_QUERY_SHAPE") var eSCENE_QUERY_SHAPE;

    /**
    \brief The shape is a trigger which can send reports whenever other shapes enter/leave its volume.

    \note Triangle meshes and heightfields can not be triggers. Shape creation will fail in these cases.

    \note Shapes marked as triggers do not collide with other objects. If an object should act both
    as a trigger shape and a collision shape then create a rigid body with two shapes, one being a 
    trigger shape and the other a collision shape. 	It is illegal to raise the eTRIGGER_SHAPE and 
    eSIMULATION_SHAPE flags on a single PxShape instance.  In the event that one of these flags is already 
    raised the sdk will reject any attempt to raise the other.  To raise the eTRIGGER_SHAPE flag first 
    ensure that eSIMULATION_SHAPE flag is already lowered.

    \note Trigger shapes will no longer send notification events for interactions with other trigger shapes.

    \note Shapes marked as triggers are allowed to participate in scene queries, provided the eSCENE_QUERY_SHAPE flag is set. 

    \note This flag has no effect if simulation is disabled for the corresponding actor (see #PxActorFlag::eDISABLE_SIMULATION).

    @see PxSimulationEventCallback.onTrigger() PxScene.setSimulationEventCallback() PxShape.setFlag(), PxShape.setFlags()
    */
    @:native("physx::PxShapeFlag::eTRIGGER_SHAPE") var eTRIGGER_SHAPE;

    /**
    \brief Enable debug renderer for this shape

    @see PxScene.getRenderBuffer() PxRenderBuffer PxVisualizationParameter
    */
	@:native("physx::PxShapeFlag::eVISUALIZATION") var eVISUALIZATION;
	
	@:op(A | B)
    private inline function or(flag:PxShapeFlag):PxShapeFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
	}
}

@:include("PxShape.h")
@:native("physx::PxShapeFlags")
private extern class PxShapeFlagImpl {}

/**
\brief collection of set bits defined in PxShapeFlag.

@see PxShapeFlag
*/
extern abstract PxShapeFlags(PxShapeFlag) from PxShapeFlag to PxShapeFlag {}


/**
\brief Abstract class for collision shapes.

Shapes are shared, reference counted objects.

An instance can be created by calling the createShape() method of the PxRigidActor class, or
the createShape() method of the PxPhysics class.

### Visualizations
- PxVisualizationParameter::eCOLLISION_AABBS
- PxVisualizationParameter::eCOLLISION_SHAPES
- PxVisualizationParameter::eCOLLISION_AXES

@see PxPhysics.createShape() PxRigidActor.createShape() PxBoxGeometry PxSphereGeometry PxCapsuleGeometry PxPlaneGeometry PxConvexMeshGeometry
PxTriangleMeshGeometry PxHeightFieldGeometry
*/
@:include("PxShape.h")
@:native("::cpp::Reference<physx::PxShape>")
extern class PxShape extends PxBase
{
	/**
	\brief Decrements the reference count of a shape and releases it if the new reference count is zero.

	Note that in releases prior to PhysX 3.3 this method did not have reference counting semantics and was used to destroy a shape 
	created with PxActor::createShape(). In PhysX 3.3 and above, this usage is deprecated, instead, use PxRigidActor::detachShape() to detach
	a shape from an actor. If the shape to be detached was created with PxActor::createShape(), the actor holds the only counted reference,
	and so when the shape is detached it will also be destroyed. 

	@see PxRigidActor::createShape() PxPhysics::createShape() PxRigidActor::attachShape() PxRigidActor::detachShape()
    */
    
	function release():Void;

	/**
	\brief Returns the reference count of the shape.

	At creation, the reference count of the shape is 1. Every actor referencing this shape increments the
	count by 1.	When the reference count reaches 0, and only then, the shape gets destroyed automatically.

	\return the current reference count.
	*/
	function getReferenceCount():PxU32;

	/**
	\brief Acquires a counted reference to a shape.

	This method increases the reference count of the shape by 1. Decrement the reference count by calling release()
	*/
	function acquireReference():Void;

	/**
	\brief Get the geometry type of the shape.

	\return Type of shape geometry.

	@see PxGeometryType
	*/
	function getGeometryType():PxGeometryType;

	/**
	\brief Adjust the geometry of the shape.

	\note The type of the passed in geometry must match the geometry type of the shape.
	\note It is not allowed to change the geometry type of a shape.
	\note This function does not guarantee correct/continuous behavior when objects are resting on top of old or new geometry.

	\param[in] geometry New geometry of the shape.

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function setGeometry(geometry:PxGeometry):Void;


	/**
	\brief Retrieve the geometry from the shape in a PxGeometryHolder wrapper class.

	\return a PxGeometryHolder object containing the geometry;
	
	@see PxGeometry PxGeometryType getGeometryType() setGeometry()
	*/

	function getGeometry():PxGeometryHolder;


	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getBoxGeometry(geometry:PxBoxGeometry):Bool;

	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getSphereGeometry(geometry:PxSphereGeometry):Bool;

	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getCapsuleGeometry(geometry:PxCapsuleGeometry):Bool;

	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getPlaneGeometry(geometry:PxPlaneGeometry):Bool;

	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getConvexMeshGeometry(geometry:PxConvexMeshGeometry):Bool;

	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getTriangleMeshGeometry(geometry:PxTriangleMeshGeometry):Bool;


	/**
	\brief Fetch the geometry of the shape.

	\note If the type of geometry to extract does not match the geometry type of the shape
	then the method will return false and the passed in geometry descriptor is not modified.

	\param[in] geometry The descriptor to save the shape's geometry data to.
	\return True on success else false

	@see PxGeometry PxGeometryType getGeometryType()
	*/
	function getHeightFieldGeometry(geometry:PxHeightFieldGeometry):Bool;

	/**
	\brief Retrieves the actor which this shape is associated with.

	\return The actor this shape is associated with, if it is an exclusive shape, else NULL

	@see PxRigidStatic, PxRigidDynamic, PxArticulationLink
    */
    function getActor():cpp.Pointer<PxRigidActor>;


/************************************************************************************************/

/** @name Pose Manipulation
*/
//@{

	/**
	\brief Sets the pose of the shape in actor space, i.e. relative to the actors to which they are attached.
	
	This transformation is identity by default.

	The local pose is an attribute of the shape, and so will apply to all actors to which the shape is attached.

	<b>Sleeping:</b> Does <b>NOT</b> wake the associated actor up automatically.

	<i>Note:</i> Does not automatically update the inertia properties of the owning actor (if applicable); use the
	PhysX extensions method #PxRigidBodyExt::updateMassAndInertia() to do this.

	<b>Default:</b> the identity transform

	\param[in] pose	The new transform from the actor frame to the shape frame. <b>Range:</b> rigid body transform

	@see getLocalPose() 
	*/
	function setLocalPose(pose:PxTransform):Void;

	/**
	\brief Retrieves the pose of the shape in actor space, i.e. relative to the actor they are owned by.

	This transformation is identity by default.

	\return Pose of shape relative to the actor's frame.

	@see setLocalPose() 
	*/
	function getLocalPose():PxTransform;

//@}
/************************************************************************************************/

/** @name Collision Filtering
*/
//@{

	/**
	\brief Sets the user definable collision filter data.
	
	<b>Sleeping:</b> Does wake up the actor if the filter data change causes a formerly suppressed
	collision pair to be enabled.

	<b>Default:</b> (0,0,0,0)

	@see getSimulationFilterData() 
	*/
	function setSimulationFilterData(data:PxFilterData):Void;

	/**
	\brief Retrieves the shape's collision filter data.

	@see setSimulationFilterData() 
	*/
	function getSimulationFilterData():PxFilterData;

	/**
	\brief Sets the user definable query filter data.

	<b>Default:</b> (0,0,0,0)

	@see getQueryFilterData() 
	*/
	function setQueryFilterData(data:PxFilterData):Void;

	/**
	\brief Retrieves the shape's Query filter data.

	@see setQueryFilterData() 
	*/
	function getQueryFilterData():PxFilterData;

//@}
/************************************************************************************************/

	@:native("setMaterials") private function _setMaterials(materials:cpp.RawPointer<cpp.RawConstPointer<PxMaterial>>, materialCount:PxU16):Void;
	/**
	\brief Assigns material(s) to the shape.
	
	<b>Sleeping:</b> Does <b>NOT</b> wake the associated actor up automatically.

	\param[in] materials List of material pointers to assign to the shape. See #PxMaterial
	\param[in] materialCount The number of materials provided.

	@see PxPhysics.createMaterial() getMaterials() 
	*/
    inline function setMaterials(materials:Array<PxMaterial>):Void
    {
        var pMats:Array<cpp.RawConstPointer<PxMaterial>> = [];
        for (m in materials)
            pMats.push(cpp.RawConstPointer.addressOf(m));

        _setMaterials(cpp.Pointer.ofArray(pMats).raw, pMats.length);
	}
	
	/**
	\brief Returns the number of materials assigned to the shape.

	You can use #getMaterials() to retrieve the material pointers.

	\return Number of materials associated with this shape.

	@see PxMaterial getMaterials()
	*/
	function getNbMaterials():PxU16;

	/**
	\brief Retrieve all the material pointers associated with the shape.

	You can retrieve the number of material pointers by calling #getNbMaterials()

	Note: Removing materials with #PxMaterial::release() will invalidate the pointer of the released material.

	\param[out] userBuffer The buffer to store the material pointers.
	\param[in] bufferSize Size of provided user buffer.
	\param[in] startIndex Index of first material pointer to be retrieved
	\return Number of material pointers written to the buffer.

	@see PxMaterial getNbMaterials() PxMaterial::release()
	*/
    inline function getMaterials(userBuffer:Array<PxMaterial>, startIndex:PxU32 = 0):Void
    {

    }
	
	/**
	\brief Retrieve material from given triangle index.

	The input index is the internal triangle index as used inside the SDK. This is the index
	returned to users by various SDK functions such as raycasts.
	
	This function is only useful for triangle meshes or heightfields, which have per-triangle
	materials. For other shapes the function returns the single material associated with the
	shape, regardless of the index.

	\param[in] faceIndex The internal triangle index whose material you want to retrieve.
	\return Material from input triangle

	\note If faceIndex value of 0xFFFFffff is passed as an input for mesh and heightfield shapes, this function will issue a warning and return NULL.
	\note Scene queries set the value of PxQueryHit::faceIndex to 0xFFFFffff whenever it is undefined or does not apply.

	@see PxMaterial getNbMaterials() PxMaterial::release()
	*/
	function getMaterialFromInternalFaceIndex(faceIndex:PxU32):PxMaterial;

	/**
	\brief Sets the contact offset.

	Shapes whose distance is less than the sum of their contactOffset values will generate contacts. The contact offset must be positive and
	greater than the rest offset. Having a contactOffset greater than than the restOffset allows the collision detection system to
	predictively enforce the contact constraint even when the objects are slightly separated. This prevents jitter that would occur
	if the constraint were enforced only when shapes were within the rest distance.

	<b>Default:</b> 0.02f * PxTolerancesScale::length

	<b>Sleeping:</b> Does <b>NOT</b> wake the associated actor up automatically.

	\param[in] contactOffset <b>Range:</b> [maximum(0,restOffset), PX_MAX_F32)

	@see getContactOffset PxTolerancesScale setRestOffset
	*/
	function setContactOffset(contactOffset:PxReal):Void;

	/**
	\brief Retrieves the contact offset. 

	\return The contact offset of the shape.

	@see setContactOffset()
	*/
	function getContactOffset():PxReal;

	/**
	\brief Sets the rest offset. 

	Two shapes will come to rest at a distance equal to the sum of their restOffset values. If the restOffset is 0, they should converge to touching 
	exactly.  Having a restOffset greater than zero is useful to have objects slide smoothly, so that they do not get hung up on irregularities of 
	each others' surfaces.

	<b>Default:</b> 0.0f

	<b>Sleeping:</b> Does <b>NOT</b> wake the associated actor up automatically.

	\param[in] restOffset	<b>Range:</b> (-PX_MAX_F32, contactOffset)

	@see getRestOffset setContactOffset
	*/
	function setRestOffset(restOffset:PxReal):Void;

	/**
	\brief Retrieves the rest offset. 

	\return The rest offset of the shape.

	@see setRestOffset()
	*/
	function getRestOffset():PxReal;


	/**
	\brief Sets torsional patch radius.
	
	This defines the radius of the contact patch used to apply torsional friction. If the radius is 0, no torsional friction
	will be applied. If the radius is > 0, some torsional friction will be applied. This is proportional to the penetration depth
	so, if the shapes are separated or penetration is zero, no torsional friction will be applied. It is used to approximate 
	rotational friction introduced by the compression of contacting surfaces.

	\param[in] radius	<b>Range:</b> (0, PX_MAX_F32)

	*/
	function setTorsionalPatchRadius(radius:PxReal):Void;

	/**
	\brief Gets torsional patch radius.

	This defines the radius of the contact patch used to apply torsional friction. If the radius is 0, no torsional friction
	will be applied. If the radius is > 0, some torsional friction will be applied. This is proportional to the penetration depth
	so, if the shapes are separated or penetration is zero, no torsional friction will be applied. It is used to approximate
	rotational friction introduced by the compression of contacting surfaces.

	\return The torsional patch radius of the shape.
	*/
	function getTorsionalPatchRadius():PxReal;

	/**
	\brief Sets minimum torsional patch radius.

	This defines the minimum radius of the contact patch used to apply torsional friction. If the radius is 0, the amount of torsional friction
	that will be applied will be entirely dependent on the value of torsionalPatchRadius. 
	
	If the radius is > 0, some torsional friction will be applied regardless of the value of torsionalPatchRadius or the amount of penetration.

	\param[in] radius	<b>Range:</b> (0, PX_MAX_F32)

	*/
	function setMinTorsionalPatchRadius(radius:PxReal):Void;

	/**
	\brief Gets minimum torsional patch radius.

	This defines the minimum radius of the contact patch used to apply torsional friction. If the radius is 0, the amount of torsional friction
	that will be applied will be entirely dependent on the value of torsionalPatchRadius. 
	
	If the radius is > 0, some torsional friction will be applied regardless of the value of torsionalPatchRadius or the amount of penetration.

	\return The minimum torsional patch radius of the shape.
	*/
	function getMinTorsionalPatchRadius():PxReal;


/************************************************************************************************/

	/**
	\brief Sets shape flags

	<b>Sleeping:</b> Does <b>NOT</b> wake the associated actor up automatically.

	\param[in] flag The shape flag to enable/disable. See #PxShapeFlag.
	\param[in] value True to set the flag. False to clear the flag specified in flag.

	<b>Default:</b> PxShapeFlag::eVISUALIZATION | PxShapeFlag::eSIMULATION_SHAPE | PxShapeFlag::eSCENE_QUERY_SHAPE

	@see PxShapeFlag getFlags()
	*/
	function setFlag(flag:PxShapeFlag, value:Bool):Void;

	/**
	\brief Sets shape flags

	@see PxShapeFlag getFlags()
	*/
	function setFlags(inFlags:PxShapeFlags):Void;

	/**
	\brief Retrieves shape flags.

	\return The values of the shape flags.

	@see PxShapeFlag setFlag()
	*/
	function getFlags():PxShapeFlags;

	/**
	\brief Returns true if the shape is exclusive to an actor.
	
	@see PxPhysics::createShape()
	*/
	function isExclusive():Bool;

	/**
	\brief Sets a name string for the object that can be retrieved with #getName().
	
	This is for debugging and is not used by the SDK.
	The string is not copied by the SDK, only the pointer is stored.

	<b>Default:</b> NULL
	
	\param[in] name The name string to set the objects name to.

	@see getName()
	*/
	function setName(name:String):Void;

	/**
	\brief retrieves the name string set with setName().
	\return The name associated with the shape.

	@see setName()
	*/
	function getName():String;

/************************************************************************************************/

	/**
     * user can assign this to whatever, usually to create a 1:1 relationship with a user object.
	 */
	public var userData:physx.hx.PxUserData;
}