package physx.task;

/** 
A CpuDispatcher is responsible for scheduling the execution of tasks passed to it by the SDK.

A typical implementation would for example use a thread pool with the dispatcher
pushing tasks onto worker thread queues or a global queue.

In Haxe, currently the only way to provide custom behavior is to write it in C++. Just use `PxDefaultCpuDispatcher`.

@see PxBaseTask
@see PxTask
@see PxTaskManager
@see physx.foundation.PxDefaultCpuDispatcher
*/
@:include("task/PxCpuDispatcher.h")
@:native("::cpp::Reference<physx::PxCpuDispatcher>")
extern class PxCpuDispatcher
{
}