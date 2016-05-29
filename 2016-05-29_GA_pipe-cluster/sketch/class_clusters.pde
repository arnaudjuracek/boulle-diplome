public class Clusters{

	private Organism[] organisms;
	private Organism current;
	private int current_index = -1;
	private ArrayList<Cluster> clusters;

	// -------------------------------------------------------------------------
	public Clusters(Organism[] organisms){
		this.organisms = organisms;
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
	public Organism getNextOrganism(){
		if(this.current_index++ < this.organisms.length-1) return this.organisms[this.current_index];
		else return null;
	}
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
			c.display(x, y);
			if((x+=TBN_WIDTH)>width-TBN_WIDTH){
				x = 0;
				y += TBN_HEIGHT;
			}
		}
	}

	public void displayAll(int w, int h){
		noLoop();
		int x = 0;
		int y = 0;
		for(Cluster c : this.getClusters()){
			for(Organism o : c.getOrganisms()){
				image(o.createThumbnail(w, h), x, y);
				if((x+=w)>width-w){
					x = 0;
					y += h;
				}
			}
		}
	}

}