import peasy.*;
import toxi.math.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Random;

public static float EPSILON = 0.00001f;

Vec3D a, b;
Pipe pipe;
Curve curve;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	// PeasyCam c = new PeasyCam(this, 2500);

	Vec3D[] path = {
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width))
	};


	int n_slices = 12;
	// pipe = new Pipe(path, n_slices);

	int res = 10;
	float[] values = new float[res];
	for(int i=0; i<values.length; i++) values[i] = random(height);

	curve = new Curve(values);
	curve.setInterpolation(new CircularInterpolation());
	curve.setInterpolation(new CosineInterpolation());
	curve.interpolate(500);
}

void draw(){
	background(255);

	for(int i=0; i<curve.getOriginalValues().length-1; i++){
		Vec2D
			a = new Vec2D(
				map(i, 0, curve.getOriginalValues().length-1, 0, width),
				curve.getOriginalValues()[i]),
			b = new Vec2D(
				map(i+1, 0, curve.getOriginalValues().length-1, 0, width),
				curve.getOriginalValues()[i+1]);

		stroke(200, 0, 100, 100);
		strokeWeight(1);
		line(a.x, a.y, b.x, b.y);
		strokeWeight(5);
		point(a.x, a.y);
	}


	for(int i=0; i<curve.size()-1; i++){
		Vec2D
			a = new Vec2D(
				map(i, 0, curve.size(), 0, width),
				curve.getValue(i)),
			b = new Vec2D(
				map(i+1, 0, curve.size(), 0, width),
				curve.getValue(i+1));

		stroke(0);
		strokeWeight(1);
		line(a.x, a.y, b.x, b.y);
		strokeWeight(5);
		point(a.x, a.y);
	}


	// noFill(); stroke(100); strokeWeight(1);
	// box(width*2, height*2, width*2);

	// strokeWeight(10);
	// Vec3D[] points = pipe.getPath();
	// for(int i=0; i<points.length-1; i++){
	// 	line(points[i].x, points[i].y, points[i].z, points[i+1].x, points[i+1].y, points[i+1].z);
	// }


	// fill(255); stroke(0); strokeWeight(1);
	// shape(pipe.getPShape(), 0, 0);
}

void keyPressed(){
	if(key == 'r') setup();
}