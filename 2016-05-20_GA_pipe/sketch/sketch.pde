import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Random;

public static float EPSILON = 0.00001f;
public PApplet PAPPLET;

Pipe pipe;
Curve debug_curve;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();
		PAPPLET = this;

	// PeasyCam c = new PeasyCam(this, 2500);

	float[] radiuses = new float[int(random(1, 100))];
	for(int i=0; i<radiuses.length; i++) radiuses[i] = random(300);

	// pipe = new Pipe(
	// 	new Vec3D[]{
	// 		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 		new Vec3D(random(-width, width), random(-height, height), random(-width, width))
	// 	},
	// 	new Curve(radiuses).setInterpolation(new CircularInterpolation()),
	// 	30
	// );

	debug_curve = new Curve(radiuses);
	// debug_curve.interpolate(10);

}

void draw(){
	background(255);

	debug_curve.debug_draw();

	// noFill(); stroke(100); strokeWeight(1);
	// box(width*2, height*2, width*2);

	// lights();
	// fill(255); stroke(0, 20);
	// shape(pipe.getPShape(), 0, 0);
}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 's') debug_curve.smooth(0.1);
}