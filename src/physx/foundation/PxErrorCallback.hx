package physx.foundation;

import physx.foundation.PxErrors;

@:include("foundation/PxErrorCallback.h")
@:native("physx::PxErrorCallback")
extern class PxErrorCallback
{
	/**
	Reports an error code.
	@param code Error code, see `PxErrorCode`
	@param message Message to display.
	@param file File error occured in.
	@param line Line number error occured on.
	*/
    public function reportError(code:PxErrorCode, message:cpp.ConstCharStar, file:cpp.ConstCharStar, line:Int):Void;
}