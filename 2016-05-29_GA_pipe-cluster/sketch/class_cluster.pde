public class Cluster{

	private ArrayList<Organism> organisms;
	private PImage thumbnail;
	public boolean HOVER = false;

	// -------------------------------------------------------------------------
	public Cluster(Organism o){
		this.organisms = new ArrayList<Organism>();
		this.add(o);
		this.thumbnail = o.createThumbnail(200, 200);
	}



	// -------------------------------------------------------------------------
	public Cluster add(Organism o){ this.organisms.add(o); return this; }


	// -------------------------------------------------------------------------
	// GETTER
	public ArrayList<Organism> getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms.get(index); }

	public PImage getThumbnail(){ return this.thumbnail; }

	// -------------------------------------------------------------------------
	// UI handling
	public void display(int x, int y){
		this.HOVER = is_hover(x, y);
		image(this.getThumbnail(), x, y);

		// println(this.getOrganisms().size());
	}

	public boolean is_hover(int x, int y){
		return (mouseX > x && mouseX < x + this.getThumbnail().width && mouseY > y && mouseY < y + this.getThumbnail().height);
	}

}