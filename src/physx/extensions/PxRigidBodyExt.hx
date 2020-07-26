package physx.extensions;

import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes.PxReal;

@:include("extensions/PxRigidBodyExt.h")
extern class PxRigidBodyExt
{
    /**
	\brief Computation of mass properties for a rigid body actor

	See previous method for details.

	\param[in,out] body The rigid body.
	\param[in] density The density of the body. Used to compute the mass of the body. The density must be greater than 0. 
	\param[in] massLocalPose The center of mass relative to the actor frame.  If set to null then (0,0,0) is assumed.
	\param[in] includeNonSimShapes True if all kind of shapes (PxShapeFlag::eSCENE_QUERY_SHAPE, PxShapeFlag::eTRIGGER_SHAPE) should be taken into account.
	\return Boolean. True on success else false.

	@see PxRigidBody::setMassLocalPose PxRigidBody::setMassSpaceInertiaTensor PxRigidBody::setMass
    */
    @:native("physx::PxRigidBodyExt::updateMassAndInertia")
    static function updateMassAndInertia(body:PxRigidBody, density:PxReal, ?massLocalPose:cpp.ConstPointer<PxVec3>, includeNonSimShapes:Bool = false):Bool;
}