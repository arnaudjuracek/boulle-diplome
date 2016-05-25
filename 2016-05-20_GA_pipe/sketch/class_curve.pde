import toxi.math.*;

/*
 * InterpolateStrategy LinearInterpolation();
 * InterpolateStrategy CircularInterpolation();
 * InterpolateStrategy CircularInterpolation(true);
 * InterpolateStrategy SigmoidInterpolation((float)mouseX/width*4);
 * InterpolateStrategy CosineInterpolation();
 * InterpolateStrategy ExponentialInterpolation((float)mouseX/width*4);
 * InterpolateStrategy ThresholdInterpolation((float)mouseX/width);
 * InterpolateStrategy DecimatedInterpolation((int)((float)mouseX/width*20),circular);
 * InterpolateStrategy ZoomLensInterpolation();
 * InterpolateStrategy new ThresholdInterpolation((float) threshold);
*/

public class Curve{

	private float[] values, original_values;
	private InterpolateStrategy interpolation;
	private float smooth_coef;

	// -------------------------------------------------------------------------
	Curve(float value){ this(new float[]{value});}

	Curve(float[] values){
		this.interpolation = new LinearInterpolation();
		this.original_values = values;
		this.values = values;
	}

	Curve(float[] values, InterpolateStrategy interpolation){
		this(values);
		this.setInterpolation(interpolation);
	}

	Curve(float[] values, float smooth_coef){
		this(values);
		this.setSmoothCoef(smooth_coef);
	}

	Curve(float[] values, InterpolateStrategy interpolation, float smooth_coef){
		this(values);
		this.setInterpolation(interpolation);
		this.setSmoothCoef(smooth_coef);
	}



	// -------------------------------------------------------------------------
	// CURVE MANIPULATION
	public Curve interpolate(int resolution){
		float[] values = this.getOriginalValues();

		if(values.length != resolution){
			float[] interpolated = new float[resolution];

			if(values.length>1){

				for(int i=0; i<interpolated.length-1; i++){
					int ax = int(map(i, 0, interpolated.length-1, 0, values.length-1) );
					int bx = ax+1;

					float a = values[ax], b = values[bx];
					float t = norm(map(i, 0, interpolated.length-1, 0, values.length-1), ax, bx);
					interpolated[i] = this.getInterpolation().interpolate(a, b, t);
				}

				// add last point, which is not interpolated
				if(interpolated.length>0) interpolated[interpolated.length-1] = values[values.length-1];

			}else{
				for(int i=0; i<interpolated.length; i++){
					interpolated[i] = values[0];
				}
			}
			return this.setValues(interpolated);
		}else return this;
	}

	public Curve interpolate(int resolution, InterpolateStrategy interpolation){
		this.setInterpolation(interpolation);
		return this.interpolate(resolution);
	}

	public Curve smooth(float coef){
		// exponential smoothing algorithm implementation
		// @see https://en.wikipedia.org/wiki/Exponential_smoothing

		if(coef>0){
			float[] values = this.getValues();
			float[] smoothed = new float[values.length];

			smoothed[0] = values[0];
			for(int i=1; i<values.length; i++)
				smoothed[i] = (1-coef)*values[i] + coef*smoothed[i-1];

			return this.setSmoothCoef(coef).setValues(smoothed);
		}else return this;
	}

	public Curve cross(Curve c){
		if(this.size() < c.size()) this.interpolate(c.size());
		else if(this.size() > c.size()) c.interpolate(this.size());

		float[] values = new float[this.size()];
		float r = random(values.length);
		for(int i=0; i<values.length; i++){
			// segment swapping method
			values[i] = (i>r) ? this.getValue(i) : c.getValue(i);

		}
		return new Curve(values);
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Curve setValues(float[] values){ this.values = values; return this; }
	public Curve setOriginalValues(float[] values){ this.original_values = values; return this; }
	public Curve setInterpolation(InterpolateStrategy itrp){ this.interpolation = itrp; return this; }
	public Curve setSmoothCoef(float coef){ this.smooth_coef = coef; return this; }


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

	public float getSmoothCoef(){ return this.smooth_coef; }



	// -------------------------------------------------------------------------
	// DEBUG
	public void debug_draw(){
		// this.interpolate(int(map(mouseX, 0, width, 0, 1) * 100));

		for(int i=0; i<this.getOriginalValues().length-1; i++){
			Vec2D
				a = new Vec2D(
					map(i, 0, this.getOriginalValues().length-1, 20, width-20),
					this.getOriginalValues()[i]),
				b = new Vec2D(
					map(i+1, 0, this.getOriginalValues().length-1, 20, width-20),
					this.getOriginalValues()[i+1]);

			stroke(200, 0, 100, 100);
			strokeWeight(1);
			line(a.x, a.y, b.x, b.y);
			strokeWeight(5);
			point(a.x, a.y);
		}
		point(width-20, this.getOriginalValues()[this.getOriginalValues().length-1]);

		for(int i=0; i<this.size()-1; i++){
			Vec2D
				a = new Vec2D(
					map(i, 0, this.size()-1, 20, width-20),
					this.getValue(i)),
				b = new Vec2D(
					map(i+1, 0, this.size()-1, 20, width-20),
					this.getValue(i+1));

			stroke(0);
			strokeWeight(1);
			line(a.x, a.y, b.x, b.y);
			strokeWeight(5);
			point(a.x, a.y);
		}
		point(width-20, this.getValue(this.size()-1));

	}
}