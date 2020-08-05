package physx.foundation;

import physx.foundation.PxSimpleTypes.PxReal;

/*!
class representing a rigid euclidean transform as a quaternion and a vector
*/
@:forward
@:forwardStatics
extern abstract PxTransform(PxTransformData)
{
    @:from
    inline static function fromMatrix(m:PxMat44):PxTransform
    {
        return PxTransform.create(m);
    }

    /**
     * Construct from position and orientation.
     * For alternative constructors, see `PxTransform.create()`, `PxTransform.identity()`, `PxTransform.fromMatrix()` & `PxTransform.fromPlaneEquation()`.
     */
    inline function new(p0:PxVec3, q0:PxQuat)
    {
        this = cast PxTransform.create(p0, q0);
    }

	/**
	returns true if the two transforms are exactly equal
	*/
    @:op(A == B)
    inline function equals(t:PxTransform):Bool
    {
        return this.equals(t);
    }
    
    @:op(A *= B)
    inline function mulAssign(t:PxTransform):PxTransform
    {
        return this.mulAssign(t);
    }
    
    @:op(A * B)
    inline function mul(t:PxTransform):PxTransform
    {
        return this.mul(t);
    }
}

@:include("foundation/PxTransform.h")
@:native("physx::PxTransform")
@:structAccess
private extern class PxTransformData implements physx.hx.IncludeHelper<"foundation/Px.h">
{
    var q:PxQuat;
    var p:PxVec3;

    /**
     * Constructor
     */
	@:native("physx::PxTransform")
	@:overload(function():PxTransform {})
	@:overload(function(position:PxVec3):PxTransform {})
	@:overload(function(orientation:PxQuat):PxTransform {})
	@:overload(function(x:cpp.Float32, y:cpp.Float32, z:cpp.Float32):PxTransform {})
	@:overload(function(x:cpp.Float32, y:cpp.Float32, z:cpp.Float32, aQ:PxQuat):PxTransform {})
	@:overload(function(m:PxMat44):PxTransform {})
    static function create(p0:PxVec3, q0:PxQuat):PxTransform;

    /**
     * Construct with zero position and identity orientation.
     */
    inline static function identity():PxTransform
    {
        return untyped __cpp__("physx::PxTransform(physx::PxIdentity)");
    }
    
	/**
	returns true if the two transforms are exactly equal
	*/
    @:native("operator==") function equals(t:PxTransform):Bool;
    
    /**
     * Matrix multiplication
     */
    @:native("operator*") function mul(t:PxTransform):PxTransform;

    /**
     * Same as `mul` but modifies `this`.
     */
    @:native("operator*=") function mulAssign(other:PxTransform):PxTransform;

    function getInverse():PxTransform;
    
	/**
	return a normalized transform (i.e. one in which the quaternion has unit magnitude)
	*/
    function getNormalized():PxTransform;

    @:overload(function(src:PxTransform):PxTransform {})
    @:overload(function(src:PxPlane):PxPlane {})
    function transform(input:PxVec3):PxVec3;
    @:overload(function(src:PxTransform):PxTransform {})
    function transformInv(input:PxVec3):PxVec3;
    function inverseTransform(plane:PxPlane):PxPlane;

    function rotate(input:PxVec3):PxVec3;
    function rotateInv(input:PxVec3):PxVec3;

	/**
	returns true if finite and q is a unit quaternion
	*/
    function isValid():Bool;
	/**
	returns true if finite and quat magnitude is reasonably close to unit to allow for some accumulation of error
	vs isValid
	*/
    function isSane():Bool;
	/**
	returns true if all elems are finite (not NAN or INF, etc.)
	*/
    function isFinite():Bool;


    
    /**
     * Creates a transform from a plane equation, suitable for an actor transform for a PxPlaneGeometry
     * @param plane the desired plane equation
     * @return a PxTransform which will transform the plane PxPlane(1,0,0,0) to the specified plane
    */
    @:include("geometry/PxPlaneGeometry.h")
    @:native("physx::PxTransformFromPlaneEquation")
    static function fromPlaneEquation(plane:PxPlane):PxTransform;

    /** 
     * Creates a transform from the endpoints of a segment, suitable for an actor transform for a PxCapsuleGeometry
     * @param p0 one end of major axis of the capsule
     * @param p1 the other end of the axis of the capsule
     * @param halfHeight the halfHeight of the capsule. This parameter is optional.
     * @return A PxTransform which will transform the vector (1,0,0) to the capsule axis shrunk by the halfHeight
     */
    inline static function fromSegment(p0:PxVec3, p1:PxVec3, ?halfHeight:Null<PxReal>):PxTransform
    {
        return _fromSegment(p0, p1, cpp.Pointer.fromHandle(halfHeight));
    }

    @:include("geometry/PxCapsuleGeometry.h")
    @:native("physx::PxTransformFromSegment")
    private static function _fromSegment(p0:PxVec3, p1:PxVec3, halfHeight:cpp.Pointer<PxReal>):PxTransform;
}
