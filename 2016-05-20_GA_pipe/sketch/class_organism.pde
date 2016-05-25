public class Organism{

	private Population population;
	private Dna dna;
	private Organism[] parents;
	private Pipe pipe;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// define parents, translate genotype onto phenotype
	public Organism(Population pop, Dna dna, Organism mom, Organism dad){
		this.population = pop;
		this.dna = dna;
		this.parents = new Organism[2];
		this.parents[0] = mom;
		this.parents[1] = dad;

		// map GENES to phenotype
		this.P_define();

	}

	public Organism(Population pop, Dna dna){ this(pop, dna, null, null); }
	public Organism(Population pop){ this(pop, new Dna(), null, null); }

	public Organism cross(Organism o, float mutationRate, float mutationAmp){
		// Mate their genes into a child, then mutate it
		Dna childDNA = this.getDna().recombinate(o.getDna());
		childDNA.mutate(mutationRate, mutationAmp);

		return new Organism(this.getPopulation(), childDNA, this, o);
	}



	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	// private color P_color;
	// private int P_size = 20;

	private void P_define(){
		if(this.getParent(0) == null || this.getParent(1) == null){
			this.pipe = new Pipe(
				new Path(
					new Vec3D[]{
						new Vec3D(0, height, 0),
						new Vec3D(0, -height, 0),
						new Vec3D(random(-200, 200), -height*1.5, random(-200, 200)),
					}, this.getDna().getNextGene(0, 1)
				),
				new Curve(
					new Wave(
						int(random(0, 4)),
						random(0, 100),
						random(100, 600),
						V_RESOLUTION
					).getValues(), this.getDna().getNextGene(0, 1)),
				new Curve(
					new Wave(
						int(random(0, 4)),
						random(3, 5),
						random(5, U_RESOLUTION),
						V_RESOLUTION
					).getValues(), this.getDna().getNextGene(0, 1))
			);
		}else{
			Pipe
				dad = this.getParent(0).getPipe(),
				mom = this.getParent(1).getPipe();

			float
				mutationRate = this.getPopulation().getMutationRate(),
				mutationAmp = this.getPopulation().getMutationAmp();

			Vec3D[] path =
				dad.getPath().cross( (Path) mom.getPath() )
					.mutate(mutationRate, mutationAmp)
					.getOriginalPoints();

			Curve radiuses = dad.getRadiusesCurve().cross( (Curve) mom.getRadiusesCurve() ).mutate(mutationRate, mutationAmp);
			if(random(1) < mutationRate) radiuses = new Curve(new Wave(int(random(0, 4)), random(0, 100), random(100, 600), V_RESOLUTION ).getValues());

			Curve sides = dad.getSidesLengthCurve().cross( (Curve) mom.getSidesLengthCurve() ).mutate(mutationRate, mutationAmp);

			this.pipe = new Pipe(
				new Path( path, this.getDna().getNextGene(.1, 1) ),
				radiuses.smooth(this.getDna().getNextGene(0, 1)),
				sides.smooth(this.getDna().getNextGene(0, 1))
			);
		}
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Population getPopulation(){ return this.population; }
	public Dna getDna(){ return this.dna; }
	public Organism[] getParents(){ return this.parents; }
	public Organism getParent(int index){ return this.parents[index]; }
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
			strokeWeight(1);
			gfx.meshNormalMapped(pipe.getMesh(), true, 100);
		}else if(D_TEX){
			noStroke();
			fill(255);
			gfx.texturedMesh(pipe.getMesh(), TEX, true);
		}else{
			noStroke();
			fill(255);
			gfx.mesh(pipe.getMesh(), true);
		}

	}

}