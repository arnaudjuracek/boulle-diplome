public class Node{

	private Tree PARENT;
	private Obj OBJ;
	private ArrayList<CPoint> CPOINTS;
	private Mtl MATERIAL;

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
		this.MATERIAL = o.getRandomMaterial();
		if(this.MATERIAL==null) this.MATERIAL = new Mtl();
		println(this.getMaterial().getName());

		// draw the Node from one of its OBJ's contact points
			this.ORIGIN = o.getRandomContactPoint();
			// this.ORIGIN = o.getFirstContactPoint();

		// compute the rotation of the Node based on its origin CPoint and the sourceCPoint
	 	// or create a new random rotation
			this.ROTATION = this.computeRotation(sourceCPoint);
				if(this.ROTATION == null) this.ROTATION = this.randomRotation(1);

		// create transformation matrix for this given state
			this.MATRIX = new Matrix4x4()
				.translate(sourceCPoint.getPosition())
				.rotateY(this.getRotation().z)
				.rotateX(this.getRotation().y)
				.scale(1)
				.translate(-this.getPosition().x, -this.getPosition().y, -this.getPosition().z);

		// apply matrix to the Node's contactpoints, and register them in its parent Tree
			this.CPOINTS = this.registerCPoints(this.transformCPoints(o.getContactPoints(), this.getMatrix()));

		// apply matrix to the Node's mesh
			this.TOXIMESH = this.OBJ.getToxiMesh().copy();
			this.TOXIMESH.transform(this.getMatrix());
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Tree getParent(){ return this.PARENT; }
	public Obj getObj(){ return this.OBJ; }
	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public PShape getPShape(){
		if(this.PSHAPE == null){
			this.PSHAPE = new Converter().toxiToPShape(this.getToxiMesh(), this.getMaterial());
		}
		return this.PSHAPE;
	}

	public Mtl getMaterial(){ return this.MATERIAL; }

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
		Vec3D s = source.computeRotation();
		if(s != null){
			Vec3D o = this.getOrigin().computeRotation();
			// println("s:" + degrees(s.x) + ", " + degrees(s.y));
			return new Vec3D(
							s.x,
							s.y,
							s.z
						);
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
			cp.setParent(this);
			// if(!this.getParent().getContactPoints().contains(cp))
				this.getParent().getContactPoints().add(cp);
		}
		return cpoints;
	}

	// generate a new random rotation, returned as a new Vec3D
	private Vec3D randomRotation(int rotationType){
		Vec3D r = null;
		switch(rotationType){
			case -1 : r = new Vec3D(map(mouseX, 0, width, 0, 1) * TWO_PI, map(mouseY, 0, height, 0, 1) * TWO_PI, 0); break;

			case 0 : r = new Vec3D(); break;
			case 1 : r = new Vec3D(radians(int(random(8))*45), radians(int(random(8))*45), radians(int(random(8))*45));
			case 2 : r = new Vec3D(radians(int(random(4))*90), radians(int(random(4))*90), radians(int(random(4))*90));
			case 3 : r = Vec3D.randomVector().scale(TWO_PI); break;
			default : r = null;
		}
		return r;
	}

}