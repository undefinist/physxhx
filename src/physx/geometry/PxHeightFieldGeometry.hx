package physx.geometry;

import physx.common.PxCoreUtilityTypes.PxPadding3;
import physx.geometry.PxTriangleMeshGeometry.PxMeshGeometryFlags;
import physx.foundation.PxSimpleTypes;

/**
\brief Height field geometry class.

This class allows to create a scaled height field geometry instance.

There is a minimum allowed value for Y and XZ scaling - PX_MIN_HEIGHTFIELD_XZ_SCALE, heightfield creation will fail if XZ value is below this value.
*/
@:include("geometry/PxHeightFieldGeometry.h")
@:native("physx::PxHeightFieldGeometry")
@:structAccess
extern class PxHeightFieldGeometry extends PxGeometry
{
	/**
	\brief The height field data.
	*/
	var heightField:PxHeightField;

	/**
	\brief The scaling factor for the height field in vertical direction (y direction in local space).
	*/
	var heightScale:PxReal;

	/**
	\brief The scaling factor for the height field in the row direction (x direction in local space).
	*/
	var rowScale:PxReal;

	/**
	\brief The scaling factor for the height field in the column direction (z direction in local space).
	*/
	var columnScale:PxReal;

	/**
	\brief Flags to specify some collision properties for the height field.
	*/
	var heightFieldFlags:PxMeshGeometryFlags;

	/**
	 * padding for mesh flags.
	 */
	var paddingFromFlags:PxPadding3;
	
	/**
	\brief Returns true if the geometry is valid.

	\return True if the current settings are valid

	**Note:** A valid height field has a positive scale value in each direction (heightScale > 0, rowScale > 0, columnScale > 0).
	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a height field that has zero extents in any direction.

	@see PxRigidActor::createShape, PxPhysics::createShape
	*/
	function isValid():Bool;
}

// {
// public:
// 	PX_INLINE PxHeightFieldGeometry() :		
// 		PxGeometry		(PxGeometryType::eHEIGHTFIELD),
// 		heightField		(NULL),
// 		heightScale		(1.0f), 
// 		rowScale		(1.0f), 
// 		columnScale		(1.0f), 
// 		heightFieldFlags(0)
// 	{}

// 	PX_INLINE PxHeightFieldGeometry(PxHeightField* hf,
// 									PxMeshGeometryFlags flags, 
// 									PxReal heightScale_,
// 									PxReal rowScale_, 
// 									PxReal columnScale_) :
// 		PxGeometry			(PxGeometryType::eHEIGHTFIELD), 
// 		heightField			(hf) ,
// 		heightScale			(heightScale_), 
// 		rowScale			(rowScale_), 
// 		columnScale			(columnScale_), 
// 		heightFieldFlags	(flags)
// 		{
// 		}

// 	/**
// 	\brief Returns true if the geometry is valid.

// 	\return True if the current settings are valid

// 	**Note:** A valid height field has a positive scale value in each direction (heightScale > 0, rowScale > 0, columnScale > 0).
// 	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a height field that has zero extents in any direction.

// 	@see PxRigidActor::createShape, PxPhysics::createShape
// 	*/
// 	PX_INLINE bool isValid() const;

// public:

// };