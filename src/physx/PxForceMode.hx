package physx;

/**
\brief Parameter to addForce() and addTorque() calls, determines the exact operation that is carried out.

@see PxRigidBody.addForce() PxRigidBody.addTorque()
*/
extern enum abstract PxForceMode(PxForceModeImpl)
{
	/**
	 * parameter has unit of mass * distance / time^2, i.e. a force
	 */
    @:native("physx::PxForceMode::eFORCE") var eFORCE;
    /**
     * parameter has unit of mass * distance / time
     */
    @:native("physx::PxForceMode::eIMPULSE") var eIMPULSE;
	/**
	 * parameter has unit of distance / time, i.e. the effect is mass independent: a velocity change.
	 */
    @:native("physx::PxForceMode::eVELOCITY_CHANGE") var eVELOCITY_CHANGE;
	/**
	 * parameter has unit of distance / time^2, i.e. an acceleration. It gets treated just like a force except the mass is not divided out before integration.
	 */
	@:native("physx::PxForceMode::eACCELERATION") var eACCELERATION;
}

@:include("PxForceMode.h")
@:native("physx::PxForceMode::Enum")
private extern class PxForceModeImpl {}