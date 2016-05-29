public class Cluster{

	private ArrayList<Organism> organisms;
	private PImage thumbnail;
	public boolean HOVER = false;

	// -------------------------------------------------------------------------
	public Cluster(Organism o){
		this.organisms = new ArrayList<Organism>();
		this.add(o);
		this.thumbnail = o.createThumbnail(TBN_WIDTH, TBN_HEIGHT);
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
		if(this.HOVER=is_hover(x,y)){
			strokeWeight(3);
			stroke(0);
			noFill();
			rect(x, y, this.getThumbnail().width, this.getThumbnail().height);
			image(this.getThumbnail(), x, y);
			textAlign(CENTER, CENTER);
			textSize(20);
			fill(0);
			text(this.getOrganisms().size(), x + this.getThumbnail().width/2, y + this.getThumbnail().height/2);
		}else image(this.getThumbnail(), x, y);
	}

	public boolean is_hover(int x, int y){
		return (mouseX > x && mouseX < x + this.getThumbnail().width && mouseY > y && mouseY < y + this.getThumbnail().height);
	}

}