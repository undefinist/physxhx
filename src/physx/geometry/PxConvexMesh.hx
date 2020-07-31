package physx.geometry;

import physx.foundation.PxBounds3;
import physx.foundation.PxMat33;
import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxBase;

/**
\brief Polygon data

Plane format: (mPlane0,mPlane1,mPlane2).dot(x) + mPlane3 = 0
With the normal outward-facing from the hull.
*/
@:include("geometry/PxConvexMesh.h")
@:native("::cpp::Struct<physx::PxHullPolygon>")
extern class PxHullPolygon
{
    /**
     * Plane equation for this polygon, mPlane[0]
     */
    @:native("mPlane[0]") var mPlane0:PxReal;
    /**
     * Plane equation for this polygon, mPlane[1]
     */
    @:native("mPlane[1]") var mPlane1:PxReal;
    /**
     * Plane equation for this polygon, mPlane[2]
     */
    @:native("mPlane[2]") var mPlane2:PxReal;
    /**
     * Plane equation for this polygon, mPlane[3]
     */
    @:native("mPlane[3]") var mPlane3:PxReal;
    /**
     * Number of vertices/edges in the polygon
     */
    var mNbVerts:PxU16;
    /**
     * Offset in index buffer
     */
    var mIndexBase:PxU16;
}

/**
 * A convex mesh.
 * 
 * Internally represented as a list of convex polygons. The number
 * of polygons is limited to 256.
 * 
 * To avoid duplicating data when you have several instances of a particular
 * mesh positioned differently, you do not use this class to represent a
 * convex object directly. Instead, you create an instance of this mesh via
 * the `PxConvexMeshGeometry` and `PxShape` classes.
 * 
 * **Creation:**
 * 
 * To create an instance of this class call `PxPhysics.createConvexMesh()`,
 * and `PxConvexMesh.release()` to delete it. This is only possible
 * once you have released all of its `PxShape` instances.
 * 
 * **Visualizations:**
 * - `PxVisualizationParameter.eCOLLISION_AABBS`
 * - `PxVisualizationParameter.eCOLLISION_SHAPES`
 * - `PxVisualizationParameter.eCOLLISION_AXES`
 * - `PxVisualizationParameter.eCOLLISION_FNORMALS`
 * - `PxVisualizationParameter.eCOLLISION_EDGES`
 * 
 * @see PxConvexMeshDesc PxPhysics.createConvexMesh()
 */
@:include("geometry/PxConvexMesh.h")
@:native("::cpp::Reference<physx::PxConvexMesh>")
extern class PxConvexMesh extends PxBase
{
    /**
    \brief Returns the number of vertices.
    \return	Number of vertices.
    @see getVertices()
    */
    function getNbVertices():PxU32;

    /**
    \brief Returns the vertices.
    \return	Array of vertices.
    @see getNbVertices()
    */
    function getVertices():cpp.ConstPointer<PxVec3>;

    /**
    \brief Returns the index buffer.
    \return	Index buffer.
    @see getNbPolygons() getPolygonData()
    */
    function getIndexBuffer():cpp.ConstPointer<PxU8>;

    /**
    \brief Returns the number of polygons.
    \return	Number of polygons.
    @see getIndexBuffer() getPolygonData()
    */
    function getNbPolygons():PxU32;

    /**
    \brief Returns the polygon data.
    \param[in] index	Polygon index in [0 ; getNbPolygons()[.
    \param[out] data	Polygon data.
    \return	True if success.
    @see getIndexBuffer() getNbPolygons()
    */
    function getPolygonData(index:PxU32, data:cpp.Reference<PxHullPolygon>):Bool;

    /**
    \brief Decrements the reference count of a convex mesh and releases it if the new reference count is zero.	
    
    @see PxPhysics.createConvexMesh() PxConvexMeshGeometry PxShape
    */
    function release():Void;

    /**
    \brief Returns the reference count of a convex mesh.

    At creation, the reference count of the convex mesh is 1. Every shape referencing this convex mesh increments the
    count by 1.	When the reference count reaches 0, and only then, the convex mesh gets destroyed automatically.

    \return the current reference count.
    */
    function getReferenceCount():PxU32;

    /**
    \brief Acquires a counted reference to a convex mesh.

    This method increases the reference count of the convex mesh by 1. Decrement the reference count by calling release()
    */
    function acquireReference():Void;

    /**
    \brief Returns the mass properties of the mesh assuming unit density.

    The following relationship holds between mass and volume:

        mass = volume * density

    The mass of a unit density mesh is equal to its volume, so this function returns the volume of the mesh.

    Similarly, to obtain the localInertia of an identically shaped object with a uniform density of d, simply multiply the
    localInertia of the unit density mesh by d.

    \param[out] mass The mass of the mesh assuming unit density.
    \param[out] localInertia The inertia tensor in mesh local space assuming unit density.
    \param[out] localCenterOfMass Position of center of mass (or centroid) in mesh local space.
    */
    function getMassInformation(mass:cpp.Reference<PxReal>, localInertia:cpp.Reference<PxMat33>, localCenterOfMass:cpp.Reference<PxVec3>):Void;

    /**
    \brief Returns the local-space (vertex space) AABB from the convex mesh.

    \return	local-space bounds
    */
    function getLocalBounds():PxBounds3;

    /**
    \brief This method decides whether a convex mesh is gpu compatible. If the total number of vertices are more than 64 or any number of vertices in a polygon is more than 32, or
    convex hull data was not cooked with GPU data enabled during cooking or was loaded from a serialized collection, the convex hull is incompatible with GPU collision detection. Otherwise
    it is compatible.

    \return True if the convex hull is gpu compatible
    */
    function isGpuCompatible():Bool;
}