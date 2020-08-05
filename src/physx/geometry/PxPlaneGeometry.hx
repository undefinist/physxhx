package physx.geometry;

/**
Class describing a plane geometry.

The plane geometry specifies the half-space volume x<=0. As with other geometry types, 
when used in a PxShape the collision volume is obtained by transforming the halfspace 
by the shape local pose and the actor global pose.

To generate a PxPlane from a PxTransform, transform PxPlane(1,0,0,0).

To generate a PxTransform from a PxPlane, use PxTransformFromPlaneEquation.

@see PxShape.setGeometry() PxShape.getPlaneGeometry() PxTransformFromPlaneEquation 
*/
@:forward
extern abstract PxPlaneGeometry(PxPlaneGeometryData) from PxPlaneGeometryData to PxPlaneGeometryData
{
    inline function new()
    {
        this = cast PxPlaneGeometryData.create();
    }
}

@:include("geometry/PxPlaneGeometry.h")
@:native("physx::PxPlaneGeometry")
@:structAccess
private extern class PxPlaneGeometryData extends PxGeometry
{
    @:native("physx::PxPlaneGeometry")
    static function create():PxPlaneGeometry;

	/**
	Returns true if the geometry is valid.

	@return True if the current settings are valid
	*/
	function isValid():Bool;
}