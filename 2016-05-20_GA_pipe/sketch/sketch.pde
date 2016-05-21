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

	Vec3D[] path = {
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width))
	};


	int n_slices = 12;
	pipe = new Pipe(path, n_slices);

}

void draw(){
	background(255);
	noFill(); stroke(100); strokeWeight(1);
	box(width*2, height*2, width*2);

	pipe.setPath(pipe.interpolatePath(int(map(mouseX, 0, width, 1, 100))));

	strokeWeight(3);
	Vec3D[] points = pipe.getPath();
	for(int i=0; i<points.length-1; i++){
		line(points[i].x, points[i].y, points[i].z, points[i+1].x, points[i+1].y, points[i+1].z);
	}

	// fill(255); stroke(0); strokeWeight(1);
	// shape(pipe.getPShape(), 0, 0);
}

void keyPressed(){
	if(key == 'r') setup();
}