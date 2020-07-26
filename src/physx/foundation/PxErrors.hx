package physx.foundation;

extern enum abstract PxErrorCode(PxErrorCodeImpl)
{
    @:native("physx::PxErrorCode::eNO_ERROR") var eNO_ERROR;

    //! \brief An informational message.
    @:native("physx::PxErrorCode::eDEBUG_INFO") var eDEBUG_INFO;

    //! \brief a warning message for the user to help with debugging
    @:native("physx::PxErrorCode::eDEBUG_WARNING") var eDEBUG_WARNING;

    //! \brief method called with invalid parameter(s)
    @:native("physx::PxErrorCode::eINVALID_PARAMETER") var eINVALID_PARAMETER;

    //! \brief method was called at a time when an operation is not possible
    @:native("physx::PxErrorCode::eINVALID_OPERATION") var eINVALID_OPERATION;

    //! \brief method failed to allocate some memory
    @:native("physx::PxErrorCode::eOUT_OF_MEMORY") var eOUT_OF_MEMORY;

    /** \brief The library failed for some reason.
    Possibly you have passed invalid values like NaNs, which are not checked for.
    */
    @:native("physx::PxErrorCode::eINTERNAL_ERROR") var eINTERNAL_ERROR;

    //! \brief An unrecoverable error, execution should be halted and log output flushed
    @:native("physx::PxErrorCode::eABORT") var eABORT;

    //! \brief The SDK has determined that an operation may result in poor performance.
    @:native("physx::PxErrorCode::ePERF_WARNING") var ePERF_WARNING;

    //! \brief A bit mask for including all errors
    @:native("physx::PxErrorCode::eMASK_ALL") var eMASK_ALL;
}

@:include("foundation/PxErrors.h")
@:native("physx::PxErrorCode::Enum")
private extern class PxErrorCodeImpl {}