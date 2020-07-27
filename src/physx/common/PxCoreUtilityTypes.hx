package physx.common;

import physx.foundation.PxSimpleTypes;

@:include("common/PxCoreUtilityTypes.h")
@:native("::cpp::Struct<physx::PxStridedData>")
extern class PxStridedData
{
	/**
	\brief The offset in bytes between consecutive samples in the data.

	<b>Default:</b> 0
	*/
	var stride:PxU32;
	var data:cpp.ConstPointer<cpp.Void>;
}

extern abstract PxPadding3(PxPadding3Data) 
{
    inline function new()
    {
        this = null;
    }
    @:op([]) inline function mPaddingGet(index:PxU8):PxU8
    {
        return untyped __cpp__("{0}.mPadding[{1}]", this, index);
    }
    @:op([]) inline function mPaddingSet(index:PxU8, value:PxU8):PxU8
    {
        return untyped __cpp__("{0}.mPadding[{1}] = {2}", this, index, value);
    }
}

@:include("common/PxCoreUtilityTypes.h")
@:native("::cpp::Struct<physx::PxPadding<3>>")
private extern class PxPadding3Data {}