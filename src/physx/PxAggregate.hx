package physx;

import physx.foundation.PxBase;
import physx.foundation.PxSimpleTypes;
import physx.geometry.PxBVHStructure;
import physx.PxActor;

@:include("PxAggregate.h")
@:native("::cpp::Reference<physx::PxAggregate>")
extern class PxAggregate extends PxBase
{
	/**
	Deletes the aggregate object.

	Deleting the PxAggregate object does not delete the aggregated actors. If the PxAggregate object
	belongs to a scene, the aggregated actors are automatically re-inserted in that scene. If you intend
	to delete both the PxAggregate and its actors, it is best to release the actors first, then release
	the PxAggregate when it is empty.
	*/
    override public function release():Void;

	/**
	Adds an actor to the aggregate object.

	A warning is output if the total number of actors is reached, or if the incoming actor already belongs
	to an aggregate.

	If the aggregate belongs to a scene, adding an actor to the aggregate also adds the actor to that scene.

	If the actor already belongs to a scene, a warning is output and the call is ignored. You need to remove
	the actor from the scene first, before adding it to the aggregate.

	\note When BVHStructure is provided the actor shapes are grouped together. 
	The scene query pruning structure inside PhysX SDK will store/update one
	bound per actor. The scene queries against such an actor will query actor
	bounds and then make a local space query against the provided BVH structure, which is in
	actor's local space.

	@param actor The actor that should be added to the aggregate
	@param bvhStructure BVHStructure for actor shapes.
	@return	true if success
	*/
	public function addActor(actor:PxActor, bvhStructure:cpp.Pointer<PxBVHStructure>):Bool;

	/**
	\brief Removes an actor from the aggregate object.

	A warning is output if the incoming actor does not belong to the aggregate. Otherwise the actor is
	removed from the aggregate. If the aggregate belongs to a scene, the actor is reinserted in that
	scene. If you intend to delete the actor, it is best to call #PxActor::release() directly. That way
	the actor will be automatically removed from its aggregate (if any) and not reinserted in a scene.

	\param	[in] actor The actor that should be removed from the aggregate
	return	true if success
	*/
	public function removeActor(actor:PxActor):Void;

	/**
	\brief Adds an articulation to the aggregate object.

	A warning is output if the total number of actors is reached (every articulation link counts as an actor), 
	or if the incoming articulation already belongs	to an aggregate.

	If the aggregate belongs to a scene, adding an articulation to the aggregate also adds the articulation to that scene.

	If the articulation already belongs to a scene, a warning is output and the call is ignored. You need to remove
	the articulation from the scene first, before adding it to the aggregate.

	\param	[in] articulation The articulation that should be added to the aggregate
	return	true if success
	*/
	public function addArticulation(articulation:PxArticulationBase):Void;

	/**
	\brief Removes an articulation from the aggregate object.

	A warning is output if the incoming articulation does not belong to the aggregate. Otherwise the articulation is
	removed from the aggregate. If the aggregate belongs to a scene, the articulation is reinserted in that
	scene. If you intend to delete the articulation, it is best to call #PxArticulation::release() directly. That way
	the articulation will be automatically removed from its aggregate (if any) and not reinserted in a scene.

	\param	[in] articulation The articulation that should be removed from the aggregate
	return	true if success
	*/
	public function removeArticulation(articulation:PxArticulationBase):Bool;

	/**
	\brief Returns the number of actors contained in the aggregate.

	You can use #getActors() to retrieve the actor pointers.

	\return Number of actors contained in the aggregate.

	@see PxActor getActors()
	*/
	public function getNbActors():PxU32;

	/**
	\brief Retrieves max amount of actors that can be contained in the aggregate.

	\return Max aggregate size. 

	@see PxPhysics::createAggregate()
	*/
	public function getMaxNbActors():PxU32;

	/**
	\brief Retrieve all actors contained in the aggregate.

	You can retrieve the number of actor pointers by calling #getNbActors()

	\param[out] userBuffer The buffer to store the actor pointers.
	\param[in] bufferSize Size of provided user buffer.
	\param[in] startIndex Index of first actor pointer to be retrieved
	\return Number of actor pointers written to the buffer.

	@see PxShape getNbShapes()
	*/
	//virtual PxU32		getActors(PxActor** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

	/**
	\brief Retrieves the scene which this aggregate belongs to.

	\return Owner Scene. NULL if not part of a scene.

	@see PxScene
	*/
	public function getScene():PxScene; // cpp.RawPointer<PxScene>;

	/**
	\brief Retrieves aggregate's self-collision flag.

	\return self-collision flag
	*/
	public function getSelfCollision():Bool;
}