public class Pipe{
	public final int MAX_SIDES_LENGTH = 40;

	private Vec3D[] path, original_path;
	private float[] radiuses;
	private TriangleMesh mesh;

	// -------------------------------------------------------------------------
	public Pipe(Vec3D[] path, Curve radiuses, int n_slices){
		this.path = path;
		this.original_path = path;

		this.radiuses = radiuses.interpolate(n_slices).smooth(0.3).getValues();

		Slice[] slices = this.slicer(n_slices);
		this.setMesh(this.triangulate(slices));
	}



	// -------------------------------------------------------------------------
	// GENERATORS
	private Slice[] slicer(int n){
		Vec3D[] path = this.interpolatePath(n+1);
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

	private TriangleMesh triangulate(Slice[] slices){
		TriangleMesh mesh = new TriangleMesh();

		for(int u=0; u<MAX_SIDES_LENGTH-1; u++){

			for(int v=0; v<slices.length-1; v++){

				Vec3D
					a = slices[v].getVertex(u),
					b = slices[v].getVertex(u+1),
					c = slices[v+1].getVertex(u+1),
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

		mesh.computeFaceNormals();
		mesh.computeVertexNormals();

		return mesh;
	}



	// -------------------------------------------------------------------------
	// DATA MANIPULATION
	public Vec3D[] interpolatePath(int resolution){
		// create an array of 3 curves for each Vec3D components
		Curve[] curve = new Curve[3];

		Vec3D[] path = this.getOriginalPath();
		float[][] curves_values = new float[curve.length][path.length];
		for(int i=0; i<path.length; i++){
			Vec3D v = path[i];
			curves_values[0][i] = v.x;
			curves_values[1][i] = v.y;
			curves_values[2][i] = v.z;
		}

		for(int i=0; i<curve.length; i++){
			curve[i] = new Curve(curves_values[i]);
			curve[i].interpolate(resolution);
		}

		Vec3D[] interpolated_path = new Vec3D[curve[0].size()];
		for(int i=0; i<interpolated_path.length; i++){
			interpolated_path[i] = new Vec3D(curve[0].getValue(i), curve[1].getValue(i), curve[2].getValue(i));
		}

		return interpolated_path;
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Pipe setPath(Vec3D[] path){ this.path = path; return this; }
	public Pipe setMesh(TriangleMesh mesh){ this.mesh = mesh; return this; }
	public Pipe setRadiuses(float[] radiuses){ this.radiuses = radiuses; return this; }


	// -------------------------------------------------------------------------
	// GETTERS
	public Vec3D[] getPath(){ return this.path; }
	public Vec3D[] getOriginalPath(){ return this.original_path; }

	public float[] getRadiuses(){ return this.radiuses; }
	public float getRadius(int index){ return this.radiuses[index]; }

	public TriangleMesh getMesh(){ return this.mesh; }

}