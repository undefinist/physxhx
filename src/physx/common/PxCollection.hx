package physx.common;

import physx.common.PxSerialFramework;
import physx.foundation.PxBase;
import physx.foundation.PxSimpleTypes;

/**
\brief Collection class for serialization.

A collection is a set of PxBase objects. PxBase objects can be added to the collection
regardless of other objects they depend on. Objects may be named using PxSerialObjectId values in order 
to resolve dependencies between objects of different collections.

Serialization and deserialization only work through collections.

A scene is typically serialized using the following steps:

 -`` create a serialization registry
 -`` create a collection for scene objects
 -`` complete the scene objects (adds all dependent objects, e.g. meshes)
 -`` serialize collection
 -`` release collection
 -`` release serialization registry

For example the code may look like this:

\code
    PxPhysics* physics; // The physics
    PxScene* scene;		// The physics scene
    SerialStream s;		// The user-defined stream doing the actual write to disk
    
    PxSerializationRegistry* registry = PxSerialization::createSerializationRegistry(*physics);	// step 1)
    PxCollection* collection = PxSerialization::createCollection(*scene);						// step 2)
    PxSerialization::complete(*collection, *registry);											// step 3)
    PxSerialization::serializeCollectionToBinary(s, *collection, *registry);					// step 4)
    collection->release();																		// step 5)
    registry->release();																		// step 6)
\endcode

A scene is typically deserialized using the following steps:

 -`` load a serialized collection into memory
 -`` create a serialization registry
 -`` create a collection by passing the serialized memory block
 -`` add collected objects to scene
 -`` release collection
 -`` release serialization registry

For example the code may look like this:

\code
    PxPhysics* physics; // The physics
    PxScene* scene;		// The physics scene
    void* memory128;	// a 128-byte aligned buffer previously loaded from disk by the user	- step 1)
    
    PxSerializationRegistry* registry = PxSerialization::createSerializationRegistry(*physics);		// step 2)
    PxCollection* collection = PxSerialization::createCollectionFromBinary(memory128, *registry);	// step 3)
    scene->addCollection(*collection);																// step 4)
    collection->release();																			// step 5)
    registry->release();																			// step 6)
\endcode

@see PxBase, PxCreateCollection()
*/
@:include("common/PxCollection.h")
@:native("::cpp::Reference<physx::PxCollection>")
extern class PxCollection
{
    /**
    \brief Adds a PxBase object to the collection.

    Adds a PxBase object to the collection. Optionally a PxSerialObjectId can be provided
    in order to resolve dependencies between collections. A PxSerialObjectId value of PX_SERIAL_OBJECT_ID_INVALID 
    means the object remains without id. Objects can be added regardless of other objects they require. If the object
    is already in the collection, the ID will be set if it was PX_SERIAL_OBJECT_ID_INVALID previously, otherwise the
    operation fails.


    \param[in] object Object to be added to the collection
    \param[in] id Optional PxSerialObjectId id
    */
    function add(object:PxBase, ?id:PxSerialObjectId = PX_SERIAL_OBJECT_ID_INVALID):Void;

    /**
    \brief Removes a PxBase member object from the collection.

    Object needs to be contained by the collection.

    \param[in] object PxBase object to be removed
    */
    function remove(object:PxBase):Void;
            
    /**
    \brief Returns whether the collection contains a certain PxBase object.

    \param[in] object PxBase object
    \return Whether object is contained.
    */
    function contains(object:PxBase):Bool;

    /**
    \brief Adds an id to a member PxBase object.

    If the object is already associated with an id within the collection, the id is replaced.
    May only be called for objects that are members of the collection. The id needs to be unique 
    within the collection.
    
    \param[in] object Member PxBase object
    \param[in] id PxSerialObjectId id to be given to the object
    */
    function addId(object:PxBase, id:PxSerialObjectId):Void;

    /**
    \brief Removes id from a contained PxBase object.

    May only be called for ids that are associated with an object in the collection.
    
    \param[in] id PxSerialObjectId value
    */
    function removeId(id:PxSerialObjectId):Void;
    
    /**
    \brief Adds all PxBase objects and their ids of collection to this collection.

    PxBase objects already in this collection are ignored. Object ids need to be conflict 
    free, i.e. the same object may not have two different ids within the two collections.
    
    \param[in] collection Collection to be added
    */
    @:native("add") function addOfCollection(collection:PxCollection):Void;

    /**
    \brief Removes all PxBase objects of collection from this collection.

    PxBase objects not present in this collection are ignored. Ids of objects 
    which are removed are also removed.

    \param[in] collection Collection to be removed
    */
    @:native("remove") function removeOfCollection(collection:PxCollection):Void;

    /**
    \brief Gets number of PxBase objects in this collection.
    
    \return Number of objects in this collection
    */
    function getNbObjects():PxU32;

    /**
    \brief Gets the PxBase object of this collection given its index.

    \param[in] index PxBase index in [0, getNbObjects())
    \return PxBase object at index index
    */
    function getObject(index:PxU32):PxBase;

    /**
    \brief Copies member PxBase pointers to a user specified buffer.

    \param[out] userBuffer Array of PxBase pointers
    \param[in] bufferSize Capacity of userBuffer
    \param[in] startIndex Offset into list of member PxBase objects
    \return number of members PxBase objects that have been written to the userBuffer 
    */
//virtual	PxU32						getObjects(PxBase** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    /**
    \brief Looks for a PxBase object given a PxSerialObjectId value.

    If there is no PxBase object in the collection with the given id, NULL is returned.

    \param[in] id PxSerialObjectId value to look for
    \return PxBase object with the given id value or NULL
    */
    function find(id:PxSerialObjectId):PxBase;
    
    /**
    \brief Gets number of PxSerialObjectId names in this collection.
    
    \return Number of PxSerialObjectId names in this collection
    */
    function getNbIds():PxU32;

    /**
    \brief Copies member PxSerialObjectId values to a user specified buffer.

    \param[out] userBuffer Array of PxSerialObjectId values
    \param[in] bufferSize Capacity of userBuffer
    \param[in] startIndex Offset into list of member PxSerialObjectId values
    \return number of members PxSerialObjectId values that have been written to the userBuffer 
    */
//virtual	PxU32						getIds(PxSerialObjectId* userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    /**
    \brief Gets the PxSerialObjectId name of a PxBase object within the collection.

    The PxBase object needs to be a member of the collection.

    \param[in] object PxBase object to get id for
    \return PxSerialObjectId name of the object or PX_SERIAL_OBJECT_ID_INVALID if the object is unnamed
    */
    function getId(object:PxBase):PxSerialObjectId;

    /**
    \brief Deletes a collection object.

    This function only deletes the collection object, i.e. the container class. It doesn't delete objects
    that are part of the collection.

    @see PxCreateCollection() 
    */
    function release():Void;
    
    /**
    \brief Creates a collection object.

    Objects can only be serialized or deserialized through a collection.
    For serialization, users must add objects to the collection and serialize the collection as a whole.
    For deserialization, the system gives back a collection of deserialized objects to users.

    \return The new collection object.

    @see PxCollection, PxCollection::release()
    */
    @:native("::PxCreateCollection") static function create():PxCollection;
}