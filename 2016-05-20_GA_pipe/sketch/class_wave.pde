import toxi.math.waves.*;

/* FMHarmonicSquareWave's shape can tweaked by adjusting the number of harmonics
 * used (the higher the more square-like the wave becomes).
 * ConstantWave is simply representing a fixed value
 *
 * Currently available wave forms are:
 * SineWave, FMSineWave, AMFMSineWave
 * FMTriangleWave
 * FMSawtoothWave
 * FMSquareWave, FMHarmonicSquareWave
 * ConstantWave
 *
 * For a demonstration how to use these wave generators as oscillators to
 * synthesize audio samples, please have a look at the toxiclibs audioutils sub-package
 * which is being distributed separately.
 *
 * You can also create entirely new waveforms by subclassing the parent AbstractWave
 * type and overwriting the update() method.
 */

public class Wave{

	public static final int
		CONSTANTWAVE = 0,
		FMTRIANGLEWAVE = 1,
		FMSAWTOOTHWAVE = 2,
		FMSQUAREWAVE = 3,
		FMSINEWAVE = 4;

	private AbstractWave wave;
	private float[] values;

	// -------------------------------------------------------------------------
	public Wave(){ this(Wave.CONSTANTWAVE, 0, 0.1f, -1, 1, 100); }

	public Wave(int waveType, float offset, float frequency, float min, float max, int resolution){
		this.wave = this.create(waveType, offset, frequency, null);
		this.values = this.convertWaveToArray(min, max, resolution);
	}

	public Wave(AbstractWave wave, float min, float max, int resolution){
		this.wave = wave;
		this.values = this.convertWaveToArray(min, max, resolution);
	}

	public Wave(int waveType, float min, float max, int resolution){ this(waveType, 0, 0.1f, min, max, resolution); }



	// -------------------------------------------------------------------------
	// GENERATORS
	private AbstractWave create(int waveType, float offset, float frequency, AbstractWave fmod){
		AbstractWave wave = null;

		// default fmod if create(int waveType, float frequency, null)
		if(fmod==null) fmod = new ConstantWave(0);

		switch(waveType){
			case Wave.CONSTANTWAVE: 	wave = new ConstantWave(1); break;
			case Wave.FMTRIANGLEWAVE: 	wave = new FMTriangleWave(offset, frequency, 1, 0, fmod); break;
			case Wave.FMSAWTOOTHWAVE: 	wave = new FMSawtoothWave(offset, frequency, 1, 0, fmod); break;
			case Wave.FMSQUAREWAVE: 	wave = new FMSquareWave(offset, frequency, 1, 0, fmod); break;
			case Wave.FMSINEWAVE: 		wave = new FMSineWave(offset, frequency, 1, 0, fmod); break;
		}

		return wave;
	}

	public float[] convertWaveToArray(float min, float max, int resolution){
		float[] values = new float[resolution];

		this.getWave().reset();
		for(int i=0; i<values.length; i++){
			values[i] = map(this.getWave().update(), -1, 1, min, max);
		}

		return values;
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Wave setValues(float[] values){ this.values = values; return this; }



	// -------------------------------------------------------------------------
	// GETTERS
	public AbstractWave getWave(){ return this.wave; }

	public float[] getValues(){ return this.values; }
	public float getValue(int index){ return this.values[index]; }

}