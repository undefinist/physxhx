package physx.geometry;

import physx.foundation.PxSimpleTypes;

/**
\brief A geometry type.

Used to distinguish the type of a ::PxGeometry object.
*/
@:build(physx.hx.PxEnumBuilder.build("physx::PxGeometryType"))
extern enum abstract PxGeometryType(PxGeometryTypeImpl)
{
    var eSPHERE;
    var ePLANE;
    var eCAPSULE;
    var eBOX;
    var eCONVEXMESH;
    var eTRIANGLEMESH;
    var eHEIGHTFIELD;
    /** internal use only! */
    var eGEOMETRY_COUNT;
    /** internal use only! */
    //var eINVALID = -1;
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