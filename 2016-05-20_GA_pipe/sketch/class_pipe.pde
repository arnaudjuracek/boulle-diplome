import toxi.geom.*;
import toxi.geom.mesh.*;

public class Pipe{
	public final int
		U_RESOLUTION = 10,
		V_RESOLUTION = 50;

	private Path path;
	private Curve radiuses, sides;
	private TriangleMesh mesh;
	private AABB aabb;

	// -------------------------------------------------------------------------
	public Pipe(Path path, Curve radiuses, Curve sides){
		this.path = path.interpolatePath(V_RESOLUTION+1).smooth(path.getSmoothCoef());
		this.radiuses = radiuses.interpolate(V_RESOLUTION).smooth(radiuses.getSmoothCoef());
		this.sides = sides.interpolate(V_RESOLUTION).smooth(sides.getSmoothCoef());

		this.setMesh( this.triangulate( this.slicer(V_RESOLUTION), true ) );
	}



	// -------------------------------------------------------------------------
	// GENERATORS
	private Slice[] slicer(int n){
		Vec3D[] path = this.getPath().getPoints();
		Slice[] slices = new Slice[n];


		// slice once at the begining of each segment of the path
		for(int i=0; i<path.length-1; i++){
			Vec3D a = path[i], b = path[i+1];

			// create the slice,
			// turn it to face the direction of the current segment
			// and move it to its right interpolate position
			Slice s = new Slice(this.getRadius(i), int(this.getSideLength(i)));
				s.lookAt(a, b);
				s.moveTo(a);

			slices[i] = s.computeVertices().interpolateVertices(U_RESOLUTION);

		}

		return slices;
	}

	private TriangleMesh triangulate(Slice[] slices, boolean... closeEnds){
		TriangleMesh mesh = new TriangleMesh();

		// DEBUG / TEST RANDOM DISPLACEMENT
		// for(int i=0; i<slices.length; i++){
		// 	for(int j=1; j<slices[i].getVertices().length-1; j++){
		// 		slices[i].getVertex(j).jitter(5);
		// 	}
		// }

		for(int u=0; u<U_RESOLUTION-1; u++){
			for(int v=0; v<slices.length-1; v++){
				Vec3D
					a = slices[v].getVertex(u),
					b = slices[v].getVertex((u+1)%(U_RESOLUTION-1)),
					c = slices[v+1].getVertex((u+1)%(U_RESOLUTION-1)),
					d = slices[v+1].getVertex(u);
				Vec2D
					uvA = new Vec2D(norm(u, 0, U_RESOLUTION), norm(v, 0, slices.length)),
					uvB = new Vec2D(norm(u+1, 0, U_RESOLUTION), norm(v, 0, slices.length)),
					uvC = new Vec2D(norm(u+1, 0, U_RESOLUTION), norm(v+1, 0, slices.length)),
					uvD = new Vec2D(norm(u, 0, U_RESOLUTION), norm(v+1, 0, slices.length));

				mesh.addFace(a, b, c, uvA, uvB, uvC);
				mesh.addFace(c, d, a, uvC, uvD, uvA);
			}
		}

		if(closeEnds.length>0 && closeEnds[0]){
			Slice a = slices[0];
			for(int i=U_RESOLUTION-2; i>=0; i--) mesh.addFace(a.getPosition(), a.getVertex((i+1)%(U_RESOLUTION-1)), a.getVertex(i), new Vec2D(), new Vec2D(), new Vec2D());

			Slice b = slices[slices.length-1];
			for(int i=0; i<U_RESOLUTION-1; i++) mesh.addFace(b.getPosition(), b.getVertex(i), b.getVertex((i+1)%(U_RESOLUTION-1)), new Vec2D(), new Vec2D(), new Vec2D());
		}

		mesh.computeFaceNormals();
		mesh.computeVertexNormals();

		return mesh;
	}

	private TriangleMesh morphTo(TriangleMesh b, float t){
		TriangleMesh a = this.getMesh().copy();

		for(int i=0; i<a.getFaces().size()-1; i++){
			Face fa = a.faces.get(i), fb = b.faces.get(i);
			fa.a.interpolateToSelf(fb.a, t);
			fa.b.interpolateToSelf(fb.b, t);
			fa.c.interpolateToSelf(fb.c, t);
		}

		a.computeFaceNormals();
		a.computeVertexNormals();

		return a;
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Pipe setPath(Path path){ this.path = path; return this; }
	public Pipe setMesh(TriangleMesh mesh){ this.mesh = mesh; return this; }


	// -------------------------------------------------------------------------
	// GETTERS
	public Path getPath(){ return this.path; }

	public Curve getRadiusesCurve(){ return this.radiuses; }
	public float[] getRadiuses(){ return this.radiuses.getValues(); }
	public float getRadius(int index){ return this.radiuses.getValue(index); }

	public Curve getSidesLengthCurve(){ return this.sides; }
	public float[] getSidesLength(){ return this.sides.getValues(); }
	public float getSideLength(int index){ return this.sides.getValue(index); }

	public TriangleMesh getMesh(){ return this.mesh; }
	public AABB getAABB(){
		if(this.aabb==null) this.aabb = this.getMesh().getBoundingBox();
		return this.aabb;
	}

}