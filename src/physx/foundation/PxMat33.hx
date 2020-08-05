package physx.foundation;

/*!
3x3 matrix class

Some clarifications, as there have been much confusion about matrix formats etc in the past.

Short:
- Matrix have base vectors in columns (vectors are column matrices, 3x1 matrices).
- Matrix is physically stored in column major format
- Matrices are concaternated from left

Long:
Given three base vectors a, b and c the matrix is stored as

|a.x b.x c.x|
|a.y b.y c.y|
|a.z b.z c.z|

Vectors are treated as columns, so the vector v is

|x|
|y|
|z|

And matrices are applied _before_ the vector (pre-multiplication)
v' = M*v

|x'|   |a.x b.x c.x|   |x|   |a.x*x + b.x*y + c.x*z|
|y'| = |a.y b.y c.y| * |y| = |a.y*x + b.y*y + c.y*z|
|z'|   |a.z b.z c.z|   |z|   |a.z*x + b.z*y + c.z*z|


Physical storage and indexing:
To be compatible with popular 3d rendering APIs (read D3d and OpenGL)
the physical indexing is

|0 3 6|
|1 4 7|
|2 5 8|

index = column*3 + row

which in C++ translates to M[column][row]

The mathematical indexing is M_row,column and this is what is used for _-notation
so _12 is 1st row, second column and operator(row, column)!

*/
@:forward
@:forwardStatics
extern abstract PxMat33(PxMat33Data)
{
    /**
     * Construct from a quaternion
     */
    @:from
    inline static function fromQuat(q:PxQuat):PxMat33
    {
        return PxMat33.create(q);
    }

    /**
     * Construct from three base vectors.
     * For alternative constructors, see `PxMat33.create()`, `PxMat33.identity()`, `PxMat33.zero()`, `PxMat33.fromQuat()` & `PxMat33.createDiagonal()`
     */
    inline function new(col0:PxVec3, col1:PxVec3, col2:PxVec3)
    {
        this = cast PxMat33.create(col0, col1, col2);
    }

    /**
    returns true if the two matrices are exactly equal
    */
    @:op(A == B)
    inline function equals(other:PxMat33):Bool
    {
        return this.equals(other);
    }
    
    /** matrix multiplication assignment */
    @:op(A *= B)
    inline function mulmatAssign(other:PxMat33):PxMat33
    {
        return this.mulmatAssign(other);
    }
    
    /** matrix multiplication */
    @:op(A * B)
    inline function mulmat(other:PxMat33):PxMat33
    {
        return this.mulmat(other);
    }
    
    /** vector multiplication */
    @:op(A * B)
    inline function mulvec(vec:PxVec3):PxMat33
    {
        return this.mulvec(vec);
    }
    
    /** scalar multiplication */
    @:op(A * B)
    inline function mul(scalar:cpp.Float32):PxMat33
    {
        return this.mul(scalar);
    }
    
    @:op(A += B)
    inline function addAssign(other:PxMat33):PxMat33
    {
        return this.addAssign(other);
    }
    
    @:op(A + B)
    inline function add(other:PxMat33):PxMat33
    {
        return this.add(other);
    }
    
    @:op(A -= B)
    inline function subAssign(other:PxMat33):PxMat33
    {
        return this.subAssign(other);
    }
    
    @:op(A - B)
    inline function sub(other:PxMat33):PxMat33
    {
        return this.sub(other);
    }
    
    @:op(-A)
    inline function neg():PxMat33
    {
        return this.neg();
    }

    @:op([])
    inline function elemGet(index:Int):PxVec3
    {
        return untyped __cpp__("{0}[{1}]", this, index);
    }
    
    @:op([])
    inline function elemSet(index:Int, value:PxVec3):PxVec3
    {
        return untyped __cpp__("{0}[{1}] = {2}", this, index, value);
    }
}

@:include("foundation/PxMat33.h")
@:native("physx::PxMat33")
@:structAccess
private extern class PxMat33Data implements physx.hx.IncludeHelper<"foundation/Px.h">
{
    var column0:PxVec3;
    var column1:PxVec3;
    var column2:PxVec3;

    /**
     * Creates a 3x3 matrix.
     * 
     * - `create()` - Default constructor, does not do any initialization.
     * - `create(r)` - Construct from a scalar, which generates a multiple of the identity matrix
     * - `create(q)` - Construct from a quaternion
     * - `create(col0, col1, col2)` - Construct from three base vectors
     */
    @:native("physx::PxMat33")
    @:overload(function():PxMat33{})
    @:overload(function(r:cpp.Float32):PxMat33{})
    @:overload(function(q:PxQuat):PxMat33{})
    static function create(col0:PxVec3, col1:PxVec3, col2:PxVec3):PxMat33;

    //! identity constructor
    inline static function identity():PxMat33
    {
        return untyped __cpp__("physx::PxMat33(physx::PxIdentity)");
    }

    //! zero constructor
    inline static function zero():PxMat33
    {
        return untyped __cpp__("physx::PxMat33(physx::PxZero)");
    }

	//! Construct from diagonal, off-diagonals are zero.
	static function createDiagonal(d:PxVec3):PxMat33;



    @:native("operator==") function set(other:PxMat33):PxMat33;

	/**
	returns true if the two matrices are exactly equal
	*/
    @:native("operator==") function equals(m:PxMat33):Bool;

	//! Get transposed matrix
	function getTranspose():PxMat33;

	//! Get the real inverse
	function getInverse():PxMat33;

	//! Get determinant
	function getDeterminant():cpp.Float32;

	//! Unary minus
	@:native("operator-") function neg():PxMat33;

	//! Add
	@:native("operator+") function add(other:PxMat33):PxMat33;

	//! Subtract
	@:native("operator-") function sub(other:PxMat33):PxMat33;

	//! Scalar multiplication
	@:native("operator*") function mul(scalar:cpp.Float32):PxMat33;

	//! Matrix vector multiplication (returns 'this->transform(vec)')
	@:native("operator*") function mulvec(vec:PxVec3):PxMat33;

	//! Matrix multiplication
	@:native("operator*") function mulmat(other:PxMat33):PxMat33;

    // a <op>= b operators
    
	//! Equals-add
	@:native("operator+=") function addAssign(other:PxMat33):PxMat33;

	//! Equals-sub
	@:native("operator-=") function subAssign(other:PxMat33):PxMat33;

	//! Equals scalar multiplication
	@:native("operator*=") function mulAssign(scalar:cpp.Float32):PxMat33;

	//! Equals matrix multiplication
	@:native("operator*=") function mulmatAssign(other:PxMat33):PxMat33;

	//! Element access, mathematical way!
	@:native("operator()") function elemAt(row:cpp.UInt32, col:cpp.UInt32):cpp.Float32;

	// Transform etc

	/**
	 * Transform vector by matrix, equal to v' = M*v
	 */
	function transform(other:PxVec3):PxVec3;

	/**
	 * Transform vector by matrix transpose, v' = M^t*v
	 */
	function transformTranspose(other:PxVec3):PxVec3;
}