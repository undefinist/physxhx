package physx.common;

import physx.foundation.PxSimpleTypes;

/**
\brief Class to define the scale at which simulation runs. Most simulation tolerances are
calculated in terms of the values here. 

**Note:** if you change the simulation scale, you will probablly also wish to change the scene's
default value of gravity, and stable simulation will probably require changes to the scene's 
bounceThreshold also.
*/
@:forward
extern abstract PxTolerancesScale(PxTolerancesScaleData)
{
    inline function new()
    {
        this = null;
    }
}

@:include("common/PxTolerancesScale.h")
@:native("::cpp::Struct<physx::PxTolerancesScale>")
extern class PxTolerancesScaleData
{
    /** brief
    The approximate size of objects in the simulation. 
    
    For simulating roughly human-sized in metric units, 1 is a good choice.
    If simulation is done in centimetres, use 100 instead. This is used to
    estimate certain length-related tolerances.
    */
    var length:PxReal;

    /** brief
    The typical magnitude of velocities of objects in simulation. This is used to estimate 
    whether a contact should be treated as bouncing or resting based on its impact velocity,
    and a kinetic energy threshold below which the simulation may put objects to sleep.

    For normal physical environments, a good choice is the approximate speed of an object falling
    under gravity for one second.
    */
    var speed:PxReal;

    /**
    \brief Returns true if the descriptor is valid.
    \return true if the current settings are valid (returns always true).
    */
    function isValid():Bool;
}