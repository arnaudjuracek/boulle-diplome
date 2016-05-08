import processing.opengl.*;
import toxi.processing.*;

import peasy.*;

ObjLoader OBJECTS;
Tree TREE;
ToxiclibsSupport gfx;

void settings(){
	size(800, 800, OPENGL);
		smooth();
		// ortho();
	OBJECTS = new ObjLoader("data/set1/");
}

void setup(){
	PeasyCam c = new PeasyCam(this, 400);
	gfx = new ToxiclibsSupport(this);

	TREE = new Tree();
	for (int i=0; i<1; i++) {
		// Obj o = OBJECTS.getRandom();
		Obj o = OBJECTS.get("cube.obj");
		// Obj o = OBJECTS.get(0);
		Vec3D p = TREE.getRandomContactPoint();
		TREE.add(o, p);
	}

}



void draw(){
	background(50);

	// Obj o = OBJECTS.get(0);
	// 	noFill();
	// 	strokeWeight(1);
	// 	stroke(255);
	// 	gfx.mesh(o.getToxiMesh(), false);

	// 	strokeWeight(10);
	// 	stroke(255, 0, 0);
	// 	for(Vec3D v : o.getContactPoints()) point(v.x, v.y, v.z);

	strokeWeight(1);
	stroke(255, 100);
	fill(200, 0, 100, 100);
	int c = 0;
	for(Node n : TREE.getNodes()){
		TriangleMesh m = n.getToxiMesh();
		gfx.mesh(m, false);
	}

	// stroke(0, 200, 0);
	// gfx.mesh(TREE.getLastNode().getToxiMesh(), false);

	strokeWeight(10);
	stroke(255);
	for(Vec3D v : TREE.getContactPoints()) point(v.x, v.y, v.z);


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
			Vec3D p = TREE.getRandomContactPoint();
			TREE.add(o, p);
		}
	}
}