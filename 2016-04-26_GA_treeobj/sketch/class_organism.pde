public class Organism{
	public Dna DNA;
	public Organism[] PARENTS = new Organism[2];
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

		this.P_define();
	}

	// CONSTRUCTOR :
	// initialize fitness to 1
	// define parents
	// translate genotype onto phenotype
	public Organism(Dna dna, Organism mom, Organism dad){
		this.DNA = dna;
		this.FITNESS = 1;

		this.PARENTS[0] = mom;
		this.PARENTS[1] = dad;

		this.P_define();
	}



	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	private int P_size = 600;
	private Vec3D P_cAmp = new Vec3D(300, 255, 300);

	private void P_define(){
		this.SHAPE = this.buildShape();
	}



	// -------------------------------------------------------------------------
	// ORGANISM'S SHAPE :
	//
	//
	private PShape buildShape(){
		HE_Mesh hemesh = new HE_Mesh( new HEC_Geodesic(this.P_size/2) );

		// convert HE_mesh to WETriangleMesh
		this.MESH = (WETriangleMesh) ((TriangleMesh) hemeshToToxi(hemesh)).toWEMesh();
		return this.meshToPShape(this.MESH);
	}



	// -------------------------------------------------------------------------
	// TOXIC MESH TO PSHAPE CONVERSION :
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

	}

	public boolean is_hover(int x, int y){
		return dist(mouseX, mouseY, x, y) < 100;
	}

}