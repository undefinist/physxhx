package physx.extensions;

import physx.foundation.PxAllocatorCallback;

/**
default implementation of the allocator interface required by the SDK
*/
@:include("extensions/PxDefaultAllocator.h")
@:native("::cpp::Struct<physx::PxDefaultAllocator>")
extern class PxDefaultAllocator extends PxAllocatorCallback
{
}