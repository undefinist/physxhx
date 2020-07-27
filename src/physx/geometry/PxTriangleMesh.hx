package physx.geometry;

import physx.common.PxPhysXCommonConfig;
import physx.foundation.PxBounds3;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;
import physx.foundation.PxBase;

/**
\brief Mesh midphase structure. This enum is used to select the desired acceleration structure for midphase queries
 (i.e. raycasts, overlaps, sweeps vs triangle meshes).

 The PxMeshMidPhase::eBVH33 structure is the one used in recent PhysX versions (up to PhysX 3.3). It has great performance and is
 supported on all platforms.

 The PxMeshMidPhase::eBVH34 structure is a revisited implementation introduced in PhysX 3.4. It can be significantly faster both
 in terms of cooking performance and runtime performance, but it is currently only available on platforms supporting the
 SSE2 instuction set.
*/
extern enum abstract PxMeshMidPhase(PxMeshMidPhaseImpl) 
{
    /**
     * Default midphase mesh structure, as used up to PhysX 3.3
     */
    @:native("physx::PxMeshMidPhase::eBVH33") var eBVH33;
    /**
     * Default midphase mesh structure, as used up to PhysX 3.4
     */
    @:native("physx::PxMeshMidPhase::eBVH34") var eBVH34;
}

@:include("geometry/PxTriangleMesh.h")
@:native("physx::PxMeshMidPhase::Enum")
private extern class PxMeshMidPhaseImpl {}

/**
\brief Flags for the mesh geometry properties.

Used in ::PxTriangleMeshFlags.
*/
extern enum abstract PxTriangleMeshFlag(PxTriangleMeshFlagImpl) 
{
    /**
     * The triangle mesh has 16bits vertex indices.
     */
    @:native("physx::PxTriangleMeshFlag::e16_BIT_INDICES") var e16_BIT_INDICES;
    /**
     * The triangle mesh has adjacency information build.
     */
    @:native("physx::PxTriangleMeshFlag::eADJACENCY_INFO") var eADJACENCY_INFO;
}

@:include("geometry/PxTriangleMesh.h")
@:native("physx::PxTriangleMeshFlags")
private extern class PxTriangleMeshFlagImpl {}

/**
\brief collection of set bits defined in PxTriangleMeshFlag.

@see PxTriangleMeshFlag
*/
extern abstract PxTriangleMeshFlags(PxTriangleMeshFlag) from PxTriangleMeshFlag to PxTriangleMeshFlag {}

