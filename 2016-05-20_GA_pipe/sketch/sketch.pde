import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Random;

public static float EPSILON = 0.00001f;

Pipe pipe;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	PeasyCam c = new PeasyCam(this, 2500);

	pipe = new Pipe(
		new Vec3D[]{
			new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
			new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
			new Vec3D(random(-width, width), random(-height, height), random(-width, width))
		},
		new Curve(new float[]{100, 100}).setInterpolation(new CircularInterpolation()),
		30
	);

}

void draw(){
	background(255);
	noFill(); stroke(100); strokeWeight(1);
	box(width*2, height*2, width*2);

	lights();
	fill(255); stroke(100);
	shape(pipe.getPShape(), 0, 0);
}

void keyPressed(){
	if(key == 'r') setup();
}