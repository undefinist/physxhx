package physx.geometry;

import physx.foundation.PxBase;
import physx.foundation.PxBounds3;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;

/**
\brief Class representing the bounding volume hierarchy structure.

PxBVHStructure can be  provided to PxScene::addActor. In this case the scene query 
pruning structure inside PhysX SDK will store/update one bound per actor. 
The scene queries against such an actor will query actor bounds and then 
make a local space query against the provided BVH structure, which is in
actor's local space.

@see PxScene::addActor
*/
@:include("geometry/PxBVHStructure.h")
@:native("::cpp::Reference<physx::PxBVHStructure>")
extern class PxBVHStructure extends PxBase
{
    /**
     * Raycast test against a BVH structure.
     * 
     * @param [in]origin		The origin of the ray.
     * @param [in]unitDir		Normalized direction of the ray.
     * @param [in]maxDist		Maximum ray length, has to be in the [0, inf) range
     * @param [in]maxHits		Max number of returned hits = size of 'rayHits' buffer
     * @param [out]rayHits		Raycast hits information, bounds indices 
     * @return Number of hits  
     */
    function raycast(origin:PxVec3, unitDir:PxVec3,
        maxDist:PxReal, maxHits:PxU32,
        rayHits:cpp.Pointer<PxU32>):PxU32;

    /**
     * Sweep test against a BVH structure.
     * 
     * @param [in]aabb			The axis aligned bounding box to sweep
     * @param [in]unitDir		Normalized direction of the sweep.
     * @param [in]maxDist		Maximum sweep length, has to be in the [0, inf) range
     * @param [in]maxHits		Max number of returned hits = size of 'sweepHits' buffer
     * @param [out]sweepHits	Sweep hits information, bounds indices 
     * @return Number of hits 
     */
    function sweep(aabb:PxBounds3, unitDir:PxVec3,
        maxDist:PxReal, maxHits:PxU32,
        sweepHits:cpp.Pointer<PxU32>):PxU32;

    /**
     * AABB overlap test against a BVH structure.
     * 
     * @param [in]aabb			The axis aligned bounding box		
     * @param [in]maxHits		Max number of returned hits = size of 'overlapHits' buffer
     * @param [out]overlapHits	Overlap hits information, bounds indices 
     * @return Number of hits 
     */
    function overlap(aabb:PxBounds3, maxHits:PxU32,
        overlapHits:cpp.Pointer<PxU32>):PxU32;

    /**
    \brief Retrieve the bounds in the BVH.

    @see PxBounds3
    */
    function getBounds():cpp.ConstPointer<PxBounds3>;

    /**
    \brief Returns the number of bounds in the BVH.

    You can use `getBounds()` to retrieve the bounds.

    \return Number of bounds in the BVH.

    */
    function getNbBounds():PxU32;
}