/**

\brief A triangle mesh, also called a 'polygon soup'.

It is represented as an indexed triangle list. There are no restrictions on the
triangle data. 

To avoid duplicating data when you have several instances of a particular 
mesh positioned differently, you do not use this class to represent a 
mesh object directly. Instead, you create an instance of this mesh via
the PxTriangleMeshGeometry and PxShape classes.

<h3>Creation</h3>

To create an instance of this class call PxPhysics::createTriangleMesh(),
and release() to delete it. This is only possible
once you have released all of its PxShape instances.


<h3>Visualizations:</h3>
\li #PxVisualizationParameter::eCOLLISION_AABBS
\li #PxVisualizationParameter::eCOLLISION_SHAPES
\li #PxVisualizationParameter::eCOLLISION_AXES
\li #PxVisualizationParameter::eCOLLISION_FNORMALS
\li #PxVisualizationParameter::eCOLLISION_EDGES

@see PxTriangleMeshDesc PxTriangleMeshGeometry PxShape PxPhysics.createTriangleMesh()
*/
@:include("geometry/PxTriangleMesh.h")
@:native("::cpp::Reference<physx::PxTriangleMesh>")
extern class PxTriangleMesh extends PxBase
{
    /**
	\brief Returns the number of vertices.
	\return	number of vertices
	@see getVertices()
	*/
	function getNbVertices():PxU32;

	/**
	\brief Returns the vertices.
	\return	array of vertices
	@see getNbVertices()
	*/
    function getVertices():cpp.ConstPointer<PxVec3>;

//#if PX_ENABLE_DYNAMIC_MESH_RTREE
	/**
	\brief Returns all mesh vertices for modification.

	This function will return the vertices of the mesh so that their positions can be changed in place.
	After modifying the vertices you must call refitBVH for the refitting to actually take place.
	This function maintains the old mesh topology (triangle indices).	

	\return  inplace vertex coordinates for each existing mesh vertex.

	\note works only for PxMeshMidPhase::eBVH33
	\note Size of array returned is equal to the number returned by getNbVertices().
	\note This function operates on cooked vertex indices.
	\note This means the index mapping and vertex count can be different from what was provided as an input to the cooking routine.
	\note To achieve unchanged 1-to-1 index mapping with orignal mesh data (before cooking) please use the following cooking flags:
	\note eWELD_VERTICES = 0, eDISABLE_CLEAN_MESH = 1.
	\note It is also recommended to make sure that a call to validateTriangleMesh returns true if mesh cleaning is disabled.
	@see getNbVertices()
	@see refitBVH()	
	*/
    function getVerticesForModification():cpp.Pointer<PxVec3>;

	/**
	\brief Refits BVH for mesh vertices.

	This function will refit the mesh BVH to correctly enclose the new positions updated by getVerticesForModification.
	Mesh BVH will not be reoptimized by this function so significantly different new positions will cause significantly reduced performance.	

	\return New bounds for the entire mesh.

	\note works only for PxMeshMidPhase::eBVH33
	\note PhysX does not keep a mapping from the mesh to mesh shapes that reference it.
	\note Call PxShape::setGeometry on each shape which references the mesh, to ensure that internal data structures are updated to reflect the new geometry.
	\note PxShape::setGeometry does not guarantee correct/continuous behavior when objects are resting on top of old or new geometry.
	\note It is also recommended to make sure that a call to validateTriangleMesh returns true if mesh cleaning is disabled.
	\note Active edges information will be lost during refit, the rigid body mesh contact generation might not perform as expected.
	@see getNbVertices()
	@see getVerticesForModification()	
	*/
	function refitBVH():PxBounds3;
//#endif // PX_ENABLE_DYNAMIC_MESH_RTREE

	/**
	\brief Returns the number of triangles.
	\return	number of triangles
	@see getTriangles() getTrianglesRemap()
	*/
	function getNbTriangles():PxU32;

	/**
	\brief Returns the triangle indices.

	The indices can be 16 or 32bit depending on the number of triangles in the mesh.
	Call getTriangleMeshFlags() to know if the indices are 16 or 32 bits.

	The number of indices is the number of triangles * 3.

	\return	array of triangles
	@see getNbTriangles() getTriangleMeshFlags() getTrianglesRemap()
	*/
	function getTriangles():cpp.ConstPointer<cpp.Void>;

	/**
	\brief Reads the PxTriangleMesh flags.
	
	See the list of flags #PxTriangleMeshFlag

	\return The values of the PxTriangleMesh flags.

	@see PxTriangleMesh
	*/
	function getTriangleMeshFlags():PxTriangleMeshFlags;

	/**
	\brief Returns the triangle remapping table.

	The triangles are internally sorted according to various criteria. Hence the internal triangle order
	does not always match the original (user-defined) order. The remapping table helps finding the old
	indices knowing the new ones:

		remapTable[ internalTriangleIndex ] = originalTriangleIndex

	\return	the remapping table (or NULL if 'PxCookingParams::suppressTriangleMeshRemapTable' has been used)
	@see getNbTriangles() getTriangles() PxCookingParams::suppressTriangleMeshRemapTable
	*/
	function getTrianglesRemap():cpp.ConstPointer<PxU32>;


	/**	
	\brief Decrements the reference count of a triangle mesh and releases it if the new reference count is zero.	
	
	@see PxPhysics.createTriangleMesh()
	*/
	function release():Void;

	/**
	\brief Returns material table index of given triangle

	This function takes a post cooking triangle index.

	\param[in] triangleIndex (internal) index of desired triangle
	\return Material table index, or 0xffff if no per-triangle materials are used
	*/
	function getTriangleMaterialIndex(triangleIndex:PxTriangleID):PxMaterialTableIndex;

	/**
	\brief Returns the local-space (vertex space) AABB from the triangle mesh.

	\return	local-space bounds
	*/
	function getLocalBounds():PxBounds3;

	/**
	\brief Returns the reference count for shared meshes.

	At creation, the reference count of the mesh is 1. Every shape referencing this mesh increments the
	count by 1.	When the reference count reaches 0, and only then, the mesh gets destroyed automatically.

	\return the current reference count.
	*/
	function getReferenceCount():PxU32;

	/**
	\brief Acquires a counted reference to a triangle mesh.

	This method increases the reference count of the triangle mesh by 1. Decrement the reference count by calling release()
	*/
	function acquireReference():Void;
}

/**
\brief A triangle mesh containing the PxMeshMidPhase::eBVH33 structure.

@see PxMeshMidPhase
*/
@:include("geometry/PxTriangleMesh.h")
@:native("::cpp::Reference<physx::PxBVH33TriangleMesh>")
extern class PxBVH33TriangleMesh extends PxTriangleMesh {}

/**
\brief A triangle mesh containing the PxMeshMidPhase::eBVH34 structure.

@see PxMeshMidPhase
*/
@:include("geometry/PxTriangleMesh.h")
@:native("::cpp::Reference<physx::PxBVH34TriangleMesh>")
extern class PxBVH34TriangleMesh extends PxTriangleMesh {}