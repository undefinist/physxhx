package physx.geometry;

import physx.foundation.PxSimpleTypes.PxReal;

/**
A class representing the geometry of a sphere.

Spheres are defined by their radius.
**Note:** The scaling of the sphere is expected to be baked into this value, there is no additional scaling parameter.
*/
@:forward
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
    The radius of the sphere.
    */
    var radius:PxReal;

    @:native("physx::PxSphereGeometry")
    static function create(ir:PxReal = 0):PxSphereGeometry;

    /**
    Returns true if the geometry is valid.

    @return True if the current settings are valid

    **Note:** A valid sphere has radius > 0.  
    It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a sphere that has zero radius.

    @see PxRigidActor::createShape, PxPhysics::createShape
    */
    function isValid():Bool;
}