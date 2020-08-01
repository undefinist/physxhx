package;

import physx.extensions.PxDefaultStreams.PxDefaultFileInputData;
import physx.foundation.PxIO;
import physx.PxFiltering;
import physx.PxFoundation;
import physx.PxMaterial;
import physx.PxPhysics;
import physx.PxPhysicsVersion;
import physx.PxQueryReport;
import physx.PxRigidDynamic;
import physx.PxScene;
import physx.PxSceneDesc;
import physx.PxSimulationEventCallback;
import physx.common.PxTolerancesScale;
import physx.extensions.PxDefaultAllocator;
import physx.extensions.PxDefaultCpuDispatcher;
import physx.extensions.PxDefaultErrorCallback;
import physx.extensions.PxDefaultSimulationFilterShader;
import physx.extensions.PxRigidBodyExt;
import physx.extensions.PxSimpleFactory;
import physx.foundation.PxPlane;
import physx.foundation.PxQuat;
import physx.foundation.PxSimpleTypes;
import physx.foundation.PxTransform;
import physx.foundation.PxVec3;
import physx.geometry.PxBoxGeometry;
import physx.geometry.PxGeometry;
import physx.geometry.PxSphereGeometry;
import physx.pvd.PxPvd;
import physx.pvd.PxPvdTransport;

class Main
{
    static public function main()
    {
        trace("hello!!");
        var test:Test = new Test();
        test.initPhysics();
        trace("hello!!");
        for(i in 0...100)
        {
            test.stepPhysics();
        }
        trace("hello!!");
        test.cleanupPhysics();
        trace("hello!!");
    }
}

class SimulationCallback extends PxSimulationEventCallbackHx
{
    public function new() { super(); }
    override function onContact(pairHeader:PxContactPairHeader, pairs:haxe.ds.Vector<PxContactPair>)
    {
        if(pairHeader.actor0.getName() == "Ball")
            trace(pairHeader.actor0.userData.rawInt);
        else if(pairHeader.actor1.getName() == "Ball")
            trace(pairHeader.actor1.userData.rawInt);
    }
}

class Test
{
    static var gFoundation:PxFoundation;
    static var gPhysics:PxPhysics;
    static var gPvd:PxPvd;
    static var gMaterial:PxMaterial;
    static var gScene:PxScene;
    static var gDispatcher:PxDefaultCpuDispatcher;
    static var gErrorCallback:PxDefaultErrorCallback = null;
    static var gAllocator:PxDefaultAllocator = null;
    static var gSimulationCallback:SimulationCallback = new SimulationCallback();

    @:unreflective
    static function contactReportFilterShader(attributes0:PxFilterObjectAttributes, filterData0:PxFilterData, 
        attributes1:PxFilterObjectAttributes, filterData1:PxFilterData,
        pairFlags:cpp.Reference<PxPairFlags>, constantBlock:cpp.ConstStar<cpp.Void>, constantBlockSize:PxU32):PxFilterFlags
    {
        // all initial and persisting reports for everything, with per-point data
        pairFlags = PxPairFlag.eSOLVE_CONTACT
            | PxPairFlag.eDETECT_DISCRETE_CONTACT
            | PxPairFlag.eNOTIFY_TOUCH_FOUND 
            | PxPairFlag.eNOTIFY_TOUCH_PERSISTS
            | PxPairFlag.eNOTIFY_CONTACT_POINTS;

        return PxFilterFlag.eDEFAULT;
    }

    public function new() {}

    function createDynamic(t:PxTransform, geometry:PxGeometry, velocity:PxVec3):PxRigidDynamic
    {
        var dyn = PxSimpleFactory.createDynamic(gPhysics, t, geometry, gMaterial, 10);
        dyn.setAngularDamping(0.5);
        dyn.setLinearVelocity(velocity);
        dyn.setName("Ball");
        dyn.userData.rawInt = 42; // see physx.hx.PxUserData

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
        var transport = PxPvdTransport.defaultPvdSocketTransportCreate("localhost", 5425, 10);
        gPvd.connect(transport, eALL);
    
        gPhysics = PxPhysics.create(PX_PHYSICS_VERSION, gFoundation, new PxTolerancesScale(), true, gPvd);
    
        var sceneDesc = new PxSceneDesc(gPhysics.getTolerancesScale());
        sceneDesc.gravity = new PxVec3(0, -9.81, 0);

        gDispatcher = PxDefaultCpuDispatcher.create(4);
        sceneDesc.cpuDispatcher	= gDispatcher;
        //sceneDesc.filterShader = PxDefaultSimulationFilterShader.func;
        sceneDesc.filterShader = cpp.Callable.fromStaticFunction(contactReportFilterShader);
        sceneDesc.simulationEventCallback = gSimulationCallback;
        
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

        // Raycast should hit Ball
        var buf = new PxRaycastBuffer();
        if(gScene.raycast(new PxVec3(0, 40, 0), new PxVec3(0, 0, 1), 200, buf))
        {
            trace("Raycast hit: " + buf.block.actor.getName());
        }
    }

    public function stepPhysics()
    {
        gScene.simulate(1.0 / 60.0);
        trace("step!!");
        gScene.fetchResults(true);
        trace("fetch!!");
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
        gSimulationCallback = null;
        cpp.vm.Gc.run(true); // should call gSimulationCallback._release
    }
}