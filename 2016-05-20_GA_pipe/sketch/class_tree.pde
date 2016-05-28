public class Tree{

	private PApplet parent;
	private Frame frame;
	private int width, height;

	private Population population;
	private ArrayList<Organism> organisms;

	// -------------------------------------------------------------------------
	public Tree(PApplet parent, Population population, int width, int height){
		this.parent = parent;
		this.population = population;
		this.organisms = new ArrayList<Organism>();

		// this.frame = new Frame(this, this.width, this.height);
		this.frame = new Frame(this, 0);
		this.width = this.frame.getWidth();
		this.height = this.frame.getHeight();
	}



	// -------------------------------------------------------------------------
	// SETTER
	public Tree add(Organism o){
		this.organisms.add(o);

		// GRID
		// PGraphics pg = createGraphics(this.width, this.height);
		// 	pg.beginDraw();

		// 	int w = int(this.width/10),
		// 		h = int(this.height/5),
		// 		x = -w, y = 0;

		// 	for(int i=0; i<this.getOrganisms().size(); i++){
		// 		o = this.getOrganism(i);

		// 		x += w; if(x>this.width-w){ x = 0; y += h; }
		// 		pg.image(o.createThumbnail(w, h, 0.05), x, y);

		// 	}
		// 	pg.endDraw();

		// GENEALOGY
		PGraphics pg = createGraphics(this.width, this.height);
		pg.beginDraw();
			pg.background(0);
			pg.rotate(PI/2);
			pg.image(o.createThumbnail(this.height, this.width), 0, -this.width);
		pg.endDraw();


		this.frame.setG(pg);
		return this;
	}

	public Tree reset(){
		this.getOrganisms().clear();
		this.frame.setG(null);
		return this;
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Population getPopulation(){ return this.population; }

	public ArrayList<Organism> getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms.get(index); }

}