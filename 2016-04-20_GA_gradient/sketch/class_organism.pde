public class Organism{
	public Dna DNA;
	public float FITNESS;

	boolean HOVER;
	color[] COLORS;
	PImage IMAGE;
	int SIZE = 150;


	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		// map GENES to phenotype
		color[] colors = {
			color(this.DNA.next_gene()*255, this.DNA.next_gene()*255, this.DNA.next_gene()*255),
			color(this.DNA.next_gene()*255, this.DNA.next_gene()*255, this.DNA.next_gene()*255)
		};

		this.COLORS = colors;

		this.IMAGE = this.create_gradient();
	}



	// -------------------------------------------------------------------------
	// see wave creation below
	PImage create_gradient(){
		AbstractWave
			waveX = this.create_wave(
					// wave type
						int(this.DNA.next_gene(0, 5)),
					// offset
						this.DNA.next_gene(0, this.SIZE),
					// frequency
						this.DNA.next_gene(0.0000005, 0.01),
					// amplitude
						this.DNA.next_gene(.1, 2),
					// frequency modulation
						new SineWave(0, this.DNA.next_gene(0.0000005, 0.02), this.DNA.next_gene(0.1, 0.5), 0)
					),
			waveY = this.create_wave(
					// wave type
						int(this.DNA.next_gene(0, 5)),
					// offset
						this.DNA.next_gene(0, this.SIZE),
					// frequency
						this.DNA.next_gene(0.0000005, 0.01),
					// amplitude
						this.DNA.next_gene(.1, 2),
					// frequency modulation
						new SineWave(0, this.DNA.next_gene(0.0000005, 0.02), this.DNA.next_gene(0.1, 0.5), 0)
					);

		float
			SATURATION = this.DNA.next_gene(100, 100),
			BRIGHTNESS = this.DNA.next_gene(100, 100);
		int GRADIENT_MODE = int(this.DNA.next_gene(0, 5));

		PGraphics pg = createGraphics(this.SIZE, this.SIZE);
			pg.beginDraw();
			pg.loadPixels();
			pg.endDraw();


			float prevY = waveY.update();
			for(int y=0; y<this.SIZE; y++){
				float valueY = waveY.update();
				waveX.push();
				for(int x=0; x<this.SIZE; x++){
					int index = x + y*this.SIZE;
					float valueX = waveX.update();

					colorMode(HSB, 360, 100, 100);
					color h = color(map(valueX+valueY, -2, 2, 0, 360), SATURATION, BRIGHTNESS);
					colorMode(RGB, 255, 255, 255);

					color c = this.COLORS[0];
					switch(GRADIENT_MODE){
						case 0 : c = lerpColor(this.COLORS[0], this.COLORS[1], map(x+y, 0, 2*(this.SIZE), 0, 1)); break;
						case 1 : c = lerpColor(this.COLORS[0], this.COLORS[1], map(x, 0, this.SIZE, 0, 1)); break;
						case 2 : c = lerpColor(this.COLORS[0], this.COLORS[1], map(y, 0, this.SIZE, 0, 1)); break;
						case 3 : c = lerpColor(this.COLORS[0], this.COLORS[1], map(x*y, 0, sq(this.SIZE), 0, 1)); break;
					}

					pg.pixels[index] = lerpColor(h, c, .9);

				}
				waveX.pop();
			}
			pg.updatePixels();
		return pg;
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
				wave = new FMSineWave(offset, frequency, amplitude, 0, fmod);
				break;
			case 3:
				wave = new AMFMSineWave(offset, frequency, 0, fmod, new SineWave(0, random(0.01,0.2), random(2, 3), 0));
				break;
			case 4:
				wave = new ConstantWave(random(-1,1));
				break;
		}
		return wave;
	}

	// -------------------------------------------------------------------------
	// export handling

	boolean export(String path){
		this.IMAGE.save(path);
		return true;
	}


	// -------------------------------------------------------------------------
	// UI handling
	float tv = 1, v = 0, easing = .09, counter = frameCount*.01;

	void display(int x, int y){
		this.HOVER =  this.is_hover(x,y);
		v += ((this.HOVER ? 2 : 1) - v)*easing;

		if(this.IMAGE!=null) image(this.IMAGE, x-this.IMAGE.width/2, y-this.IMAGE.height/2);
	}

	void displayFitness(int x, int y){
		pushStyle();
			fill(0, map(v, 1, 2, 255*.4, 255*.9));
			noStroke();
			float r = sqrt(map(this.FITNESS, 0, 100, sq(40 + v*10), sq(this.SIZE - 50 + v*20)));
			ellipse(x,y,r,r);
		popStyle();

		fill(255, map(v, 1, 2, 255*.6, 255*.9));
		textAlign(CENTER, CENTER);
		text(int(this.FITNESS) + "%", x, y-1);
	}

	boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}