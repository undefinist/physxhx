package physx.geometry;

import physx.foundation.PxMat33;
import physx.foundation.PxQuat;
import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;

/**
\brief A class expressing a nonuniform scaling transformation.

The scaling is along arbitrary axes that are specified by PxMeshScale::rotation.

\note	Negative scale values are supported for PxTriangleMeshGeometry
		with absolute values for each component within [PX_MIN_ABS_MESH_SCALE, PX_MAX_ABS_MESH_SCALE] range.
		Negative scale causes a reflection around the specified axis, in addition PhysX will flip the normals
		for mesh triangles when scale.x*scale.y*scale.z < 0.
\note	Only positive scale values are supported for PxConvexMeshGeometry
		with values for each component within [PX_MIN_ABS_MESH_SCALE, PX_MAX_ABS_MESH_SCALE] range).

@see PxConvexMeshGeometry PxTriangleMeshGeometry
*/
@:forward
@:forwardStatics
extern abstract PxMeshScale(PxMeshScaleData)
{
    /** \brief Minimum allowed absolute magnitude for each of mesh scale's components (x,y,z).
        \note Only positive scale values are allowed for convex meshes. */
    static inline final MIN:Float = 1e-6;
    
    /** \brief Maximum allowed absolute magnitude for each of mesh scale's components (x,y,z).
        \note Only positive scale values are allowed for convex meshes. */
    static inline final MAX:Float = 1e6;

    /**
     * Constructor to initialize arbitrary scaling.
     * For alternative constructors, see `PxMeshScale.create()` and `PxMeshScale.identity()`
     */
    inline function new(s:PxVec3, r:PxQuat)
    {
        this = PxMeshScaleData.create(s, r);
    }

    static inline function identity():PxMeshScale
    {
        return cast PxMeshScaleData.create();
    }
}

@:include("geometry/PxMeshScale.h")
@:native("physx::PxMeshScale")
@:structAccess
private extern class PxMeshScaleData
{
    /**
     * A nonuniform scaling
     */
    var scale:PxVec3;
    /**
     * The orientation of the scaling axes
     */
    var rotation:PxQuat;

    /**
     * Constructors:
     * - create() : Constructor initializes to identity scale and rotation.
     * - create(r) : Constructor from scalar for scale, identity rotation.
     * - create(s) : Constructor to initialize arbitrary scale and identity scale rotation.
     * - create(s, r): Constructor to initialize arbitrary scaling.
     */
    @:native("physx::PxMeshScale")
    @:overload(function():PxMeshScaleData {})
    @:overload(function(r:PxReal):PxMeshScaleData {})
    @:overload(function(s:PxVec3):PxMeshScaleData {})
    static function create(s:PxVec3, r:PxQuat):PxMeshScaleData;


	/**
	\brief Returns true if the scaling is an identity transformation.
	*/
	function isIdentity():Bool;

	/**
	\brief Returns the inverse of this scaling transformation.
	*/
	function getInverse():PxMeshScale;

	/**
	\brief Converts this transformation to a 3x3 matrix representation.
	*/
	function toMat33():PxMat33;

	/**
	\brief Returns true if combination of negative scale components will cause the triangle normal to flip. The SDK will flip the normals internally.
	*/
	function hasNegativeDeterminant():Bool;

	function transform(v:PxVec3):PxVec3;
	function isValidForTriangleMesh():Bool;
	function isValidForConvexMesh():Bool;
}