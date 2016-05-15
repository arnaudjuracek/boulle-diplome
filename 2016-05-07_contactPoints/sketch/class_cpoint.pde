public class CPoint{

	private Vec3D POSITION, NORMAL;
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
		this.SURFACE = points;
		this.POSITION = this.computeCentroid(points);
		this.NORMAL = this.computeNormal(points);
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public CPoint copy(){return new CPoint(this.getPosition(), this.getNormal(), this.getSurface()); }

	public CPoint setPosition(Vec3D p){ this.POSITION = p; return this; }
	public CPoint setNormal(Vec3D n){ this.NORMAL = n; return this; }

	public CPoint transform(Matrix4x4 m){
		this.setPosition( m.applyTo(this.POSITION) );

		if(this.SURFACE != null){
			for(int i=0; i<this.SURFACE.size(); i++){
				Vec3D p = this.SURFACE.get(i);
				this.SURFACE.set(i, m.applyTo(p));
			}
			this.setNormal( this.computeNormal(this.SURFACE) );
		}
		return this;
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Vec3D getPosition(){ return this.POSITION; }
	public Vec3D getNormal(){ return this.NORMAL; }
	public ArrayList<Vec3D> getSurface(){ return this.SURFACE; }



	// -------------------------------------------------------------------------
	// MATH & GEOM HELPERS
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

	private Vec3D computeNormal(ArrayList<Vec3D> points){
		return new Triangle3D(
						points.get(0),
						points.get(1),
						points.get(2)
					).computeNormal();
	}

	public Vec3D computeRotation(){
		return null;
	}
}