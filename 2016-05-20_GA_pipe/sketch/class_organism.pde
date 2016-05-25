public class Organism{

	private Dna dna;
	private Organism[] parents;
	private Pipe pipe;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// define parents, translate genotype onto phenotype
	public Organism(Dna dna, Organism mom, Organism dad){
		this.dna = dna;
		this.parents = new Organism[2];
		this.parents[0] = mom;
		this.parents[1] = dad;

		// map GENES to phenotype
		this.P_define();

	}

	public Organism(Dna dna){ this(dna, null, null); }
	public Organism(){ this(new Dna(), null, null); }

	public Organism cross(Organism o, float mutationRate, float mutationAmp){
		// Mate their genes into a child, then mutate it
		Dna childDNA = this.getDna().recombinate(o.getDna());
		childDNA.mutate(mutationRate, mutationAmp);

		return new Organism(childDNA, this, o);
	}



	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	// private color P_color;
	// private int P_size = 20;

	private void P_define(){
		this.pipe = new Pipe(
			new Path(
				new Vec3D[]{
					new Vec3D(0, height, 0),
					new Vec3D(0, -height, 0),
					new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
					new Vec3D(random(-width, width), random(-height, height), random(-width, width))
				}, .9
			),
			// new Curve(new Wave(Wave.FMSQUAREWAVE, 0, .2f, 0, 300, 50).getValues(), .9),
			new Curve(
				new Wave(
					new Wave().create(Wave.FMSINEWAVE, 0, .1f, new Wave().create(Wave.FMSAWTOOTHWAVE, 0, .5f, null)),
					0, 600, 50
				).getValues(), .9),
			new Curve(10),
			// new Curve(new Wave(Wave.FMSINEWAVE, 0, .1f, 3, 5, 50).getValues(), .6),
			50
		);
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Dna getDna(){ return this.dna; }
	public Organism[] getParents(){ return this.parents; }
	public Pipe getPipe(){ return this.pipe; }

	// -------------------------------------------------------------------------
	// UI handling
	public void display(){
		Pipe pipe = this.getPipe();

		if(D_PATH){
			stroke(0);
			for(int i=0; i<pipe.getPath().getPoints().length-1; i++){
				Vec3D a = pipe.getPath().getPoint(i);
				Vec3D b = pipe.getPath().getPoint(i+1);
				strokeWeight(1);
				line(a.x, a.y, a.z, b.x, b.y, b.z);
				strokeWeight(11);
				point(a.x, a.y, a.z);
			}
			point(pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).x, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).y, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).z);

			stroke(200, 0, 100);
			for(int i=0; i<pipe.getPath().getOriginalPoints().length-1; i++){
				Vec3D a = pipe.getPath().getOriginalPoint(i);
				Vec3D b = pipe.getPath().getOriginalPoint(i+1);
				strokeWeight(1);
				line(a.x, a.y, a.z, b.x, b.y, b.z);
				strokeWeight(10);
				point(a.x, a.y, a.z);
			}
			point(pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).x, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).y, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).z);

		}else if(D_WIREFRAME && !D_NORMAL){
			strokeWeight(1);
			stroke(0, 50);
			noFill();
			gfx.mesh(pipe.getMesh(), false);
		}else if(D_NORMAL){
			gfx.meshNormalMapped(pipe.getMesh(), true, 100);
		}else if(D_TEX){
			noStroke();
			fill(255);
			gfx.mesh(pipe.getMesh(), true);
			// gfx.texturedMesh(pipe.getMesh(), get(), true);
		}else{
			noStroke();
			fill(255);
			gfx.mesh(pipe.getMesh(), true);
		}

	}

}