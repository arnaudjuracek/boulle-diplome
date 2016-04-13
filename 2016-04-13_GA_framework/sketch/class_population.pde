class Population{
	float mutation_rate;
	Square[] population;
	ArrayList<Square> pool;
	int generations;

	Population(float m, int num){
		this.mutation_rate = m;
		this.population = new Square[num];
		this.pool = new ArrayList<Square>();
		this.generations = 0;

		for(int i=0; i<this.population.length; i++){
			this.population[i] = new Square(new Dna(), 50 + i*101, 50);
		}
	}

	void display(){
		for(int i=0; i<this.population.length; i++) this.population[i].display();
	}

	void selection(){
		this.pool.clear();
		// Calculate total fitness of whole population
		float maxFitness = this.getMaxFitness();

		// Calculate fitness for each member of the population (scaled to value between 0 and 1)
		// Based on fitness, each member will get added to the mating pool a certain number of times
		// A higher fitness = more entries to mating pool = more likely to be picked as a parent
		// A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
		for (int i = 0; i < this.population.length; i++) {
			float fitnessNormal = map(this.population[i].fitness, 0, maxFitness, 0, 1);
			int n = (int) (fitnessNormal * 100);  // Arbitrary multiplier
			for(int j = 0; j < n; j++){
				this.pool.add(this.population[i]);
			}
		}
	}

	// Making the next generation
	void reproduction() {
		// Refill the population with children from the mating pool
		for (int i = 0; i < this.population.length; i++) {
			// Sping the wheel of fortune to pick two parents
			int m = int(random(this.pool.size()));
			int d = int(random(this.pool.size()));
			// Pick two parents
			Square mom = this.pool.get(m);
			Square dad = this.pool.get(d);
			// Get their genes
			Dna momgenes = mom.getDNA();
			Dna dadgenes = dad.getDNA();
			// Mate their genes
			Dna child = momgenes.crossover(dadgenes);
			// Mutate their genes
			child.mutate(this.mutation_rate);
			// Fill the new population with the new chil
			this.population[i] = new Square(child, 50 + i*101, 50);
		}
		this.generations++;
	}

	// Find highest fintess for the population
	float getMaxFitness() {
		float record = 0;
		for(int i = 0; i < this.population.length; i++){
			if(this.population[i].fitness > record) record = this.population[i].fitness;
		}
	return record;
  }
}