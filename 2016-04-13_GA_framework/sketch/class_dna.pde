public class Dna{
	public float[] GENES;
	private int
		ITERATOR = 0,
		GENES_LENGTH = 3;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// Create a new DNA with random assigned genes
	// used by class.Organism
	public Dna(){
		this.GENES = new float[GENES_LENGTH];
		for(int i=0; i<this.GENES.length; i++) this.GENES[i] = random(0,1);
	}

	// CONSTRUCTOR :
	// Create a new DNA with the genes passed in parameter
	// used by class.Dna.recombinate
	private Dna(float[] new_genes){ this.GENES = new_genes; }



	// -------------------------------------------------------------------------
	// DNA RECOMBINATION :
	// Cross this DNA with a partner's one and
	// return the crossed DNA as a new child
	public Dna recombinate(Dna partner){
		float[] child = new float[this.GENES.length];
		int r = int(random(this.GENES.length));

		for(int i=0; i<this.GENES.length; i++){
			if(i>r) child[i] = GENES[i];
			else child[i] = partner.GENES[i];
		}

		return new Dna(child);
	}



	// -------------------------------------------------------------------------
	// DNA MUTATION :
	// replace randomly picked genes (based on mutation_rate) with new random ones
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public void mutate(float mutation_rate){
		for(int i=0; i<this.GENES.length; i++){
			if(random(1) < mutation_rate) this.GENES[i] = random(0,1);
		}
	}

	// add a random mutation constrained within a mutation amplitute on randomly picked (based on mutation_rate) genes
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public void mutate(float mutation_rate, float mutation_amp){
		for(int i=0; i<this.GENES.length; i++){
			if(random(1) < mutation_rate) this.GENES[i] = constrain(this.GENES[i] + random(-mutation_amp, mutation_amp), 0, 1);
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