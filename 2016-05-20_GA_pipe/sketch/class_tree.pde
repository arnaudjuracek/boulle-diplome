public class Tree{

	private PApplet parent;
	private Frame frame;
	private int width, height;

	private Population population;
	private ArrayList<Organism> organisms;

	// -------------------------------------------------------------------------
	public Tree(PApplet parent, Population population){
		this.parent = parent;
		this.population = population;
		this.organisms = new ArrayList<Organism>();

		// this.frame = new Frame(this, 800, 400);
		this.frame = new Frame(this, 1);
		this.width = this.frame.getWidth();
		this.height = this.frame.getHeight();
	}



	// -------------------------------------------------------------------------
	// SETTER
	public Tree add(Organism o){
		this.organisms.add(o);
		this.frame.setG(this.render_familyTree(o));
		// this.frame.setG(this.render_grid(o));
		return this;
	}

	public Tree reset(){
		this.getOrganisms().clear();
		this.frame.setG(null);
		return this;
	}



	// -------------------------------------------------------------------------
	// RENDERERS
	private PGraphics render_grid(Organism o){
		PGraphics pg = createGraphics(this.width, this.height);
		pg.beginDraw();
		int w = int(this.width/10),
			h = int(this.height/5),
			x = -w, y = 0;
		for(int i=0; i<this.getOrganisms().size(); i++){
			x += w; if(x>this.width-w){ x = 0; y += h; }
			pg.image(this.getOrganism(i).createThumbnail(w, h), x, y);
		}
		pg.endDraw();
		return pg;
	}

	private PGraphics render_familyTree(Organism o){
		PGraphics pg = createGraphics(this.width, this.height);
		pg.beginDraw();
			pg.background(0);

			pg.rotate(-PI/2); pg.translate(-this.height, 0);
			// pg.rotate(PI/2); pg.translate(0, -this.width);

			if(this.getOrganisms().size()==1) pg.image(o.createThumbnail(this.height, this.width), 0, 0);
			else{
				this.place_strokes(this.getLastOrganism(), pg, this.height, this.width, true);
				this.place_organisms(this.getLastOrganism(), pg, this.height, this.width);
			}

		pg.endDraw();
		return pg;
	}

	private void place_strokes(Organism o, PGraphics pg, int w, int h, boolean is_left){
		h /= 2;
		if(min(h,w) > 10){ // PLACE NEW PARENTS ONLY IF BIG ENOUGH PLACE
			// DRAW CURRENT
				float
					offsetX = 0,
			 		offsetY = 0,
			 		size = min(w/2, h/2);

			 	// color c = this.getOrganisms().contains(o) ? color(200, 0, 100) : color(255);
			 	color c = color(255);

			 	pg.noFill();
			 	pg.strokeWeight(5);
			 	pg.stroke(c);

				pg.ellipse((w/2) + offsetX, (h+h/2) + offsetY, size, size);

				if(this.getLastOrganism() != o){
					pg.bezier(
						(w/2) + offsetX, offsetY + (h+h/2) + (size/2),
						(w/2) + offsetX, offsetY + (h*2),
						(is_left) ? (w + offsetX*2) : (offsetX*2), (offsetY*2) + (h*2),
						(is_left) ? (w + offsetX*2) : (offsetX*2), (offsetY*2) + (h*2 + h/2)
					);
				}

			// RECURSION !
				w /= 2;
				if(o.hasParents()){
					this.place_strokes(o.getParent(1), pg, w, h, true);
					pg.pushMatrix();
						pg.translate(w, 0);
						this.place_strokes(o.getParent(0), pg, w, h, false);
					pg.popMatrix();
				}
		}
	}

	private void place_organisms(Organism o, PGraphics pg, int w, int h){
		h /= 2;
		if(min(h,w) > 10){ // PLACE NEW PARENTS ONLY IF BIG ENOUGH PLACE
			// DRAW CURRENT
				pg.image(o.createThumbnail(w, h), 0, h);

			// RECURSION !
				w /= 2;
				if(o.hasParents()){
					this.place_organisms(o.getParent(1), pg, w, h);
					pg.pushMatrix();
						pg.translate(w, 0);
						this.place_organisms(o.getParent(0), pg, w, h);
					pg.popMatrix();
				}
		}
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Population getPopulation(){ return this.population; }

	public ArrayList<Organism> getOrganisms(){ return this.organisms; }
	public Organism getOrganism(int index){ return this.organisms.get(index); }
	public Organism getLastOrganism(){ return this.organisms.get(this.organisms.size()-1); }

}