package physx.foundation;

/**
\brief Representation of a plane.

 Plane equation used: n.dot(v) + d = 0
*/
@:forward
@:forwardStatics
extern abstract PxPlane(PxPlaneData)
{
    /**
     * Constructor from a normal and a distance. For alternative constructors, see `PxPlane.create()`.
     * @param nx normal x
     * @param ny normal y
     * @param nz normal z
     * @param distance 
     */
    inline function new(nx:Float, ny:Float, nz:Float, distance:Float = 0)
    {
        this = PxPlaneData.create(nx, ny, nz, distance);
    }
}

@:include("foundation/PxPlane.h")
@:native("physx::PxPlane")
@:structAccess
private extern class PxPlaneData
{
    /**
     * The normal to the plane
     */
    var n:PxVec3;
    /**
     * The distance from the origin
     */
    var d:cpp.Float32;

    /**
     * Constructor
     * - `create()` : Default constructor.
     * - `create(nx, ny, nz, distance)` : Constructor from a normal and a distance
     * - `create(normal, distance)` : Constructor from a normal and a distance
     * - `create(point, normal)` : Constructor from a point on the plane and a normal
     * - `create(p0, p1, p2)` : Constructor from three points
     */
    @:native("physx::PxPlane")
    @:overload(function():PxPlaneData {})
    @:overload(function(normal:PxVec3, distance:cpp.Float32):PxPlaneData {})
    @:overload(function(point:PxVec3, normal:PxVec3):PxPlaneData {})
    @:overload(function(p0:PxVec3, p1:PxVec3, p2:PxVec3):PxPlaneData {})
    static function create(nx:cpp.Float32, ny:cpp.Float32, nz:cpp.Float32, distance:cpp.Float32):PxPlaneData;

    /**
    \brief returns true if the two planes are exactly equal
    */
    @:native("operator==") function equals(p:PxPlane):Bool;

    function distance(p:PxVec3):cpp.Float32;
    function contains(p:PxVec3):Bool;

    /**
    \brief projects p into the plane
    */
    function project(p:PxVec3):PxVec3;

    /**
    \brief find an arbitrary point in the plane
    */
    function pointInPlane():PxVec3;

    /**
    \brief equivalent plane with unit normal
    */
    function normalize():Void;
}