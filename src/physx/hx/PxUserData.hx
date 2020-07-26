package physx.hx;

/**
 * Convenience class to handle userdata in physx.
 * 
 * Usage:
 * ```haxe
 * var anyObj:String = "stringObj";
 * actor.userData = anyObj; // stores pointer to anyObj
 * var str:String = actor.userData; // get what userData points to, as a String
 * anyObj = "changedString";
 * trace(x); // prints stringObj
 * trace((actor.userData:String)); // prints changedString
 * 
 * var anyObj:Int = 123;
 * actor.userData.rawInt = anyObj; // store 123 in userData. This simply treats the void* as int
 * anyObj = 456;
 * trace(actor.userData.rawInt); // still prints 123.
 * 
 * actor.userData.stringLiteral = "Player"; // store "Player" as a const char*
 * trace(actor.userData.stringLiteral); // prints Player
 * 
 * actor.userData.stringLiteral = str; // not recommended. Stores internal data of str, which may get GC'ed and data overwritten
 * str = "modifiedString";
 * trace(actor.userData.stringLiteral); // still prints stringObj
 * ```
 */
extern abstract PxUserData(cpp.Star<cpp.Void>)
{
    /**
     * Treat this as a raw integer. See `PxUserData` documentation for more info.
     */
    var rawInt(get, set):Int;
    private inline function get_rawInt():Int 
    {
        var self:cpp.Reference<cpp.Star<cpp.Void>> = this;
        return untyped __cpp__("reinterpret_cast<int&>({0})", self);
    }
    private inline function set_rawInt(rawInt:Int):Int 
    {
        var self:cpp.Reference<cpp.Star<cpp.Void>> = this;
        return untyped __cpp__("reinterpret_cast<int&>({0}) = {1}", self, rawInt);
    }

    /**
     * Treat this as a string literal. You **should** set it to a string constant, or behavior is undefined!
     * See `PxUserData` documentation for more info.
     * 
     * e.g. `actor.userData.stringLiteral = "Player"`
     */
    var stringLiteral(get, set):cpp.ConstCharStar;
    private inline function get_stringLiteral():cpp.ConstCharStar 
    {
        return (cast this:cpp.ConstCharStar);
    }
    private inline function set_stringLiteral(stringLiteral:cpp.ConstCharStar):cpp.ConstCharStar
    {
        return (cast (this = (cast stringLiteral:cpp.Star<cpp.Void>)):cpp.ConstCharStar);
    }

    
    @:from static inline function from(obj:Dynamic):PxUserData
    {
        return cast cpp.Pointer.addressOf(obj);
    }
    @:to inline function to<T>():T
    {
        return (cpp.Pointer.fromStar(this).reinterpret():cpp.Pointer<T>).ref;
    }
}