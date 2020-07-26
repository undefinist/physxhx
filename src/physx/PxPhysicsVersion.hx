package physx;

import physx.foundation.PxSimpleTypes;

enum abstract PxPhysicsVersion(PxU32) to PxU32
{
    var PX_PHYSICS_VERSION_MAJOR = 4;
    var PX_PHYSICS_VERSION_MINOR = 1;
    var PX_PHYSICS_VERSION_BUGFIX = 1;
    var PX_PHYSICS_VERSION = ((PX_PHYSICS_VERSION_MAJOR<<24) + (PX_PHYSICS_VERSION_MINOR<<16) + (PX_PHYSICS_VERSION_BUGFIX<<8) + 0);
}