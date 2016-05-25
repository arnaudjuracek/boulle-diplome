public class Dna{

	private FloatList genes;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Dna(FloatList new_genes){ this.genes = new_genes.copy(); }
	public Dna(){ this(new FloatList()); }



	// -------------------------------------------------------------------------
	// DNA MANIPULATION

	// Cross this DNA with a partner's one and
	// return the crossed DNA as a new child
	public Dna recombinate(Dna partner){
		FloatList child = new FloatList();
		int r = int(random(this.getGenes().size())); // segment swapping method

		for(int i=0; i<this.getGenes().size(); i++){
			if(i>r) child.append(this.getGene(i)); // segment swapping method
			// if(random(1)>.5) child.append(getGenes().get(i)); // gene swapping method
			else child.append(partner.getGene(i));
		}

		return new Dna(child);
	}

	// replace randomly picked genes (based on mutation_rate) with new random ones
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public Dna mutate(float mutation_rate){
		for(int i=0; i<this.getGenes().size(); i++){
			if(random(1) < mutation_rate) this.getGenes().set(i, random(0,1));
		}
		return this;
	}

	// add a random mutation constrained within a mutation amplitute on randomly picked (based on mutation_rate) genes
	// Dna.mutate(m) == Dna.mutate(m, 1)
	public Dna mutate(float mutation_rate, float mutation_amp){
		for(int i=0; i<this.getGenes().size(); i++){
			if(random(1) < mutation_rate) this.getGenes().set(i, constrain(this.getGene(i) + random(-mutation_amp, mutation_amp), 0, 1));
		}
		return this;
	}



	// -------------------------------------------------------------------------
	// GETTER
	public FloatList getGenes(){ return this.genes; }
	public float getGene(int index){ return this.genes.get(index); }

	// return next gene
	// if no more gene on the DNA, create a brand new one
	private int ITERATOR = -1;
	public float getNextGene(){
		if(this.ITERATOR++ >= this.getGenes().size()-1) this.getGenes().append(random(0,1));
		return this.getGene(this.ITERATOR);
	}

	// return next gene, mapped from a to b
	public float getNextGene(float a, float b){ return map(this.getNextGene(), 0, 1, a, b); }

}