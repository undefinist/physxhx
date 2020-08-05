package physx.foundation;

@:build(physx.hx.EnumBuilder.build("physx::PxErrorCode"))
extern enum abstract PxErrorCode(PxErrorCodeImpl)
{
    var eNO_ERROR = 0;

    /** An informational message. */
    var eDEBUG_INFO = 1;

    /** a warning message for the user to help with debugging */
    var eDEBUG_WARNING = 2;

    /** method called with invalid parameter(s) */
    var eINVALID_PARAMETER = 4;

    /** method was called at a time when an operation is not possible */
    var eINVALID_OPERATION = 8;

    /** method failed to allocate some memory */
    var eOUT_OF_MEMORY = 16;

    /** 
     * The library failed for some reason.
     * Possibly you have passed invalid values like NaNs, which are not checked for.
     */
    var eINTERNAL_ERROR = 32;

    /** An unrecoverable error, execution should be halted and log output flushed */
    var eABORT = 64;

    /** The SDK has determined that an operation may result in poor performance. */
    var ePERF_WARNING = 128;

    /** A bit mask for including all errors */
    var eMASK_ALL = -1;
}

@:include("foundation/PxErrors.h")
@:native("physx::PxErrorCode::Enum")
private extern class PxErrorCodeImpl {}