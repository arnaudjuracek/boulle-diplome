public class Tree{

	private ArrayList<Node> NODES;
	private TriangleMesh TOXIMESH;
	private ArrayList<Vec3D> CPOINTS;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Tree(){
		this.CPOINTS = new ArrayList<Vec3D>();
			this.CPOINTS.add(new Vec3D(0,0,0));
		this.NODES = new ArrayList<Node>();
	}



	// -------------------------------------------------------------------------
	// SETTER
	public Tree add(Obj o, Vec3D p){
		Node n = new Node(this, p, o);
		this.NODES.add(n);
		this.CPOINTS.remove(p);

		// for(int i = n.getContactPoints_Vec3D().size()-1; i>0; i--){
		// 	Vec3D t = n.getContactPoint(i);
		// 	for(int k = this.CPOINTS.size()-1; k>0; k--){
		// 		Vec3D c = this.CPOINTS.get(k);
		// 		if(t!=c && t.distanceTo(c) < 1){
		// 			this.CPOINTS.remove(t);
		// 			this.CPOINTS.remove(c);
		// 		}
		// 	}
		// }

		return this;
	}


	// -------------------------------------------------------------------------
	// GETTER
	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }

	public ArrayList<Node> getNodes(){ return this.NODES; }
	public Node getNode(int index){ return this.NODES.get(index); }
	public Node getFirstNode(){ return this.NODES.get(0); }
	public Node getLastNode(){ return this.NODES.size()>0 ? this.NODES.get(this.NODES.size()-1) : null; }
	public Node getRandomNode(){ return this.NODES.get(int(random(this.NODES.size()))); }

	public ArrayList<Vec3D> getContactPoints(){ return this.CPOINTS; }
	public Vec3D getContactPoint(int index){ return this.CPOINTS.get(index); }
	public Vec3D getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public Vec3D getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public Vec3D getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }
}