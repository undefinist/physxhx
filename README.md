# physxhx

Haxe/hxcpp @:native bindings for [PhysX](https://github.com/NVIDIAGameWorks/PhysX).

This is a [linc](http://snowkit.github.io/linc/) & [Kha](https://github.com/Kode/Kha) library.

---

This library works with the Haxe cpp target only.

---

### Notes

This library was written with the following in mind:
- Write bindings in a way that allow natural Haxe expressions.
  - e.g. Using `new ExternClass` instead of `ExternClass.create` wherever possible & sensible.
  - As well as operator overloads for mathematical structures such as `PxVec3` and `PxQuat`.
- Maintain original physx folder layout and documentation wherever possible & sensible.
  - To aid in development and not have to keep the docs open all the time.
- To do this we have to write the bindings *manually*.

Other features include:
- Callbacks implemented as a base class in Haxe to extend, to write the behavior in Haxe.
  - The class names are typically postfixed with `Hx`.
  - E.g. `PxSimulationEventCallback` => `PxSimulationEventCallbackHx`:
    ```haxe
    class SimulationCallback extends PxSimulationEventCallbackHx
    {
        public function new() { super(); }
        override function onContact(pairHeader:PxContactPairHeader, pairs:haxe.ds.Vector<PxContactPair>)
        {
            // do stuff...
        }
    }
    ```
- `PxUserData` as a helpful facilitation for `void* userData` between Haxe and C++.
  - Convenience for pointing to haxe object, or reinterpreting `void*` as `int` or `const char*`: 
    ```haxe
    var anyObj:String = "stringObj";
    actor.userData = anyObj; // stores pointer to anyObj
    var str:String = actor.userData; // get what userData points to, as a String
    anyObj = "changedString";
    trace(x); // prints stringObj
    trace((actor.userData:String)); // prints changedString

    var anyObj:Int = 123;
    actor.userData.rawInt = anyObj; // store 123 in userData. This simply treats the void* as int
    anyObj = 456;
    trace(actor.userData.rawInt); // still prints 123.

    actor.userData.stringLiteral = "Player"; // store "Player" as a const char*
    trace(actor.userData.stringLiteral); // prints Player

    actor.userData.stringLiteral = str; // not recommended. Stores internal data of str, which may get GC'ed and data overwritten
    str = "modifiedString";
    trace(actor.userData.stringLiteral); // still prints stringObj
    ```
- Multithreading (asynchronous simulation etc.) in `PxDefaultCpuDispatcher` implemented for hxcpp.
  - For foreign threads to cooperate with Haxe, we have to attach/detach to/from Haxe GC.
  - See modification of [ExtCpuWorkerThread](https://github.com/NVIDIAGameWorks/PhysX/blob/4.1/physx/source/physxextensions/src/ExtCpuWorkerThread.cpp) => [ExtCpuWorkerThreadHx](src/linc/include/ExtCpuWorkerThreadHx.cpp).

### Usage

See [test/Main.hx](test/Main.hx). Build with `build.hxml` with cwd in `test/`.

Install [PhysX Visual Debugger](https://developer.nvidia.com/physx-visual-debugger).
Run the PVD, then run the test and it should automatically connect to the PVD.

Also see the [PhysX 4.1 User Guide](https://gameworksdocs.nvidia.com/PhysX/4.1/documentation/physxguide/Index.html) and [PhysX 4.1 API Documentation](https://gameworksdocs.nvidia.com/PhysX/4.1/documentation/physxapi/files/index.html).

#### Using for Kha

To use physxhx as a Kha library, simply add the library and dlls (which need to exist beside the output exe), by adding to your khafile.js:
```js
if(platform == Platform.Windows)
{
    let dir = project.addLibrary('physxhx');
    project.addAssets(dir + '/lib/Windows/dll/**', { destination: '', notinlist: true });
}
```

#### Example Code

The following code is adapted from [SnippetHelloWorld.cpp](https://github.com/NVIDIAGameWorks/PhysX/blob/4.1/physx/snippets/snippethelloworld/SnippetHelloWorld.cpp):
```haxe
class Main
{
    static public function main()
    {
        var test:Test = new Test();
        test.initPhysics();
        for(i in 0...100)
            test.stepPhysics();
        test.cleanupPhysics();
    }
}

class Test
{
    var gFoundation:PxFoundation;
    var gPhysics:PxPhysics;
    var gPvd:PxPvd;
    var gMaterial:PxMaterial;
    var gScene:PxScene;
    var gDispatcher:PxDefaultCpuDispatcher;
    static var gErrorCallback:PxDefaultErrorCallback = null;
    static var gAllocator:PxDefaultAllocator = null;

    public function new() {}

    function createDynamic(t:PxTransform, geometry:PxGeometry, velocity:PxVec3):PxRigidDynamic
    {
        var dyn = PxSimpleFactory.createDynamic(gPhysics, t, geometry, gMaterial, 10);
        dyn.setAngularDamping(0.5);
        dyn.setLinearVelocity(velocity);
        gScene.addActor(dyn);
        return dyn;
    }

    function createStack(t:PxTransform, size:PxU32, halfExtent:PxReal)
    {
        var shape = gPhysics.createShape(PxBoxGeometry.create(halfExtent, halfExtent, halfExtent), gMaterial);
        for(i in 0...size)
        {
            for(j in 0...size-i)
            {
                var localTm = new PxTransform(new PxVec3(j * 2 - (size - i), i * 2 + 1, 0) * halfExtent, PxQuat.identity());
                var body = gPhysics.createRigidDynamic(t.transform(localTm));
                body.attachShape(shape);
                PxRigidBodyExt.updateMassAndInertia(body, 10);
                gScene.addActor(body);
            }
        }
        shape.release();
    }

    public function initPhysics()
    {
        gFoundation = PxFoundation.create(PX_PHYSICS_VERSION, gAllocator, gErrorCallback);

        gPvd = PxPvd.create(gFoundation);
        var transport = PxPvdTransport.defaultPvdSocketTransportCreate("127.0.0.1", 5425, 10);
        gPvd.connect(transport, eALL);
    
        gPhysics = PxPhysics.create(PX_PHYSICS_VERSION, gFoundation, new PxTolerancesScale(), true, gPvd);
    
        var sceneDesc = new PxSceneDesc(gPhysics.getTolerancesScale());
        sceneDesc.gravity = new PxVec3(0, -9.81, 0);

        gDispatcher = PxDefaultCpuDispatcher.create(4);
        sceneDesc.cpuDispatcher	= gDispatcher;
        sceneDesc.filterShader = PxDefaultSimulationFilterShader.func;
        
        gScene = gPhysics.createScene(sceneDesc);
    
        var pvdClient = gScene.getScenePvdClient();
        if(pvdClient != null)
        {
            pvdClient.setScenePvdFlag(eTRANSMIT_CONSTRAINTS, true);
            pvdClient.setScenePvdFlag(eTRANSMIT_CONTACTS, true);
            pvdClient.setScenePvdFlag(eTRANSMIT_SCENEQUERIES, true);
        }
        gMaterial = gPhysics.createMaterial(0.5, 0.5, 0.6);

        var groundPlane = PxSimpleFactory.createPlane(gPhysics, new PxPlane(0, 1, 0, 0), gMaterial);
        gScene.addActor(groundPlane);
        
        var stackZ = 10.0;
        for(i in 0...5)
        {
            stackZ -= 10.0;
            createStack(new PxTransform(new PxVec3(0, 0, stackZ), PxQuat.identity()), 10, 2.0);
        }
        
        createDynamic(new PxTransform(new PxVec3(0,40,100), PxQuat.identity()), new PxSphereGeometry(10), new PxVec3(0,-50,-100));
    }

    public function stepPhysics()
    {
        gScene.simulate(1.0 / 60.0);
        gScene.fetchResults(true);
    }

    public function cleanupPhysics()
    {
        gScene.release();
        gDispatcher.release();
        gPhysics.release();
        if(gPvd != null)
        {
            var transport = gPvd.getTransport();
            gPvd.release();
            transport.release();
        }
        gFoundation.release();
    }
}
```

### Precompiled libs and dlls

Currently there are only Windows libs and dlls included. They are compiled on a Windows x64 machine, in Visual Studio 2019.

As per [build guidelines](https://gameworksdocs.nvidia.com/PhysX/4.1/documentation/physxguide/Manual/BuildingWithPhysX.html) they are compiled with the **checked** build configuration which is recommended for day-to-day development and QA. If you need other build configs (e.g. release), please build them yourself. See the linked page for a guide.

### Contributions

Please note that this is my first hxcpp binding project, as well as my first time using PhysX. Therefore there may be things I've mishandled and not taken into account. Furthermore, PhysX is a gigantic project to bind and so there are bound to be many things not done. Still, I hope I've covered the bases. That said, contributions and PRs are highly welcome!

### Alternatives

physxhx was written for a [still very wip 3d engine](https://github.com/undefinist/kappa) I've been working on.

Alternatives for 3d physics:
- [OimoPhysics](https://github.com/saharan/OimoPhysics)
- [haxebullet](https://github.com/armory3d/haxebullet)

### License

The Haxe code is licensed under the MIT License. The headers and minor source modifications still have the original license intact.