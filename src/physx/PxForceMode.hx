package physx;

/**
\brief Parameter to addForce() and addTorque() calls, determines the exact operation that is carried out.

@see PxRigidBody.addForce() PxRigidBody.addTorque()
*/
@:build(physx.hx.PxEnumBuilder.build("physx::PxForceMode"))
extern enum abstract PxForceMode(PxForceModeImpl)
{
	/**
	 * parameter has unit of mass * distance / time^2, i.e. a force
	 */
    var eFORCE;
    /**
     * parameter has unit of mass * distance / time
     */
    var eIMPULSE;
	/**
	 * parameter has unit of distance / time, i.e. the effect is mass independent: a velocity change.
	 */
    var eVELOCITY_CHANGE;
	/**
	 * parameter has unit of distance / time^2, i.e. an acceleration. It gets treated just like a force except the mass is not divided out before integration.
	 */
	var eACCELERATION;
}

@:include("PxForceMode.h")
@:native("physx::PxForceMode::Enum")
private extern class PxForceModeImpl {}