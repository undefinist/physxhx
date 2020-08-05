package physx.geometry;

import physx.geometry.PxHeightFieldFlag.PxHeightFieldFlags;
import physx.geometry.PxHeightFieldFlag.PxHeightFieldFormat;
import physx.common.PxPhysXCommonConfig;
import physx.foundation.PxBase;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxVec3;

@:include("geometry/PxHeightField.h")
@:native("::cpp::Reference<physx::PxHeightField>")
extern class PxHeightField extends PxBase
{
    /**
	Decrements the reference count of a height field and releases it if the new reference count is zero.

	@see PxPhysics.createHeightField() PxHeightFieldDesc PxHeightFieldGeometry PxShape
	*/
    function release():Void;

    /**
    Writes out the sample data array.

	The user provides destBufferSize bytes storage at destBuffer.
	The data is formatted and arranged as PxHeightFieldDesc.samples.

	@param [out]destBuffer The destination buffer for the sample data.
	@param [in]destBufferSize The size of the destination buffer.
	@return The number of bytes written.

	@see PxHeightFieldDesc.samples
    */
    function saveCells(destBuffer:cpp.Pointer<cpp.Void>, destBufferSize:PxU32):PxU32;

    /**
    Replaces a rectangular subfield in the sample data array.

	The user provides the description of a rectangular subfield in subfieldDesc.
	The data is formatted and arranged as PxHeightFieldDesc.samples.

	@param [in]startCol First cell in the destination heightfield to be modified. Can be negative.
	@param [in]startRow First row in the destination heightfield to be modified. Can be negative.
	@param [in]subfieldDesc Description of the source subfield to read the samples from.
	@param [in]shrinkBounds If left as false, the bounds will never shrink but only grow. If set to true the bounds will be recomputed from all HF samples at O(nbColums*nbRows) perf cost.
	@return True on success, false on failure. Failure can occur due to format mismatch.

	**Note:** Modified samples are constrained to the same height quantization range as the original heightfield.
	Source samples that are out of range of target heightfield will be clipped with no error.
	PhysX does not keep a mapping from the heightfield to heightfield shapes that reference it.
	Call PxShape::setGeometry on each shape which references the height field, to ensure that internal data structures are updated to reflect the new geometry.
	Please note that PxShape::setGeometry does not guarantee correct/continuous behavior when objects are resting on top of old or new geometry.

	@see PxHeightFieldDesc.samples PxShape.setGeometry
	*/
	function modifySamples(startCol:PxI32, startRow:PxI32, subfieldDesc:PxHeightFieldDesc, shrinkBounds:Bool = false):Bool;

	/**
	Retrieves the number of sample rows in the samples array.

	@return The number of sample rows in the samples array.

	@see PxHeightFieldDesc.nbRows
	*/
	function getNbRows():PxU32;

	/**
	Retrieves the number of sample columns in the samples array.

	@return The number of sample columns in the samples array.

	@see PxHeightFieldDesc.nbColumns
	*/
	function getNbColumns():PxU32;

	/**
	Retrieves the format of the sample data.

	@return The format of the sample data.

	@see PxHeightFieldDesc.format PxHeightFieldFormat
	*/
	function getFormat():PxHeightFieldFormat;

	/**
	Retrieves the offset in bytes between consecutive samples in the array.

	@return The offset in bytes between consecutive samples in the array.

	@see PxHeightFieldDesc.sampleStride
	*/
	function getSampleStride():PxU32;

	/**
	Retrieves the convex edge threshold.

	@return The convex edge threshold.

	@see PxHeightFieldDesc.convexEdgeThreshold
	*/
	function getConvexEdgeThreshold():PxReal;

	/**
	Retrieves the flags bits, combined from values of the enum ::PxHeightFieldFlag.

	@return The flags bits, combined from values of the enum ::PxHeightFieldFlag.

	@see PxHeightFieldDesc.flags PxHeightFieldFlag
	*/
	function getFlags():PxHeightFieldFlags;
	
	/**
	Retrieves the height at the given coordinates in grid space.

	@return The height at the given coordinates or 0 if the coordinates are out of range.
	*/
	function getHeight(x:PxReal, z:PxReal):PxReal;

	/**
	Returns the reference count for shared heightfields.

	At creation, the reference count of the heightfield is 1. Every shape referencing this heightfield increments the
	count by 1.	When the reference count reaches 0, and only then, the heightfield gets destroyed automatically.

	@return the current reference count.
	*/
	function getReferenceCount():PxU32;

	/**
	Acquires a counted reference to a heightfield.

	This method increases the reference count of the heightfield by 1. Decrement the reference count by calling release()
	*/
	function acquireReference():Void;

	/**
	Returns material table index of given triangle

	**Note:** This function takes a post cooking triangle index.

	@param [in]triangleIndex (internal) index of desired triangle
	@return Material table index, or 0xffff if no per-triangle materials are used
	*/
	function getTriangleMaterialIndex(triangleIndex:PxTriangleID):PxMaterialTableIndex;

	/**
	Returns a triangle face normal for a given triangle index

	**Note:** This function takes a post cooking triangle index.

	@param [in]triangleIndex (internal) index of desired triangle
	@return Triangle normal for a given triangle index
	*/
	function getTriangleNormal(triangleIndex:PxTriangleID):PxVec3;

	/**
	Returns heightfield sample of given row and column	

	@param [in]row Given heightfield row
	@param [in]column Given heightfield column
	@return Heightfield sample
	*/
	function getSample(row:PxU32, column:PxU32):PxHeightFieldSample;

	/**
	Returns the number of times the heightfield data has been modified
	
	This method returns the number of times modifySamples has been called on this heightfield, so that code that has
	retained state that depends on the heightfield can efficiently determine whether it has been modified.
	
	@return the number of times the heightfield sample data has been modified.
	*/
	function getTimestamp():PxU32;
}