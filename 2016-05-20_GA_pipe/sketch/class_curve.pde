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

		if(values.length>1){
			for(int i=0; i<interpolated.length-1; i++){
				int ax = int( norm(i,0,interpolated.length-1) * (values.length-1) );
				int bx = ax + 1;

				float a = values[ax], b = values[bx];
				float t = norm(map(i, 0, interpolated.length-1, 0, values.length-1), ax, bx);
				interpolated[i] = this.getInterpolation().interpolate(a, b, t);
			}

			if(interpolated.length>0) interpolated[interpolated.length-1] = values[values.length-1]; // ¯\_(ツ)_/¯
		}else{
			for(int i=0; i<interpolated.length; i++){
				interpolated[i] = values[0];
			}
		}
		return this.setValues(interpolated);
	}

	public Curve interpolate(int resolution, InterpolateStrategy interpolation){
		this.setInterpolation(interpolation);
		return this.interpolate(resolution);
	}

	public Curve smooth(float coef){
		// exponential smoothing algorithm implementation
		// @see https://en.wikipedia.org/wiki/Exponential_smoothing

		float[] values = this.getValues();
		float[] smoothed = new float[values.length];

		smoothed[0] = values[0];
		for(int i=1; i<values.length; i++)
			smoothed[i] = (1-coef)*values[i] + coef*smoothed[i-1];

		return this.setValues(smoothed);
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Curve setValues(float[] values){ this.values = values; return this; }
	public Curve setOriginalValues(float[] values){ this.original_values = values; return this; }
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
	}
}