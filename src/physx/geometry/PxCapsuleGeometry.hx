package physx.geometry;

/**
\brief Class representing the geometry of a capsule.

Capsules are shaped as the union of a cylinder of length 2 * halfHeight and with the 
given radius centered at the origin and extending along the x axis, and two hemispherical ends.
\note The scaling of the capsule is expected to be baked into these values, there is no additional scaling parameter.

The function PxTransformFromSegment is a helper for generating an appropriate transform for the capsule from the capsule's interior line segment.

@see PxTransformFromSegment
*/
@:include("geometry/PxCapsuleGeometry.h")
@:native("physx::PxCapsuleGeometry")
extern class PxCapsuleGeometry extends PxGeometry 
{
}
// public:
// 	/**
// 	\brief Default constructor, initializes to a capsule with zero height and radius.
// 	*/
// 	PX_INLINE PxCapsuleGeometry() :						PxGeometry(PxGeometryType::eCAPSULE), radius(0), halfHeight(0)		{}

// 	/**
// 	\brief Constructor, initializes to a capsule with passed radius and half height.
// 	*/
// 	PX_INLINE PxCapsuleGeometry(PxReal radius_, PxReal halfHeight_) :	PxGeometry(PxGeometryType::eCAPSULE), radius(radius_), halfHeight(halfHeight_)	{}

// 	/**
// 	\brief Returns true if the geometry is valid.

// 	\return True if the current settings are valid.

// 	\note A valid capsule has radius > 0, halfHeight > 0.
// 	It is illegal to call PxRigidActor::createShape and PxPhysics::createShape with a capsule that has zero radius or height.

// 	@see PxRigidActor::createShape, PxPhysics::createShape
// 	*/
// 	PX_INLINE bool isValid() const;

// public:
// 	/**
// 	\brief The radius of the capsule.
// 	*/
// 	PxReal radius;

// 	/**
// 	\brief half of the capsule's height, measured between the centers of the hemispherical ends.
// 	*/
// 	PxReal halfHeight;
//};




/** \brief creates a transform from the endpoints of a segment, suitable for an actor transform for a PxCapsuleGeometry

\param[in] p0 one end of major axis of the capsule
\param[in] p1 the other end of the axis of the capsule
\param[out] halfHeight the halfHeight of the capsule. This parameter is optional.
\return A PxTransform which will transform the vector (1,0,0) to the capsule axis shrunk by the halfHeight
*/

//PX_FOUNDATION_API PxTransform PxTransformFromSegment(const PxVec3& p0, const PxVec3& p1, PxReal* halfHeight = NULL);


