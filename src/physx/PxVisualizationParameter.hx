package physx;

/*
NOTE: Parameters should NOT be conditionally compiled out. Even if a particular feature is not available.
Otherwise the parameter values get shifted about and the numeric values change per platform. This causes problems
when trying to serialize parameters.

New parameters should also be added to the end of the list for this reason. Also make sure to update 
eNUM_VALUES, which should be one higher than the maximum value in the enum.
*/

/**
\brief Debug visualization parameters.

`PxVisualizationParameter.eSCALE` is the master switch for enabling visualization, please read the corresponding documentation
for further details.

@see PxScene.setVisualizationParameter() PxScene.getVisualizationParameter() PxScene.getRenderBuffer()
*/
@:build(physx.hx.EnumBuilder.build("physx::PxVisualizationParameter"))
extern enum abstract PxVisualizationParameter(PxVisualizationParameterImpl)
{
/* RigidBody-related parameters  */

    /**
    \brief This overall visualization scale gets multiplied with the individual scales. Setting to zero ignores all visualizations. Default is 0.

    The below settings permit the debug visualization of various simulation properties. 
    The setting is either zero, in which case the property is not drawn. Otherwise it is a scaling factor
    that determines the size of the visualization widgets.

    Only objects for which visualization is turned on using setFlag(eVISUALIZATION) are visualized (see `PxActorFlag::eVISUALIZATION,` `PxShapeFlag.eVISUALIZATION,` ...).
    Contacts are visualized if they involve a body which is being visualized.
    Default is 0.

    Notes:
    - to see any visualization, you have to set PxVisualizationParameter::eSCALE to nonzero first.
    - the scale factor has been introduced because it's difficult (if not impossible) to come up with a
    good scale for 3D vectors. Normals are normalized and their length is always 1. But it doesn't mean
    we should render a line of length 1. Depending on your objects/scene, this might be completely invisible
    or extremely huge. That's why the scale factor is here, to let you tune the length until it's ok in
    your scene.
    - however, things like collision shapes aren't ambiguous. They are clearly defined for example by the
    triangles & polygons themselves, and there's no point in scaling that. So the visualization widgets
    are only scaled when it makes sense.

    **Range:** [0, PX_MAX_F32)<br>
    **Default:** 0
    */
    var eSCALE;

    
    /**
    \brief Visualize the world axes.
    */
    var eWORLD_AXES;
    
/* Body visualizations */

    /**
    \brief Visualize a bodies axes.

    @see PxActor.globalPose PxActor
    */
    var eBODY_AXES;
    
    /**
    \brief Visualize a body's mass axes.

    This visualization is also useful for visualizing the sleep state of bodies. Sleeping bodies are drawn in
    black, while awake bodies are drawn in white. If the body is sleeping and part of a sleeping group, it is
    drawn in red.

    @see PxBodyDesc.massLocalPose PxActor
    */
    var eBODY_MASS_AXES;
    
    /**
    \brief Visualize the bodies linear velocity.

    @see PxBodyDesc.linearVelocity PxActor
    */
    var eBODY_LIN_VELOCITY;
    
    /**
    \brief Visualize the bodies angular velocity.

    @see PxBodyDesc.angularVelocity PxActor
    */
    var eBODY_ANG_VELOCITY;


/* Contact visualisations */

    /**
    \brief  Visualize contact points. Will enable contact information.
    */
    var eCONTACT_POINT;
    
    /**
    \brief Visualize contact normals. Will enable contact information.
    */
    var eCONTACT_NORMAL;
    
    /**
    \brief  Visualize contact errors. Will enable contact information.
    */
    var eCONTACT_ERROR;
    
    /**
    \brief Visualize Contact forces. Will enable contact information.
    */
    var eCONTACT_FORCE;

    
    /**
    \brief Visualize actor axes.

    @see PxRigidStatic PxRigidDynamic PxArticulationLink
    */
    var eACTOR_AXES;

    
    /**
    \brief Visualize bounds (AABBs in world space)
    */
    var eCOLLISION_AABBS;
    
    /**
    \brief Shape visualization

    @see PxShape
    */
    var eCOLLISION_SHAPES;
    
    /**
    \brief Shape axis visualization

    @see PxShape
    */
    var eCOLLISION_AXES;

    /**
    \brief Compound visualization (compound AABBs in world space)
    */
    var eCOLLISION_COMPOUNDS;

    /**
    \brief Mesh & convex face normals

    @see PxTriangleMesh PxConvexMesh
    */
    var eCOLLISION_FNORMALS;
    
    /**
    \brief Active edges for meshes

    @see PxTriangleMesh
    */
    var eCOLLISION_EDGES;

    /**
    \brief Static pruning structures
    */
    var eCOLLISION_STATIC;

    /**
    \brief Dynamic pruning structures
    */
    var eCOLLISION_DYNAMIC;

    /**
    \brief Visualizes pairwise state.
    */
    var eDEPRECATED_COLLISION_PAIRS;

    /**
    \brief Joint local axes
    */
    var eJOINT_LOCAL_FRAMES;

    /** 
    \brief Joint limits
    */
    var eJOINT_LIMITS;

    /**
    \brief Visualize culling box
    */
    var eCULL_BOX;

    /**
    \brief MBP regions
    */
    var eMBP_REGIONS;

    /**
    \brief This is not a parameter, it just records the current number of parameters (as maximum(PxVisualizationParameter)+1) for use in loops.
    */
    var eNUM_VALUES;

    //var eFORCE_DWORD = 0x7fffffff;
}

@:include("PxVisualizationParameter.h")
@:native("physx::PxVisualizationParameter::Enum")
private extern class PxVisualizationParameterImpl {}