package physx.foundation;

import physx.foundation.PxSimpleTypes;

typedef PxType = PxI16;

/**
Flags for PxBase.
*/
@:build(physx.hx.EnumBuilder.buildFlags("physx::PxBaseFlag", PxU16))
extern enum abstract PxBaseFlag(PxBaseFlagImpl)
{
    var eOWNS_MEMORY = (1<<0);
	var eIS_RELEASABLE = (1<<1);
}

@:include("foundation/PxBase.h")
@:native("physx::PxBaseFlag::Enum")
private extern class PxBaseFlagImpl {}

@:native("physx::PxBaseFlags")
extern abstract PxBaseFlags(PxBaseFlag) from PxBaseFlag to PxBaseFlag {}

/**
\brief Base class for objects that can be members of a PxCollection.

All PxBase sub-classes can be serialized.

@see PxCollection 
*/
@:include("foundation/PxBase.h")
@:native("::cpp::Reference<physx::PxBase>")
extern class PxBase
{
	/**
	Releases the PxBase instance, please check documentation of release in derived class.
	*/
    public function release():Void;

	/**
    Returns string name of dynamic type.
    
	\return	Class name of most derived type of this object.
	*/
    public function getConcreteTypeName():cpp.ConstCharStar;

	/**
    Returns concrete type of object.
    
	\return	PxConcreteType::Enum of serialized object

	@see PxConcreteType
	*/
    public function getConcreteType():PxType;

	/**
	Set PxBaseFlag	

	@param flag The flag to be set
	@param value The flags new value
	*/
    public function setBaseFlag(flag:PxBaseFlag, value:Bool):Void;

	/**
	Set PxBaseFlags	

	@param inFlags The flags to be set

	@see PxBaseFlags
	*/
    public function setBaseFlags(flag:PxBaseFlags):Void;

	/**
	Returns PxBaseFlags 

	\return	PxBaseFlags

	@see PxBaseFlags
	*/
    public function getBaseFlags():PxBaseFlags;

	/**
	Whether the object is subordinate.
	
	A class is subordinate, if it can only be instantiated in the context of another class.

	\return	Whether the class is subordinate
	
	@see PxSerialization::isSerializable
	*/
    public function isReleasable():Bool;
}