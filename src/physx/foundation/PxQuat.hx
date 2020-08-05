package physx.foundation;

/**
This is a quaternion class. For more information on quaternion mathematics
consult a mathematics source on complex numbers.
*/
@:forward
@:forwardStatics
extern abstract PxQuat(PxQuatData)
{
    /**
    Creates from angle-axis representation.

    Axis must be normalized!

    Angle is in radians!

    **Unit:** Radians
    */
    inline static function angleAxis(angleRadians:cpp.Float32, unitAxis:PxVec3):PxQuat
    {
        return PxQuat.create(angleRadians, unitAxis);
    }

    /**
    Creates from orientation matrix.

    @param m Rotation matrix to extract quaternion from.
    */
    @:from
    inline static function fromMatrix(m:PxMat33):PxQuat
    {
        return PxQuat.create(m);
    }

    /**
     * Initialize from 4 scalars. Take note of the order of the elements!
     * For alternative constructors, see `PxQuat.create()`, `PxQuat.identity()`, `PxQuat.angleAxis()` & `PxQuat.fromMatrix()`.
     * @param x Real part x
     * @param y Real part y
     * @param z Real part z
     * @param w Imaginary part
     */
    inline function new(x:cpp.Float32, y:cpp.Float32, z:cpp.Float32, w:cpp.Float32) 
    {
        this = cast PxQuat.create(x, y, z, w);
    }
    
    /**
    returns true if the two quaternions are exactly equal
    */
    @:op(A == B)
    inline function equals(q:PxQuat):Bool
    {
        return this.equals(q);
    }
    
    /** quaternion multiplication assignment */
    @:op(A *= B)
    inline function mulAssign(q:PxQuat):PxQuat
    {
        return this.mulAssign(q);
    }
    
    /** quaternion multiplication */
    @:op(A * B)
    inline function mul(q:PxQuat):PxQuat
    {
        return this.mul(q);
    }
    
    @:op(A * B)
    inline function scl(r:cpp.Float32):PxQuat
    {
        return this.scl(r);
    }
    
    @:op(A += B)
    inline function addAssign(q:PxQuat):PxQuat
    {
        return this.addAssign(q);
    }
    
    @:op(A + B)
    inline function add(q:PxQuat):PxQuat
    {
        return this.add(q);
    }
    
    @:op(A -= B)
    inline function subAssign(q:PxQuat):PxQuat
    {
        return this.subAssign(q);
    }
    
    @:op(A - B)
    inline function sub(q:PxQuat):PxQuat
    {
        return this.sub(q);
    }
    
    @:op(-A)
    inline function neg():PxQuat
    {
        return this.neg();
    }
}

@:include("foundation/PxQuat.h")
@:native("physx::PxQuat")
@:structAccess
private extern class PxQuatData implements physx.hx.IncludeHelper<"foundation/Px.h">
{
    var x:cpp.Float32;
    var y:cpp.Float32;
    var z:cpp.Float32;
    var w:cpp.Float32;

    /**
     * Creates a quaternion.
     * 
     * - `create()` - Default constructor, does not do any initialization.
     * - `create(r)` - Constructor from a scalar: sets the real part w to the `r`, and the imaginary parts (x,y,z) to zero.
     * - `create(x, y, z, w)` - Initialize from 4 scalars. Take note of the order of the elements!
     * - `create(angleRadians, unitAxis)` - Creates from angle-axis representation. Axis must be normalized! Angle is in radians!
     * - `create(m)` - Creates from rotation matrix.
     */
    @:native("physx::PxQuat")
    @:overload(function():PxQuat{})
    @:overload(function(r:cpp.Float32):PxQuat{})
    @:overload(function(angleRadians:cpp.Float32, unitAxis:PxVec3):PxQuat{})
    @:overload(function(m:PxMat33):PxQuat{})
    static function create(x:cpp.Float32, y:cpp.Float32, z:cpp.Float32, w:cpp.Float32):PxQuat;
    
    //! identity constructor
    inline static function identity():PxQuat
    {
        return untyped __cpp__("physx::PxQuat(physx::PxIdentity)");
    }

    /**
    returns true if quat is identity
    */
    function isIdentity():Bool;

    /**
    returns true if all elements are finite (not NAN or INF, etc.)
    */
    function isFinite():Bool;

    /**
    returns true if finite and magnitude is close to unit
    */
    function isUnit():Bool;

    /**
    returns true if finite and magnitude is reasonably close to unit to allow for some accumulation of error vs
    isValid
    */
    function isSane():Bool;

    /**
    returns true if the two quaternions are exactly equal
    */
    function equals(q:PxQuat):Bool;

    @:native("toRadiansAndUnitAxis") private function _toRadiansAndUnitAxis(angle:cpp.Reference<cpp.Float32>, axis:cpp.Reference<PxVec3>):Void;
    /**
    converts this quaternion to angle-axis representation
    */
    inline function toRadiansAndUnitAxis():{angle:cpp.Float32, axis:PxVec3}
    {
        var angle:cpp.Float32 = 0;
        var axis:PxVec3 = PxVec3.create();
        _toRadiansAndUnitAxis(angle, axis);
        return { angle: angle, axis: axis };
    }

    /**
    Gets the angle between this quat and the specified `q`, or the identity quaternion if not specified.

    **Unit:** Radians
    */
    @:overload(function ():cpp.Float32 {})
    function getAngle(q:PxQuat):cpp.Float32;

    /**
    This is the squared 4D vector length, should be 1 for unit quaternions.
    */
    function magnitudeSquared():cpp.Float32;

    /**
    returns the scalar product of this and other.
    */
    function dot(v:PxQuat):cpp.Float32;

    function getNormalized():PxQuat;

    function magnitude():cpp.Float32;

    // modifiers:
    /**
    converts this PxQuat to a unit quaternion and returns the original magnitude.
    */
    function normalize():cpp.Float32;

    /*
    returns the conjugate.

    **Note:** for unit quaternions, this is the inverse.
    */
    function getConjugate():PxQuat;

    /*
    returns imaginary part.
    */
    function getImaginaryPart():PxVec3;

    /** brief computes rotation of x-axis */
    function getBasisVector0():PxVec3;

    /** brief computes rotation of y-axis */
    function getBasisVector1():PxVec3;

    /** brief computes rotation of z-axis */
    function getBasisVector2():PxVec3;

    /**
    rotates passed vec by this (assumed unitary)
    */
    function rotate(v:PxVec3):PxVec3;

    /**
    inverse rotates passed vec by this (assumed unitary)
    */
    function rotateInv(v:PxVec3):PxVec3;

    /**
    Assignment
    */
    @:native("operator=") function set(p:PxQuat):PxQuat;

    /** quaternion multiplication */
    @:native("operator*") function mul(q:PxQuat):PxQuat;
    @:native("operator*") function scl(r:cpp.Float32):PxQuat;
    /** quaternion multiplication assignment */
    @:native("operator*=") function mulAssign(q:PxQuat):PxQuat;

    /** quaternion addition */
    @:native("operator+") function add(q:PxQuat):PxQuat;
    /** quaternion addition assignment */
    @:native("operator+=") function addAssign(q:PxQuat):PxQuat;

    /** quaternion subtraction */
    @:native("operator-") function neg():PxQuat;
    /** quaternion subtraction */
    @:native("operator-") function sub(q:PxQuat):PxQuat;
    /** quaternion subtraction assignment */
    @:native("operator-=") function subAssign(q:PxQuat):PxQuat;
}