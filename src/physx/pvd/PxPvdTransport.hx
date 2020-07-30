package physx.pvd;

@:include("pvd/PxPvdTransport.h")
@:native("::cpp::Reference<physx::PxPvdTransport>")
extern class PxPvdTransport
{
	// connect, isConnected, disconnect, read, write, flush

	/**
	Connects to the Visual Debugger application.
	return True if success
	*/
	function connect():Bool;

	/**
	Disconnects from the Visual Debugger application.
	If we are still connected, this will kill the entire debugger connection.
	*/
	function disconnect():Void;

	/**
	 *	Return if connection to PVD is created.
	 */
	function isConnected():Bool;

	/**
	 *	write bytes to the other endpoint of the connection. should lock before witre. If an error occurs
	 *	this connection will assume to be dead.
	 */
	function write(inBytes:cpp.ConstPointer<cpp.UInt8>, inLength:cpp.UInt32):Bool;

	/*
	    lock this transport and return it
	*/
	function lock():PxPvdTransport;

	/*
	    unlock this transport
	*/
	function unlock():Void;

	/**
	 *	send any data and block until we know it is at least on the wire.
	 */
	function flush():Void;

	/**
	 *	Return size of written data.
	 */
	function getWrittenDataSize():cpp.UInt64;

	function release():Void;


    @:native("physx::PxDefaultPvdSocketTransportCreate")
    private static function _defaultPvdSocketTransportCreate(host:cpp.ConstCharStar, port:Int, time:UInt):PxPvdTransport;
    /**
        Create a default socket transport.
        @param host host address of the pvd application.
        @param port ip port used for pvd, should same as the port setting in pvd application.
        @param timeoutInMilliseconds timeout when connect to pvd host.
    */
    inline static function defaultPvdSocketTransportCreate(host:String, port:Int, time:UInt):PxPvdTransport
    {
        return _defaultPvdSocketTransportCreate(host, port, time);
    }

    @:native("physx::PxDefaultPvdFileTransportCreate")
    private static function _defaultPvdFileTransportCreate(name:cpp.ConstCharStar):PxPvdTransport;
    /**
        Create a default file transport.
        @param name full path filename used save captured pvd data, or NULL for a fake/test file transport.
    */
    inline static function defaultPvdFileTransportCreate(name:String):PxPvdTransport
    {
        return _defaultPvdFileTransportCreate(name);
    }
}