public class Path{

	private Vec3D[] points, original_points;

	// -------------------------------------------------------------------------
	public Path(Vec3D[] points){
		this.original_points = points;
		this.points = points;
	}



	// -------------------------------------------------------------------------
	// DATA MANIPULATION
	public Path interpolatePath(int resolution){
		// create an array of 3 curves for each Vec3D components
		Curve[] curves = new Curve[3];

		Vec3D[] path = this.getOriginalPoints();
		float[][] curves_values = new float[curves.length][path.length];
		for(int i=0; i<path.length; i++){
			Vec3D v = path[i];
			curves_values[0][i] = v.x;
			curves_values[1][i] = v.y;
			curves_values[2][i] = v.z;
		}

		for(int i=0; i<curves.length; i++){
			curves[i] = new Curve(curves_values[i]);
			curves[i].interpolate(resolution);
		}

		Vec3D[] interpolated_path = new Vec3D[curves[0].size()];
		for(int i=0; i<interpolated_path.length; i++){
			interpolated_path[i] = new Vec3D(curves[0].getValue(i), curves[1].getValue(i), curves[2].getValue(i));
		}

		return this.setPoints(interpolated_path);
	}

	public Path smooth(float coef){
		// create an array of 3 curves for each Vec3D components
		Curve[] curves = new Curve[3];

		Vec3D[] path = this.getPoints();
		float[][] curves_values = new float[curves.length][path.length];
		for(int i=0; i<path.length; i++){
			Vec3D v = path[i];
			curves_values[0][i] = v.x;
			curves_values[1][i] = v.y;
			curves_values[2][i] = v.z;
		}

		for(int i=0; i<curves.length; i++){
			curves[i] = new Curve(curves_values[i]);
			curves[i].smooth(coef);
		}

		Vec3D[] smoothed_path = new Vec3D[curves[0].size()];
		for(int i=0; i<smoothed_path.length; i++){
			smoothed_path[i] = new Vec3D(curves[0].getValue(i), curves[1].getValue(i), curves[2].getValue(i));
		}

		return this.setPoints(smoothed_path);
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Path setPoints(Vec3D[] points){ this.points = points; return this; }
	public Path setOriginalPoints(Vec3D[] points){ this.original_points = points; return this; }


	// -------------------------------------------------------------------------
	// GETTERS
	public Vec3D[] getPoints(){ return this.points; }
	public Vec3D[] getOriginalPoints(){ return this.original_points; }

	public Vec3D getPoint(int index){ return this.points[index]; }
	public Vec3D getOriginalPoint(int index){ return this.original_points[index]; }
}