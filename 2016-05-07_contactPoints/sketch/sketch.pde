import processing.opengl.*;
import toxi.processing.*;
import peasy.*;

ObjLoader OBJECTS;
Tree TREE;
ToxiclibsSupport gfx;
PeasyCam cam;

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	OBJECTS = new ObjLoader("data/set1/");
		OBJECTS
			.weightObj(OBJECTS.get("cube.obj"), 1)
			.weightObj(OBJECTS.get("stick.obj"), 99)
			.weightObj(OBJECTS.get("bowl.obj"), 1);

 	cam = new PeasyCam(this, 1000);
	gfx = new ToxiclibsSupport(this);

	TREE = new Tree();
	for (int i=0; i<20; i++) {
		Obj o = OBJECTS.getRandom();
		if(i==0) o = OBJECTS.get("bowl.obj");
		// Obj o = OBJECTS.get("cube.obj");
		// Obj o = OBJECTS.get(int(i%2==0));

		Vec3D p = TREE.getRandomContactPoint();
		// if(TREE.getNodes().size()>0) p = TREE.getLastNode().getLastContactPoint();
		TREE.add(o, p);
	}

}



void draw(){
	background(50);

	cam.beginHUD();
		rotateX(PI*1.5);
		lights();
	cam.endHUD();

	// DRAW TOXIMESH
		// strokeWeight(2);
		// int c = 0;
		// for(Node n : TREE.getNodes()){
		// 	if(n.getObj().getFilename().equals("stick.obj")){ stroke(255, 0, 100, 100); fill(200, 0, 100, 100); }
		// 	else{ stroke(0, 255, 100, 100); fill(0, 200, 100, 100); }
		// 	TriangleMesh m = n.getToxiMesh();
		// 	gfx.mesh(m, false);
		// }

	// DRAW LAST NODE
		// stroke(255); noFill();
		// gfx.mesh(TREE.getLastNode().getToxiMesh(), false);

	// DRAW PSHAPES
		for(Node n : TREE.getNodes()) shape(n.getPShape(), 0, 0);

	// DRAW CONTACT POINTS
		// strokeWeight(10);
		// stroke(255);
		// for(Vec3D v : TREE.getContactPoints()) point(v.x, v.y, v.z);


	// DISPLAY INFOS
		surface.setTitle(TREE.getContactPoints().size() + " / " + int(frameRate) + "fps");
}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 'a'){
		Obj o = OBJECTS.getRandom();
		// Obj o = OBJECTS.get(1);
		Vec3D p = TREE.getRandomContactPoint();
		TREE.add(o, p);
	}
	if(key == ' '){
		for (int i=0; i<10; i++) {
			Obj o = OBJECTS.getRandom();
			// Vec3D p = TREE.getRandomContactPoint();
			Vec3D p = TREE.getLastNode().getLastContactPoint();
			TREE.add(o, p);
		}
	}
}