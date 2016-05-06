public class Population{
	public ArrayList<Organism> ORGANISMS;
	public float MUTATION_RATE, MUTATION_AMP;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// Create a new population of *num* organisms
	// with an assigned mutation_rate
	public Population(int num, float mutation_rate, float mutation_amp){
		this.MUTATION_RATE = mutation_rate;
		this.MUTATION_AMP = mutation_amp;

		this.ORGANISMS = new ArrayList<Organism>();

		// spawn a random pool of organisms
		for(int i=0; i<num; i++) this.ORGANISMS.add( new Organism(new PVector(random(width), random(height)), new Dna()) );

		// throw warning if too many unecessary genes
		int record = 0;
		for(Organism o : this.ORGANISMS) if(o.DNA.ITERATOR > record) record = o.DNA.ITERATOR;
		if(record < this.ORGANISMS.get(0).DNA.GENES_LENGTH) println("Max Genes needed : " + record);
	}



	// // -------------------------------------------------------------------------
	// // MATING POOL REPRODUCTION :
	// // reproduce the organisms placed in the mating pool between each others,
	// // thus creating a new generation of the population
	// private void reproduce() {
	// 	// Refill the population with children from the mating pool
	// 	for(int i=0; i<this.ORGANISMS.length; i++){

	// 		// Pick two parents
	// 		Organism mom = this.getRandomOrganismFromPool();
	// 		Organism dad = this.getRandomOrganismFromPool();

	// 		// Mate their genes into a child, then mutate it
	// 		Dna childDNA = mom.DNA.recombinate(dad.DNA);
	// 		// childDNA.mutate(this.MUTATION_RATE);
	// 		childDNA.mutate(this.MUTATION_RATE, this.MUTATION_AMP);

	// 		PVector position = new PVector(0, 0);

	// 		// Fill the new population with the new child
	// 		this.ORGANISMS[i] = new Organism(position, childDNA, mom, dad);
	// 	}
	// 	this.GENERATION++;
	// }



	// -------------------------------------------------------------------------
	// HELPERS :
	// Find highest fintess for the population
	// used by Population.reproduce()
	private float getMaxFitness(){
		float record = 0;
		for(Organism o : this.ORGANISMS){
			if(o.FITNESS > record) record = o.FITNESS;
		}
		return record;
	}



	// -------------------------------------------------------------------------
	// UI handling

	public void update_breed_and_display(){
		// ArrayList<Organism> newOrganisms = new ArrayList<Organism>();
		Organism newOrganisms = null;

		for(int i=this.ORGANISMS.size()-1; i>0; i--){
			Organism o = this.ORGANISMS.get(i);
			o.update();

			if(o.FITNESS < 0) this.ORGANISMS.remove(o);
			else{
				if(o.LAST_REPRODUCTION > 100 && o.FITNESS > 20){
					for(Organism n : this.ORGANISMS){
						if(n!=o){
							if(PVector.dist(n.P_position, o.P_position) < max(n.P_size, o.P_size)){
								o.LAST_REPRODUCTION = 0;
								PVector position = PVector.lerp(n.P_position, o.P_position, .5);

								// Mate their genes into a child, then mutate this child
								Dna childDNA = o.DNA.recombinate(n.DNA);
								childDNA.mutate(this.MUTATION_RATE, this.MUTATION_AMP);

								// Add the child to the population
								// newOrganisms.add( new Organism(position, childDNA, o, n) );
								newOrganisms = new Organism(position, childDNA, o, n);
							}
						}
					}
				}
				o.display(o.P_position.x, o.P_position.y);
			}
		}

		// for(Organism n : newOrganisms) this.ORGANISMS.add(n);
		if(newOrganisms != null) this.ORGANISMS.add(newOrganisms);
	}

}