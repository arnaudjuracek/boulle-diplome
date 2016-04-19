public class Organism{
	public Dna DNA;
	public float FITNESS;

	boolean HOVER;
	color COLOR;
	PShape SHAPE;
	float SIZE = 600;


	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		// map GENES to phenotype
		this.COLOR = color(
			this.DNA.next_gene()*255,
			this.DNA.next_gene()*255,
			this.DNA.next_gene()*255
		);
		this.SHAPE = this.create_shape();
		this.SHAPE.setStroke(false);
		// this.SHAPE.setFill(color(255));
	}



	// -------------------------------------------------------------------------
	// create a supershape with the superformula
	// see wave creation below
	PShape create_shape(){
		PShape s = createShape(GROUP);

		AbstractWave
			waveX = this.create_wave(
					// wave type
						int(this.DNA.next_gene(0, 7)),
					// offset
						this.DNA.next_gene(0, this.SIZE),
					// frequency
						this.DNA.next_gene(0.005, 0.05),
					// amplitude
						this.DNA.next_gene(.1, 3),
					// frequency modulation
						new SineWave(0, this.DNA.next_gene(0.005, 0.02), this.DNA.next_gene(0.1, 0.5), 0)
					),
			waveY = this.create_wave(
					// wave type
						int(this.DNA.next_gene(0, 7)),
					// offset
						this.DNA.next_gene(0, this.SIZE),
					// frequency
						this.DNA.next_gene(0.005, 0.05),
					// amplitude
						this.DNA.next_gene(.1, 3),
					// frequency modulation
						new SineWave(0, this.DNA.next_gene(0.005, 0.02), this.DNA.next_gene(0.1, 0.5), 0)
					);

		int STEP = int(sqrt(this.DNA.next_gene(0, sq(10)))),
			AMP = ceil( sqrt(this.DNA.next_gene())*50);

		float prevY = waveY.update();
		for(int y = 0; y < this.SIZE; y += STEP) {
			float valueY = waveY.update();

			waveX.push();

			PShape child = createShape();
			child.beginShape(TRIANGLE_STRIP);
			for(int x = 0; x < this.SIZE; x += STEP) {
				float valueX = waveX.update();

				child.fill(
					map(valueX, -1, 1, 200, 255),
					sqrt(map(x, 0, this.SIZE, sq(100), sq(255))),
					map(prevY, -1, 1, 200, 255));
				child.vertex(
					x - (this.SIZE/2),
					y - STEP - (this.SIZE/2),
					(valueX + prevY) * AMP);

				child.fill(
					map(valueX, -1, 1, 200, 255),
					sqrt(map(x, 0, this.SIZE, sq(100), sq(255))),
					map(valueY ,-1 ,1, 200 , 255));
				child.vertex(
					x - (this.SIZE/2),
					y - (this.SIZE/2), (valueX
					 + valueY) * AMP);
			}
			child.endShape();
			s.addChild(child);

			waveX.pop();
			prevY = valueY;
		}
		return s;
	}



	// -------------------------------------------------------------------------
	// Wave creation based on ToxicLibs :
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
	AbstractWave create_wave(int wavetype, float offset, float frequency, float amplitude, AbstractWave fmod){
		AbstractWave wave = null;

		// default fmod if create_wave(int wavetype, float frequency, null)
		if(fmod==null) fmod = new SineWave(0, random(0.005, 0.02), random(0.1, 0.5), 0);

		switch(wavetype){
			case 0:
				wave = new FMTriangleWave(offset, frequency, amplitude, 0, fmod);
				break;
			case 1:
				wave = new FMSawtoothWave(offset, frequency, amplitude, 0, fmod);
				break;
			case 2:
				wave = new FMSquareWave(offset, frequency, amplitude, 0, fmod);
				break;
			case 3:
				wave = new FMHarmonicSquareWave(offset, frequency, amplitude, 0, fmod);
				((FMHarmonicSquareWave) wave ).maxHarmonics=(int)random(3,30);
				break;
			case 4:
				wave = new FMSineWave(offset, frequency, amplitude, 0, fmod);
				break;
			case 5:
				wave = new AMFMSineWave(offset, frequency, 0, fmod, new SineWave(0, random(0.01,0.2), random(2, 3), 0));
				break;
			case 6:
				wave = new ConstantWave(random(-1,1));
				break;
		}
		return wave;
	}



	// -------------------------------------------------------------------------
	// UI handling
	float tv = 1, v = 1, easing = .09, counter = 0;

	void display(int x, int y){
		this.HOVER =  this.is_hover(x,y);

		counter+=.01;

		v += ((this.HOVER ? 2 : 1) - v)*easing;

		pushMatrix();
			translate(x,y, int(this.HOVER)*500);
			rotateX(PI/3);
			pushMatrix();
				rotateZ(counter);

				noFill();
				stroke(255, map(v,1,2,0,100));
				if(this.HOVER) box(map(v,1,2,150,300), map(v,1,2,150,300), map(v,1,2,150,300)*.5);

				scale(map(v,1,2,150,300)/this.SIZE);
				if(this.SHAPE != null) shape(this.SHAPE, 0, 0);
			popMatrix();
		popMatrix();

		if(this.HOVER || this.FITNESS > 1) this.displayFitness(x,y);
	}

	void displayFitness(int x, int y){
		hint(DISABLE_DEPTH_TEST);
			pushStyle();
				fill(0, map(v, 1, 2, 255*.4, 255*.9));
				noStroke();
				float r = sqrt(map(this.FITNESS, 0, 100, sq(40 + v*10), sq(60 + v*20)));
				ellipse(x,y,r,r);
			popStyle();

			fill(255, map(v, 1, 2, 255*.6, 255*.9));
			textAlign(CENTER, CENTER);
			text(int(this.FITNESS) + "%", x, y-1);
		hint(ENABLE_DEPTH_TEST);
	}

	boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}