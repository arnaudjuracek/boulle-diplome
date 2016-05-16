import processing.opengl.*;
import toxi.processing.*;
import peasy.*;

ObjLoader OBJECTS;
Tree TREE;
ToxiclibsSupport gfx;
PeasyCam cam;
PImage debug_tex;

boolean
	DRAW_CPOINTS = false,
	DRAW_MESH = false;

// void settings(){
// 	fullScreen(OPENGL);
// }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	debug_tex = loadImage("data/tex.png");

	OBJECTS = new ObjLoader("data/rams/");
		// OBJECTS
		// 	.weightObj(OBJECTS.get("ecrou.obj"), 10)
		// 	.weightObj(OBJECTS.get("grille.obj"), 0)
		// 	.weightObj(OBJECTS.get("gros_potar.obj"), 10)
		// 	.weightObj(OBJECTS.get("paraP.obj"), 0)
		// 	.weightObj(OBJECTS.get("petit_potar.obj"), 10)
		// 	.weightObj(OBJECTS.get("pietement.obj"), 10)
		// 	.weightObj(OBJECTS.get("vis.obj"), 10);

 	cam = new PeasyCam(this, 300);
	gfx = new ToxiclibsSupport(this);

	TREE = new Tree();
	for (int i=0; i<1; i++) {
		TREE.add(
			OBJECTS.get(1),
			TREE.getLastContactPoint(),
			false
		);
	}

}


// void mouseMoved(){
// 	if(frameCount%1==0){
// 		TREE = new Tree();
// 		for (int i=0; i<2; i++) {
// 			TREE.add(
// 				OBJECTS.getRandom(),
// 				TREE.getLastContactPoint(),
// 				false
// 			);
// 		}
// 	}
// }


void draw(){
	background(50);

	cam.beginHUD();
		rotateX(PI*1.5);
		lights();
	cam.endHUD();

	if(DRAW_MESH){
		for(int i=0; i<TREE.getNodes().size(); i++){
			Node n = TREE.getNode(i);
			if(n.getTexture()!=null){
				noFill(); noStroke();
				gfx.texturedMesh(n.getToxiMesh(), n.getTexture(), true);
			}else{
				strokeWeight(1); stroke(255, 255*.2); noFill();
				if(i==TREE.getNodes().size()-1) stroke(0, 100, 200);
				gfx.mesh(n.getToxiMesh());
			}
		}
	}else{
		for(Node n : TREE.getNodes()) shape(n.getPShape(), 0, 0);
	}

	if(DRAW_CPOINTS){
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
					if(c.getNormal()!=null){
						line(0,0,0, c.getNormal().scale(100).x, c.getNormal().scale(100).y, c.getNormal().scale(100).z);

						// draw GIZMO
						strokeWeight(2);
						stroke(255, 0, 0); line(0,0,0, c.getNormal().X_AXIS.scale(50).x, c.getNormal().X_AXIS.scale(50).y, c.getNormal().X_AXIS.scale(50).z);
						stroke(0, 255, 0); line(0,0,0, c.getNormal().Y_AXIS.scale(-50).x, c.getNormal().Y_AXIS.scale(-50).y, c.getNormal().Y_AXIS.scale(-50).z);
						stroke(0, 0, 255); line(0,0,0, c.getNormal().Z_AXIS.scale(50).x, c.getNormal().Z_AXIS.scale(50).y, c.getNormal().Z_AXIS.scale(50).z);
					}
				popMatrix();
			popMatrix();
		}

		for(CPoint c : TREE.getContactPoints()){
			Vec3D v = c.getPosition();
			pushMatrix();
				fill(0, 200, 50);
				noStroke();
				translate(v.x, v.y, v.z);
				pushMatrix();
					sphere(sphere_size);

					stroke(0, 200, 50);
					strokeWeight(4);
					if(c.getNormal()!=null) line(0,0,0, c.getNormal().scale(100).x, c.getNormal().scale(100).y, c.getNormal().scale(100).z);
				popMatrix();
			popMatrix();
		}

		lights();
	}


	// DISPLAY INFOS
		surface.setTitle(TREE.getContactPoints().size() + " / " + int(frameRate) + "fps");
}


void keyPressed(){
	if(key == 'c') DRAW_CPOINTS = !DRAW_CPOINTS;
	if(key == 'm') DRAW_MESH = !DRAW_MESH;
	if(key == 'r') setup();
	if(key == 'a'){
		TREE.add(
			OBJECTS.getRandom(),
			TREE.getLastNode().getRandomContactPoint(),
			false
		);
	}
	if(key == ' '){
		for(int i=0; i<10; i++) {
			TREE.add(
				OBJECTS.getRandom(),
				TREE.getRandomContactPoint()
			);
		}
	}
}