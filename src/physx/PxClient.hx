package physx;

import physx.foundation.PxSimpleTypes;

@:include("PxClient.h")
@:native("physx::PxClientID")
extern abstract PxClientID(PxU8) from PxU8 to PxU8
{
    static inline final PX_DEFAULT_CLIENT:PxClientID = 0;
    static inline final PX_MAX_CLIENTS:PxClientID = 128;
}