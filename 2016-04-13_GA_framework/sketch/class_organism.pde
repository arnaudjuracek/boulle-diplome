public class Organism{
	public Dna DNA;
	public float FITNESS;

	boolean hover;
	color COLOR;
	int size = 20;

	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		// map GENES to phenotype
		this.COLOR = color(
			this.DNA.GENES[0]*255,
			this.DNA.GENES[1]*255,
			this.DNA.GENES[2]*255
		);
	}

	// -------------------------------------------------------------------------
	// UI handling
	void display(int x, int y){
		this.hover = this.is_hover(x,y);

		if(this.hover) stroke(255);
		else stroke(this.COLOR);

		fill(this.COLOR);
		rect(x, y, size, size);
	}

	void displayFitness(int x, int y){
		if(this.hover) fill(this.COLOR);
		else fill(255);
		textAlign(CENTER, TOP);
		text(int(this.FITNESS), x + size/2, y);
	}

	boolean is_hover(int x, int y){
		return (mouseX > x && mouseX < x + size && mouseY > y && mouseY < y + size);
	}

}