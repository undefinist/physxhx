package physx.extensions;

import physx.PxFiltering;

/**
 * Implementation of a simple filter shader that emulates PhysX 2.8.x filtering. Use `PxDefaultSimulationFilterShader.func`.
 * 
 * This shader provides the following logic:
 * - If one of the two filter objects is a trigger, the pair is acccepted and `PxPairFlag.eTRIGGER_DEFAULT` will be used for trigger reports
 * - Else, if the filter mask logic (see further below) discards the pair it will be suppressed (`PxFilterFlag.eSUPPRESS`)
 * - Else, the pair gets accepted and collision response gets enabled (`PxPairFlag.eCONTACT_DEFAULT`)
 * 
 * Filter mask logic:
 * Given the two `PxFilterData` structures fd0 and fd1 of two collision objects, the pair passes the filter if the following
 * conditions are met:
 * 
 * 1) Collision groups of the pair are enabled  
 * 2) Collision filtering equation is satisfied
 * 
 * @see PxSimulationFilterShader
 */
@:include("extensions/PxDefaultSimulationFilterShader.h")
extern class PxDefaultSimulationFilterShader
{
    @:native("physx::PxDefaultSimulationFilterShader")
    static var func:PxSimulationFilterShader;
}