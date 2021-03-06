public class Population{

	private Organism[] organisms, p_organisms;
	private float mutationRate, mutationAmp;
	private Selector selector;
	private int generation;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// Create a new population of *num* organisms
	// with an assigned mutation_rate
	public Population(int num, float mutation_rate, float mutation_amp){
		this.organisms = new Organism[num];
		// spawn a random pool of organisms
		for(int i=0; i<this.organisms.length; i++) this.organisms[i] = new Organism(this);
		this.p_organisms = this.organisms.clone();

		this.setMutationRate(mutation_rate);
		this.setMutationAmp(mutation_amp);


		this.selector = new Selector(this.organisms.length-1);
	}


	// -------------------------------------------------------------------------
	// SETTER
	public Population setMutationRate(float r){ this.mutationRate = r; return this; }
	public Population setMutationAmp(float a){ this.mutationAmp = a; return this; }

	public Population setOrganism(int index, Organism o){ this.organisms[index] = o; return this; }

	// -------------------------------------------------------------------------
	// GETTER
	public Selector getSelector(){ return this.selector; }

	public Organism[] getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms[index]; }
	public Organism getSelected(){ return this.getOrganism(this.getSelector().SELECTION); }

	public float getMutationRate(){ return this.mutationRate; }
	public float getMutationAmp(){ return this.mutationAmp; }
	public int getGeneration(){ return this.generation; }

	// -------------------------------------------------------------------------
	// MATING POOL REPRODUCTION :
	// reproduce the organisms placed in the mating pool between each others,
	// thus creating a new generation of the population
	private Population reproduce(Organism stallion){
		this.generation++;
		this.morph_counter = 0;
		this.p_organisms = this.getOrganisms().clone();

		for(int i=0; i<this.getOrganisms().length; i++){
			Organism o = this.getOrganism(i);
			if(o != stallion) o = o.cross(stallion, this.getMutationRate(), this.getMutationAmp());
			this.setOrganism(i, o);
		}

		return this;
	}


	// -------------------------------------------------------------------------
	// FILE
	public void export(String path, float shellThickness){
		char[] chars = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
		for(int i=0; i<this.getOrganisms().length; i++){
			String name = this.generation + "_" + chars[i];
			if(this.getOrganism(i)==this.getSelected()) name += "-stallion";
			this.getOrganism(i).getPipe().export(path, name, shellThickness);
		}
	}

	public void export(String path){ this.export(path, 10); }


	// -------------------------------------------------------------------------
	// UI handling
	private float morph_counter = 0, morph_duration = 120;

	public void display(float fromX, float targetX){
		float morph_t = 1 - pow(2, -10*(morph_counter++)/morph_duration);

		this.getSelector().update();
		for(int i=0; i<this.getOrganisms().length; i++){
			float x = map(i, 0, this.getOrganisms().length-1, fromX-width, targetX+width);

			pushMatrix();
				translate(x, 0, 0);
				rotateY((frameCount*.01)%TWO_PI);
				// if(this.getSelector().TRANSITION[i] > .01){
				// 	Vec3D size = this.getOrganism(i).getPipe().getAABB().getExtent();
				// 	pushMatrix();
				// 		translate(0, 600-this.getSelector().TRANSITION[i]*300, 0);
				// 		stroke(0, this.getSelector().TRANSITION[i]*255);
				// 		fill(255, this.getSelector().TRANSITION[i]*255);
				// 		box(size.x*2, this.getSelector().TRANSITION[i]*600, size.z*2);
				// 	popMatrix();
				// }
				translate(0, -this.getSelector().TRANSITION[i]*600, 0);
				this.getOrganism(i).display(this.p_organisms[i].getPipe().getMesh(), 1 - morph_t);
			popMatrix();
		}
	}

}