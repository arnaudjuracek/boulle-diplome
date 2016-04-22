public class Dna{
	public float[] GENES;
	private int ITERATOR = 0;
	private int GENES_LENGTH = 20;

	// -------------------------------------------------------------------------
	// Constructor :
	// Create a new DNA with random assigned genes
	// used by class.Organism
	public Dna(){
		this.GENES = new float[GENES_LENGTH];
		for(int i=0; i<this.GENES.length; i++) this.GENES[i] = random(0,1);
	}

	// Constructor :
	// Create a new DNA with the genes passed in parameter
	// used by class.Dna.recombinate
	private Dna(float[] new_genes){ this.GENES = new_genes; }



	// -------------------------------------------------------------------------
	// DNA recombination :
	// Cross this DNA with a partner's one and
	// return the crossed DNA as a new child
	public Dna recombinate(Dna partner){
		float[] child = new float[this.GENES.length];
		int r = int(random(this.GENES.length));

		for(int i=0; i<this.GENES.length; i++){
			// if(i>r) child[i] = GENES[i]; // segment swapping
			if(random(1)>.5) child[i] = GENES[i]; // gene swapping
			else child[i] = partner.GENES[i];
		}

		return new Dna(child);
	}



	// -------------------------------------------------------------------------
	// DNA mutation :
	// replace randomly picked genes (based on mutation_rates) with new random ones
	public void mutate(float mutation_rate){
		for(int i=0; i<this.GENES.length; i++){
			if(random(1) < mutation_rate) this.GENES[i] = random(0,1);
		}
	}



	// -------------------------------------------------------------------------
	// GENE ITERATOR :
	// return next gene
	public float next_gene(){
		return this.GENES[this.ITERATOR++];
	}

	// return next gene, mapped from a to b
	public float next_gene(float a, float b){
		return map(this.GENES[this.ITERATOR++], 0, 1, a, b);
	}
}