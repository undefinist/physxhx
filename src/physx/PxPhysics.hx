package physx;

import physx.geometry.PxConvexMesh;
import physx.geometry.PxBVHStructure;
import physx.geometry.PxHeightField;
import physx.PxShape.PxShapeFlag;
import physx.PxShape.PxShapeFlags;
import physx.geometry.PxGeometry;
import physx.foundation.PxTransform;
import physx.common.PxTolerancesScale;
import physx.foundation.PxIO;
import physx.foundation.PxSimpleTypes;
import physx.geometry.PxTriangleMesh;
import physx.pvd.PxPvd;
import physx.PxSceneDesc;

/**
Abstract singleton factory class used for instancing objects in the Physics SDK.

In addition you can use PxPhysics to set global parameters which will effect all scenes and create 
objects that can be shared across multiple scenes.

You can get an instance of this class by calling PxCreateBasePhysics() or PxCreatePhysics() with pre-registered modules.

@see PxCreatePhysics() PxCreateBasePhysics() PxScene PxVisualizationParameter
*/
@:include("PxPhysics.h")
@:native("::cpp::Reference<physx::PxPhysics>")
extern class PxPhysics
{

    // global namespace fns

    @:native("::PxCreatePhysics")
    @:overload(function(version:PxU32, foundation:PxFoundation, scale:PxTolerancesScale):PxPhysics{})
    @:overload(function(version:PxU32, foundation:PxFoundation, scale:PxTolerancesScale, trackOutstandingAllocations:Bool):PxPhysics{})
    static function create(version:PxU32,
                           foundation:PxFoundation,
                           scale:PxTolerancesScale, 
                           trackOutstandingAllocations:Bool, 
                           pvd:PxPvd):PxPhysics;



    // Basics

    /**	
    Destroys the instance it is called on.

    Use this release method to destroy an instance of this class. Be sure
    to not keep a reference to this object after calling release.
    Avoid release calls while a scene is simulating (in between simulate() and fetchResults() calls).

    Note that this must be called once for each prior call to PxCreatePhysics, as
    there is a reference counter. Also note that you mustn't destroy the allocator or the error callback (if available) until after the
    reference count reaches 0 and the SDK is actually removed.

    Releasing an SDK will also release any scenes, triangle meshes, convex meshes, heightfields and shapes
    created through it, provided the user hasn't already done so.

    **Note:** This function is required to be called to release foundation usage.

    @see PxCreatePhysics()
    */
    function release():Void;

    /**
    Retrieves the Foundation instance.
    @return A reference to the Foundation object.
    */
    function getFoundation():PxFoundation;

    /**
    Creates an aggregate with the specified maximum size and selfCollision property.

    @param [in]maxSize				The maximum number of actors that may be placed in the aggregate.
    @param [in]enableSelfCollision	Whether the aggregate supports self-collision
    @return The new aggregate.

    @see PxAggregate
    */
    function createAggregate(maxSize:PxU32, enableSelfCollision:Bool):PxAggregate;

    /**
    Returns the simulation tolerance parameters.  
    @return The current simulation tolerance parameters.  
    */
    function getTolerancesScale():PxTolerancesScale;



    // Meshes

    /**
    Creates a triangle mesh object.

    This can then be instanced into `PxShape` objects.

    @param [in]stream	The triangle mesh stream.
    @return The new triangle mesh.

    @see PxTriangleMesh PxMeshPreprocessingFlag PxTriangleMesh.release() PxInputStream PxTriangleMeshFlag
    */
    function createTriangleMesh(stream:PxInputStream):PxTriangleMesh;
    
    /**
    Return the number of triangle meshes that currently exist.

    @return Number of triangle meshes.

    @see getTriangleMeshes()
    */
    function getNbTriangleMeshes():PxU32;

    // /**
    // Writes the array of triangle mesh pointers to a user buffer.
    
    // Returns the number of pointers written.

    // The ordering of the triangle meshes in the array is not specified.

    // @param [out]userBuffer	The buffer to receive triangle mesh pointers.
    // @param [in] bufferSize	The number of triangle mesh pointers which can be stored in the buffer.
    // @param [in] startIndex	Index of first mesh pointer to be retrieved
    // @return The number of triangle mesh pointers written to userBuffer, this should be less or equal to bufferSize.

    // @see getNbTriangleMeshes() PxTriangleMesh
    // */
    // virtual	PxU32				getTriangleMeshes(PxTriangleMesh** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    /**
    Creates a heightfield object from previously cooked stream.

    This can then be instanced into `PxShape` objects.

    @param [in]stream	The heightfield mesh stream.
    @return The new heightfield.

    @see PxHeightField PxHeightField.release() PxInputStream PxRegisterHeightFields
    */
    function createHeightField(stream:PxInputStream):PxHeightField;

    /**
    Return the number of heightfields that currently exist.

    @return Number of heightfields.

    @see getHeightFields()
    */
    function getNbHeightFields():PxU32;

    // /**
    // Writes the array of heightfield pointers to a user buffer.
    
    // Returns the number of pointers written.

    // The ordering of the heightfields in the array is not specified.

    // @param [out]userBuffer	The buffer to receive heightfield pointers.
    // @param [in] bufferSize	The number of heightfield pointers which can be stored in the buffer.
    // @param [in] startIndex	Index of first heightfield pointer to be retrieved
    // @return The number of heightfield pointers written to userBuffer, this should be less or equal to bufferSize.

    // @see getNbHeightFields() PxHeightField
    // */
    // virtual	PxU32				getHeightFields(PxHeightField** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    /**
    Creates a convex mesh object.

    This can then be instanced into `PxShape` objects.

    @param [in]stream	The stream to load the convex mesh from.
    @return The new convex mesh.

    @see PxConvexMesh PxConvexMesh.release() PxInputStream createTriangleMesh() PxConvexMeshGeometry PxShape
    */
    function createConvexMesh(stream:PxInputStream):PxConvexMesh;

    /**
    Return the number of convex meshes that currently exist.

    @return Number of convex meshes.

    @see getConvexMeshes()
    */
    function getNbConvexMeshes():PxU32;

    // /**
    // Writes the array of convex mesh pointers to a user buffer.
    
    // Returns the number of pointers written.

    // The ordering of the convex meshes in the array is not specified.

    // @param [out]userBuffer	The buffer to receive convex mesh pointers.
    // @param [in] bufferSize	The number of convex mesh pointers which can be stored in the buffer.
    // @param [in] startIndex	Index of first convex mesh pointer to be retrieved
    // @return The number of convex mesh pointers written to userBuffer, this should be less or equal to bufferSize.

    // @see getNbConvexMeshes() PxConvexMesh
    // */
    // virtual	PxU32				getConvexMeshes(PxConvexMesh** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    /**
    Creates a bounding volume hierarchy structure.
    
    @param [in]stream	The stream to load the BVH structure from.
    @return The new BVH structure.

    @see PxBVHStructure PxInputStream
    */
    function createBVHStructure(stream:PxInputStream):PxBVHStructure;

    /**
    Return the number of bounding volume hierarchy structures that currently exist.

    @return Number of bounding volume hierarchy structures.

    @see getBVHStructures()
    */
    function getNbBVHStructures():PxU32;

    // /**
    // Writes the array of bounding volume hierarchy structure pointers to a user buffer.
    
    // Returns the number of pointers written.

    // The ordering of the BVH structures in the array is not specified.

    // @param [out]userBuffer	The buffer to receive BVH structure pointers.
    // @param [in] bufferSize	The number of BVH structure pointers which can be stored in the buffer.
    // @param [in] startIndex	Index of first BVH structure pointer to be retrieved
    // @return The number of BVH structure pointers written to userBuffer, this should be less or equal to bufferSize.

    // @see getNbBVHStructures() PxBVHStructure
    // */
    // virtual	PxU32				getBVHStructures(PxBVHStructure** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;



    // Scenes
    
    /**
    Creates a scene.

    **Note:** Every scene uses a Thread Local Storage slot. This imposes a platform specific limit on the
    number of scenes that can be created.

    @param [in]sceneDesc	Scene descriptor. See `PxSceneDesc`
    @return The new scene object.

    @see PxScene PxScene.release() PxSceneDesc
    */
    function createScene(sceneDesc:PxSceneDesc):PxScene;
    
    /**
    Gets number of created scenes.

    @return The number of scenes created.

    @see getScene()
    */
    function getNbScenes():PxU32;

    /**
    Writes the array of scene pointers to a user buffer.
    
    Returns the number of pointers written.

    The ordering of the scene pointers in the array is not specified.

    @param [out]userBuffer	The buffer to receive scene pointers.
    @param [in] bufferSize	The number of scene pointers which can be stored in the buffer.
    @param [in] startIndex	Index of first scene pointer to be retrieved
    @return The number of scene pointers written to userBuffer, this should be less or equal to bufferSize.

    @see getNbScenes() PxScene
    */
//function getScenes(PxScene** userBuffer, PxU32 bufferSize, PxU32 startIndex=0):PxU32;
    
    //@}
    /** @name Actors
    */
    //@{

    /**
    Creates a static rigid actor with the specified pose and all other fields initialized
    to their default values.
    
    @param [in]pose	The initial pose of the actor. Must be a valid transform

    @see PxRigidStatic
    */
    function createRigidStatic(pose:PxTransform):PxRigidStatic;

    /**
    Creates a dynamic rigid actor with the specified pose and all other fields initialized
    to their default values.
    
    @param [in]pose	The initial pose of the actor. Must be a valid transform

    @see PxRigidDynamic
    */
    function createRigidDynamic(pose:PxTransform):PxRigidDynamic;
    
    /**
    Creates a pruning structure from actors.

    **Note:** Every provided actor needs at least one shape with the eSCENE_QUERY_SHAPE flag set.
    **Note:** Both static and dynamic actors can be provided.
    **Note:** It is not allowed to pass in actors which are already part of a scene.
    **Note:** Articulation links cannot be provided.

    @param [in]actors		Array of actors to add to the pruning structure. Must be non NULL.
    @param [in]nbActors	Number of actors in the array. Must be >0.
    @return Pruning structure created from given actors, or NULL if any of the actors did not comply with the above requirements.
    @see PxActor PxPruningStructure
    */
    inline function createPruningStructure(actors:Array<PxRigidActor>):PxPruningStructure
    {
        var p:cpp.Pointer<PxRigidActor> = cpp.Pointer.ofArray(actors);
        return untyped __cpp__(
            "{0}->createPruningStructure(reinterpret_cast<PxRigidActor*const*>({1}), {2})",
            this, p, actors.length);
    }



    // Shapes
    
    /**
    Creates a shape which may be attached to multiple actors
    
    The shape will be created with a reference count of 1.

    Shared shapes are not mutable when they are attached to an actor

    @param geometry		The geometry for the shape
    @param material		The material for the shape
    @param isExclusive	Whether this shape is exclusive to a single actor or maybe be shared, default `false`
    @param shapeFlags	The PxShapeFlags to be set, default `eVISUALIZATION \| eSCENE_QUERY_SHAPE \| eSIMULATION_SHAPE`

    @see PxShape
    */
    @:overload(function(geometry:PxGeometry, material:PxMaterial):PxShape {})
    @:overload(function(geometry:PxGeometry, material:PxMaterial, isExclusive:Bool):PxShape {})
    function createShape(geometry:PxGeometry, material:PxMaterial, isExclusive:Bool, shapeFlags:PxShapeFlags):PxShape;

    /**
    Creates a shape which may be attached to multiple actors
    
    The shape will be created with a reference count of 1.

    @param [in]geometry		The geometry for the shape
    @param [in]materials		The materials for the shape
    @param [in]materialCount	The number of materials
    @param [in]isExclusive	Whether this shape is exclusive to a single actor or may be shared
    @param [in]shapeFlags		The PxShapeFlags to be set

    Shared shapes are not mutable when they are attached to an actor

    @see PxShape
    */
    // virtual PxShape*			createShape(const PxGeometry& geometry, 
    //                                         PxMaterial*const * materials, 
    //                                         PxU16 materialCount, 
    //                                         bool isExclusive = false,
    //                                         PxShapeFlags shapeFlags = PxShapeFlag::eVISUALIZATION | PxShapeFlag::eSCENE_QUERY_SHAPE | PxShapeFlag::eSIMULATION_SHAPE) = 0;

    /**
    Return the number of shapes that currently exist.

    @return Number of shapes.

    @see getShapes()
    */
    function getNbShapes():PxU32;

    /**
    Writes the array of shape pointers to a user buffer.
    
    Returns the number of pointers written.

    The ordering of the shapes in the array is not specified.

    @param [out]userBuffer	The buffer to receive shape pointers.
    @param [in] bufferSize	The number of shape pointers which can be stored in the buffer.
    @param [in] startIndex	Index of first shape pointer to be retrieved
    @return The number of shape pointers written to userBuffer, this should be less or equal to bufferSize.

    @see getNbShapes() PxShape
    */
    //virtual	PxU32				getShapes(PxShape** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;

    //@}
    /** @name Constraints and Articulations
    */
    //@{

    /**
    Creates a constraint shader.

    **Note:** A constraint shader will get added automatically to the scene the two linked actors belong to. Either, but not both, of actor0 and actor1 may
    be NULL to denote attachment to the world.
    
    @param [in]actor0		The first actor
    @param [in]actor1		The second actor
    @param [in]connector	The connector object, which the SDK uses to communicate with the infrastructure for the constraint
    @param [in]shaders	The shader functions for the constraint
    @param [in]dataSize	The size of the data block for the shader

    @return The new shader.

    @see PxConstraint
    */
    //function createConstraint(actor0:PxRigidActor, actor1:PxRigidActor, PxConstraintConnector& connector, const PxConstraintShaderTable& shaders, PxU32 dataSize):PxConstraint;

    /**
    Creates an articulation with all fields initialized to their default values.
    
    @return the new articulation

    @see PxArticulation, PxRegisterArticulations
    */
    function createArticulation():PxArticulation;

    /**
    Creates a reduced coordinate articulation with all fields initialized to their default values.

    @return the new articulation

    @see PxArticulationReducedCoordinate, PxRegisterArticulationsReducedCoordinate
    */
    function createArticulationReducedCoordinate():PxArticulationReducedCoordinate;



    // Materials

    /**
    Creates a new material with default properties.

    @return The new material.

    @param [in]staticFriction		The coefficient of static friction
    @param [in]dynamicFriction	The coefficient of dynamic friction
    @param [in]restitution		The coefficient of restitution

    @see PxMaterial 
    */
    function createMaterial(staticFriction:PxReal, dynamicFriction:PxReal, restitution:PxReal):PxMaterial;


    /**
    Return the number of materials that currently exist.

    @return Number of materials.

    @see getMaterials()
    */
    function getNbMaterials():PxU32;

    /**
    Writes the array of material pointers to a user buffer.
    
    Returns the number of pointers written.

    The ordering of the materials in the array is not specified.

    @param [out]userBuffer	The buffer to receive material pointers.
    @param [in] bufferSize	The number of material pointers which can be stored in the buffer.
    @param [in] startIndex	Index of first material pointer to be retrieved
    @return The number of material pointers written to userBuffer, this should be less or equal to bufferSize.

    @see getNbMaterials() PxMaterial
    */
    //virtual	PxU32				getMaterials(PxMaterial** userBuffer, PxU32 bufferSize, PxU32 startIndex=0) const = 0;


}