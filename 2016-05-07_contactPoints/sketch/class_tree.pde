public class Tree{

	private ArrayList<Node> NODES;
	private TriangleMesh TOXIMESH;
	private ArrayList<CPoint> CPOINTS;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Tree(){
		this.CPOINTS = new ArrayList<CPoint>();
			this.CPOINTS.add(new CPoint(0,0,0));
		this.NODES = new ArrayList<Node>();
	}



	// -------------------------------------------------------------------------
	// SETTER
	// add to the Tree a new Node at the CPoint with the Obj o
	// then remove the CPoint from the Tree's list
	public Tree add(Obj o, CPoint p){
		Node n = new Node(this, p, o);
		this.NODES.add(n);
		this.getContactPoints().remove(p);
		return this;
	}

	// add to the Tree a new Node at the CPoint with the Obj o
	// then remove the CPoint from the Tree's list if removeP is true
	public Tree add(Obj o, CPoint p, boolean removeP){
		Node n = new Node(this, p, o);
		this.NODES.add(n);
		if(removeP) this.getContactPoints().remove(p);
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

	public ArrayList<CPoint> getContactPoints(){ return this.CPOINTS; }
	public CPoint getContactPoint(int index){ return this.CPOINTS.get(index); }
	public CPoint getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public CPoint getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public CPoint getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }
}