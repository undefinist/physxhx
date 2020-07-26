package physx.geometry;

/**
\brief Flags controlling the simulated behavior of the convex mesh geometry.

Used in ::PxConvexMeshGeometryFlags.
*/
// struct PxConvexMeshGeometryFlag
// {
// 	enum Enum
// 	{
// 		eTIGHT_BOUNDS = (1<<0)	//!< Use tighter (but more expensive to compute) bounds around the convex geometry.
// 	};
// };

// /**
// \brief collection of set bits defined in PxConvexMeshGeometryFlag.

// @see PxConvexMeshGeometryFlag
// */
// typedef PxFlags<PxConvexMeshGeometryFlag::Enum,PxU8> PxConvexMeshGeometryFlags;
// PX_FLAGS_OPERATORS(PxConvexMeshGeometryFlag::Enum,PxU8)

/**
\brief Convex mesh geometry class.

This class unifies a convex mesh object with a scaling transform, and 
lets the combined object be used anywhere a PxGeometry is needed.

The scaling is a transform along arbitrary axes contained in the scale object.
The vertices of the mesh in geometry (or shape) space is the 
PxMeshScale::toMat33() transform, multiplied by the vertex space vertices 
in the PxConvexMesh object.
*/
@:include("geometry/PxConvexMeshGeometry.h")
@:native("physx::PxConvexMeshGeometry")
extern class PxConvexMeshGeometry extends PxGeometry
{

}

// {
// public:
// 	/**
// 	\brief Default constructor.

// 	Creates an empty object with a NULL mesh and identity scale.
// 	*/
// 	PX_INLINE PxConvexMeshGeometry() :
// 		PxGeometry	(PxGeometryType::eCONVEXMESH),
// 		scale		(PxMeshScale(1.0f)),
// 		convexMesh	(NULL),
// 		meshFlags	(PxConvexMeshGeometryFlag::eTIGHT_BOUNDS)
// 	{}

// 	/**
// 	\brief Constructor.
// 	\param[in] mesh		Mesh pointer. May be NULL, though this will not make the object valid for shape construction.
// 	\param[in] scaling	Scale factor.
// 	\param[in] flags	Mesh flags.
// 	\
// 	*/
// 	PX_INLINE PxConvexMeshGeometry(	PxConvexMesh* mesh, 
// 									const PxMeshScale& scaling = PxMeshScale(),
// 									PxConvexMeshGeometryFlags flags = PxConvexMeshGeometryFlag::eTIGHT_BOUNDS) :
// 		PxGeometry	(PxGeometryType::eCONVEXMESH),
// 		scale		(scaling),
// 		convexMesh	(mesh),
// 		meshFlags	(flags)
// 	{
// 	}

// 	/**
// 	\brief Returns true if the geometry is valid.

// 	\return True if the current settings are valid for shape creation.

// 	\note A valid convex mesh has a positive scale value in each direction (scale.x > 0, scale.y > 0, scale.z > 0).
// 	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a convex that has zero extent in any direction.

// 	@see PxRigidActor::createShape, PxPhysics::createShape
// 	*/
// 	PX_INLINE bool isValid() const;

// public:
// 	PxMeshScale					scale;				//!< The scaling transformation (from vertex space to shape space).
// 	PxConvexMesh*				convexMesh;			//!< A reference to the convex mesh object.
// 	PxConvexMeshGeometryFlags	meshFlags;			//!< Mesh flags.
// 	PxPadding<3>				paddingFromFlags;	//!< padding for mesh flags
// };
