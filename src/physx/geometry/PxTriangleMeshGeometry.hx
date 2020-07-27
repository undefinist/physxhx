package physx.geometry;

import physx.common.PxCoreUtilityTypes;

/**
\brief Flags controlling the simulated behavior of the triangle mesh geometry.

Used in ::PxMeshGeometryFlags.
*/
extern enum abstract PxMeshGeometryFlag(PxMeshGeometryFlagImpl)
{
    /**
     * Meshes with this flag set are treated as double-sided.
     * This flag is currently only used for raycasts and sweeps (it is ignored for overlap queries).
     * For detailed specifications of this flag for meshes and heightfields please refer to the Geometry Query section of the user guide.
     */
    @:native("physx::PxMeshGeometryFlag::eDOUBLE_SIDED") var eDOUBLE_SIDED;
}

@:include("geometry/PxTriangleMeshGeometry.h")
@:native("physx::PxMeshGeometryFlags")
private extern class PxMeshGeometryFlagImpl {}

/**
\brief collection of set bits defined in PxMeshGeometryFlag.

@see PxMeshGeometryFlag
*/
extern abstract PxMeshGeometryFlags(PxMeshGeometryFlag) from PxMeshGeometryFlag to PxMeshGeometryFlag {}

/**
\brief Triangle mesh geometry class.

This class unifies a mesh object with a scaling transform, and 
lets the combined object be used anywhere a PxGeometry is needed.

The scaling is a transform along arbitrary axes contained in the scale object.
The vertices of the mesh in geometry (or shape) space is the 
PxMeshScale::toMat33() transform, multiplied by the vertex space vertices 
in the PxConvexMesh object.
*/
@:forward
@:forwardStatics
extern abstract PxTriangleMeshGeometry(PxTriangleMeshGeometryData)
{
    /**
     * Constructor.
     * @param mesh Mesh pointer. May be NULL, though this will not make the object valid for shape construction.
     * @param scaling Scale factor.
     * @param flags Mesh flags.
     * @see `PxTriangleMeshGeometry.empty()`
     * @see `PxTriangleMeshGeometry.create()`
     */
    inline function new(mesh:PxTriangleMesh, scaling:PxMeshScale, flags:PxMeshGeometryFlags)
    {
        this = PxTriangleMeshGeometryData.create(mesh, scaling, flags);
    }

    /**
     * Default constructor.
     *
     * Creates an empty object with a NULL mesh and identity scale.
     */
    static inline function empty():PxTriangleMeshGeometry
    {
        return cast PxTriangleMeshGeometryData.create();
    }
}

@:include("geometry/PxTriangleMeshGeometry.h")
@:native("physx::PxTriangleMeshGeometry")
@:structAccess
private extern class PxTriangleMeshGeometryData extends PxGeometry
{
    /**
     * The scaling transformation.
     */
    var scale:PxMeshScale;
    /**
     * Mesh flags.
     */
    var meshFlags:PxMeshGeometryFlags;
    /**
     * Padding for mesh flags.
     */
    var paddingFromFlags:PxPadding3;
    /**
     * A reference to the mesh object.
     */
    var triangleMesh:PxTriangleMesh;

    /**
    \brief Returns true if the geometry is valid.

    \return  True if the current settings are valid for shape creation.

    \note A valid triangle mesh has a positive scale value in each direction (scale.scale.x > 0, scale.scale.y > 0, scale.scale.z > 0).
    It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a triangle mesh that has zero extents in any direction.

    @see PxRigidActor::createShape, PxPhysics::createShape
    */
    function isValid():Bool;

    /**
	 * Constructor. 
     * @param mesh Mesh pointer. May be NULL, though this will not make the object valid for shape construction. 
     * @param scaling Scale factor. Default `PxMeshScale.identity()`.
     * @param flags Mesh flags. Default `0`.
	 */
    @:native("physx::PxTriangleMeshGeometry")
    @:overload(function():PxTriangleMeshGeometryData {})
    @:overload(function(mesh:PxTriangleMesh):PxTriangleMeshGeometryData {})
    @:overload(function(mesh:PxTriangleMesh, scaling:PxMeshScale):PxTriangleMeshGeometryData {})
    static function create(mesh:PxTriangleMesh, scaling:PxMeshScale, flags:PxMeshGeometryFlags):PxTriangleMeshGeometryData;
}