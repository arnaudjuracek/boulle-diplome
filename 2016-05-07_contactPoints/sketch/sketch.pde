import processing.opengl.*;
import toxi.processing.*;

import peasy.*;

ArrayList<Obj> OBJECTS = new ArrayList<Obj>();
ToxiclibsSupport gfx;

void setup(){
	size(800, 800, OPENGL);
	PeasyCam c = new PeasyCam(this, 1000);
	gfx = new ToxiclibsSupport(this);
	smooth();
	// ortho();

	String dir = "data/set1/";

	FilenameFilter filter = new FilenameFilter() { @Override public boolean accept(File dir, String name) { return name.endsWith(".obj"); } };
	File[] files = new File(sketchPath(dir)).listFiles(filter);
	for(File f : files){
    	if(f.isFile()){
    		OBJECTS.add(new Obj(f));
    	}
	}
}



void draw(){
	background(50);

	Obj o = OBJECTS.get(0);
		noFill();
		strokeWeight(1);
		stroke(255);
		gfx.mesh(o.getToxiMesh(), false);

		strokeWeight(10);
		stroke(255, 0, 0);
		for(PVector v : o.getContactPoints_PVector()) point(v.x, v.y, v.z);

	// DISPLAY INFOS
	surface.setTitle(int(frameRate) + "fps");
}

void keyPressed(){
	if(key == 'r') setup();
}