package physx;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxBase;

/**
\brief Flags which control the behavior of a material.

@see PxMaterial 
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxMaterialFlag", PxU16))
extern enum abstract PxMaterialFlag(PxMaterialFlagImpl)
{
    /**
    If this flag is set, friction computations are always skipped between shapes with this material and any other shape.
    */
    var eDISABLE_FRICTION = 1 << 0;

    /**
    The difference between "normal" and "strong" friction is that the strong friction feature
    remembers the "friction error" between simulation steps. The friction is a force trying to
    hold objects in place (or slow them down) and this is handled in the solver. But since the
    solver is only an approximation, the result of the friction calculation can include a small
    "error" - e.g. a box resting on a slope should not move at all if the static friction is in
    action, but could slowly glide down the slope because of a small friction error in each 
    simulation step. The strong friction counter-acts this by remembering the small error and
    taking it to account during the next simulation step.

    However, in some cases the strong friction could cause problems, and this is why it is
    possible to disable the strong friction feature by setting this flag. One example is
    raycast vehicles, that are sliding fast across the surface, but still need a precise
    steering behavior. It may be a good idea to reenable the strong friction when objects
    are coming to a rest, to prevent them from slowly creeping down inclines.

    Note: This flag only has an effect if the PxMaterialFlag::eDISABLE_FRICTION bit is 0.
    */
    var eDISABLE_STRONG_FRICTION = 1 << 1;

    /**
    This flag only has an effect if PxFrictionType::ePATCH friction model is used.

    When using the patch friction model, up to 2 friction anchors are generated per patch. As the number of friction anchors
    can be smaller than the number of contacts, the normal force is accumulated over all contacts and used to compute friction
    for all anchors. Where there are more than 2 anchors, this can produce frictional behavior that is too strong (approximately 2x as strong
    as analytical models suggest). 

    This flag causes the normal force to be distributed between the friction anchors such that the total amount of friction applied does not 
    exceed the analyical results.
    */
    var eIMPROVED_PATCH_FRICTION = 1 << 2;
}

@:include("PxMaterial.h")
@:native("physx::PxMaterialFlags")
private extern class PxMaterialFlagImpl {}

/**
\brief collection of set bits defined in PxMaterialFlag.

@see PxMaterialFlag
*/
extern abstract PxMaterialFlags(PxMaterialFlag) from PxMaterialFlag to PxMaterialFlag {}


/**
\brief enumeration that determines the way in which two material properties will be combined to yield a friction or restitution coefficient for a collision.

When two actors come in contact with each other, they each have materials with various coefficients, but we only need a single set of coefficients for the pair.

Physics doesn't have any inherent combinations because the coefficients are determined empirically on a case by case
basis. However, simulating this with a pairwise lookup table is often impractical.

For this reason the following combine behaviors are available:

eAVERAGE
eMIN
eMULTIPLY
eMAX

The effective combine mode for the pair is maximum(material0.combineMode, material1.combineMode).

@see PxMaterial.setFrictionCombineMode() PxMaterial.getFrictionCombineMode() PxMaterial.setRestitutionCombineMode() PxMaterial.getFrictionCombineMode()
*/
@:build(physx.hx.EnumBuilder.build("physx::PxCombineMode"))
extern enum abstract PxCombineMode(PxCombineModeImpl)
{
    /** Average: (a + b)/2 */
    var eAVERAGE	= 0;
    /** Minimum: minimum(a,b) */
    var eMIN		= 1;
    /** Multiply: a*b */
    var eMULTIPLY	= 2;
    /** Maximum: maximum(a,b) */
    var eMAX		= 3;
    /** This is not a valid combine mode, it is a sentinel to denote the number of possible values. We assert that the variable's value is smaller than this. */
    var eN_VALUES	= 4;
    //ePAD_32		= 0x7fffffff //!< This is not a valid combine mode, it is to assure that the size of the enum type is big enough.
}

@:include("PxMaterial.h")
@:native("physx::PxCombineMode::Enum")
private extern class PxCombineModeImpl {}


