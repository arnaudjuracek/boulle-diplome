import processing.opengl.*;
import toxi.processing.*;
import peasy.*;

public static float EPSILON = 0.0001f;

public ObjLoader OBJECTS;
public Tree TREE;
public ToxiclibsSupport gfx;
public PeasyCam cam;
public PGraphics bg_gradient;
public PShape bg_grid;

public boolean
	DRAW_CPOINTS = false,
	DRAW_MESH = false;

// void settings(){
// 	fullScreen(OPENGL);
// }

void setup(){
	size(1000, 800, OPENGL);
		smooth();
		bg_gradient = createGradient(color(255, 246, 255), color(187, 255, 255));
		bg_grid = createGrid(width, height, 20);

	OBJECTS = new ObjLoader("data/_debug/", false);
		// OBJECTS
		// 	.weightObj(OBJECTS.get("data/kristall/memphis_kristall_box.obj"), 0)
		// 	.weightObj(OBJECTS.get("data/kristall/memphis_kristall_body.obj"), 0)
		// 	.weightObj(OBJECTS.get("data/kristall/memphis_kristall_table.obj"), 10)
		// 	.weightObj(OBJECTS.get("data/kristall/memphis_kristall_foot.obj"), 10);

	// for(Mtl m : OBJECTS.getMaterials()){
	// 	println("---------");
	// 	println(m.getName());
	// 	println(m.getAmbientColor());
	// 	println(m.getDiffuseColor());
	// 	println(m.getSpecularColor());
	// }

 	cam = new PeasyCam(this, 1200);
	gfx = new ToxiclibsSupport(this);

	TREE = new Tree();
	for (int i=0; i<random(10); i++) {
		TREE.add(
			OBJECTS.getRandom(),
			TREE.getRandomContactPoint(),
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
	if(DRAW_MESH) background(50);
	else background(bg_gradient);

	cam.beginHUD();
		rotateX(PI*1.5);
		lights();
	cam.endHUD();

	// pushMatrix();
	// 	translate(0, height/2);
	// 	rotateX(PI/3);
	// 	shape(bg_grid, 0, -height/2);
	// popMatrix();

	if(DRAW_MESH){
		for(int i=0; i<TREE.getNodes().size(); i++){
			Node n = TREE.getNode(i);
			if(n.getTexture()!=null){
				noFill(); noStroke();
				gfx.texturedMesh(n.getToxiMesh(), n.getTexture(), true);
			}else{
				strokeWeight(1); stroke(255, 255*.2); noFill();
				if(i==TREE.getNodes().size()-1) stroke(0, 100, 200);
				// gfx.meshNormalMapped(n.getToxiMesh(), true, 1);
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
						// strokeWeight(2);
						// stroke(255, 0, 0); line(0,0,0, c.getNormal().X_AXIS.scale(50).x, c.getNormal().X_AXIS.scale(50).y, c.getNormal().X_AXIS.scale(50).z);
						// stroke(0, 255, 0); line(0,0,0, c.getNormal().Y_AXIS.scale(-50).x, c.getNormal().Y_AXIS.scale(-50).y, c.getNormal().Y_AXIS.scale(-50).z);
						// stroke(0, 0, 255); line(0,0,0, c.getNormal().Z_AXIS.scale(50).x, c.getNormal().Z_AXIS.scale(50).y, c.getNormal().Z_AXIS.scale(50).z);
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
	if(key == 'e') TREE.saveAsOBJ("/Users/RNO/Desktop/export.obj");
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


// -------------------------------------------------------------------------
// GOODIES

PShape createGrid(int w, int h, int scl){
	PShape grid = createShape(GROUP);

	int cols = w / scl,
		rows = h / scl;

  	for (int y = 0; y < rows - 1; y++) {
  		PShape s = createShape();
    	s.beginShape(TRIANGLE_STRIP);
    	s.noFill();
    	s.stroke(255, 100);
    	s.strokeWeight(1);
    	for (int x = 0; x < cols; x++) {
      		s.vertex(x*scl, y*scl);
      		s.vertex(x*scl, (y+1)*scl);
    	}
    	s.endShape(CLOSE);
    	grid.addChild(s);
  	}
  	return grid;
}

PGraphics createGradient(color c1, color c2){
	PGraphics gradient = createGraphics(width, height);
	gradient.beginDraw();
	for(int y=0; y<height; y++){
		gradient.stroke(lerpColor(c1, c2, sq(norm(y, 0, height))));
		gradient.line(0, y, width, y);
	}
	gradient.endDraw();
	return gradient;
}