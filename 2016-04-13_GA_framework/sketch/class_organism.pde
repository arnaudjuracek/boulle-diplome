public class Organism{
	public Dna DNA;
	public Organism[] PARENTS;
	public float FITNESS;
	public boolean HOVER;


	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// initialize fitness to 1
	// set parents to null
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		this.PARENTS = new Organism[2];
		this.PARENTS[0] = null;
		this.PARENTS[1] = null;

		// map GENES to phenotype
		this.P_define();
	}

	// CONSTRUCTOR :
	// initialize fitness to 1
	// define parents
	// translate genotype onto phenotype
	public Organism(Dna dna, Organism mom, Organism dad){
		this.DNA = dna;
		this.FITNESS = 1;
		this.PARENTS = new Organism[2];
		this.PARENTS[0] = mom;
		this.PARENTS[1] = dad;

		// map GENES to phenotype
		this.P_define();

	}

	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	private color P_color;
	private int P_size = 20;

	private void P_define(){
		this.P_color = color(
				(int) this.DNA.nextGene(0,255),
				(int) this.DNA.nextGene(0,255),
				(int) this.DNA.nextGene(0,255)
			);
	}


	// -------------------------------------------------------------------------
	// UI handling
	void display(int x, int y){
		this.HOVER = this.is_hover(x,y);

		if(this.HOVER) stroke(255);
		else stroke(this.P_color);

		fill(this.P_color);
		rect(x, y, this.P_size, this.P_size);
	}

	void displayFitness(int x, int y){
		if(this.HOVER) fill(this.P_color);
		else fill(255);
		textAlign(CENTER, TOP);
		text(int(this.FITNESS), x + this.P_size/2, y);
	}

	boolean is_hover(int x, int y){
		return (mouseX > x && mouseX < x + this.P_size && mouseY > y && mouseY < y + this.P_size);
	}

}