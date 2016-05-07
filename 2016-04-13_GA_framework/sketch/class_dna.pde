public class Dna{
	private FloatList GENES;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// Create a new empty DNA
	// used by class.Organism
	public Dna(){ this.GENES = new FloatList(); }

	// CONSTRUCTOR :
	// Create a new DNA with the genes passed in parameter
	// used by class.Dna.recombinate
	private Dna(FloatList new_genes){ this.GENES = new_genes.copy(); }



	// -------------------------------------------------------------------------
	// DNA RECOMBINATION :
	// Cross this DNA with a partner's one and
	// return the crossed DNA as a new child
	public Dna recombinate(Dna partner){
		FloatList child = new FloatList();
		int r = int(random(this.GENES.size())); // segment swapping method

		for(int i=0; i<this.GENES.size(); i++){
			if(i>r) child.append(GENES.get(i)); // segment swapping method
			// if(random(1)>.5) child.append(GENES.get(i)); // gene swapping method
			else child.append(partner.GENES.get(i));
		}

		return new Dna(child);
	}



	// -------------------------------------------------------------------------
	// DNA MUTATION :
	// replace randomly picked genes (based on mutation_rate) with new random ones
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public void mutate(float mutation_rate){
		for(int i=0; i<this.GENES.size(); i++){
			if(random(1) < mutation_rate) this.GENES.set(i, random(0,1));
		}
	}

	// add a random mutation constrained within a mutation amplitute on randomly picked (based on mutation_rate) genes
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public void mutate(float mutation_rate, float mutation_amp){
		for(int i=0; i<this.GENES.size(); i++){
			if(random(1) < mutation_rate) this.GENES.set(i, constrain(this.GENES.get(i) + random(-mutation_amp, mutation_amp), 0, 1));
		}
	}



	// -------------------------------------------------------------------------
	// GENE ITERATOR :
	private int ITERATOR = -1;

	// return next gene
	// if no more gene on the DNA, create a brand new one
	public float nextGene(){
		if(this.ITERATOR++ >= this.GENES.size()-1) this.GENES.append(random(0,1));
		return this.GENES.get(this.ITERATOR);
	}

	// return next gene, mapped from a to b
	public float nextGene(float a, float b){
		return map(this.nextGene(), 0, 1, a, b);
	}
}