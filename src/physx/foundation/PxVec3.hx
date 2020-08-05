package physx.foundation;

/**
3 Element vector class.

This is a 3-dimensional vector class with public data members.
*/
@:forward
@:forwardStatics
extern abstract PxVec3(PxVec3Data)
{
    /**
     * Assigns scalar parameter `a` to all elements.
     */
    inline static function scalar(a:cpp.Float32):PxVec3
    {
        return PxVec3Data.create(a);
    }

    /**
     * Initializes from 3 scalar parameters. For alternative constructors, see `PxVec3.create()`.
     */
    inline function new(x:cpp.Float32 = 0, y:cpp.Float32 = 0, z:cpp.Float32 = 0)
    {
        this = cast PxVec3Data.create(x, y, z);
    }

    /**
    element access
    */
    @:op([])
    inline function elemGet(index:Int):cpp.Float32
    {
        return untyped __cpp__("{0}[{1}]", this, index);
    }
    
    /**
    element access
    */
    @:op([])
    inline function elemSet(index:Int, value:cpp.Float32):cpp.Float32
    {
        return untyped __cpp__("{0}[{1}] = {2}", this, index, value);
    }

    /**
    returns true if the two vectors are exactly equal.
    */
    @:op(A == B)
    inline function equals(v:PxVec3):Bool
    {
        return untyped __cpp__("{0} == {1}", this, v);
    }

    /**
    returns true if the two vectors are not exactly equal.
    */
    @:op(A != B)
    inline function notEquals(v:PxVec3):Bool
    {
        return untyped __cpp__("{0} != {1}", this, v);
    }
    
    /**
    negation
    */
    @:op(-A)
    inline function negate():PxVec3
    {
        return untyped __cpp__("-{0}", this);
    }
    
    /**
    vector addition
    */
    @:op(A + B)
    inline function add(v:PxVec3):PxVec3
    {
        return untyped __cpp__("{0} + {1}", this, v);
    }
    
    /**
    vector difference
    */
    @:op(A - B)
    inline function sub(v:PxVec3):PxVec3
    {
        return untyped __cpp__("{0} - {1}", this, v);
    }
    
    /**
    scalar post-multiplication
    */
    @:op(A * B)
    @:commutative
    inline function scl(f:cpp.Float32):PxVec3
    {
        return untyped __cpp__("{0} * {1}", this, f);
    }
    
    /**
    scalar division
    */
    @:op(A / B)
    inline function div(f:cpp.Float32):PxVec3
    {
        return untyped __cpp__("{0} / {1}", this, f);
    }
}

@:include("foundation/Px.h")
@:include("foundation/PxVec3.h")
@:native("physx::PxVec3")
@:structAccess
private extern class PxVec3Data
{
    var x:cpp.Float32;
    var y:cpp.Float32;
    var z:cpp.Float32;
    
    /**
     * Creates a vector.
     * 
     * `create()` - default constructor leaves data uninitialized.
     * `create(a)` - Assigns scalar parameter `a` to all elements.  
     * `create(x, y, z)` - Initializes from 3 scalar parameters.
     */
    @:native("physx::PxVec3")
    @:overload(function():PxVec3{})
    @:overload(function(a:cpp.Float32):PxVec3{})
    static function create(x:cpp.Float32, y:cpp.Float32, z:cpp.Float32):PxVec3;

    /**
     * Zero constructor
     */
    inline static function zero():PxVec3
    {
        return untyped __cpp__("physx::PxVec3(physx::PxZero)");
    }
    
    /**
    tests for exact zero vector
    */
    function isZero():Bool;

    /**
    returns true if all 3 elems of the vector are finite (not NAN or INF, etc.)
    */
    function isFinite():Bool;
    
    /**
    is normalized - used by API parameter validation
    */
    function isNormalized():Bool;

    /**
    returns the squared magnitude

    Avoids calling PxSqrt()!
    */
    function magnitudeSquared():cpp.Float32;

    /**
    returns the magnitude
    */
    function magnitude():cpp.Float32;

    /**
    returns the scalar product of this and other.
    */
    function dot(v:PxVec3):cpp.Float32;

    /**
    cross product
    */
    function cross(v:PxVec3):PxVec3;

    /**
    return a unit vector
    */
    function getNormalized():PxVec3;

    /**
    normalizes the vector in place
    */
    function normalize():cpp.Float32;

    /**
    normalizes the vector in place. Does nothing if vector magnitude is under PX_NORMALIZATION_EPSILON.
    Returns vector magnitude if >= PX_NORMALIZATION_EPSILON and 0.0f otherwise.
    */
    function normalizeSafe():cpp.Float32;

    /**
    normalizes the vector in place. Asserts if vector magnitude is under PX_NORMALIZATION_EPSILON.
    returns vector magnitude.
    */
    function normalizeFast():cpp.Float32;

    /**
    a[i] * b[i], for all i.
    */
    function multiply(a:PxVec3):PxVec3;

    /**
    element-wise minimum
    */
    function minimum(v:PxVec3):PxVec3;

    /**
    returns MIN(x, y, z);
    */
    function minElement():cpp.Float32;

    /**
    element-wise maximum
    */
    function maximum(v:PxVec3):PxVec3;

    /**
    returns MAX(x, y, z);
    */
    function maxElement():cpp.Float32;

    /**
    returns absolute values of components;
    */
    function abs():PxVec3;
}