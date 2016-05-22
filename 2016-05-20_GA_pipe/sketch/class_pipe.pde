import toxi.geom.*;
import toxi.geom.mesh.*;

public class Pipe{
	public final int MAX_SIDES_LENGTH = 40;

	private Path path;
	private float[] radiuses;
	private TriangleMesh mesh;

	// -------------------------------------------------------------------------
	public Pipe(Path path, Curve radiuses, int n_slices){
		this.path = path;

		this.radiuses = radiuses
							.interpolate(n_slices)
							.smooth(0.3)
							.getValues();

		this.setMesh(
			this.triangulate(
				this.slicer(n_slices),
				true
			)
		);
	}



	// -------------------------------------------------------------------------
	// GENERATORS
	private Slice[] slicer(int n){
		Vec3D[] path = this.getPath().interpolatePath(n+1).getPoints();
		Slice[] slices = new Slice[n];


		// slice once at the begining of each segment of the path
		for(int i=0; i<path.length-1; i++){
			Vec3D a = path[i], b = path[i+1];

			// create the slice,
			// turn it to face the direction of the current segment
			// and move it to its right interpolate position
			Slice s = new Slice(this.getRadius(i), 100);
				s.lookAt(a, b);
				s.moveTo(a);

			slices[i] = s.computeVertices().interpolateVertices(MAX_SIDES_LENGTH);

		}

		return slices;
	}

	private TriangleMesh triangulate(Slice[] slices, boolean... closeEnds){
		TriangleMesh mesh = new TriangleMesh();

		// DEBUG / TEST RANDOM DISPLACEMENT
		// for(int i=0; i<slices.length; i++){
		// 	for(int j=1; j<slices[i].getVertices().length-1; j++){
		// 		slices[i].getVertex(j).jitter(10);
		// 	}
		// }

		for(int u=0; u<MAX_SIDES_LENGTH-1; u++){
			for(int v=0; v<slices.length-1; v++){
				Vec3D
					a = slices[v].getVertex(u),
					b = slices[v].getVertex((u+1)%(MAX_SIDES_LENGTH-1)),
					c = slices[v+1].getVertex((u+1)%(MAX_SIDES_LENGTH-1)),
					d = slices[v+1].getVertex(u);
				Vec2D
					uvA = new Vec2D(norm(u, 0, MAX_SIDES_LENGTH), norm(v, 0, slices.length)),
					uvB = new Vec2D(norm(u+1, 0, MAX_SIDES_LENGTH), norm(v, 0, slices.length)),
					uvC = new Vec2D(norm(u+1, 0, MAX_SIDES_LENGTH), norm(v+1, 0, slices.length)),
					uvD = new Vec2D(norm(u, 0, MAX_SIDES_LENGTH), norm(v+1, 0, slices.length));

				mesh.addFace(a, b, c, uvA, uvB, uvC);
				mesh.addFace(c, d, a, uvC, uvD, uvA);
			}
		}

		if(closeEnds.length>0 && closeEnds[0]){
			for(Slice end : new Slice[]{slices[0], slices[slices.length-1]}){
				Vec3D center = end.getPosition();
				for(int i=0; i<end.getVertices().length-1; i++){
					mesh.addFace(center, end.getVertex(i), end.getVertex(i+1), new Vec2D(), new Vec2D(), new Vec2D());
				}
			}
		}


		mesh.computeFaceNormals();
		mesh.computeVertexNormals();

		return mesh;
	}



	// -------------------------------------------------------------------------
	// DATA MANIPULATION



	// -------------------------------------------------------------------------
	// SETTERS
	public Pipe setPath(Path path){ this.path = path; return this; }
	public Pipe setMesh(TriangleMesh mesh){ this.mesh = mesh; return this; }
	public Pipe setRadiuses(float[] radiuses){ this.radiuses = radiuses; return this; }


	// -------------------------------------------------------------------------
	// GETTERS
	public Path getPath(){ return this.path; }

	public float[] getRadiuses(){ return this.radiuses; }
	public float getRadius(int index){ return this.radiuses[index]; }

	public TriangleMesh getMesh(){ return this.mesh; }

}