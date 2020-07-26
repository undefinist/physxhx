package physx.extensions;

import physx.PxFiltering;
import physx.foundation.PxSimpleTypes;

@:include("extensions/PxDefaultSimulationFilterShader.h")
extern class PxDefaultSimulationFilterShader
{
    @:native("physx::PxDefaultSimulationFilterShader")
    static function fn(attributes0:PxFilterObjectAttributes, filterData0:PxFilterData,
        attributes1:PxFilterObjectAttributes, filterData1:PxFilterData,
        pairFlags:cpp.Reference<PxPairFlags>, constantBlock:cpp.ConstPointer<cpp.Void>, constantBlockSize:PxU32)
            :PxFilterFlags;
}