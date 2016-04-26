public class Organism{
	public Dna DNA;
	public Organism[] PARENTS;
	public float FITNESS;
	public boolean HOVER;

	private PShape SHAPE;
	private WETriangleMesh MESH;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// initialize fitness to 1
	// set parents to null
	// translate genotype onto phenotype
	public Organism(Dna dna){
		this.DNA = dna;
		this.FITNESS = 1;

		this.PARENTS = new Organism[2];
		this.PARENTS[0] = null;
		this.PARENTS[1] = null;

		this.P_define();
	}

	// CONSTRUCTOR :
	// initialize fitness to 1
	// define parents
	// translate genotype onto phenotype
	public Organism(Dna dna, Organism mom, Organism dad){
		this.DNA = dna;
		this.FITNESS = 1;

		this.PARENTS = new Organism[2];
		this.PARENTS[0] = mom;
		this.PARENTS[1] = dad;

		this.P_define();
	}


	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	private int
		P_numParticles = 200,
		P_size = 600,
		P_resolution = 20;
	private float
		P_isoThreshold = 7,
		P_volumetricSpaceScale = 1.25;
	private Vec3D
		P_cAmp = new Vec3D(300, 255, 300),
		P_evolvingDirection = new Vec3D(0, 0, 0);
	private ArrayList<Vec3D>
		P_particles = new ArrayList<Vec3D>(),
		P_neg_particles = new ArrayList<Vec3D>();

	private void P_define(){
		this.P_evolvingDirection = new Vec3D(
										this.DNA.next_gene(-this.P_size, this.P_size),
										this.DNA.next_gene(-this.P_size, this.P_size),
										this.DNA.next_gene(-this.P_size, this.P_size)
									);
		// this.P_resolution = (int) this.DNA.next_gene(10, 50);
		this.P_resolution *= this.P_volumetricSpaceScale;
		// fix weird bug with ODD resolutions
		if(this.P_resolution%2!=0) this.P_resolution++;

		// this.P_isoThreshold = (float) this.DNA.next_gene(5, 20);

		this.SHAPE = this.buildShape();
	}

	// -------------------------------------------------------------------------
	// ORGANISM'S SHAPE :
	// populate an array of particles, then compute this array as an isosurface
	// mesh casted in a defined volumetric space, then convert this mesh into
	// a 3D PShape, and return this PShape.
	private PShape buildShape(){
		// PARTICLES SYSTEM
			this.P_particles = this.spawnParticles();

		// ISOSURFACE COMPUTATION
			WETriangleMesh mesh = this.computeSurfaceMesh(
									this.P_particles,
									new VolumetricSpaceArray(
										new Vec3D(this.P_size*this.P_volumetricSpaceScale, this.P_size*this.P_volumetricSpaceScale, this.P_size*this.P_volumetricSpaceScale),
										this.P_resolution, this.P_resolution, this.P_resolution
									),
									this.P_isoThreshold
								);

			// // sphere substraction ?
			// // Vec3D sphereCenterPoint = new Vec3D(random(this.P_size/2), random(this.P_size/2), random(this.P_size/2));
			// Vec3D sphereCenterPoint = new Vec3D(0,0,0);
			// float sphereRadius = 200; //random(this.P_size);
			// Sphere sphere = new Sphere(sphereCenterPoint, sphereRadius);
			// // ArrayList<Vec3D> vertices = new ArrayList<Vec3D>();
			// for(Vec3D v : mesh.vertices.values()){
			// 	if(sphere.containsPoint(v)){
			// 		float d = norm(v.distanceTo(sphereCenterPoint), 0, sphereRadius);
			// 		v.interpolateToSelf(sphereCenterPoint, d-1);
			// 		// v.clear();
			// 	}
    		// }


			// float m = this.DNA.next_gene();
			// if(m < .5){
			// 	// HEM_Lattice mod = new HEM_Lattice();
			// 	// 	mod.setDepth(1);
			// 	// 	mod.setWidth(m*10);
			// 	HEM_Twist mod = new HEM_Twist();
			// 		mod.setAngleFactor(radians(m*45));
			// 		mod.setTwistAxis(new WB_Line(0,0,0, 0,0,1));

			// // 	HEM_Stretch mod2 = new HEM_Stretch();
			// // 			mod2.setGroundPlane(0,0,0, 0,0,1);
			// // 			mod2.setStretchFactor(2);
			// // 			mod2.setCompressionFactor(1);
			// 	mesh = hemeshToToxi( toxiToHemesh(mesh).modify(mod) ).toWEMesh();
			// }

		// ISOSURFACE CONVERSION
			this.MESH = mesh;

		return this.meshToPShape(mesh);
	}



	// -------------------------------------------------------------------------
	// PARTICLES HANDLING :
	// take this organism's parent's particles, mix them together
	// using a segment swapping technic, then add some new particles
	private ArrayList<Vec3D> spawnParticles(){
		ArrayList<Vec3D> particles = new ArrayList<Vec3D>();

		if(this.PARENTS[0] == null || this.PARENTS[1] == null){
			// Create a whole new array of particles
				Vec3D spreader = new Vec3D(
									this.DNA.next_gene(0, this.P_size/2),
									this.DNA.next_gene(0, this.P_size/2),
									this.DNA.next_gene(0, this.P_size/2)
								);

				for(int i=0; i<this.P_numParticles; i++){
					Vec3D v = Vec3D.randomVector().scale(spreader);
					// Vec3D v = new Vec3D( this.DNA.next_gene(-this.P_size/3, this.P_size/3), this.DNA.next_gene(-this.P_size/3, this.P_size/3), this.DNA.next_gene(-this.P_size/3, this.P_size/3) );
					particles.add(v);
				}
		}else{
			// Mix the particles of this organism's two parents
			// using a segment swapping technic
				int r = int(random(this.P_numParticles));
				for(int i=0; i<this.PARENTS[0].P_particles.size(); i++){
					if(i>r) particles.add(this.PARENTS[0].P_particles.get(i));
					else particles.add(this.PARENTS[1].P_particles.get(i));
				}

			// Create a line of particles from Vec3D from to Vec3D P_evolvingDirection
				Vec3D centroid = new Vec3D(0,0,0);
				for(Vec3D v : particles) centroid.addSelf(v);
				centroid.scaleSelf(1/particles.size());

				if(centroid.distanceTo(P_evolvingDirection) > this.P_size/2){

					Vec3D from = particles.get(int(random(particles.size())));
					float dist = from.distanceTo(P_evolvingDirection);
					float jitter = sqrt(this.DNA.next_gene(0, sq(20)));
					for(int i=0; i<dist; i+=20){
						Vec3D v = from.interpolateTo(P_evolvingDirection, norm(i, 0, from.distanceTo(P_evolvingDirection)));
						particles.add(v);
						v.jitter(jitter);
					}

				}

			// int start = int(this.DNA.next_gene(0, particles.size())),
			// 	end = int(this.DNA.next_gene(start, particles.size()));

			// for(int i=start; i<end; i++){
			// 	Vec3D p = particles.get(i);
			// 	p.shuffle(3);
			// }
		}

		return particles;
	}



	// -------------------------------------------------------------------------
	// ISOSURFACE COMPUTATION :
	// Take an array of Vec3D particles and return an isosurface mesh of it
	// the isosurface is applied with a threshold,
	// and takes place in a predefined volumetric space array (aka voxels)
	private WETriangleMesh computeSurfaceMesh(ArrayList<Vec3D> particles, VolumetricSpaceArray volume, float isoThreshold){
		WETriangleMesh mesh = new WETriangleMesh();
		IsoSurface surface = new HashIsoSurface(volume);

		float voxelsize = (float) (this.P_size/this.P_resolution)*this.P_volumetricSpaceScale;
		Vec3D pos = new Vec3D();
		float[] volumeData = volume.getData();

		for(int z=int(-this.P_resolution/2), index=0; z<(this.P_resolution/2); z++){
			pos.z = z*voxelsize;
			for(int y=int(-this.P_resolution/2); y<(this.P_resolution/2); y++){
				pos.y = y*voxelsize;
				for(int x=int(-this.P_resolution/2); x<(this.P_resolution/2); x++){
					pos.x = x*voxelsize;

					float val = 0;
					for(Vec3D p : particles){
						float mag = pos.distanceToSquared(p) + .00001;
						val += 1/mag;
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
	private PShape meshToPShape(WETriangleMesh mesh){
		int num = mesh.getNumFaces();
		mesh.computeVertexNormals();
		mesh.computeFaceNormals();

		PShape s = createShape();
		s.beginShape(TRIANGLE);
		s.stroke(255, 10);
		for(int i=0; i<num; i++){
			Face f = mesh.faces.get(i);
			Vec3D c = f.a.add(this.P_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.a.normal.x, f.a.normal.y, f.a.normal.z);
				s.vertex(f.a.x, f.a.y, f.a.z);

			c = f.b.add(this.P_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.b.normal.x, f.b.normal.y, f.b.normal.z);
				s.vertex(f.b.x, f.b.y, f.b.z);

			c = f.c.add(this.P_cAmp);
				s.fill(c.x,c.y,c.z);
				s.normal(f.c.normal.x, f.c.normal.y, f.c.normal.z);
				s.vertex(f.c.x, f.c.y, f.c.z);
		}
		s.endShape();
		return s;
	}



	// -------------------------------------------------------------------------
	// TOXICLIBS / HEMESH CONVERTERS
	// see https://gist.github.com/arnaudjuracek/8766cde42b0a4e3f7c88fd3dce1e64f3
	private TriangleMesh hemeshToToxi(HE_Mesh m){
		m.triangulate();

		TriangleMesh tmesh = new TriangleMesh();

		Iterator<HE_Face> fItr = m.fItr();
		HE_Face f;
		while(fItr.hasNext()){
			f = fItr.next();
			List<HE_Vertex> v = f.getFaceVertices();
			tmesh.addFace(
				new Vec3D(v.get(0).xf(), v.get(0).yf(), v.get(0).zf()),
				new Vec3D(v.get(1).xf(), v.get(1).yf(), v.get(1).zf()),
				new Vec3D(v.get(2).xf(), v.get(2).yf(), v.get(2).zf()));
		}
		return tmesh;
	}

	private HE_Mesh toxiToHemesh(TriangleMesh m){
		String path = "/tmp/processing_toxiToHemesh";
		m.saveAsOBJ(path);
		return new HE_Mesh(new HEC_FromOBJFile(path));
	}



	// -------------------------------------------------------------------------
	// EXPORT HANDLING
	// save the mesh as OBJ and STL on a specified path
	public boolean export(String path){
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
				scale(map(v,1,2,150,300)/this.P_size);
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

	public void displayInformations(int x, int y){
		hint(DISABLE_DEPTH_TEST);
			pushStyle();
				fill(0, map(v, 1, 2, 255*.4, 255*.9));
				noStroke();
				rect(x-this.P_size/4,y-this.P_size/4,this.P_size/2, this.P_size/2);
			popStyle();

			fill(255, map(v, 1, 2, 255*.6, 255*.9));
			textAlign(CENTER, CENTER);
			text(
				"r:" + this.P_resolution + "\n" +
				"t:" + this.P_isoThreshold + "\n",
				x, y-1);
		hint(ENABLE_DEPTH_TEST);
	}

	public boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}