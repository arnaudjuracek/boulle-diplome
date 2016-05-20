public class Pipe{

	private Vec3D[] path;
	private PShape pshape;

	int DEBUG_N_SIDES = 40;
	int DEBUG_RADIUS = 200;

	// -------------------------------------------------------------------------
	public Pipe(Vec3D[] path, int n_slices){
		this.path = path;

		Slice[] slices = this.slicer(n_slices);
		this.setPShape(this.triangulate(slices));
	}



	// -------------------------------------------------------------------------
	// GENERATORS
	private Slice[] slicer(int n){
		ArrayList<Slice> slices = new ArrayList<Slice>();
		Vec3D[] path = this.getPath();

		float step = 1/float(n/path.length);
		println(n);
		println(step);



		// slice once at the begining of each segment of the path
		for(int index=0, i=0; i<path.length-1; i++){
			Vec3D a = path[i], b = path[i+1];

			// slice each segment
			for(float t=0; t<1; t+=step){
				// create the slice,
				// turn it to face the direction of the current segment
				// and move it to its right interpolate position
				Slice s = new Slice(random(DEBUG_RADIUS), DEBUG_N_SIDES);
					s.lookAt(a.interpolateTo(b, t), b);
					s.moveTo(a.interpolateTo(b, t));

				slices.add(s.computeVertices());
			}

		}

		return slices.toArray(new Slice[slices.size()]);
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
	// SETTERS
	public Pipe setPath(Vec3D[] path){this.path = path; return this; }
	public Pipe setPShape(PShape shape){this.pshape = shape; return this; }



	// -------------------------------------------------------------------------
	// GETTERS
	public Vec3D[] getPath(){ return this.path; }

	public TriangleMesh getMesh(){ return null; }
	public PShape getPShape(){ return this.pshape; }

}