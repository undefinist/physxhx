package physx.geometry;

import physx.foundation.PxSimpleTypes;
import physx.foundation.PxBitAndData;

/**
\brief Special material index values for height field samples.

@see PxHeightFieldSample.materialIndex0 PxHeightFieldSample.materialIndex1
*/
extern enum abstract PxHeightFieldMaterial(PxHeightFieldMaterialImpl)
{
    /**
     * A material indicating that the triangle should be treated as a hole in the mesh.
     */
    @:native("physx::PxHeightFieldMaterial::eHOLE") var eHOLE;
}

@:include("geometry/PxHeightFieldSample.h")
@:native("physx::PxHeightFieldMaterial::Enum")
private extern class PxHeightFieldMaterialImpl {}

/**
\brief Heightfield sample format.

This format corresponds to the #PxHeightFieldFormat member PxHeightFieldFormat::eS16_TM.

An array of heightfield samples are used when creating a PxHeightField to specify
the elevation of the heightfield points. In addition the material and tessellation of the adjacent 
triangles are specified.

@see PxHeightField PxHeightFieldDesc PxHeightFieldDesc.samples
*/
@:forward
extern abstract PxHeightFieldSample(PxHeightFieldSampleData)
{
    inline function new()
    {
        this = cast untyped __cpp__("{}");
    }
}

@:include("geometry/PxHeightFieldSample.h")
@:native("physx::PxHeightFieldSample")
@:structAccess
private extern class PxHeightFieldSampleData
{
	/**
	\brief The height of the heightfield sample

	This value is scaled by PxHeightFieldGeometry::heightScale.

	@see PxHeightFieldGeometry
	*/
    var height:PxI16;
    
	/**
	\brief The triangle material index of the quad's lower triangle + tesselation flag

	An index pointing into the material table of the shape which instantiates the heightfield.
	This index determines the material of the lower of the quad's two triangles (i.e. the quad whose 
	upper-left corner is this sample, see the Guide for illustrations).

	Special values of the 7 data bits are defined by PxHeightFieldMaterial

	The tesselation flag specifies which way the quad is split whose upper left corner is this sample.
	If the flag is set, the diagonal of the quad will run from this sample to the opposite vertex; if not,
	it will run between the other two vertices (see the Guide for illustrations).

	@see PxHeightFieldGeometry materialIndex1 PxShape.setmaterials() PxShape.getMaterials()
    */
    var materialIndex0:PxBitAndByte;

	/**
	\brief The triangle material index of the quad's upper triangle + reserved flag

	An index pointing into the material table of the shape which instantiates the heightfield.
	This index determines the material of the upper of the quad's two triangles (i.e. the quad whose 
	upper-left corner is this sample, see the Guide for illustrations).

	@see PxHeightFieldGeometry materialIndex0 PxShape.setmaterials() PxShape.getMaterials()
	*/
    var materialIndex1:PxBitAndByte;

    function tessFlag():PxU8;
    function setTessFlag():Void;
    function clearTessFlag():Void;
}