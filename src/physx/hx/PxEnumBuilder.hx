package physx.hx;

import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;

class PxEnumBuilder
{
    public static macro function build(scope:String):Array<Field>
    {
        var fields = Context.getBuildFields();

        for (f in fields)
        {
            switch(f.kind)
            {
                case FVar(t, e):
                    if(e != null)
                    {
                        f.doc = '= `${e.toString()}`\n\n' + (f.doc == null ? "" : f.doc);
                        f.kind = FVar(t);
                    }
                default:
            }
            f.meta.push({ name: ":native", params: [ macro $v{scope + "::" + f.name } ], pos: Context.currentPos() });
        }

        return fields;
    }

    public static macro function buildFlags(scope:String, type:ExprOf<Class<Int>>):Array<Field>
    {
        var pos = Context.currentPos();
        var fields = Context.getBuildFields();

        for (f in fields)
        {
            switch(f.kind)
            {
                case FVar(t, e):
                    if(e != null)
                    {
                        f.doc = '= `${e.toString()}`\n\n' + (f.doc == null ? "" : f.doc);
                        f.kind = FVar(t);
                    }
                default:
            }
            f.meta.push({ name: ":native", params: [ macro $v{scope + "::" + f.name } ], pos: pos });
        }

        var ctFlags = switch (Context.getLocalClass().get().kind)
        {
            case KAbstractImpl(a): Context.getType(a.toString()).toComplexType();
            default: null;
        }
        if(ctFlags == null)
            Context.error("Must be abstract.", pos);

        var ctIntegral:ComplexType = Context.getType(type.toString()).toComplexType();

        // @:op(A | B)
        // inline function or(flag:Flag):Flag
        // {
        //     return untyped __cpp__("{0} | {1}", this, flag);
        // }
        var opBitwiseOr:Function = {
            expr: macro return untyped __cpp__("{0} | {1}", this, flag),
            args: [ { name: "flag", type: ctFlags } ],
            ret: ctFlags
        };
        fields.push({
            name: "or",
            pos: pos,
            kind: FFun(opBitwiseOr),
            meta: [ { name: ":op", params: [ macro A | B ], pos: pos } ],
            access: [ AInline ]
        });

        // @:from static inline function from(value:Integral):Flag { return cast value; }
        var from:Function = {
            expr: macro return cast value,
            args: [ { name: "value", type: ctIntegral } ],
            ret: ctFlags
        };
        fields.push({
            name: "from",
            pos: pos,
            kind: FFun(from),
            meta: [ { name: ":from", pos: pos } ],
            access: [ AStatic, AInline ]
        });

        // @:to inline function to():Integral { var ret:Integral = cast this; return ret; }
        // create a variable to cast to, so it can be casted to other integral types, as
        // PxFlags<Enum, IntegralType> can only be implicitly casted to IntegralType
        var to:Function = {
            expr: macro { var ret:$ctIntegral = cast this; return ret; },
            args: [],
            ret: ctIntegral
        };
        fields.push({
            name: "to",
            pos: pos,
            kind: FFun(to),
            meta: [ { name: ":to", pos: pos } ],
            access: [ AInline ]
        });

        return fields;
    }
}