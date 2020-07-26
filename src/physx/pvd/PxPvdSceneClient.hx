package physx.pvd;

import physx.common.PxRenderBuffer;
import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;

/**
\brief types of instrumentation that PVD can do.
*/
extern enum abstract PxPvdSceneFlag(PxPvdSceneFlagImpl)
{
    /**
     * Transmits contact stream to PVD.
     */
    @:native("physx::PxPvdSceneFlag::eTRANSMIT_CONTACTS") var eTRANSMIT_CONTACTS;

    /**
     * Transmits scene query stream to PVD.
     */
    @:native("physx::PxPvdSceneFlag::eTRANSMIT_SCENEQUERIES") var eTRANSMIT_SCENEQUERIES;

    /**
     * Transmits constraints visualize stream to PVD.
     */
    @:native("physx::PxPvdSceneFlag::eTRANSMIT_CONSTRAINTS") var eTRANSMIT_CONSTRAINTS;

    @:op(A | B)
    private inline function or(flag:PxPvdSceneFlag):PxPvdSceneFlag
    {
        return untyped __cpp__("{0} | {1}", this, flag);
    }
}

@:include("pvd/PxPvdSceneClient.h")
@:native("cpp::Struct<physx::PxPvdSceneFlag::Enum, ::cpp::EnumHandler>")
private extern class PxPvdSceneFlagImpl {}

/**
\brief Bitfield that contains a set of raised flags defined in PxPvdInstrumentationFlag.

@see PxPvdInstrumentationFlag
*/
extern abstract PxPvdSceneFlags(PxPvdSceneFlag) from PxPvdSceneFlag to PxPvdSceneFlag {}

/**
\brief Special client for PxScene.
It provides access to the PxPvdSceneFlag.
It also provides simple user debug services that associated scene position such as immediate rendering and camera updates.
*/
@:include("pvd/PxPvdSceneClient.h")
@:native("::cpp::Reference<physx::PxPvdSceneClient>")
extern class PxPvdSceneClient
{
	/**
	Sets the PVD flag. See PxPvdSceneFlag.
	\param flag Flag to set.
	\param value value the flag gets set to.
	*/
	function setScenePvdFlag(flag:PxPvdSceneFlag, value:Bool):Void;

	/**
	Sets the PVD flags. See PxPvdSceneFlags.
	\param flags Flags to set.
	*/
	function setScenePvdFlags(flags:PxPvdSceneFlags):Void;

	/**
	Retrieves the PVD flags. See PxPvdSceneFlags.
	*/
	function getScenePvdFlags():PxPvdSceneFlags;

    @:native("updateCamera") private function _updateCamera(name:cpp.ConstCharStar, origin:PxVec3, up:PxVec3, target:PxVec3):Void;
	/**
	update camera on PVD application's render window
	*/
    inline function updateCamera(name:String, origin:PxVec3, up:PxVec3, target:PxVec3):Void
    {
        _updateCamera(name, origin, up, target);
    }

	/**
	draw points on PVD application's render window
	*/
    inline function drawPoints(points:Array<PxDebugPoint>):Void
    {
        untyped __cpp__("{0}.drawPoints(reinterpret_cast<physx::pvdsdk::PvdDebugPoint*>({1}, {2})",
            this, cpp.Pointer.ofArray(points), points.length);
    }

	/**
	draw lines on PVD application's render window
	*/
    inline function drawLines(lines:Array<PxDebugLine>):Void
    {
        untyped __cpp__("{0}.drawLines(reinterpret_cast<physx::pvdsdk::PvdDebugLine*>({1}, {2})",
            this, cpp.Pointer.ofArray(lines), lines.length);
    }

	/**
	draw triangles on PVD application's render window
	*/
    inline function drawTriangles(triangles:Array<PxDebugTriangle>):Void
    {
        untyped __cpp__("{0}.drawTriangles(reinterpret_cast<physx::pvdsdk::PvdDebugTriangle*>({1}, {2})",
            this, cpp.Pointer.ofArray(triangles), triangles.length);
    }

	/**
	draw text on PVD application's render window
	*/
    inline function drawText(text:Array<PxDebugText>):Void
    {
        untyped __cpp__("{0}.drawText(reinterpret_cast<physx::pvdsdk::PvdDebugText*>({1}, {2})",
            this, cpp.Pointer.ofArray(text), text.length);
    }
    
}