package physx.geometry;

import physx.foundation.PxSimpleTypes.PxReal;

/**
\brief A class representing the geometry of a sphere.

Spheres are defined by their radius.
\note The scaling of the sphere is expected to be baked into this value, there is no additional scaling parameter.
*/
@:forward
@:forwardStatics
extern abstract PxSphereGeometry(PxSphereGeometryData) from PxSphereGeometryData to PxSphereGeometryData
{
    inline function new(ir:PxReal = 0)
    {
        this = cast PxSphereGeometryData.create(ir);
    }
}

@:include("geometry/PxSphereGeometry.h")
@:native("physx::PxSphereGeometry")
@:structAccess
private extern class PxSphereGeometryData extends PxGeometry
{
    /**
    \brief The radius of the sphere.
    */
    var radius:PxReal;

    @:native("physx::PxSphereGeometry")
    static function create(ir:PxReal = 0):PxSphereGeometry;

    /**
    \brief Returns true if the geometry is valid.

    \return True if the current settings are valid

    \note A valid sphere has radius > 0.  
    It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a sphere that has zero radius.

    @see PxRigidActor::createShape, PxPhysics::createShape
    */
    function isValid():Bool;
}