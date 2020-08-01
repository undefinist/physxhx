package physx.extensions;

/**
 * Raycast-CCD manager.
 * 
 * Raycast-CCD is a simple and potentially cheaper alternative to the SDK's built-in continuous collision detection algorithm.
 * 
 * This implementation has some limitations:
 * - it is only implemented for `PxRigidDynamic` objects (not for `PxArticulationLink`)
 * - it is only implemented for simple actors with 1 shape (not for "compounds")
 * 
 * Also, since it is raycast-based, the solution is not perfect. In particular:
 * - small dynamic objects can still go through the static world if the ray goes through a crack between edges, or a small
 * hole in the world (like the keyhole from a door).
 * - dynamic-vs-dynamic CCD is very approximate. It only works well for fast-moving dynamic objects colliding against
 * slow-moving dynamic objects.
 * 
 * Finally, since it is using the SDK's scene queries under the hood, it only works provided the simulation shapes also have
 * scene-query shapes associated with them. That is, if the objects in the scene only use `PxShapeFlag.eSIMULATION_SHAPE`
 * (and no `PxShapeFlag.eSCENE_QUERY_SHAPE`), then the raycast-CCD system will not work.
 */
@:include("extensions/PxRaycastCCD.h")
@:native("::cpp::Reference<physx::PxRaycastCCD>")
extern class RaycastCCDManager
{
    /**
     * Create an instance of RaycastCCDManager. It is not handled by GC. Make sure to call `release()` on cleanup!
     */
    @:native("new physx::PxRaycastCCD")
    static function create(scene:PxScene):RaycastCCDManager;

    inline function release():Void
    {
        untyped __cpp__("delete {0}.ptr", this);
    }

    /**
     * Register dynamic object for raycast CCD.
     * 
     * @param actor object's actor
     * @param shape object's shape
     * 
     * @return True if success
     */
    function registerRaycastCCDObject(actor:PxRigidDynamic, shape:PxShape):Bool;

    /**
     * Perform raycast CCD. Call this after your simulate/fetchResults calls.
     * 
     * @param doDynamicDynamicCCD True to enable dynamic-vs-dynamic CCD (more expensive, not always needed)
     */
    function doRaycastCCD(doDynamicDynamicCCD:Bool):Void;
}