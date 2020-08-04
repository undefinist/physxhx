package physx.geometry;

import physx.foundation.PxSimpleTypes;

/**
\brief Class representing the geometry of a capsule.

Capsules are shaped as the union of a cylinder of length 2 * halfHeight and with the 
given radius centered at the origin and extending along the x axis, and two hemispherical ends.
**Note:** The scaling of the capsule is expected to be baked into these values, there is no additional scaling parameter.

The function PxTransformFromSegment is a helper for generating an appropriate transform for the capsule from the capsule's interior line segment.

@see PxTransformFromSegment
*/
@:forward
extern abstract PxCapsuleGeometry(PxCapsuleGeometryData) from PxCapsuleGeometryData to PxCapsuleGeometryData
{
	/**
	 * Constructor, initializes to a capsule with passed radius and half height.
	 */
    inline function new(radius:PxReal = 0, halfHeight:PxReal = 0)
    {
        this = PxCapsuleGeometryData.create(radius, halfHeight);
    }
}

@:include("geometry/PxCapsuleGeometry.h")
@:native("physx::PxCapsuleGeometry")
@:structAccess
private extern class PxCapsuleGeometryData extends PxGeometry 
{
    /**
    \brief The radius of the capsule.
    */
    var radius:PxReal;

    /**
    \brief half of the capsule's height, measured between the centers of the hemispherical ends.
    */
    var halfHeight:PxReal;

	/**
	\brief Constructor, initializes to a capsule with passed radius and half height.
	*/
    @:native("physx::PxCapsuleGeometry")
    @:overload(function():PxCapsuleGeometryData {})
    static function create(radius:PxReal, halfHeight:PxReal):PxCapsuleGeometryData;

	/**
	\brief Returns true if the geometry is valid.

	\return True if the current settings are valid.

	**Note:** A valid capsule has radius > 0, halfHeight > 0.
	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a capsule that has zero radius or height.

	@see PxRigidActor::createShape, PxPhysics::createShape
	*/
    function isValid():Bool;
}