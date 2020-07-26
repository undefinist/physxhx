//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of NVIDIA CORPORATION nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Copyright (c) 2008-2019 NVIDIA Corporation. All rights reserved.
// Copyright (c) 2004-2008 AGEIA Technologies, Inc. All rights reserved.
// Copyright (c) 2001-2004 NovodeX AG. All rights reserved.  

/**
 * Modified from physx\source\physxextensions\src\ExtCpuWorkerThread.h, by Malody Hoe
 * for Haxe/hxcpp to attach or detach threads for Haxe GC.
 */

#include <hxcpp.h>

#include "task/PxTask.h"
#include "ExtCpuWorkerThreadHx.h"
#include "ExtDefaultCpuDispatcherHx.h"
#include "ExtTaskQueueHelper.h"
#include "PsFPU.h"

using namespace physx;

Ext::CpuWorkerThreadHx::CpuWorkerThreadHx()
:	mQueueEntryPool(EXT_TASK_QUEUE_ENTRY_POOL_SIZE),
	mThreadId(0)
{
}


Ext::CpuWorkerThreadHx::~CpuWorkerThreadHx()
{
}


void Ext::CpuWorkerThreadHx::initialize(DefaultCpuDispatcherHx* ownerDispatcher)
{
	mOwner = ownerDispatcher;
}


bool Ext::CpuWorkerThreadHx::tryAcceptJobToLocalQueue(PxBaseTask& task, Ps::Thread::Id taskSubmitionThread)
{
	if(taskSubmitionThread == mThreadId)
	{
		SharedQueueEntry* entry = mQueueEntryPool.getEntry(&task);
		if (entry)
		{
			mLocalJobList.push(*entry);
			return true;
		}
		else
			return false;
	}

	return false;
}


PxBaseTask* Ext::CpuWorkerThreadHx::giveUpJob()
{
	return TaskQueueHelper::fetchTask(mLocalJobList, mQueueEntryPool);
}


void Ext::CpuWorkerThreadHx::execute()
{
	mThreadId = getId();

	// attach thread to Haxe GC. see https://haxe.org/manual/target-cpp-ThreadsAndStacks.html
	int t0 = 0;
	hx::SetTopOfStack(&t0, false);

	printf("%p", &t0);

	while (!quitIsSignalled())
    {
        mOwner->resetWakeSignal();

		PxBaseTask* task = TaskQueueHelper::fetchTask(mLocalJobList, mQueueEntryPool);

		if(!task)
			task = mOwner->fetchNextTask();
		
		if (task)
		{
			mOwner->runTask(*task);
			task->release();
		}
		else
		{
			mOwner->waitForWork();
		}
	}

	// detach thread from Haxe GC.
	hx::SetTopOfStack(0, false);

	quit();
}
