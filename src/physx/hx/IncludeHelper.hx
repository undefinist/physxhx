package physx.hx;

#if !macro

@:include("foundation/Px.h")
@:noCompletion @:noDoc extern interface IncludePx {}

@:genericBuild(physx.hx.IncludeHelper.IncludeHelperBuilder.build())
extern interface IncludeHelper<@:const T:String>
{   
}

#else

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
using StringTools;

class IncludeHelperBuilder
{
    public static function build()
    {
        var includeExpr:Expr = switch (Context.getLocalType())
        {
            case TInst(_, [ TInst(_.get().kind => KExpr(e), _) ]): e;
            default: null;
        }
        var include:String = haxe.macro.ExprTools.getValue(includeExpr);

        var className = "IncludeHelper_" + include.replace(".", "_").replace("/", "_").replace("\\", "_");

        try
        {
            return Context.toComplexType(Context.getType(className));
        }
        catch(e:String) 
        {
        }

        var c = macro interface $className {};
        c.isExtern = true;
        c.meta.push({ name: ":include", params: [ includeExpr ], pos: Context.currentPos() });

        Context.defineType(c);
        return Context.toComplexType(Context.getType(className));
    }
}

#end