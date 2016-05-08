public class Node{

	private Tree PARENT;
	private Vec3D ORIGIN;
	private Obj OBJ;
	private ArrayList<Vec3D> CPOINTS;
	private TriangleMesh TOXIMESH;

	private PVector ROTATION;
	private Vec3D CONTACT_POINT;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Node(Tree parent, Vec3D origin, Obj o){
		this.PARENT = parent;
		this.OBJ = o;

		// this.ROTATION = new PVector(
		// 	radians(random(360)),
		// 	radians(random(360)),
		// 	radians(random(360))
		// );

		this.ROTATION = new PVector(
			radians(int(random(4))*90),
			radians(int(random(4))*90),
			radians(int(random(4))*90)
		);

		this.ORIGIN = o.getRandomContactPoint();

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
	// MODIFIERS
	// public TriangleMesh rotate(Obj o){
	// 	o = (Obj) o.clone();
	// 	o.getToxiMesh()
	// 		.rotateX(this.getRotation().x)
	// 		.rotateY(this.getRotation().y)
	// 		.rotateZ(this.getRotation().z);


	// 	return o;
	// }


	// -------------------------------------------------------------------------
	// GETTER
	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public PVector getRotation(){ return this.ROTATION; }

	public ArrayList<Vec3D> getContactPoints(){ return this.CPOINTS; }
	public Vec3D getContactPoint(int index){ return this.CPOINTS.get(index); }
	public Vec3D getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public Vec3D getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public Vec3D getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }

}