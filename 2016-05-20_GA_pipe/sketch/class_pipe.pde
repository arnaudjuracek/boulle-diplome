public class Pipe{

	private Vec3D[] path, original_path;
	private PShape pshape;

	int DEBUG_N_SIDES = 40;
	int DEBUG_RADIUS = 200;

	// -------------------------------------------------------------------------
	public Pipe(Vec3D[] path, int n_slices){
		this.path = path;
		this.original_path = path;

		Slice[] slices = this.slicer(n_slices);
		this.setPShape(this.triangulate(slices));
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
			Slice s = new Slice(random(DEBUG_RADIUS), DEBUG_N_SIDES);
				s.lookAt(a, b);
				s.moveTo(a);

			slices[i] = s.computeVertices();

		}

		return slices;
	}

	private PShape triangulate(Slice[] slices){
		PShape shape = createShape(GROUP);

		for(int u=0; u<DEBUG_N_SIDES; u++){
			PShape child = createShape();
			child.beginShape(TRIANGLE_STRIP);
			for(int v=0; v<slices.length; v++){
				Vec3D b = slices[v].getVertex(u);
				Vec3D c = slices[v].getVertex((u+1)%DEBUG_N_SIDES);

				child.vertex(b.x, b.y, b.z);
				child.vertex(c.x, c.y, c.z);
			}

			child.endShape();
			shape.addChild(child);
		}
		return shape;
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
	public Pipe setPath(Vec3D[] path){this.path = path; return this; }
	public Pipe setPShape(PShape shape){this.pshape = shape; return this; }



	// -------------------------------------------------------------------------
	// GETTERS
	public Vec3D[] getPath(){ return this.path; }
	public Vec3D[] getOriginalPath(){ return this.original_path; }

	public TriangleMesh getMesh(){ return null; }
	public PShape getPShape(){ return this.pshape; }

}