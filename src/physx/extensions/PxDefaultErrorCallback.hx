package physx.extensions;

import physx.foundation.PxErrorCallback;

/**
\brief default implementation of the error callback

This class is provided in order to enable the SDK to be started with the minimum of user code. Typically an application
will use its own error callback, and log the error to file or otherwise make it visible. Warnings and error messages from
the SDK are usually indicative that changes are required in order for PhysX to function correctly, and should not be ignored.
*/
@:include("extensions/PxDefaultErrorCallback.h")
@:native("::cpp::Struct<physx::PxDefaultErrorCallback>")
extern class PxDefaultErrorCallback extends PxErrorCallback
{
}