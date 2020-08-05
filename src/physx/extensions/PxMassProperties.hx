package physx.extensions;

import physx.foundation.PxSimpleTypes.PxU32;
import physx.foundation.PxTransform;
import physx.foundation.PxQuat;
import physx.foundation.PxSimpleTypes.PxReal;
import physx.foundation.PxVec3;
import physx.foundation.PxMat33;

/**
Utility class to compute and manipulate mass and inertia tensor properties.

In most cases #PxRigidBodyExt::updateMassAndInertia(), #PxRigidBodyExt::setMassAndUpdateInertia() should be enough to
setup the mass properties of a rigid body. This utility class targets users that need to customize the mass properties
computation.
*/
@:include("extensions/PxMassProperties.h")
@:native("physx::PxMassProperties")
@:structAccess
extern class PxMassProperties
{
    var inertiaTensor:PxMat33;
    var centerOfMass:PxVec3;
    var mass:PxReal;

    /**
     * Scale mass properties. Does **not** modify this in place, meaning original is not modified.
     * 
     * @param scale The linear scaling factor to apply to the mass properties.
     * @return The scaled mass properties.
     */
    @:native("operator*") function scaled(scale:PxReal):PxMassProperties;

    /**
     * Translate the center of mass by a given vector and adjust the inertia tensor accordingly.
     * 
     * @param t The translation vector for the center of mass.
     */
    function translate(t:PxVec3):Void;
    
    @:native("physx::PxMassProperties::getMassSpaceInertia")
    private static function _getMassSpaceInertia(inertia:PxMat33, massFrame:cpp.Reference<PxQuat>):PxVec3;
    /**
     * Get the entries of the diagonalized inertia tensor and the corresponding reference rotation.
     * 
     * @param inertia The inertia tensor to diagonalize.
     * @return The `entries` of the diagonalized inertia tensor, and the `massFrame` it refers to.
     */
    static inline function getMassSpaceInertia(inertia:PxMat33):{massFrame:PxQuat, entries:PxVec3}
    {
        var massFrame = PxQuat.create();
        var entries = _getMassSpaceInertia(inertia, massFrame);
        return { massFrame: massFrame, entries: entries };
    }
    
    /**
     * Translate an inertia tensor using the parallel axis theorem
     * 
     * @param inertia The inertia tensor to translate.
     * @param mass The mass of the object.
     * @param t The relative frame to translate the inertia tensor to.
     * @return The translated inertia tensor.
     */
    static function translateInertia(inertia:PxMat33, mass:PxReal, t:PxVec3):PxMat33;

    /**
     * Rotate an inertia tensor around the center of mass
     * 
     * @param inertia The inertia tensor to rotate.
     * @param q The rotation to apply to the inertia tensor.
     * @return The rotated inertia tensor.
     */
    static function rotateInertia(inertia:PxMat33, q:PxQuat):PxMat33;

    /**
     * Non-uniform scaling of the inertia tensor
     * 
     * @param inertia The inertia tensor to scale.
     * @param scaleRotation The frame of the provided scaling factors.
     * @param scale The scaling factor for each axis (relative to the frame specified in scaleRotation).
     * @return The scaled inertia tensor.
     */
    static function scaleInertia(inertia:PxMat33, scaleRotation:PxQuat, scale:PxVec3):PxMat33;

    @:native("physx::PxMassProperties::sum")
    private static function _sum(props:cpp.ConstPointer<PxMassProperties>, transforms:cpp.ConstPointer<PxTransform>, count:PxU32):PxMassProperties;
    /**
     * Sum up individual mass properties. `props` and `transforms` should have same length.
     * 
     * @param props Array of mass properties to sum up.
     * @param transforms Reference transforms for each mass properties entry.
     * @return The summed up mass properties.
     */
    static inline function sum(props:Array<PxMassProperties>, transforms:Array<PxTransform>):PxMassProperties
    {
        return _sum(cpp.Pointer.ofArray(props), cpp.Pointer.ofArray(transforms), props.length);
    }
}