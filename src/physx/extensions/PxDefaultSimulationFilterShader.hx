package physx.extensions;

import physx.PxFiltering;
import physx.foundation.PxSimpleTypes;

@:include("extensions/PxDefaultSimulationFilterShader.h")
extern class PxDefaultSimulationFilterShader
{
    @:native("physx::PxDefaultSimulationFilterShader")
    static var func:PxSimulationFilterShader;
}