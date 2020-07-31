package physx.pvd;

import physx.foundation.PxProfiler;

/**
\brief types of instrumentation that PVD can do.
*/
@:build(physx.hx.PxEnumBuilder.buildFlags("physx::PxPvdInstrumentationFlag", cpp.UInt8))
extern enum abstract PxPvdInstrumentationFlag(PxPvdInstrumentationFlagImpl)
{
    /**
        \brief Send debugging information to PVD.

        This information is the actual object data of the rigid statics, shapes,
        articulations, etc.  Sending this information has a noticeable impact on
        performance and thus this flag should not be set if you want an accurate
        performance profile.
        */
    var eDEBUG = 1 << 0;

    /**
        \brief Send profile information to PVD.

        This information populates PVD's profile view.  It has (at this time) negligible
        cost compared to Debug information and makes PVD *much* more useful so it is quite
        highly recommended.

        This flag works together with a PxCreatePhysics parameter.
        Using it allows the SDK to send profile events to PVD.
    */
    var ePROFILE = 1 << 1;

    /**
        \brief Send memory information to PVD.

        The PVD sdk side hooks into the Foundation memory controller and listens to
        allocation/deallocation events.  This has a noticable hit on the first frame,
        however, this data is somewhat compressed and the PhysX SDK doesn't allocate much
        once it hits a steady state.  This information also has a fairly negligible
        impact and thus is also highly recommended.

        This flag works together with a PxCreatePhysics parameter,
        trackOutstandingAllocations.  Using both of them together allows users to have
        an accurate view of the overall memory usage of the simulation at the cost of
        a hashtable lookup per allocation/deallocation.  Again, PhysX makes a best effort
        attempt not to allocate or deallocate during simulation so this hashtable lookup
        tends to have no effect past the first frame.

        Sending memory information without tracking outstanding allocations means that
        PVD will accurate information about the state of the memory system before the
        actual connection happened.
    */
    var eMEMORY = 1 << 2;

    var eALL = (eDEBUG | ePROFILE | eMEMORY);
}

@:include("pvd/PxPvd.h")
@:native("physx::PxPvdInstrumentationFlags>")
private extern class PxPvdInstrumentationFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxPvdInstrumentationFlag.

@see PxPvdInstrumentationFlag
*/
extern abstract PxPvdInstrumentationFlags(PxPvdInstrumentationFlag) from PxPvdInstrumentationFlag to PxPvdInstrumentationFlag {}

@:include("pvd/PxPvd.h")
@:native("::cpp::Reference<physx::PxPvd>")
extern class PxPvd extends PxProfilerCallback
{
	/**
	Connects the SDK to the PhysX Visual Debugger application.
	\param transport transport for pvd captured data.
	\param flags Flags to set.
	return True if success
	*/
	function connect(transport:PxPvdTransport, flags:PxPvdInstrumentationFlags):Bool;

	/**
	Disconnects the SDK from the PhysX Visual Debugger application.
	If we are still connected, this will kill the entire debugger connection.
	*/
    function disconnect():Void;
    
	/**
	 *	Return if connection to PVD is created.
	  \param useCachedStatus
	    1> When useCachedStaus is false, isConnected() checks the lowlevel network status.
	       This can be slow because it needs to lock the lowlevel network stream. If isConnected() is
	       called frequently, the expense of locking can be significant.
	    2> When useCachedStatus is true, isConnected() checks the highlevel cached status with atomic access.
	       It is faster than locking, but the status may be different from the lowlevel network with latency of up to
	       one frame.
	       The reason for this is that the cached status is changed inside socket listener, which is not
	       called immediately when the lowlevel connection status changes.
	 */
	function isConnected(useCachedStatus:Bool):Bool;

	/**
	returns the PVD data transport
	returns NULL if no transport is present.
	*/
	function getTransport():PxPvdTransport;

	/**
	Retrieves the PVD flags. See PxPvdInstrumentationFlags.
	*/
	function getInstrumentationFlags():PxPvdInstrumentationFlags;

	/**
	\brief Releases the pvd instance.
	*/
	function release():Void;



    /**
        \brief Create a pvd instance. 	
        \param foundation is the foundation instance that stores the allocator and error callbacks.
    */
    @:native("physx::PxCreatePvd")
    static function create(foundation:PxFoundation):PxPvd;
}