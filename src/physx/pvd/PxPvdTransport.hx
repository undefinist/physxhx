package physx.pvd;

@:include("pvd/PxPvdTransport.h")
@:native("::cpp::Reference<physx::PxPvdTransport>")
extern class PxPvdTransport
{
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