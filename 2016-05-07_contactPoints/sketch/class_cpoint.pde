public class CPoint{

	private Node PARENT;
	private Vec3D POSITION, NORMAL, ROTATION;
	private ArrayList<Vec3D> SURFACE;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a new contact point at the specified Vec3D or at the specified x, y, z
	public CPoint(Vec3D v){ this.POSITION = v; }
	public CPoint(float x, float y, float z){ this( new Vec3D(x,y,z) ); }

	// create a new contact point at the specified Vec3D, with the specified rotation
	// used by CPoint.copy()
	private CPoint(Vec3D position, Vec3D normal, ArrayList<Vec3D> surface){
		this.POSITION = position;
		this.NORMAL = normal;
		this.SURFACE = surface;
	}

	// create a new contact surface, with a computed centroid and directions
	// used in Obj.parseCPointsFile()
	public CPoint(ArrayList<Vec3D> points){
		this.SURFACE = (ArrayList<Vec3D>) points.clone();
		this.POSITION = this.computeCentroid(points);
		this.NORMAL = this.computeNormal(points);
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public CPoint copy(){return new CPoint(this.getPosition(), this.getNormal(), this.getSurface()); }

	public CPoint setPosition(Vec3D p){ this.POSITION = p.copy(); return this; }
	public CPoint setNormal(Vec3D n){ this.NORMAL = n.copy(); return this; }
	public Node setParent(Node n){ this.PARENT = n; return n; }

	public ArrayList<Vec3D> setSurface(ArrayList<Vec3D> s){
		this.SURFACE = s;
		return this.SURFACE;
		// ArrayList<Vec3D> r = new ArrayList<Vec3D>();
		// for(Vec3D v : s) r.add(v.copy());
		// return r;
	}

	public CPoint transform(Matrix4x4 m){
		this.setPosition( m.applyTo(this.POSITION) );

		if(this.getSurface() != null){
			ArrayList<Vec3D> transformed = new ArrayList<Vec3D>();
			for(Vec3D p : this.getSurface()) transformed.add(m.applyTo(new Vec3D(p)));

			this.setSurface(transformed);
			this.setNormal( this.computeNormal(this.getSurface()) );
		}

		return this;
	}




	// -------------------------------------------------------------------------
	// GETTER
	public Vec3D getPosition(){ return this.POSITION; }
	public Vec3D getNormal(){ return this.NORMAL; }
	public ArrayList<Vec3D> getSurface(){ return this.SURFACE; }
	public Node getParent(){ return this.PARENT; }


	// -------------------------------------------------------------------------
	// MATH & GEOM HELPERS
	// compute the centroid of the contact point's surface
	private Vec3D computeCentroid(ArrayList<Vec3D> points){
		PVector
			min = new PVector(999999,999999,999999),
			max = new PVector(-999999,-999999,-999999);

		for(Vec3D v : points){
			if(v.x < min.x){min.x = v.x;}else if(v.x > max.x){max.x = v.x;}
			if(v.y < min.y){min.y = v.y;}else if(v.y > max.y){max.y = v.y;}
			if(v.z < min.z){min.z = v.z;}else if(v.z > max.z){max.z = v.z;}
		}

		return new Converter().pvectorToVec3d( PVector.lerp(min, max, .5) );
	}

	// compute the contact point's normal when given a surface
	private Vec3D computeNormal(ArrayList<Vec3D> points){
		return new Triangle3D(
						points.get(0),
						points.get(1),
						points.get(2)
					).computeNormal();
	}

	// compute the direction of the contact point normal
	public Vec2D computeRotation(){
		Vec3D n = this.getNormal();
		return (n == null) ? null :
			new Vec2D(
				(n.headingXZ() > 1 ? -1 : 1) * acos(n.y / n.magnitude()),
				(this.getParent()==null) ? 0 : this.getParent().getRotation().y
			);
	}
}