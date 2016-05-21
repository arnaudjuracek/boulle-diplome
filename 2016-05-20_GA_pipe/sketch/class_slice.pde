public class Slice{

	private Vec3D[] vertices, original_vertices;
	private Vec3D position;
	private Matrix4x4 matrix;
	private int sidesLength;
	private float radius;

	// -------------------------------------------------------------------------
	public Slice(float radius, int n_sides){
		this.matrix = new Matrix4x4();
		this.position = new Vec3D();
		this.sidesLength = n_sides;
		this.radius = radius;
	}



	// -------------------------------------------------------------------------
	// MATRIX MANIPULATION
	public Slice moveTo(Vec3D v){ this.setPosition(v); return this; }

	public Slice lookAt(Vec3D from, Vec3D to){
		// @see http://stackoverflow.com/questions/23692077/rotate-object-to-face-point
		Vec3D distance = from.sub(to);
		if(distance.magnitude() > EPSILON){
			Vec3D directionA = new Vec3D(0, 0, 1).normalize();
			Vec3D directionB = distance.copy().normalize();
			float rotationAngle = (float) Math.acos(directionA.dot(directionB));
			if(Math.abs(rotationAngle) > EPSILON){
				Vec3D rotationAxis = directionA.copy().cross(directionB).normalize();
				this.setMatrix(Quaternion.createFromAxisAngle(rotationAxis, rotationAngle).toMatrix4x4());
			}
		}
		return this;
	}



	// -------------------------------------------------------------------------
	// VERTICES COMPUTATION
	public Slice computeVertices(){
		ArrayList<Vec3D> vertices = new ArrayList<Vec3D>(this.getSidesLength());

		for(float theta=0, i=0; theta<TWO_PI+(TWO_PI/this.getSidesLength()); theta+=TWO_PI/this.getSidesLength()){
			float x = cos(theta)*radius, y = sin(theta)*radius;
			Vec3D v = new Vec3D(x, y, 0);
				v = this.getMatrix().applyTo(v);
				v = v.addSelf(this.getPosition());
			vertices.add(v);
		}

		this.original_vertices = vertices.toArray(new Vec3D[vertices.size()]);
		return this.setVertices(this.original_vertices);
	}

	public Slice interpolateVertices(int n){
		// create an array of 3 curves for each Vec3D components
		Curve[] curve = new Curve[3];

		Vec3D[] vertices = this.getOriginalVertices();
		float[][] curves_values = new float[curve.length][vertices.length];
		for(int i=0; i<vertices.length; i++){
			Vec3D v = vertices[i];
			curves_values[0][i] = v.x;
			curves_values[1][i] = v.y;
			curves_values[2][i] = v.z;
		}

		for(int i=0; i<curve.length; i++){
			curve[i] = new Curve(curves_values[i]);
			curve[i].interpolate(n);
		}

		Vec3D[] interpolated_vertices = new Vec3D[curve[0].size()];
		for(int i=0; i<interpolated_vertices.length; i++){
			interpolated_vertices[i] = new Vec3D(curve[0].getValue(i), curve[1].getValue(i), curve[2].getValue(i));
		}

		return this.setVertices(interpolated_vertices);
	}


	// -------------------------------------------------------------------------
	// SETTERS
	public Slice setVertices(Vec3D[] vertices){ this.vertices = vertices; return this; }
	public Slice setMatrix(Matrix4x4 matrix){ this.matrix = matrix; return this; }
	public Slice setPosition(Vec3D v){ this.position = v; return this; }
	public Slice setSidesLength(int l){ this.sidesLength = l; return this; }
	public Slice setRadius(float r){ this.radius = r; return this; }

	// -------------------------------------------------------------------------
	// GETTERS
	public Vec3D[] getOriginalVertices(){ return this.original_vertices; }

	public Vec3D[] getVertices(){ return this.vertices; }
	public Vec3D getVertex(int index){ return this.vertices[index]; }

	public int getSidesLength(){ return this.sidesLength; }
	public float getRadius(){ return this.radius; }

	public Matrix4x4 getMatrix(){ return this.matrix; }
	public Vec3D getPosition(){ return this.position; }
}