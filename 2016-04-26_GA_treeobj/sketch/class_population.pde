public class Population{
	public Organism[] ORGANISMS;
	public ArrayList<Organism> MATING_POOL;
	public float MUTATION_RATE;

	public int GENERATION;
	public ArrayList<Organism[]> PREVIOUS_GENERATIONS;
	public int MAX_HISTORY_STATES = 0;

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

		// throw warning if too many unecessary genes
		int record = 0;
		for(Organism o : this.ORGANISMS) if(o.DNA.ITERATOR > record) record = o.DNA.ITERATOR;
		if(record < this.ORGANISMS[0].DNA.GENES_LENGTH) println("Max Genes needed : " + record);
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
			// the child know who its dad and mom are
			this.ORGANISMS[i] = new Organism(childDNA, mom, dad);
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
	// Find highest fitness for the population
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
	public boolean VIEW_MODE_SOLO = false;
	public boolean SHOW_INFO = false;

	public void display(){
		int
			index = 0,
			margin = 150,
		 	size = ceil(sqrt(this.ORGANISMS.length));

		for(int cols=0; cols<size; cols++){
			for(int rows=0; rows<size; rows++){
				Organism o = this.ORGANISMS[index++];
				int
					x = int(map(cols, 0, size-1, margin, width - margin)),
					y = int(map(rows, 0, size-1, margin, height - margin));


				o.HOVER = o.is_hover(x,y);
				if(!this.VIEW_MODE_SOLO || (this.VIEW_MODE_SOLO && o.HOVER)){
					o.display(x,y);
					if(!this.VIEW_MODE_SOLO && (o.HOVER || o.FITNESS > 1)) o.displayFitness(x,y);
				}

				if(this.SHOW_INFO && o.HOVER) o.displayInformations(x,y);
			}
		}
	}

	public void displayHistory(){
		// no history (yet ?)
	}
}