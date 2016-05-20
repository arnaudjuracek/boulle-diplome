public class Curve{

	private float[] values, original_values;
	private InterpolateStrategy interpolation;

	// -------------------------------------------------------------------------
	Curve(float[] values){
		this.interpolation = new LinearInterpolation();
		this.original_values = values;
		this.values = values;
	}



	// -------------------------------------------------------------------------
	// CURVE MANIPULATION
	public Curve interpolate(int resolution){
		float[] values = this.getOriginalValues();
		float[] interpolated = new float[resolution];

		for(int i=0; i<interpolated.length-1; i++){
			int ax = int(map(i, 0, interpolated.length-1, 0, values.length-1));
			int bx = ax + 1;

			float a = values[ax], b = values[bx];
			float t = norm(map(i, 0, interpolated.length-1, 0, values.length-1), ax, bx);

			interpolated[i] = this.getInterpolation().interpolate(a, b, t);
		}

		this.setValues(interpolated);

		return this;
	}


	// -------------------------------------------------------------------------
	// SETTERS
	public Curve setValues(float[] values){ this.values = values; return this; }
	public Curve setInterpolation(InterpolateStrategy itrp){ this.interpolation = itrp; return this; }


	// -------------------------------------------------------------------------
	// GETTERS
	public InterpolateStrategy getInterpolation(){ return this.interpolation; }
	public float[] getOriginalValues(){ return this.original_values; }

	public float[] getValues(){ return this.values; }
	public float getValue(int x){ return this.values[x]; }
	public int size(){ return this.values.length; }

	public float getMaxValue(){
		float max = 0f;
		for(float v : this.getValues()) if(v>max) max = v;
		return max;
	}

	public float getMinValue(){
		float min = 99999f;
		for(float v : this.getValues()) if(v<min) min = v;
		return min;
	}

}