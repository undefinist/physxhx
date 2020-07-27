package physx.geometry;

import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;

/**
\brief Class representing the geometry of a box.  

The geometry of a box can be fully specified by its half extents.  This is the half of its width, height, and depth.
\note The scaling of the box is expected to be baked into these values, there is no additional scaling parameter.
*/
@:forward
@:forwardStatics
extern abstract PxBoxGeometry(PxBoxGeometryData) from PxBoxGeometryData to PxBoxGeometryData
{
	/**
	 * Constructor to initialize half extents from scalar parameters.
	 * @see `PxBoxGeometry.create()`
	 */
	inline function new(hx:PxReal = 0, hy:PxReal = 0, hz:PxReal = 0)
	{
		this = PxBoxGeometryData.create(hx, hy, hz);
	}
}

@:include("geometry/PxBoxGeometry.h")
@:native("physx::PxBoxGeometry")
@:structAccess
private extern class PxBoxGeometryData extends PxGeometry
{
	var halfExtents:PxVec3;

	/**
	 * Constructor
	 * 
	 * - `create()` : Default constructor, initializes to a box with zero dimensions.
	 * - `create(hx, hy, hz)` : Constructor to initialize half extents from scalar parameters.
	 * - `create(halfExtents)` : Constructor to initialize half extents from a vector parameter.
	*/
	@:native("physx::PxBoxGeometry")
	@:overload(function():PxBoxGeometry {})
	@:overload(function(halfExtents:PxVec3):PxBoxGeometry {})
	static function create(hx:PxReal, hy:PxReal, hz:PxReal):PxBoxGeometry;

	/**
	\brief Returns true if the geometry is valid.

	\return True if the current settings are valid

	\note A valid box has a positive extent in each direction (halfExtents.x > 0, halfExtents.y > 0, halfExtents.z > 0). 
	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a box that has zero extent in any direction.

	@see PxRigidActor::createShape, PxPhysics::createShape
	*/
	function isValid():Bool;
}