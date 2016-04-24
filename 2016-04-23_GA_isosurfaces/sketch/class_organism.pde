public class Organism{
	public Dna DNA;
	public float FITNESS;
	public boolean HOVER;

	private PShape SHAPE;
	private WETriangleMesh MESH;

	// -------------------------------------------------------------------------
	// Constructor :
	// initialize fitness to 1
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		this.OPTS_define();
		this.SHAPE = this.create_shape();
	}


	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	private int
		OPT_numParticles = 200,
		OPT_size = 600,
		OPT_resolution = 20;
	private float
		OPT_isoThreshold = 7;
	private Vec3D
		OPT_cAmp = new Vec3D(255, 255, 255);

	private void OPTS_define(){
		this.OPT_resolution = (int) 20;
		// this.OPT_resolution = (int) this.DNA.next_gene(10, 30);
		// this.OPT_isoThreshold = (float) this.DNA.next_gene(1, 20); //7;
	}

	// -------------------------------------------------------------------------
	// ORGANISM'S SHAPE :
	// populate an array of particles, then compute this array as an isosurface
	// mesh casted in a defined volumetric space, then convert this mesh into
	// a 3D PShape, and return this PShape.
	private PShape create_shape(){
		ArrayList<Vec3D> particles = new ArrayList<Vec3D>();
		for(int i=0; i<this.OPT_numParticles; i++){
			// particles.add(Vec3D.randomVector().scale(this.OPT_size/3));
			Vec3D v = new Vec3D(
							this.DNA.next_gene(-this.OPT_size/3, this.OPT_size/3),
							this.DNA.next_gene(-this.OPT_size/3, this.OPT_size/3),
							this.DNA.next_gene(-this.OPT_size/3, this.OPT_size/3)
						);
			particles.add(v);
		}

		WETriangleMesh mesh = this.computeSurfaceMesh(
								particles,
								new VolumetricSpaceArray(
									new Vec3D(this.OPT_size, this.OPT_size, this.OPT_size),
									this.OPT_resolution,
									this.OPT_resolution,
									this.OPT_resolution
								),
								this.OPT_isoThreshold
							);

		this.MESH = mesh;
		return this.meshToPShape(mesh);
	}



	// -------------------------------------------------------------------------
	// ISOSURFACE COMPUTATION :
	// Take an array of Vec3D particles and return an isosurface mesh of it
	// the isosurface is applied with a threshold,
	// and takes place in a predefined volumetric space array (aka voxels)
	private WETriangleMesh computeSurfaceMesh(ArrayList<Vec3D> particles, VolumetricSpaceArray volume, float isoThreshold){
		WETriangleMesh mesh = new WETriangleMesh();
		IsoSurface surface = new ArrayIsoSurface(volume);

		float voxelsize = this.OPT_size/this.OPT_resolution;
		Vec3D pos = new Vec3D();
		float[] volumeData = volume.getData();

		for(int z=int(-this.OPT_resolution/2), index=0; z<(this.OPT_resolution/2); z++, pos.z = z*voxelsize){
			for(int y=int(-this.OPT_resolution/2); y<(this.OPT_resolution/2); y++, pos.y = y*voxelsize){
				for(int x=int(-this.OPT_resolution/2); x<(this.OPT_resolution/2); x++, pos.x = x*voxelsize){
					float val = 0;
					for(int i=0; i<particles.size(); i++){
						Vec3D p = (Vec3D) particles.get(i);
						float mag = pos.distanceToSquared(p) + .00001;
						val += 1/mag;
						if((1/mag)>val) val = 1/mag;
					}

					volumeData[index++] = val;
				}
			}
		}

		volume.closeSides();
		surface.reset();
		surface.computeSurfaceMesh(mesh, isoThreshold*0.001);

		return mesh;
	}



	// -------------------------------------------------------------------------
	// MESH TO PSHAPE CONVERSION :
	// Take a mesh and return a 3D PShape with normals
	PShape meshToPShape(WETriangleMesh mesh){
		int num = mesh.getNumFaces();
		mesh.computeVertexNormals();
		mesh.computeFaceNormals();

		PShape s = createShape();
		s.beginShape(TRIANGLE);
		s.stroke(255, 10);
		for(int i=0; i<num; i++){
			Face f = mesh.faces.get(i);
			Vec3D c = f.a.add(this.OPT_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.a.normal.x, f.a.normal.y, f.a.normal.z);
				s.vertex(f.a.x, f.a.y, f.a.z);

			c = f.b.add(this.OPT_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.b.normal.x, f.b.normal.y, f.b.normal.z);
				s.vertex(f.b.x, f.b.y, f.b.z);

			c = f.c.add(this.OPT_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.c.normal.x, f.c.normal.y, f.c.normal.z);
				s.vertex(f.c.x, f.c.y, f.c.z);
		}
		s.endShape();
		return s;
	}



	// -------------------------------------------------------------------------
	// EXPORT HANDLING
	// save the mesh as OBJ and STL on a specified path
	boolean export(String path){
		this.MESH.saveAsOBJ(path + ".obj");
		this.MESH.saveAsSTL(path + ".stl");
		return true;
	}



	// -------------------------------------------------------------------------
	// UI handling
	// display the Organism's PShape and fitness score, with some easing,
	// scaling and misc eye candies
	private float tv = 1, v = 1, easing = .09, counter = frameCount*.01;

	public void display(int x, int y){
		// update frameCounter, hover state and eased value
		counter+=.01;
		this.HOVER =  this.is_hover(x,y);
		v += ((this.HOVER ? 2 : 1) - v)*easing;

		pushMatrix();
			translate(x,y, int(this.HOVER)*200);
			rotateX(PI/3);

			pushMatrix();
				rotateX(PI);
				lights();
			popMatrix();

			pushMatrix();
				rotateZ(counter);

				// bounding box
				noFill();
				stroke(255, map(v,1,2,0,100));
				if(this.HOVER) box(map(v,1,2,0,300), map(v,1,2,0,300), map(v,1,2,0,300));

				// shape
				scale(map(v,1,2,150,300)/this.OPT_size);
				if(this.SHAPE != null) shape(this.SHAPE, 0, 0);
			popMatrix();
		popMatrix();
	}

	public void displayFitness(int x, int y){
		hint(DISABLE_DEPTH_TEST);
			pushStyle();
				fill(0, map(v, 1, 2, 255*.4, 255*.9));
				noStroke();
				float r = sqrt(map(this.FITNESS, 0, 100, sq(40 + v*10), sq(60 + v*20)));
				ellipse(x,y,r,r);
			popStyle();

			fill(255, map(v, 1, 2, 255*.6, 255*.9));
			textAlign(CENTER, CENTER);
			text(int(this.FITNESS) + "%", x, y-1);
		hint(ENABLE_DEPTH_TEST);
	}

	public boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}