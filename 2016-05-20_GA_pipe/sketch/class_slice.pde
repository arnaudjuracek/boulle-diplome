public class Slice{

	private Vec3D[] vertices;
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
		Vec3D[] vertices = new Vec3D[this.getSidesLength()];

		for(float theta=0, i=0; theta<TWO_PI; theta+=TWO_PI/vertices.length){
			float x = cos(theta)*radius, y = sin(theta)*radius;
			Vec3D v = new Vec3D(x, y, 0);
				v = this.getMatrix().applyTo(v);
				v = v.addSelf(this.getPosition());
			vertices[(int) i++] = v;
		}

		return this.setVertices(vertices);
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
	public Vec3D[] getVertices(){ return this.vertices; }
	public Vec3D getVertex(int index){ return this.vertices[index]; }

	public int getSidesLength(){ return this.sidesLength; }
	public float getRadius(){ return this.radius; }

	public Matrix4x4 getMatrix(){ return this.matrix; }
	public Vec3D getPosition(){ return this.position; }
}