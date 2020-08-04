package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;
import physx.foundation.PxBase;

/**
\brief constraint flags

**Note:** eBROKEN is a read only flag
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxConstraintFlag", PxU16))
extern enum abstract PxConstraintFlag(PxConstraintFlagImpl)
{
    /** whether the constraint is broken */
    var eBROKEN                     = 1<<0;
    /** whether actor1 should get projected to actor0 for this constraint (note: projection of a static/kinematic actor to a dynamic actor will be ignored) */
    var ePROJECT_TO_ACTOR0          = 1<<1;
    /** whether actor0 should get projected to actor1 for this constraint (note: projection of a static/kinematic actor to a dynamic actor will be ignored) */
    var ePROJECT_TO_ACTOR1          = 1<<2;
    /** whether the actors should get projected for this constraint (the direction will be chosen by PhysX) */
    var ePROJECTION                 = ePROJECT_TO_ACTOR0 | ePROJECT_TO_ACTOR1;
    /** whether contacts should be generated between the objects this constraint constrains */
    var eCOLLISION_ENABLED          = 1<<3;
    /** whether this constraint should be visualized, if constraint visualization is turned on */
    var eVISUALIZATION              = 1<<4;
    /** limits for drive strength are forces rather than impulses */
    var eDRIVE_LIMITS_ARE_FORCES    = 1<<5;
    /** perform preprocessing for improved accuracy on D6 Slerp Drive (this flag will be removed in a future release when preprocessing is no longer required) */
    var eIMPROVED_SLERP             = 1<<7;
    /** suppress constraint preprocessing, intended for use with rowResponseThreshold. May result in worse solver accuracy for ill-conditioned constraints. */
    var eDISABLE_PREPROCESSING      = 1<<8;
    /** enables extended limit ranges for angular limits (e.g. limit values > PxPi or < -PxPi) */
    var eENABLE_EXTENDED_LIMITS     = 1<<9;
    /** the constraint type is supported by gpu dynamic */
    var eGPU_COMPATIBLE             = 1<<10;
}

@:include("PxConstraint.h")
@:native("physx::PxConstraintFlags")
private extern class PxConstraintFlagImpl {}

/**
\brief constraint flags
@see PxConstraintFlag
*/
extern abstract PxConstraintFlags(PxConstraintFlag) from PxConstraintFlag to PxConstraintFlag {}


@:include("PxConstraint.h")
@:native("physx::PxConstraintShaderTable")
extern class PxConstraintShaderTable
{
    static inline var eMAX_SOLVERPRPEP_DATASIZE:Int = 400;

	// PxConstraintSolverPrep			solverPrep;					//!< solver constraint generation function
	// PxConstraintProject				project;					//!< constraint projection function
	// PxConstraintVisualize			visualize;					//!< constraint visualization function
	// PxConstraintFlag::Enum			flag;						//!< gpu constraint
}



