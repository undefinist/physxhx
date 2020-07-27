package physx.geometry;

import physx.foundation.PxSimpleTypes.PxReal;
import physx.foundation.PxVec3;

@:forward
extern abstract PxTriangle(PxTriangleData) 
{
    /**
     * @see `PxTriangle.empty()`
     */
    inline function new(p0:PxVec3, p1:PxVec3, p2:PxVec3)
    {
        this = PxTriangleData.create(p0, p1, p2);
    }

    /**
     * Uninitialized data
     */
    inline static function empty():PxTriangle
    {
        return cast PxTriangleData.create();
    }

    @:op([]) inline function vertsGet(index:Int):PxVec3
    {
        return untyped __cpp__("{0}[{1}]", this, index);
    }
    @:op([]) inline function vertsSet(index:Int, value:PxVec3):PxVec3
    {
        return untyped __cpp__("{0}[{1}] = {2}", this, index, value);
    }
}

@:include("geometry/PxTriangle.h")
@:native("physx::PxTriangle")
@:structAccess
private extern class PxTriangleData
{
    @:native("verts[0]") var p0:PxVec3;
    @:native("verts[1]") var p1:PxVec3;
    @:native("verts[2]") var p2:PxVec3;

    @:native("physx::PxTriangle")
    @:overload(function():PxTriangleData {})
    static function create(p0:PxVec3, p1:PxVec3, p2:PxVec3):PxTriangleData;

    @:native("normal") private function _normal(normal:cpp.Reference<PxVec3>):Void;
    @:native("denormalizedNormal") private function _denormalizedNormal(normal:cpp.Reference<PxVec3>):Void;

	/**
     * Compute the normal of the Triangle.
	 */
	inline function normal():PxVec3
	{
        var norm:PxVec3;
        _normal(norm);
        return norm;
	}

	/**
     * Compute the unnormalized normal of the triangle.
	 */
	inline function denormalizedNormal():PxVec3
	{
        var norm:PxVec3;
        _denormalizedNormal(norm);
        return norm;
	}

	/**
	\brief Compute the area of the triangle.

	\return Area of the triangle.
	*/
	function area():PxReal;

	/**
	\return Computes a point on the triangle from u and v barycentric coordinates.
	*/
	function pointFromUV(u:PxReal, v:PxReal):PxVec3;
}