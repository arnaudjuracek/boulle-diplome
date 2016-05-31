// public static final char[] alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
public static final String[] alphabet = {
	"ba", "be", "bi", "bo", "bu", "by",
	"ca", "ce", "ci", "co", "cu", "cy",
	"da", "de", "di", "do", "du", "dy",
	"fa", "fe", "fi", "fo", "fu", "fy",
	"ga", "ge", "gi", "go", "gu", "gy",
	"ha", "he", "hi", "ho", "hu", "hy",
	"ja", "je", "ji", "jo", "ju", "jy",
	"ka", "ke", "ki", "ko", "ku", "ky",
	"la", "le", "li", "lo", "lu", "ly",
	"ma", "me", "mi", "mo", "mu", "my",
	"na", "ne", "ni", "no", "nu", "ny",
	"pa", "pe", "pi", "po", "pu", "py",
	"qua", "que", "qui", "quo", "qu",
	"ra", "re", "ri", "ro", "ru", "ry",
	"sa", "se", "si", "so", "su", "sy",
	"ta", "te", "ti", "to", "tu", "ty",
	"va", "ve", "vi", "vo", "vu", "vy",
	"za", "ze", "zi", "zo", "zu", "zy",

	"pha", "phe", "phi", "pho", "phu",
	"cha", "che", "chi", "cho", "chu",
	"cla", "cle", "cli", "clo", "clu",
	"sta", "ste", "sti", "sto", "stu",
	"psa", "pse", "psi", "pso", "psu",
	"fla", "fle", "fli", "flo", "flu"
};

public class Organism{

	private Population population;
	private Dna dna;
	private Organism[] parents;
	private Pipe pipe;
	private String name;
	private Material material;

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
		this.name = this.createName();
		this.material = this.createMaterial();
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
			Vec3D[] path = new Vec3D[4];
			for(int i=0; i<path.length; i++) path[i] = new Vec3D(
															int(i>1) * (this.getDna().getNextGene(0, 100)*sin(random(TWO_PI))),
															map(i, 0, path.length, height, -height*2),
															int(i>1) * (this.getDna().getNextGene(0, 100)*sin(random(TWO_PI)))
														);

			this.pipe = new Pipe(
				new Path(path, this.getDna().getNextGene(0, .9)),
				new Curve(this.getDna().getNextGene(50, 200), this.getDna().getNextGene(200, 400), V_RESOLUTION).smooth(this.getDna().getNextGene(0, .9)),
				new Curve(3, U_RESOLUTION, V_RESOLUTION).smooth(this.getDna().getNextGene(0, .9))
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
			Curve sides = dad.getSidesLengthCurve().cross( (Curve) mom.getSidesLengthCurve() ).mutate(mutationRate, mutationAmp);

			this.pipe = new Pipe(
				new Path( path, this.getDna().getNextGene(0, .9) ),
				(this.getDna().getNextGene() < MUTATION_RATE*.1)
					? new Curve(this.getDna().getNextGene(50, 200), this.getDna().getNextGene(200, 400), V_RESOLUTION).smooth(this.getDna().getNextGene(0, .9))
					: radiuses.smooth(this.getDna().getNextGene(0, .9)),
				(this.getDna().getNextGene() < MUTATION_RATE*.1)
					? new Curve(3, U_RESOLUTION, V_RESOLUTION).smooth(this.getDna().getNextGene(0, .9))
					: sides.smooth(this.getDna().getNextGene(0, .9))
			);
		}
	}

	private String createName(){
		// this.getDna().getNextGene(); // this gene is used for the 6th letter of the name
		String name = "";
		for(int i=0; i<3; i++){
			name += alphabet[int(this.getDna().getNextGene(0, alphabet.length-1))];
		}
		name = name.substring(0, 1).toUpperCase() + name.substring(1);

		return name;
	}

	private Material createMaterial(){
		float[] material_genes = new float[6];
		for(int i=0; i<material_genes.length; i++)
			material_genes[i] = this.getDna().getNextGene(0,1);

		return new Material(material_genes);
	}



	// -------------------------------------------------------------------------
	// GETTER
	public Population getPopulation(){ return this.population; }
	public Dna getDna(){ return this.dna; }
	public String getName(){ return this.name; }
	public Material getMaterial(){ return this.material; }

	public Organism[] getParents(){ return this.parents; }
	public Organism getParent(int index){ return this.parents[index]; }
	public boolean hasParents(){ return (this.getParents()!=null && this.getParent(0)!=null && this.getParent(1)!=null); }

	public Pipe getPipe(){ return this.pipe; }



	// -------------------------------------------------------------------------
	// FILE
	public void export(String path, float shellThickness){
		this.getPipe().export(path, this.getName().toLowerCase(), shellThickness);
		println("===");
		println(this.getName() + " :");
		println(this.getMaterial().getStr());
		println("===");
	}

	public void export(float shellThickness){ this.export(sketchPath("export/"), shellThickness); }



	// -------------------------------------------------------------------------
	// UI handling
	public void display(TriangleMesh p_mesh, float t){
		Pipe pipe = this.getPipe();
		TriangleMesh mesh = pipe.morphTo(p_mesh, t);

		if(D_PATH){
			stroke(int(!D_BGWHITE)*255);
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
			stroke(int(!D_BGWHITE)*255, 50);
			noFill();
			gfx.mesh(mesh, false);
		}else if(D_NORMAL){
			strokeWeight(1);
			gfx.meshNormalMapped(mesh, true, 100);
		}else if(D_TEX){
			noStroke();
			fill(255);
			gfx.texturedMesh(mesh, TEX, true);
		}else{
			noStroke();
			fill(255);
			gfx.mesh(mesh, true);
		}
	}

	public PImage createThumbnail(int width, int height){
		float
			s = min(height, width) / (this.getPipe().getBoundingSphere().radius*2);
			s -= s*.15;

		PGraphics _g = createGraphics(width, height, OPENGL);
		ToxiclibsSupport _gfx = new ToxiclibsSupport(PAPPLET, _g);
		TriangleMesh mesh = this.getPipe().getMesh();
		_g.beginDraw();
			_g.ambientLight(127, 127, 127);
			_g.textureMode(NORMAL);
			_g.directionalLight(127, 127, 127, 0, 1, 1);

			_g.translate(_g.width/2, _g.height/2, 0);
			_g.scale(s);

			_g.noStroke();
			_g.fill(255);
			_gfx.texturedMesh(mesh, TEX, true);
		_g.endDraw();

		PGraphics pg = createGraphics(_g.width, _g.height);
		pg.beginDraw();
			pg.image(_g.get(), 0, 0);
		pg.endDraw();
		return pg.get();
	}

}