public class Node{

	private Tree PARENT;
	private Obj OBJ;
	private ArrayList<CPoint> CPOINTS;

	private CPoint ORIGIN;
	private Vec3D POSITION, ROTATION;
	private Matrix4x4 MATRIX;

	private TriangleMesh TOXIMESH;
	private PShape PSHAPE;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Node(Tree parent, CPoint sourceCPoint, Obj o){
		this.PARENT = parent;
		this.OBJ = o;

		// draw the Node from one of its OBJ's contact points
			this.ORIGIN = o.getRandomContactPoint();

		// compute the rotation of the Node based on its origin CPoint and the sourceCPoint
	 	// or create a new random rotation
			this.ROTATION = this.computeRotation(sourceCPoint);
			if(this.ROTATION == null) this.ROTATION = this.randomRotation(0);
			println(degrees(this.ROTATION.x)+", "+degrees(this.ROTATION.y)+", "+degrees(this.ROTATION.z));

		// create transformation matrix for this given state
			this.MATRIX = new Matrix4x4()
				.translate(sourceCPoint.getPosition())
				.rotateX(this.getRotation().x)
				.rotateY(this.getRotation().y)
				.rotateZ(this.getRotation().z)
				// .rotateAroundAxis(sourceCPoint.heading)
				.scale(1, 1, 1)
				.translate(-this.getPosition().x, -this.getPosition().y, -this.getPosition().z);

		// apply matrix to the Node's contactpoints, and register them in its parent Tree
			this.CPOINTS = this.registerCPoints(this.transformCPoints(o.getContactPoints(), this.getMatrix()));

		// apply matrix to this Node's mesh
			this.TOXIMESH = this.OBJ.getToxiMesh().copy();
			this.TOXIMESH.transform(this.MATRIX);
	}



	// -------------------------------------------------------------------------
	// SETTER
	// private Node setToximesh(){
	// 	return this;
	// }



	// -------------------------------------------------------------------------
	// GETTER
	public Tree getParent(){ return this.PARENT; }
	public Obj getObj(){ return this.OBJ; }
	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public PShape getPShape(){
		if(this.PSHAPE==null) this.PSHAPE = new Converter().toxiToPShape(this.getToxiMesh());
		return this.PSHAPE;
	}

	public CPoint getOrigin(){ return this.ORIGIN; }
	public Vec3D getRotation(){ return this.ROTATION; }
	public Vec3D getPosition(){ return this.getOrigin().getPosition(); }
	public Matrix4x4 getMatrix(){ return this.MATRIX; }

	public ArrayList<CPoint> getContactPoints(){ return this.CPOINTS; }
	public CPoint getContactPoint(int index){ return this.CPOINTS.get(index); }
	public CPoint getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public CPoint getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public CPoint getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }



	// -------------------------------------------------------------------------
	// HELPER
	// compute the Node orientation and return it as a new Vec3D
	// based on the rotation of the source contact point
	private Vec3D computeRotation(CPoint source){
		if(source.computeRotation() != null){
			Vec3D o = this.getOrigin().computeRotation();
			Vec3D s = source.computeRotation();
			return s;
		}else return null;
	}

	// apply matrix to this Node's contact points
	private ArrayList<CPoint> transformCPoints(ArrayList<CPoint> sourceCPoints, Matrix4x4 m){
		ArrayList<CPoint> cpoints = new ArrayList<CPoint>();
		for(CPoint cp : sourceCPoints){
			cp = cp.copy().transform(m);
			cpoints.add(cp);
		}
		return cpoints;
	}

	// register the Node's contact points to its parent Tree
	private ArrayList<CPoint> registerCPoints(ArrayList<CPoint> cpoints){
		for(CPoint cp : cpoints){
			if(!this.getParent().getContactPoints().contains(cp)){
				this.getParent().getContactPoints().add(cp);
			}
		}
		return cpoints;
	}

	// generate a new random rotation, returned as a new Vec3D
	private Vec3D randomRotation(int rotationType){
		Vec3D r = null;
		switch(rotationType){
			case 0 : r = new Vec3D(); break;
			case 1 : r = new Vec3D(radians(random(360)%45), radians(random(360)%45), radians(random(360)%45));
			case 2 : r = new Vec3D(radians(random(360)%90), radians(random(360)%90), radians(random(360)%90));
			case 3 : r = Vec3D.randomVector().scale(360); break;
			default : r = null;
		}
		return r;
	}

}