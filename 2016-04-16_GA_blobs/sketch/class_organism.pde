public class Organism{
	public Dna DNA;
	public float FITNESS;

	boolean HOVER;
	color COLOR;
	PShape SHAPE;
	float SIZE = 100;
	int gene_iterator;

	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		// map GENES to phenotype
		this.gene_iterator = 0;

		this.COLOR = color(
			this.DNA.GENES[gene_iterator++]*255,
			this.DNA.GENES[gene_iterator++]*255,
			this.DNA.GENES[gene_iterator++]*255
		);

		this.SHAPE = createShape();
		this.SHAPE.beginShape();

		int side = int( map(this.DNA.GENES[gene_iterator++], 0, 1, 4, 100) );
		float size = this.SIZE;
		for(int alpha=0; alpha<360; alpha+=360/side){
			float
				radius = map(this.DNA.GENES[gene_iterator++], 0, 1, size*this.DNA.GENES[gene_iterator++], this.SIZE),
				x = cos(radians(alpha)) * radius,
				y = sin(radians(alpha)) * radius;

			if(this.DNA.GENES[gene_iterator++]*100 < 80) this.SHAPE.curveVertex(x,y);
			else this.SHAPE.vertex(x,y);
		}
		this.SHAPE.endShape(CLOSE);
		this.SHAPE.setFill(this.COLOR);
		this.SHAPE.setStrokeWeight(3);
	}

	// -------------------------------------------------------------------------
	// UI handling
	void display(int x, int y){
		this.HOVER = this.is_hover(x,y);
		if(this.HOVER) this.SHAPE.setStroke(color(255, 255));
		else this.SHAPE.setStroke(color(0, 0));

		if(this.SHAPE!=null) shape(this.SHAPE, x, y);
	}

	void displayFitness(int x, int y){
		// if(this.HOVER) fill(this.COLOR);
		// else fill(255);
		// textAlign(CENTER, TOP);
		// text(int(this.FITNESS), x + radius/2, y);
	}

	boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}