public class Population{
	public Organism[] ORGANISMS;
	public ArrayList<Organism> MATING_POOL;
	public float MUTATION_RATE;

	public int GENERATION;
	public ArrayList<Organism[]> PREVIOUS_GENERATIONS;
	public int MAX_HISTORY_STATES = 35;

	// -------------------------------------------------------------------------
	// Constructor :
	// Create a new population of *num* organisms
	// with an assigned mutation_rate
	public Population(int num, float mutation_rate){
		this.ORGANISMS = new Organism[num];
		this.MUTATION_RATE = mutation_rate;
		this.MATING_POOL = new ArrayList<Organism>();

		this.GENERATION = 0;
		this.PREVIOUS_GENERATIONS = new ArrayList<Organism[]>();
			this.PREVIOUS_GENERATIONS.add(this.ORGANISMS);

		// spawn a random pool of organisms
		for(int i=0; i<this.ORGANISMS.length; i++){
			this.ORGANISMS[i] = new Organism(new Dna());
		}
	}


	// -------------------------------------------------------------------------
	// Population evolution :
	// Push the current population into the history,
	// then evolve the current generation by populating a mating pool based on each
	// organism's fitness, and finally mate the organisms in the mating pool
	public void evolve(){
		this.pushHistory();
		this.populate_pool();
		this.reproduce();
	}


	// -------------------------------------------------------------------------
	// Mating Pool population :
	// create a mating pool populated from current generation
	// the mating pool is based on fitness of each organism
	private void populate_pool(){
		this.MATING_POOL.clear();
		// Calculate total fitness of whole population
		float maxFitness = this.getMaxFitness();

		// Calculate fitness for each member of the population (scaled to value between 0 and 1)
		// Based on fitness, each member will get added to the mating pool a certain number of times
		// A higher fitness = more entries to mating pool = more likely to be picked as a parent
		// A lower fitness = fewer entries to mating pool = less likely to be picked as a parent
		for(Organism o : this.ORGANISMS){
			float fitnessNormal = map(o.FITNESS, 0, maxFitness, 0, 1);
			int n = (int) (fitnessNormal*100); // Arbitrary multiplier

			for(int j=0; j<n; j++){
				this.MATING_POOL.add(o);
			}
		}
	}


	// -------------------------------------------------------------------------
	// Mating Pool reproduction :
	// reproduce the organisms placed in the mating pool between each others,
	// thus creating a new generation of the population
	private void reproduce() {
		// Refill the population with children from the mating pool
		for(int i=0; i<this.ORGANISMS.length; i++){

			// Pick two parents
			Organism mom = this.getRandomOrganismFromPool();
			Organism dad = this.getRandomOrganismFromPool();

			// Mate their genes into a child, then mutate it
			Dna childDNA = mom.DNA.recombinate(dad.DNA);
			childDNA.mutate(this.MUTATION_RATE);

			// Fill the new population with the new child
			this.ORGANISMS[i] = new Organism(childDNA);
		}
		this.GENERATION++;
	}


	// -------------------------------------------------------------------------
	// Push the current generation into the PREVIOUS_GENERATIONS history
	private void pushHistory(){
		Organism[] current_generation = this.ORGANISMS.clone();
		if(this.PREVIOUS_GENERATIONS.size() > this.MAX_HISTORY_STATES) this.PREVIOUS_GENERATIONS.remove(0);
		this.PREVIOUS_GENERATIONS.add(current_generation);
	}



	// -------------------------------------------------------------------------
	// Helpers
	// Find highest fintess for the population
	// used by Population.reproduce()
	private float getMaxFitness(){
		float record = 0;
		for(Organism o : this.ORGANISMS){
			if(o.FITNESS > record) record = o.FITNESS;
		}
		return record;
	}

	// return a random organism from the current mating pool
	// used by Population.reproduce()
	private Organism getRandomOrganismFromPool(){
		int r = int(random(this.MATING_POOL.size()));
		return this.MATING_POOL.get(r);
	}


	// -------------------------------------------------------------------------
	// UI handling

	public void display(){
		for(int i=0; i<this.ORGANISMS.length; i++){
			int x = 50 + i*21;
			this.ORGANISMS[i].display(x, 10);
			this.ORGANISMS[i].displayFitness(x, 32 + int(i%2==0)*10);
		}

		// display generation index
		fill(255);
		textAlign(RIGHT, CENTER);
		text(this.GENERATION, 40, 19);
	}

	public void displayHistory(){
		int yoff = 50;
		for(int i=this.PREVIOUS_GENERATIONS.size()-1; i>0; i--){
			Organism[] generation = this.PREVIOUS_GENERATIONS.get(i);

			for(int j=0; j<generation.length; j++){
				int x = 50 + j*21;
				int y = 10 + yoff;
				generation[j].display(x, y);
			}

			// display generation index
			fill(255);
			textAlign(RIGHT, CENTER);
			text(this.GENERATION - (this.PREVIOUS_GENERATIONS.size() - i), 40, yoff + 19);

			yoff+=21;
		}
	}
}