/**
\brief A plugin class for implementing constraints

@see PxPhysics.createConstraint
*/
@:include("PxConstraint.h")
@:native("::cpp::Reference<physx::PxConstraint>")
extern class PxConstraint extends PxBase
{
    /**
    \brief Releases a PxConstraint instance.

    **Note:** This call does not wake up the connected rigid bodies.

    @see PxPhysics.createConstraint, PxBase.release()
    */
    function release():Void;

    /**
    \brief Retrieves the scene which this constraint belongs to.

    \return Owner Scene. NULL if not part of a scene.

    @see PxScene
    */
    function getScene():PxScene;

    @:native("getActors") private function _getActors(actor0:cpp.Reference<cpp.Pointer<PxRigidActor>>, actor1:cpp.Reference<cpp.Pointer<PxRigidActor>>):Void;
    /**
    \brief Retrieves the actors for this constraint.

    @see PxActor
    */
    inline function getActors():{ actor0:PxRigidActor, actor1:PxRigidActor }
    {
        var p1:cpp.Pointer<PxRigidActor> = null;
        var p2:cpp.Pointer<PxRigidActor> = null;
        _getActors(p1, p2);
        return { actor0: p1.ref, actor1: p2.ref };
    }

    /**
    \brief Sets the actors for this constraint.

    \param[in] actor0 a reference to the pointer for the first actor
    \param[in] actor1 a reference to the pointer for the second actor

    @see PxActor
    */
    function setActors(actor0:PxRigidActor, actor1:PxRigidActor):Void;

    /**
    \brief Notify the scene that the constraint shader data has been updated by the application
    */
    function markDirty():Void;

    /**
    \brief Set the flags for this constraint

    \param[in] flags the new constraint flags

    default: PxConstraintFlag::eDRIVE_LIMITS_ARE_FORCES

    @see PxConstraintFlags
    */
    function setFlags(flags:PxConstraintFlags):Void;

    /**
    \brief Retrieve the flags for this constraint

    \return the constraint flags
    @see PxConstraintFlags
    */
    function getFlags():PxConstraintFlags;

    /**
    \brief Set a flag for this constraint

    \param[in] flag the constraint flag
    \param[in] value the new value of the flag

    @see PxConstraintFlags
    */
    function setFlag(flag:PxConstraintFlag, value:Bool):Void;

    /**
    \brief Retrieve the constraint force most recently applied to maintain this constraint.
    
    \param[out] linear the constraint force
    \param[out] angular the constraint torque
    */
    function getForce(linear:PxVec3, angular:PxVec3):Void;

    /**
    \brief whether the constraint is valid. 
    
    A constraint is valid if it has at least one dynamic rigid body or articulation link. A constraint that
    is not valid may not be inserted into a scene, and therefore a static actor to which an invalid constraint
    is attached may not be inserted into a scene.

    Invalid constraints arise only when an actor to which the constraint is attached has been deleted.
    */
    function isValid():Bool;

    /**
    \brief Set the break force and torque thresholds for this constraint. 
    
    If either the force or torque measured at the constraint exceed these thresholds the constraint will break.

    \param[in] linear the linear break threshold
    \param[in] angular the angular break threshold
    */
    function setBreakForce(linear:PxReal, angular:PxReal):Void;

    @:native("getBreakForce") private function _getBreakForce(linear:cpp.Reference<PxReal>, angular:cpp.Reference<PxReal>):Void;
    /**
    \brief Retrieve the constraint break force and torque thresholds
    */
    inline function getBreakForce():{ linear:PxReal, angular:PxReal }
    {
        var linear:PxReal = 0;
        var angular:PxReal = 0;
        _getBreakForce(linear, angular);
        return { linear: linear, angular: angular };
    }

    /**
    \brief Set the minimum response threshold for a constraint row 
    
    When using mass modification for a joint or infinite inertia for a jointed body, very stiff solver constraints can be generated which 
    can destabilize simulation. Setting this value to a small positive value (e.g. 1e-8) will cause constraint rows to be ignored if very 
    large changes in impulses will generate only small changes in velocity. When setting this value, also set 
    PxConstraintFlag::eDISABLE_PREPROCESSING. The solver accuracy for this joint may be reduced.

    \param[in] threshold the minimum response threshold

    @see PxConstraintFlag::eDISABLE_PREPROCESSING
    */
    function setMinResponseThreshold(threshold:PxReal):Void;

    /**
    \brief Retrieve the constraint break force and torque thresholds

    \return the minimum response threshold for a constraint row
    */
    function getMinResponseThreshold():PxReal;

    @:native("getExternalReference") private function _getExternalReference(typeID:cpp.Reference<PxU32>):Dynamic;
    /**
    \brief Fetch external owner of the constraint.
    
    Provides a reference to the external owner of a constraint and a unique owner type ID.

    \param[out] typeID Unique type identifier of the external object.
    \return Reference to the external object which owns the constraint.

    @see PxConstraintConnector.getExternalReference()
    */
    inline function getExternalReference():{ owner:Dynamic, typeID:PxU32 }
    {
        var typeID:PxU32 = 0;
        var owner = _getExternalReference(typeID);
        return { owner: owner, typeID: typeID };
    }

    /**
    \brief Set the constraint functions for this constraint
    
    \param[in] connector the constraint connector object by which the SDK communicates with the constraint.
    \param[in] shaders the shader table for the constraint
    
    @see PxConstraintConnector PxConstraintSolverPrep PxConstraintProject PxConstraintVisualize
    */
    // virtual	void				setConstraintFunctions(PxConstraintConnector& connector,
    //                                                     const PxConstraintShaderTable& shaders)		= 0;

}