package physx.common;

import physx.foundation.PxVec3;
import physx.foundation.PxSimpleTypes;

/**
\brief Default color values used for debug rendering.
*/
extern enum abstract PxDebugColor(PxDebugColorImpl)
{
    @:native("physx::PxDebugColor::eARGB_BLACK") var eARGB_BLACK;
    @:native("physx::PxDebugColor::eARGB_RED") var eARGB_RED;
    @:native("physx::PxDebugColor::eARGB_GREEN") var eARGB_GREEN;
    @:native("physx::PxDebugColor::eARGB_BLUE") var eARGB_BLUE;
    @:native("physx::PxDebugColor::eARGB_YELLOW") var eARGB_YELLOW;
    @:native("physx::PxDebugColor::eARGB_MAGENTA") var eARGB_MAGENTA;
    @:native("physx::PxDebugColor::eARGB_CYAN") var eARGB_CYAN;
    @:native("physx::PxDebugColor::eARGB_WHITE") var eARGB_WHITE;
    @:native("physx::PxDebugColor::eARGB_GREY") var eARGB_GREY;
    @:native("physx::PxDebugColor::eARGB_DARKRED") var eARGB_DARKRED;
    @:native("physx::PxDebugColor::eARGB_DARKGREEN") var eARGB_DARKGREEN;
    @:native("physx::PxDebugColor::eARGB_DARKBLUE") var eARGB_DARKBLUE;
}

@:include("common/PxRenderBuffer.h")
@:native("physx::PxDebugColor::Enum")
private extern class PxDebugColorImpl {}

/**
\brief Used to store a single point and colour for debug rendering.
*/
@:include("common/PxRenderBuffer.h")
@:native("physx::PxDebugPoint")
extern class PxDebugPoint
{
	var pos:PxVec3;
	var color:PxU32;
}

/**
\brief Used to store a single line and colour for debug rendering.
*/
@:include("common/PxRenderBuffer.h")
@:native("physx::PxDebugLine")
extern class PxDebugLine
{
	var pos0:PxVec3;
	var pos1:PxVec3;
	var color0:PxU32;
	var color1:PxU32;
}

/**
\brief Used to store a single triangle and colour for debug rendering.
*/
@:include("common/PxRenderBuffer.h")
@:native("physx::PxDebugTriangle")
extern class PxDebugTriangle
{
	var pos0:PxVec3;
	var pos1:PxVec3;
	var pos2:PxVec3;
	var color0:PxU32;
	var color1:PxU32;
	var color2:PxU32;
}

/**
\brief Used to store a text for debug rendering. Doesn't own 'string' array.
*/
@:include("common/PxRenderBuffer.h")
@:native("physx::PxDebugText")
extern class PxDebugText
{
	var position:PxVec3;
	var size:PxReal;
    var color:PxU32;

    @:native("string") private var _string:cpp.ConstCharStar;
    var string(get, set):String;
    inline function get_string():String
    {
        return _string;
    }
    inline function set_string(value:String):String
    {
        return _string = value;
    }
}

/**
\brief Interface for points, lines, triangles, and text buffer.
*/
@:include("common/PxRenderBuffer.h")
@:native("::cpp::Reference<physx::PxRenderBuffer>")
extern class PxRenderBuffer
{
	function getNbPoints():PxU32;
    inline function getPoints():Array<PxDebugPoint>
    {
        var p:cpp.Pointer<PxDebugPoint> = untyped __cpp__("{0}.getPoints()", this);
        return p.toUnmanagedArray(getNbPoints());
    }

	function getNbLines():PxU32;
    inline function getLines():Array<PxDebugLine>
    {
        var p:cpp.Pointer<PxDebugLine> = untyped __cpp__("{0}.getLines()", this);
        return p.toUnmanagedArray(getNbLines());
    }

	function getNbTriangles():PxU32;
    inline function getTriangles():Array<PxDebugTriangle>
    {
        var p:cpp.Pointer<PxDebugTriangle> = untyped __cpp__("{0}.getTriangles()", this);
        return p.toUnmanagedArray(getNbTriangles());
    }

	function getNbTexts():PxU32;
    inline function getTexts():Array<PxDebugText>
    {
        var p:cpp.Pointer<PxDebugText> = untyped __cpp__("{0}.getTexts()", this);
        return p.toUnmanagedArray(getNbTexts());
    }

	function append(other:PxRenderBuffer):Void;
	function clear():Void;
}