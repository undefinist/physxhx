package physx.geometry;

import physx.common.PxCoreUtilityTypes.PxStridedData;
import physx.geometry.PxHeightFieldFlag;
import physx.foundation.PxSimpleTypes;

/**
\brief Descriptor class for #PxHeightField.

\note The heightfield data is *copied* when a PxHeightField object is created from this descriptor. After the call the
user may discard the height data.

Construct using `= null`.

@see PxHeightField PxHeightFieldGeometry PxShape PxPhysics.createHeightField() PxCooking.createHeightField()
*/
@:include("geometry/PxHeightFieldDesc.h")
@:native("::cpp::Struct<physx::PxHeightFieldDesc>")
extern class PxHeightFieldDesc
{
    /**
	\brief Number of sample rows in the height field samples array.

	\note Local space X-axis corresponds to rows.

	<b>Range:</b> &gt;1<br>
	<b>Default:</b> 0
	*/
	var nbRows:PxU32;

	/**
	\brief Number of sample columns in the height field samples array.

	\note Local space Z-axis corresponds to columns.

	<b>Range:</b> &gt;1<br>
	<b>Default:</b> 0
	*/
	var nbColumns:PxU32;

	/**
	\brief Format of the sample data.

	Currently the only supported format is PxHeightFieldFormat::eS16_TM:

	<b>Default:</b> PxHeightFieldFormat::eS16_TM

	@see PxHeightFormat PxHeightFieldDesc.samples
	*/
	var format:PxHeightFieldFormat;

	/**
	\brief The samples array.

	It is copied to the SDK's storage at creation time.

	There are nbRows * nbColumn samples in the array,
	which define nbRows * nbColumn vertices and cells,
	of which (nbRows - 1) * (nbColumns - 1) cells are actually used.

	The array index of sample(row, column) = row * nbColumns + column.
	The byte offset of sample(row, column) = sampleStride * (row * nbColumns + column).
	The sample data follows at the offset and spans the number of bytes defined by the format.
	Then there are zero or more unused bytes depending on sampleStride before the next sample.

	<b>Default:</b> NULL

	@see PxHeightFormat
	*/
	var samples(never, set):Array<PxHeightFieldSample>;
	@:native("samples") private var _samples:PxStridedData;
	private inline function set_samples(array:Array<PxHeightFieldSample>):Array<PxHeightFieldSample>
	{
		_samples = null;
		_samples.stride = untyped __cpp__("sizeof(physx::PxHeightFieldSample)");
		_samples.data = cpp.Pointer.ofArray(array).reinterpret();
		return array;
	}

	/**
	This threshold is used by the collision detection to determine if a height field edge is convex
	and can generate contact points.
	Usually the convexity of an edge is determined from the angle (or cosine of the angle) between
	the normals of the faces sharing that edge.
	The height field allows a more efficient approach by comparing height values of neighboring vertices.
	This parameter offsets the comparison. Smaller changes than 0.5 will not alter the set of convex edges.
	The rule of thumb is that larger values will result in fewer edge contacts.

	This parameter is ignored in contact generation with sphere and capsule primitives.

	<b>Range:</b> [0, PX_MAX_F32)<br>
	<b>Default:</b> 0
	*/
	var convexEdgeThreshold:PxReal;

	/**
	\brief Flags bits, combined from values of the enum ::PxHeightFieldFlag.

	<b>Default:</b> 0

	@see PxHeightFieldFlag PxHeightFieldFlags
	*/
	var flags:PxHeightFieldFlags;

	/**
	\brief (re)sets the structure to the default.
	*/
	function setToDefault():Void;

	/**
	\brief Returns true if the descriptor is valid.
	\return True if the current settings are valid.
	*/
	function isValid():Bool;
}