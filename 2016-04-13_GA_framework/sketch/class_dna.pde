class Dna{
	float[] genes;

	Dna(){
		this.genes = new float[3];
		for(int i=0; i<this.genes.length; i++) genes[i] = random(1);
	}

	Dna(float[] new_genes){
		this.genes = new_genes;
	}


	Dna crossover(Dna partner){
		float[] child = new float[this.genes.length];
		int crossover = int(random(this.genes.length));

		for(int i=0; i<this.genes.length; i++){
			if(i>crossover) child[i] = genes[i];
			else child[i] = partner.genes[i];
		}

		return new Dna(child);
	}

	void mutate(float m){
		for(int i=0; i<this.genes.length; i++){
			if(random(1) < m ) genes[i] = random(0,1);
		}
	}
}