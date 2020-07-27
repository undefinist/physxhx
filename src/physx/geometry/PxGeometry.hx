package physx.geometry;

import physx.foundation.PxSimpleTypes;

/**
\brief A geometry type.

Used to distinguish the type of a ::PxGeometry object.
*/
extern enum abstract PxGeometryType(PxGeometryTypeImpl)
{
    @:native("physx::PxGeometryType::eSPHERE") var eSPHERE;
    @:native("physx::PxGeometryType::ePLANE") var ePLANE;
    @:native("physx::PxGeometryType::eCAPSULE") var eCAPSULE;
    @:native("physx::PxGeometryType::eBOX") var eBOX;
    @:native("physx::PxGeometryType::eCONVEXMESH") var eCONVEXMESH;
    @:native("physx::PxGeometryType::eTRIANGLEMESH") var eTRIANGLEMESH;
    @:native("physx::PxGeometryType::eHEIGHTFIELD") var eHEIGHTFIELD;
    // @:native("physx::PxGeometryType::eGEOMETRY_COUNT") var eGEOMETRY_COUNT;	//!< internal use only!
    // @:native("physx::PxGeometryType::eINVALID") var eINVALID;		    //!< internal use only!

    @:to inline function toInt():Int
    {
        return switch(cast this) 
        {
            case eSPHERE: 1;
            case ePLANE: 2;
            case eCAPSULE: 3;
            case eBOX: 4;
            case eCONVEXMESH: 5;
            case eTRIANGLEMESH: 6;
            case eHEIGHTFIELD: 7;
        }
    }
}

@:include("geometry/PxGeometry.h")
@:native("physx::PxGeometryType::Enum")
private extern class PxGeometryTypeImpl {}

/**
\brief A geometry object.

A geometry object defines the characteristics of a spatial object, but without any information
about its placement in the world.

\note This is an abstract class.  You cannot create instances directly.  Create an instance of one of the derived classes instead.
*/
@:include("geometry/PxGeometry.h")
@:native("::cpp::Reference<physx::PxGeometry>")
extern class PxGeometry 
{ 
	/**
	\brief Returns the type of the geometry.
	\return The type of the object.
    */
    function getType():PxGeometryType;
}