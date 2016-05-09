public class Node{

	private Tree PARENT;
	private Vec3D ORIGIN;
	private Obj OBJ;
	private ArrayList<Vec3D> CPOINTS;

	private TriangleMesh TOXIMESH;
	private PShape PSHAPE;

	private PVector ROTATION;
	private Vec3D CONTACT_POINT;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Node(Tree parent, Vec3D origin, Obj o){
		this.PARENT = parent;
		this.OBJ = o;

		// draw the Node from a contact point on its .obj
		this.ORIGIN = o.getRandomContactPoint();

		// rotation based on centroid of the .obj
		// allow really basic physic constraints
		// Vec3D direction = this.ORIGIN.interpolateTo(this.OBJ.getToxiMesh().computeCentroid(), -1);
		// this.ROTATION = new PVector(
		// 	0,
		// 	direction.add(this.ORIGIN).toSpherical().y,
		// 	direction.add(this.ORIGIN).toSpherical().z
		// ).add(PVector.random3D().setMag(radians(90)));

		// random rotation
		this.ROTATION = PVector.random3D().setMag(radians(180));

		// random rotation modulo 90 degrees
		// this.ROTATION = new PVector(radians(int(random(4))*90), radians(int(random(4))*90), radians(int(random(4))*90));


		this.CPOINTS = new ArrayList<Vec3D>();
		for(Vec3D objContactPoint : o.getContactPoints()){
			Vec3D nodeContactPoint =
				new Vec3D(objContactPoint)
					.add(this.ORIGIN)
					.rotateX(-this.getRotation().x)
					.rotateY(-this.getRotation().y)
					.rotateZ(+this.getRotation().z)
					.addSelf(origin);

			this.CPOINTS.add(nodeContactPoint);
			if(!this.PARENT.CPOINTS.contains(nodeContactPoint)) this.PARENT.CPOINTS.add(nodeContactPoint);
		}


		this.TOXIMESH = this.OBJ.getToxiMesh().copy()
			.translate(this.ORIGIN)
			.rotateX(this.getRotation().x)
			.rotateY(this.getRotation().y)
			.rotateZ(this.getRotation().z)
			.translate(origin);
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Obj getObj(){ return this.OBJ; }
	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public PShape getPShape(){
		if(this.PSHAPE==null) this.PSHAPE = new Converter().toxiToPShape(this.getToxiMesh());
		return this.PSHAPE;
	}

	public PVector getRotation(){ return this.ROTATION; }
	public Vec3D getOrigin(){ return this.ORIGIN; }

	public ArrayList<Vec3D> getContactPoints(){ return this.CPOINTS; }
	public Vec3D getContactPoint(int index){ return this.CPOINTS.get(index); }
	public Vec3D getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public Vec3D getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public Vec3D getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }

}