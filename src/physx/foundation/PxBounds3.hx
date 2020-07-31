package physx.foundation;

@:forward
@:forwardStatics
extern abstract PxBounds3(PxBounds3Data) 
{
    /**
     * Construct from two bounding points.
     * @see PxBounds3.empty()
     * @see PxBounds3.create()
     */
    inline function new(minimum:PxVec3, maximum:PxVec3) 
    {
        this = PxBounds3Data.create(minimum, maximum);
    }
}

@:include("foundation/PxBounds3.h")
@:native("physx::PxBounds3")
private extern class PxBounds3Data
{
    var minimum:PxVec3;
    var maximum:PxVec3;

    /**
     * Constructors:
     * - create() : Default constructor, not performing any initialization for performance reason. Use `PxBounds3.empty()` to construct empty bounds.
     * - create(minimum, maximum) : Construct from two bounding points
     */
    @:native("physx::PxBounds3")
    @:overload(function():PxBounds3Data {})
    static function create(minimum:PxVec3, maximum:PxVec3):PxBounds3Data;

    /**
    \brief Return empty bounds.
    */
    static function empty():PxBounds3;

    /**
    \brief returns the AABB containing v0 and v1.
    \param v0 first point included in the AABB.
    \param v1 second point included in the AABB.
    */
    static function boundsOfPoints(v0:PxVec3, v1:PxVec3):PxBounds3;

    /**
    \brief returns the AABB from center and extents vectors.
    \param center Center vector
    \param extent Extents vector
    */
    static function centerExtents(center:PxVec3, extent:PxVec3):PxBounds3;

    /**
    \brief Construct from center, extent, and (not necessarily orthogonal) basis
    */
    static function basisExtent(center:PxVec3, basis:PxMat33, extent:PxVec3):PxBounds3;

    /**
    \brief Construct from pose and extent
    */
    static function poseExtent(pose:PxTransform, extent:PxVec3):PxBounds3;

    /**
    \brief gets the transformed bounds of the passed AABB (resulting in a bigger AABB).

    This version is safe to call for empty bounds.

    \param[in] transform Transform to apply, can contain scaling as well
    \param[in] bounds The bounds to transform.
    */
    @:overload(function(matrix:PxMat33, bounds:PxBounds3):PxBounds3 {})
    static function transformSafe(transform:PxTransform, bounds:PxBounds3):PxBounds3;

    /**
    \brief gets the transformed bounds of the passed AABB (resulting in a bigger AABB).

    Calling this method for empty bounds leads to undefined behavior. Use #transformSafe() instead.

    \param[in] transform Transform to apply, can contain scaling as well
    \param[in] bounds The bounds to transform.
    */
    @:overload(function(matrix:PxMat33, bounds:PxBounds3):PxBounds3 {})
    static function transformFast(transform:PxTransform, bounds:PxBounds3):PxBounds3;

    /**
    \brief Sets empty to true
    */
    function setEmpty():Void;

    /**
    \brief Sets the bounds to maximum size [-PX_MAX_BOUNDS_EXTENTS, PX_MAX_BOUNDS_EXTENTS].
    */
    function setMaximal():Void;

    /**
    expands the volume to include `v`/`b`.
    @param v Point to expand to.
    @param b Bounds to perform union with.
    */
    @:overload(function(v:PxVec3):Void {})
    function include(b:PxBounds3):Void;

    function isEmpty():Bool;

    /**
    \brief indicates whether the intersection of this and b is empty or not.
    \param b Bounds to test for intersection.
    */
    function intersects(b:PxBounds3):Bool;

    /**
     \brief computes the 1D-intersection between two AABBs, on a given axis.
     \param	a		the other AABB
     \param	axis	the axis (0, 1, 2)
     */
    function intersects1D(a:PxBounds3, axis:cpp.UInt32):Bool;

    /**
    \brief indicates if these bounds contain v.
    \param v Point to test against bounds.
    */
    function contains(v:PxVec3):Bool;

    /**
     \brief	checks a box is inside another box.
     \param	box		the other AABB
     */
    function isInside(box:PxBounds3):Bool;

    /**
    \brief returns the center of this axis aligned box.
    */
    function getCenter():PxVec3;

    /**
    \brief returns the extents, which are half of the width/height/depth.
    */
    function getExtents():PxVec3;

    /**
    \brief get component of the box's center along a given axis
    */
    @:native("getCenter") function getCenterAlongAxis(axis:cpp.UInt32):cpp.Float32;

    /**
    \brief get component of the box's extents along a given axis
    */
    @:native("getExtents") function getExtentsAlongAxis(axis:cpp.UInt32):cpp.Float32;

    /**
    \brief returns the dimensions (width/height/depth) of this axis aligned box.
    */
    function getDimensions():PxVec3;

    /**
    \brief scales the AABB.

    This version is safe to call for empty bounds.

    \param scale Factor to scale AABB by.
    */
    function scaleSafe(scale:cpp.Float32):Void;

    /**
    \brief scales the AABB.

    Calling this method for empty bounds leads to undefined behavior. Use #scaleSafe() instead.

    \param scale Factor to scale AABB by.
    */
    function scaleFast(scale:cpp.Float32):Void;

    /**
    fattens the AABB in all 3 dimensions by the given distance.

    This version is safe to call for empty bounds.
    */
    function fattenSafe(distance:cpp.Float32):Void;

    /**
    fattens the AABB in all 3 dimensions by the given distance.

    Calling this method for empty bounds leads to undefined behavior. Use #fattenSafe() instead.
    */
    function fattenFast(distance:cpp.Float32):Void;

    /**
    checks that the AABB values are not NaN
    */
    function isFinite():Bool;

    /**
    checks that the AABB values describe a valid configuration.
    */
    function isValid():Bool;
}