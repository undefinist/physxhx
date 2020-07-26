package physx.extensions;

import physx.foundation.PxPlane;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxTransform;
import physx.geometry.PxGeometry;

@:include("extensions/PxSimpleFactory.h")
extern class PxSimpleFactory
{
    
    /** 
    \brief simple method to create a PxRigidDynamic actor with a single PxShape. 

    @param sdk the PxPhysics object
    @param transform the global pose of the new object
    @param geometry the geometry of the new object's shape, which must be a sphere, capsule, box or convex
    @param material the material for the new object's shape
    @param shape shape the shape of the new object
    @param density the density of the new object. Must be greater than zero.
    @param shapeOffset an optional offset for the new shape, defaults to identity

    @return a new dynamic actor with the PxRigidBodyFlag, or NULL if it could 
    not be constructed

    @see PxRigidDynamic PxShapeFlag
    */
    @:native("physx::PxCreateDynamic")
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        geometry:PxGeometry,
                        material:PxMaterial,
                        density:PxReal):PxRigidDynamic {})
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        shape:PxShape,
                        density:PxReal):PxRigidDynamic {})
    static function createDynamic(sdk:PxPhysics,
                                  transform:PxTransform,
                                  geometry:PxGeometry,
                                  material:PxMaterial,
                                  density:PxReal,
                                  shapeOffset:PxTransform):PxRigidDynamic;


    /**
    \brief simple method to create a kinematic PxRigidDynamic actor with a single PxShape. 

    unlike PxCreateDynamic, the geometry is not restricted to box, capsule, sphere or convex. However, 
	kinematics of other geometry types may not participate in simulation collision and may be used only for
	triggers or scene queries of moving objects under animation control. In this case the density parameter
	will be ignored and the created shape will be set up as a scene query only shape (see #PxShapeFlag::eSCENE_QUERY_SHAPE)

    @param sdk the PxPhysics object
    @param transform the global pose of the new object
    @param geometry the geometry of the new object's shape, which must be a sphere, capsule, box or convex
    @param material the material for the new object's shape
    @param shape shape the shape of the new object
    @param density the density of the new object. Must be greater than zero.
    @param shapeOffset an optional offset for the new shape, defaults to identity

    @return a new dynamic actor with the PxRigidBodyFlag::eKINEMATIC set, or NULL if it could 
	not be constructed

    @see PxRigidDynamic PxShapeFlag
    */
    @:native("physx::PxCreateKinematic")
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        geometry:PxGeometry,
                        material:PxMaterial,
                        density:PxReal):PxRigidDynamic {})
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        shape:PxShape,
                        density:PxReal):PxRigidDynamic {})
    static function createKinematic(sdk:PxPhysics,
                                    transform:PxTransform,
                                    geometry:PxGeometry,
                                    material:PxMaterial,
                                    density:PxReal,
                                    shapeOffset:PxTransform):PxRigidDynamic;
    

    /** 
    \brief simple method to create a PxRigidStatic actor with a single PxShape.  

    @param sdk the PxPhysics object
    @param transform the global pose of the new object
    @param geometry the geometry of the new object's shape, which must be a sphere, capsule, box or convex
    @param material the material for the new object's shape
    @param shape shape the shape of the new object
    @param shapeOffset an optional offset for the new shape, defaults to identity

    @return a new static actor, or NULL if it could not be constructed

	@see PxRigidStatic
    */
    @:native("physx::PxCreateStatic")
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        geometry:PxGeometry,
                        material:PxMaterial):PxRigidStatic {})
    @:overload(function(sdk:PxPhysics,
                        transform:PxTransform,
                        shape:PxShape):PxRigidStatic {})
    static function createStatic(sdk:PxPhysics,
                                  transform:PxTransform,
                                  geometry:PxGeometry,
                                  material:PxMaterial,
                                  shapeOffset:PxTransform):PxRigidStatic;


    /**
    \brief create a shape by copying attributes from another shape

    The function clones a PxShape. The following properties are copied:
    - geometry
    - flags
    - materials
    - actor-local pose
    - contact offset
    - rest offset
    - simulation filter data
    - query filter data

    The following are not copied and retain their default values:
    - name
    - user data

    \param[in] physicsSDK - the physics SDK used to allocate the shape
    \param[in] shape the shape from which to take the attributes.
    \param[in] isExclusive whether the new shape should be an exclusive or shared shape.

    \return the newly-created rigid static

    */
    @:native("physx::PxCloneShape")
    static function cloneShape(physicsSDK:PxPhysics, shape:PxShape, isExclusive:Bool):PxShape;

    /**
    \brief create a static body by copying attributes from another rigid actor
    
    The function clones a PxRigidDynamic or PxRigidStatic as a PxRigidStatic. A uniform scale is applied. The following properties are copied:
    - shapes
    - actor flags 
    - owner client and client behavior bits
    
    The following are not copied and retain their default values:
    - name
    - joints or observers
    - aggregate or scene membership
    - user data
    
    \note Transforms are not copied with bit-exact accuracy.
    
    \param[in] physicsSDK - the physics SDK used to allocate the rigid static
    \param[in] actor the rigid actor from which to take the attributes.
    \param[in] transform the transform of the new static.
    
    \return the newly-created rigid static
    
    */
    @:native("physx::PxCloneStatic")
    static function cloneStatic(physicsSDK:PxPhysics, transform:PxTransform, actor:PxRigidActor):PxRigidStatic;
    
    /**
    \brief create a dynamic body by copying attributes from an existing body

    The following properties are copied:
    - shapes
    - actor flags and rigidDynamic flags
    - mass, moment of inertia, and center of mass frame
    - linear and angular velocity
    - linear and angular damping
    - maximum angular velocity
    - position and velocity solver iterations
    - maximum depenetration velocity
    - sleep threshold
    - contact report threshold
    - dominance group
    - owner client and client behavior bits
    - name pointer

    The following are not copied and retain their default values:
    - name
    - joints or observers
    - aggregate or scene membership
    - sleep timer
    - user data

    \note Transforms are not copied with bit-exact accuracy.

    \param[in] physicsSDK PxPhysics - the physics SDK used to allocate the rigid static
    \param[in] body the rigid dynamic to clone.
    \param[in] transform the transform of the new dynamic

    \return the newly-created rigid static

    */
    @:native("physx::PxCloneDynamic")
    static function cloneDynamic(physicsSDK:PxPhysics, transform:PxTransform, body:PxRigidDynamic):PxRigidDynamic;
    
    /** 
    \brief create a plane actor. The plane equation is n.x + d = 0

    \param[in] sdk the PxPhysics object
    \param[in] plane a plane of the form n.x + d = 0
    \param[in] material the material for the new object's shape

    \return a new static actor, or NULL if it could not be constructed

    @see PxRigidStatic
    */
    @:native("physx::PxCreatePlane")
    static function createPlane(sdk:PxPhysics, plane:PxPlane, material:PxMaterial):PxRigidStatic;

}