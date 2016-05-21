import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
import java.util.Random;

public static float EPSILON = 0.00001f;

ToxiclibsSupport gfx;
Pipe pipe;
PImage tex;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	PeasyCam c = new PeasyCam(this, 2500);
	gfx = new ToxiclibsSupport(this);

	float[] radiuses = new float[int(random(1, 100))];
	for(int i=0; i<radiuses.length; i++) radiuses[i] = random(200, 300);

	tex = loadImage("data/tex.jpg");
	textureMode(NORMAL);

	pipe = new Pipe(
		new Vec3D[]{
			new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
			// new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
			new Vec3D(random(-width, width), random(-height, height), random(-width, width))
		},
		new Curve(radiuses).setInterpolation(new CircularInterpolation()),
		30
	);
}

void draw(){
	background(255);

	noFill(); stroke(100); strokeWeight(1);
	box(width*2, height*2, width*2);

	lights();
	fill(255); stroke(0, 20);
	// shape(pipe.getPShape(), 0, 0);
	// gfx.mesh(pipe.getMesh(), mousePressed);
	// gfx.meshNormalMapped(pipe.getMesh(), true, 100);
	gfx.texturedMesh(pipe.getMesh(), tex, mousePressed);
}

void keyPressed(){
	if(key == 'r') setup();
}