/**
\brief Material class to represent a set of surface properties. 

@see PxPhysics.createMaterial
*/
@:include("PxMaterial.h")
@:native("::cpp::Reference<physx::PxMaterial>")
extern class PxMaterial extends PxBase
{
    /**
    \brief Decrements the reference count of a material and releases it if the new reference count is zero.		
    
    @see PxPhysics.createMaterial()
    */
    function release():Void;

    /**
    \brief Returns the reference count of the material.

    At creation, the reference count of the material is 1. Every shape referencing this material increments the
    count by 1.	When the reference count reaches 0, and only then, the material gets destroyed automatically.

    \return the current reference count.
    */
    function getReferenceCount():PxU32;

    /**
    \brief Acquires a counted reference to a material.

    This method increases the reference count of the material by 1. Decrement the reference count by calling release()
    */
    function acquireReference():Void;

    /**
    \brief Sets the coefficient of dynamic friction.
    
    The coefficient of dynamic friction should be in [0, PX_MAX_F32). If set to greater than staticFriction, the effective value of staticFriction will be increased to match.

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] coef Coefficient of dynamic friction. <b>Range:</b> [0, PX_MAX_F32)

    @see getDynamicFriction()
    */
    function setDynamicFriction(coef:PxReal):Void;

    /**
    \brief Retrieves the DynamicFriction value.

    \return The coefficient of dynamic friction.

    @see setDynamicFriction
    */
    function getDynamicFriction():PxReal;

    /**
    \brief Sets the coefficient of static friction
    
    The coefficient of static friction should be in the range [0, PX_MAX_F32)

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] coef Coefficient of static friction. <b>Range:</b> [0, PX_MAX_F32)

    @see getStaticFriction() 
    */
    function setStaticFriction(coef:PxReal):Void;

    /**
    \brief Retrieves the coefficient of static friction.
    \return The coefficient of static friction.

    @see setStaticFriction 
    */
    function getStaticFriction():PxReal;

    /**
    \brief Sets the coefficient of restitution 
    
    A coefficient of 0 makes the object bounce as little as possible, higher values up to 1.0 result in more bounce.

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] rest Coefficient of restitution. <b>Range:</b> [0,1]

    @see getRestitution() 
    */
    function setRestitution(rest:PxReal):Void;

    /**
    \brief Retrieves the coefficient of restitution.     

    See #setRestitution.

    \return The coefficient of restitution.

    @see setRestitution() 
    */
    function getRestitution():PxReal;

    /**
    \brief Raises or clears a particular material flag.
    
    See the list of flags #PxMaterialFlag

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] flag The PxMaterial flag to raise(set) or clear.

    @see getFlags() PxMaterialFlag
    */
    function setFlag(flag:PxMaterialFlag, value:Bool):Void;


    /**
    \brief sets all the material flags.
    
    See the list of flags #PxMaterialFlag

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    */
    function setFlag(flags:PxMaterialFlags):Void;

    /**
    \brief Retrieves the flags. See #PxMaterialFlag.

    \return The material flags.

    @see PxMaterialFlag setFlags()
    */
    function getFlags():PxMaterialFlags;

    /**
    \brief Sets the friction combine mode.
    
    See the enum ::PxCombineMode .

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] combMode Friction combine mode to set for this material. See #PxCombineMode.

    @see PxCombineMode getFrictionCombineMode setStaticFriction() setDynamicFriction()
    */
    function setFrictionCombineMode(combMode:PxCombineMode):Void;

    /**
    \brief Retrieves the friction combine mode.
    
    See #setFrictionCombineMode.

    \return The friction combine mode for this material.

    @see PxCombineMode setFrictionCombineMode() 
    */
    function getFrictionCombineMode():PxCombineMode;

    /**
    \brief Sets the restitution combine mode.
    
    See the enum ::PxCombineMode .

    <b>Sleeping:</b> Does <b>NOT</b> wake any actors which may be affected.

    \param[in] combMode Restitution combine mode for this material. See #PxCombineMode.

    @see PxCombineMode getRestitutionCombineMode() setRestitution()
    */
    function setRestitutionCombineMode(combMode:PxCombineMode):Void;

    /**
    \brief Retrieves the restitution combine mode.
    
    See #setRestitutionCombineMode.

    \return The coefficient of restitution combine mode for this material.

    @see PxCombineMode setRestitutionCombineMode getRestitution()
    */
    function getRestitutionCombineMode():PxCombineMode;

    //public variables:
    
    /**
     * user can assign this to whatever, usually to create a 1:1 relationship with a user object.
     */
    var userData:physx.hx.PxUserData;

    function getConcreteTypeName():cpp.ConstCharStar;
}