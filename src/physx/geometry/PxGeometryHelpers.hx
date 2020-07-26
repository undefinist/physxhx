package physx.geometry;

import physx.geometry.PxGeometry;

@:include("PxGeometryHelpers.h")
@:native("physx::PxGeometryHolder")
extern class PxGeometryHolder
{
    public function getType():PxGeometryType;
    public function any():PxGeometry;
    public function sphere():PxSphereGeometry;
    public function plane():PxPlaneGeometry;
    public function capsule():PxCapsuleGeometry;
    public function box():PxBoxGeometry;
    public function convexMesh():PxConvexMeshGeometry;
    public function triangleMesh():PxTriangleMeshGeometry;
    public function heightField():PxHeightFieldGeometry;
    public function storeAny(geometry:PxGeometry):Void;
}