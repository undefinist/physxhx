package physx.geometry;

import physx.common.PxCoreUtilityTypes.PxPadding3;
import physx.foundation.PxSimpleTypes;

/**
\brief Flags controlling the simulated behavior of the convex mesh geometry.

Used in ::PxConvexMeshGeometryFlags.
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxConvexMeshGeometryFlag", PxU8))
extern enum abstract PxConvexMeshGeometryFlag(PxConvexMeshGeometryFlagImpl)
{
    /**
     * Use tighter (but more expensive to compute) bounds around the convex geometry.
     */
    var eTIGHT_BOUNDS = (1<<0);
}

@:include("geometry/PxConvexMeshGeometry.h")
@:native("physx::PxConvexMeshGeometryFlags")
private extern class PxConvexMeshGeometryFlagImpl {}

/**
\brief collection of set bits defined in PxConvexMeshGeometryFlag.

@see PxConvexMeshGeometryFlag
*/
extern abstract PxConvexMeshGeometryFlags(PxConvexMeshGeometryFlag) from PxConvexMeshGeometryFlag to PxConvexMeshGeometryFlag {}

/**
\brief Convex mesh geometry class.

This class unifies a convex mesh object with a scaling transform, and 
lets the combined object be used anywhere a PxGeometry is needed.

The scaling is a transform along arbitrary axes contained in the scale object.
The vertices of the mesh in geometry (or shape) space is the 
PxMeshScale::toMat33() transform, multiplied by the vertex space vertices 
in the PxConvexMesh object.
*/
@:forward
@:forwardStatics
extern abstract PxConvexMeshGeometry(PxConvexMeshGeometryData) from PxConvexMeshGeometryData to PxConvexMeshGeometryData
{
    /**
     * Constructor.
     * @see PxConvexMeshGeometry.create()
     * @see PxConvexMeshGeometry.empty()
     */
    inline function new(mesh:PxConvexMesh)
    {
        this = PxConvexMeshGeometry.create(mesh);
    }

    /**
     * Default constructor.
     * 
     * Creates an empty object with a NULL mesh and identity scale.
     */
    static inline function empty():PxConvexMeshGeometry
    {
        return PxConvexMeshGeometryData.create();
    }
}

@:include("geometry/PxConvexMeshGeometry.h")
@:native("physx::PxConvexMeshGeometry")
@:structAccess
private extern class PxConvexMeshGeometryData extends PxGeometry
{
    /**
     * The scaling transformation (from vertex space to shape space).
     */
    var scale:PxMeshScale;
    /**
     * A reference to the convex mesh object.
     */
    var convexMesh:PxConvexMesh;
    /**
     * Mesh flags.
     */
    var meshFlags:PxConvexMeshGeometryFlags;
    /**
     * padding for mesh flags
     */
    var paddingFromFlags:PxPadding3;

    /**
     * Constructor.
     * @param [in]mesh		Mesh pointer. May be NULL, though this will not make the object valid for shape construction.
     * @param [in]scaling	Scale factor. Default `PxMeshScale.identity()`.
     * @param [in]flags	    Mesh flags. Default `PxConvexMeshGeometryFlag.eTIGHT_BOUNDS`.
     */
    @:native("physx::PxConvexMeshGeometry")
    @:overload(function():PxConvexMeshGeometryData {})
    @:overload(function(mesh:PxConvexMesh):PxConvexMeshGeometryData {})
    @:overload(function(mesh:PxConvexMesh, scaling:PxMeshScale):PxConvexMeshGeometryData {})
    static function create(mesh:PxConvexMesh, scaling:PxMeshScale, flags:PxConvexMeshGeometryFlags):PxConvexMeshGeometryData;

    /**
     * Returns true if the geometry is valid.
     * 
     * **Note:** A valid convex mesh has a positive scale value in each direction (scale.x > 0, scale.y > 0, scale.z > 0).
     * It is illegal to call `PxRigidActor.createShape` and `PxPhysics.createShape` with a convex that has zero extent in any direction.
     * 
     * @return True if the current settings are valid for shape creation.
     * 
     * @see PxRigidActor::createShape, PxPhysics::createShape
     */
    function isValid():Bool;
}