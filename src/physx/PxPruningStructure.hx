package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxBase;

/**
\brief A precomputed pruning structure to accelerate scene queries against newly added actors.

The pruning structure can be provided to #PxScene:: addActors() in which case it will get merged
directly into the scene query optimization AABB tree, thus leading to improved performance when
doing queries against the newly added actors. This applies to both static and dynamic actors.

\note PxPruningStructure objects can be added to a collection and get serialized.
\note Adding a PxPruningStructure object to a collection will also add the actors that were used to build the pruning structure.

\note PxPruningStructure must be released before its rigid actors.
\note PxRigidBody objects can be in one PxPruningStructure only.
\note Changing the bounds of PxRigidBody objects assigned to a pruning structure that has not been added to a scene yet will 
invalidate the pruning structure. Same happens if shape scene query flags change or shape gets removed from an actor.

@see PxScene::addActors PxCollection
*/
@:include("PxPruningStructure.hx")
@:native("::cpp::Reference<PxPruningStructure>")
extern class PxPruningStructure extends PxBase
{
    /**
	\brief Retrieve rigid actors in the pruning structure.

	You can retrieve the number of rigid actor pointers by calling #getNbRigidActors()

	\param[out] userBuffer The buffer to store the actor pointers.
	\param[in] bufferSize Size of provided user buffer.
	\param[in] startIndex Index of first actor pointer to be retrieved
	\return Number of rigid actor pointers written to the buffer.

	@see PxRigidActor
	*/
	//function getRigidActors(PxRigidActor** userBuffer, PxU32 bufferSize, PxU32 startIndex=0):PxU32;

	/**
	\brief Returns the number of rigid actors in the pruning structure.

	You can use #getRigidActors() to retrieve the rigid actor pointers.

	\return Number of rigid actors in the pruning structure.

	@see PxRigidActor
	*/
	function getNbRigidActors():PxU32;
}