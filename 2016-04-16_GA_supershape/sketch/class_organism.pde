public class Organism{
	public Dna DNA;
	public float FITNESS;

	boolean HOVER;
	color COLOR = color(255);
	PShape SHAPE;
	float SIZE = 50;


	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		// map GENES to phenotype
		// this.COLOR = color(
		// 	this.DNA.next_gene()*255,
		// 	this.DNA.next_gene()*255,
		// 	this.DNA.next_gene()*255
		// );

		this.SHAPE = this.supershape();
		this.SHAPE.disableStyle();
	}



	// -------------------------------------------------------------------------
	// create a supershape with the superformula
	// for param analysis, see http://paulbourke.net/geometry/supershape/
	PShape supershape(){
		float
			turns = max(map(sqrt(this.DNA.next_gene()), 0, 1, -10, 10), 1),
			sides = map(this.DNA.next_gene(), 0, 1, 3, 360),

			a  = 1,
			b  = 1,

			x  = map(this.DNA.next_gene(), 0, 1, 0, 10),
			y  = map(this.DNA.next_gene(), 0, 1, 0, 10),

			n1 = sqrt(this.DNA.next_gene()) * 100,

			p  = this.DNA.next_gene(),
			n2 = (1 - 2*int(p<=.5))* sqrt(this.DNA.next_gene()) * 100,
			n3 = (1 - 2*int(p> .5))* sqrt(this.DNA.next_gene()) * 100;

		// supershape construction,
		// based on spherical equation with polar coordinates
		PShape s = createShape();
		s.beginShape();
		for(int alpha=0; alpha<360*turns; alpha+=((360*turns)/sides)){
			float
				phi = radians(alpha),
				r = superformula(phi, a, b, x, y, n1, n2, n3),
				radius = r*this.SIZE;
			s.vertex(radius*cos(phi), radius*sin(phi));
		}
		s.endShape();
		return s;
	}



	// -------------------------------------------------------------------------
	// superformula, thanks to http://www.k2g2.org/blog:bit.craft:superdupershape_explorer
	// modified to create asymetric supershapes as seen on https://en.wikipedia.org/wiki/Superformula
	float superformula(float phi, float a, float b, float x, float y, float n1, float n2, float n3) {
		return pow(pow(abs(cos(x * phi / 4) / a), n2) + pow(abs(sin(y * phi / 4) / b),n3), - 1/n1);
	}



	// -------------------------------------------------------------------------
	// UI handling
	float t_scale = 1, v_scale = 1, e_scale = .09;

	void display(int x, int y){
		this.HOVER = this.is_hover(x,y);

		// fill(this.COLOR, sqrt(map(this.FITNESS, 1, 100, 0, sq(255))));
		stroke(this.COLOR);
		strokeWeight(2);
		noFill();

		pushMatrix();
			translate(x,y);
			if(this.HOVER) t_scale = 2;
			else t_scale = 1;

			v_scale += (t_scale - v_scale) * e_scale;
			scale(v_scale + sin(frameCount*.03)*map(v_scale, 1, 2, 0, .2));
			if(this.SHAPE!=null) shape(this.SHAPE, 0, 0);
		popMatrix();

		if(this.HOVER || this.FITNESS > 1) this.displayFitness(x,y);
	}

	void displayFitness(int x, int y){
		pushStyle();
			fill(0, map(v_scale, 1, 2, 255*.7, 255*.9));
			noStroke();
			float r = sqrt(map(this.FITNESS, 0, 100, sq(40 + v_scale*10), sq(60 + v_scale*20)));
			ellipse(x,y,r,r);
		popStyle();

		fill(255, map(v_scale, 1, 2, 255*.6, 255*.9));
		textAlign(CENTER, CENTER);
		text(int(this.FITNESS) + "%", x, y-1);
	}

	boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < this.SIZE;
	}

}