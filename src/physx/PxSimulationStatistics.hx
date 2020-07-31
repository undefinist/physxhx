package physx;

import physx.geometry.PxGeometry.PxGeometryType;
import physx.foundation.PxSimpleTypes.PxU32;

/**
\brief Different types of rigid body collision pair statistics.
@see getRbPairStats
*/
@:build(physx.hx.PxEnumBuilder.build("physx::PxSimulationStatistics"))
extern enum abstract RbPairStatsType(RbPairStatsTypeImpl)
{
    /**
    \brief Shape pairs processed as discrete contact pairs for the current simulation step.
    */
    var eDISCRETE_CONTACT_PAIRS;

    /**
    \brief Shape pairs processed as swept integration pairs for the current simulation step.

    \note Counts the pairs for which special CCD (continuous collision detection) work was actually done and NOT the number of pairs which were configured for CCD. 
    Furthermore, there can be multiple CCD passes and all processed pairs of all passes are summed up, hence the number can be larger than the amount of pairs which have been configured for CCD.

    @see PxPairFlag::eDETECT_CCD_CONTACT,
    */
    var eCCD_PAIRS;

    /**
    \brief Shape pairs processed with user contact modification enabled for the current simulation step.

    @see PxContactModifyCallback
    */
    var eMODIFIED_CONTACT_PAIRS;

    /**
    \brief Trigger shape pairs processed for the current simulation step.

    @see PxShapeFlag::eTRIGGER_SHAPE
    */
    var eTRIGGER_PAIRS;
}

@:include("PxSimulationStatistics.h")
@:native("physx::PxSimulationStatistics::RbPairStatsType")
extern class RbPairStatsTypeImpl {}

/**
\brief Class used to retrieve statistics for a simulation step.

@see PxScene::getSimulationStatistics()
*/
@:include("PxSimulationStatistics.h")
@:native("::cpp::Struct<physx::PxSimulationStatistics>")
extern class PxSimulationStatistics
{
//objects:    
	/**
	\brief Number of active PxConstraint objects (joints etc.) for the current simulation step.
	*/
	var nbActiveConstraints:PxU32;

	/**
	\brief Number of active dynamic bodies for the current simulation step.

	\note Does not include active kinematic bodies
	*/
	var nbActiveDynamicBodies:PxU32;

	/**
	\brief Number of active kinematic bodies for the current simulation step.
	
	\note Kinematic deactivation occurs at the end of the frame after the last call to PxRigidDynamic::setKinematicTarget() was called so kinematics that are
	deactivated in a given frame will be included by this counter.
	*/
	var nbActiveKinematicBodies:PxU32;

	/**
	\brief Number of static bodies for the current simulation step.
	*/
	var nbStaticBodies:PxU32;

	/**
	\brief Number of dynamic bodies for the current simulation step.

	\note Includes inactive bodies and articulation links
	\note Does not include kinematic bodies
	*/
	var nbDynamicBodies:PxU32;

	/**
	\brief Number of kinematic bodies for the current simulation step.

	\note Includes inactive bodies
	*/
	var nbKinematicBodies:PxU32;

	/**
	\brief Number of shapes of each geometry type.
	*/
	var nbShapes:cpp.Pointer<PxU32>;

	/**
	\brief Number of aggregates in the scene.
	*/
	var nbAggregates:PxU32;
	
	/**
	\brief Number of articulations in the scene.
	*/
	var nbArticulations:PxU32;

//solver:
	/**
	\brief The number of 1D axis constraints(joints+contact) present in the current simulation step.
	*/
	var nbAxisSolverConstraints:PxU32;

	/**
	\brief The size (in bytes) of the compressed contact stream in the current simulation step
	*/
	var compressedContactSize:PxU32;

	/**
	\brief The total required size (in bytes) of the contact constraints in the current simulation step
	*/
	var requiredContactConstraintMemory:PxU32;

	/**
	\brief The peak amount of memory (in bytes) that was allocated for constraints (this includes joints) in the current simulation step
	*/
	var peakConstraintMemory:PxU32;

//broadphase:
	/**
	\brief Get number of broadphase volumes added for the current simulation step.

	\return Number of broadphase volumes added.
	*/
	function getNbBroadPhaseAdds():PxU32;

	/**
	\brief Get number of broadphase volumes removed for the current simulation step.

	\return Number of broadphase volumes removed.
	*/
	function getNbBroadPhaseRemoves():PxU32;

//collisions:
	/**
	\brief Get number of shape collision pairs of a certain type processed for the current simulation step.

	There is an entry for each geometry pair type.

	\note entry[i][j] = entry[j][i], hence, if you want the sum of all pair
	      types, you need to discard the symmetric entries

	\param[in] pairType The type of pair for which to get information
	\param[in] g0 The geometry type of one pair object
	\param[in] g1 The geometry type of the other pair object
	\return Number of processed pairs of the specified geometry types.
	*/
	function getRbPairStats(pairType:RbPairStatsType, g0:PxGeometryType, g1:PxGeometryType):PxU32;

	/**
	\brief Total number of (non CCD) pairs reaching narrow phase
	*/
	var nbDiscreteContactPairsTotal:PxU32;

	/**
	\brief Total number of (non CCD) pairs for which contacts are successfully cached (<=nbDiscreteContactPairsTotal)
	\note This includes pairs for which no contacts are generated, it still counts as a cache hit.
	*/
	var nbDiscreteContactPairsWithCacheHits:PxU32;

	/**
	\brief Total number of (non CCD) pairs for which at least 1 contact was generated (<=nbDiscreteContactPairsTotal)
	*/
	var nbDiscreteContactPairsWithContacts:PxU32;

	/**
	\brief Number of new pairs found by BP this frame
	*/
	var nbNewPairs:PxU32;

	/**
	\brief Number of lost pairs from BP this frame
	*/
	var nbLostPairs:PxU32;

	/**
	\brief Number of new touches found by NP this frame
	*/
	var nbNewTouches:PxU32;

	/**
	\brief Number of lost touches from NP this frame
	*/
	var nbLostTouches:PxU32;

	/**
	\brief Number of partitions used by the solver this frame
	*/
	var nbPartitions:PxU32;
}