public class Population{

	private Organism[] organisms;
	private float mutationRate, mutationAmp;

	private ArrayList<Organism> MATING_POOL = new ArrayList<Organism>();

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// Create a new population of *num* organisms
	// with an assigned mutation_rate
	public Population(int num, float mutation_rate, float mutation_amp){
		this.organisms = new Organism[num];

		this.setMutationRate(mutation_rate);
		this.setMutationAmp(mutation_amp);

		// spawn a random pool of organisms
		for(int i=0; i<this.organisms.length; i++) this.organisms[i] = new Organism();
	}


	// -------------------------------------------------------------------------
	// SETTER
	public Population setMutationRate(float r){ this.mutationRate = r; return this; }
	public Population setMutationAmp(float a){ this.mutationAmp = a; return this; }

	public Population setOrganism(int index, Organism o){ this.organisms[index] = o; return this; }

	// -------------------------------------------------------------------------
	// GETTER
	public Organism[] getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms[index]; }

	public float getMutationRate(){ return this.mutationRate; }
	public float getMutationAmp(){ return this.mutationAmp; }



	// -------------------------------------------------------------------------
	// MATING POOL REPRODUCTION :
	// reproduce the organisms placed in the mating pool between each others,
	// thus creating a new generation of the population
	private Population reproduce(Organism stallion){

		for(int i=0; i<this.getOrganisms().length; i++){
			Organism o = this.getOrganism(i);
			if(o != stallion) o = o.cross(stallion, this.getMutationRate(), this.getMutationAmp());
			this.setOrganism(i, o);
		}

		// this.GENERATION++;

		return this;
	}



	// -------------------------------------------------------------------------
	// UI handling

	public void display(Vec3D from, Vec3D target){
		for(int i=0; i<this.getOrganisms().length; i++){
			Vec3D p = from.interpolateTo(target, norm(i, 0, this.getOrganisms().length-1));
			pushMatrix();
				translate(p.x, p.y, p.z);
				this.getOrganism(i).display();
			popMatrix();
		}
	}

	public void display(float x1, float y1, float z1, float x2, float y2, float z2){
		this.display(new Vec3D(x1, y1, z1), new Vec3D(x2, y2, z2));
	}

}