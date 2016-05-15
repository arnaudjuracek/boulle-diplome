import processing.opengl.*;
import toxi.processing.*;
import peasy.*;

ObjLoader OBJECTS;
Tree TREE;
ToxiclibsSupport gfx;
PeasyCam cam;

// void settings(){
// 	fullScreen(OPENGL);
// }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	OBJECTS = new ObjLoader("data/debug/");
		// OBJECTS
		// 	.weightObj(OBJECTS.get("ecrou.obj"), 10)
		// 	.weightObj(OBJECTS.get("grille.obj"), 0)
		// 	.weightObj(OBJECTS.get("gros_potar.obj"), 10)
		// 	.weightObj(OBJECTS.get("paraP.obj"), 0)
		// 	.weightObj(OBJECTS.get("petit_potar.obj"), 10)
		// 	.weightObj(OBJECTS.get("pietement.obj"), 10)
		// 	.weightObj(OBJECTS.get("vis.obj"), 10);

 	cam = new PeasyCam(this, 500);
	gfx = new ToxiclibsSupport(this);

	TREE = new Tree();
	for (int i=0; i<1; i++) {

		// if(i==0) o = OBJECTS.get("bowl.obj");
		// Obj o = OBJECTS.get("cube.obj");
		Obj o = OBJECTS.get(0);
		// if(i>0) o = OBJECTS.getRandom();

		CPoint p = TREE.getRandomContactPoint();
		TREE.add(o, p);
	}

}



void draw(){
	background(50);

	// rotateX(radians(45));
	// rotateY(radians(45));

	cam.beginHUD();
		rotateX(PI*1.5);
		lights();
	cam.endHUD();

	// DRAW PSHAPES
		// for(Node n : TREE.getNodes()) shape(n.getPShape(), 0, 0);

	// DRAW TOXIMESH
		strokeWeight(1); stroke(255); noFill();
		for(Node n : TREE.getNodes()) gfx.mesh(n.getToxiMesh());

		stroke(0, 100, 200);
		gfx.mesh(TREE.getLastNode().getToxiMesh());

	// DRAW CONTACT POINTS
		if(SHOW_CPOINTS){
			int sphere_size = 4;
			noLights();
			for(CPoint c : TREE.getContactPoints()){
				Vec3D v = c.getPosition();
				pushMatrix();
					fill(200, 0, 50);
					noStroke();
					translate(v.x, v.y, v.z);
					pushMatrix();
						sphere(sphere_size);

						stroke(200, 0, 50);
						strokeWeight(4);
						line(0,0,0, c.getNormal().scale(100).x, c.getNormal().scale(100).y, c.getNormal().scale(100).z);
					popMatrix();
				popMatrix();
			}
			fill(0, 200, 50);
			noStroke();
			pushMatrix();
				translate(TREE.getFirstContactPoint().getPosition().x, TREE.getFirstContactPoint().getPosition().y, TREE.getFirstContactPoint().getPosition().z);
				sphere(sphere_size);
			popMatrix();
			lights();
		}


	// DISPLAY INFOS
		surface.setTitle(TREE.getContactPoints().size() + " / " + int(frameRate) + "fps");
}

boolean SHOW_CPOINTS = true;

void keyPressed(){
	if(key == 'c') SHOW_CPOINTS = !SHOW_CPOINTS;
	if(key == 'r') setup();
	if(key == 'a'){
		Obj o = OBJECTS.getRandom();
		// Obj o = OBJECTS.get(1);
		CPoint p = TREE.getLastNode().getRandomContactPoint();
		TREE.add(o, p);
	}
	if(key == ' '){
		for (int i=0; i<10; i++) {
			Obj o = OBJECTS.getRandom();
			// Vec3D p = TREE.getRandomContactPoint();
			CPoint p = TREE.getLastNode().getLastContactPoint();
			TREE.add(o, p);
		}
	}
}