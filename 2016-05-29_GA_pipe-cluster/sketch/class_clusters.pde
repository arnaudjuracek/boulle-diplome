public class Clusters{

	private Organism[] organisms;
	private Organism current;
	private int current_index = 0;
	private ArrayList<Cluster> clusters;

	// -------------------------------------------------------------------------
	public Clusters(Population population){
		this.organisms = population.getOrganisms();
		this.clusters = new ArrayList<Cluster>();
		this.current = this.getNextOrganism();

		this.createNewCluster(this.current);
	}



	// -------------------------------------------------------------------------
	public Clusters addTo(Organism o, Cluster c){
		c.add(o);
		this.current = this.getNextOrganism();
		return this;
	}

	public Clusters createNewCluster(Organism o){
		this.clusters.add(new Cluster(o));
		this.current = this.getNextOrganism();
		return this;
	}

	// -------------------------------------------------------------------------
	// GETTER
	public Organism[] getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms[index]; }
	public Organism getFirstOrganism(){ return this.organisms[0]; }
	public Organism getNextOrganism(){ return this.organisms[(this.current_index++)]; }
	public Organism getLastOrganism(){ return this.organisms[this.organisms.length-1]; }
	public Organism getRandomOrganism(){ return this.organisms[int(random(this.organisms.length))]; }
	public Organism getCurrent(){ return this.current; }

	public ArrayList<Cluster> getClusters(){ return this.clusters; }
	public Cluster getCluster(int index){ return this.clusters.get(index); }



	// -------------------------------------------------------------------------
	// UI handling
	public void displayCurrent(){
		this.getCurrent().display(this.getCurrent().getPipe().getMesh(), 0);
	}

	public void displayClusters(){
		int x = 0;
		int y = 0;
		for(int i=0; i<this.getClusters().size(); i++){
			Cluster c = this.getCluster(i);
			if((x+=200)>=width-200){
				x = 0;
				y += 200;
			}
			c.display(x, y);
		}
	}

}