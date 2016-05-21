import peasy.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import java.util.Random;

public static float EPSILON = 0.00001f;

Vec3D a, b;
Pipe pipe;
Curve curveX, curveY, curveZ;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();

	PeasyCam c = new PeasyCam(this, 2500);

	Vec3D[] path = {
		new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
		new Vec3D(random(-width, width), random(-height, height), random(-width, width))
	};


	// int n_slices = 12;
	// pipe = new Pipe(path, n_slices);

	int l = 10;
	float[]
		x = new float[l],
		y = new float[l],
		z = new float[l];

	for(int i=0; i<l; i++){
		x[i] = random(-width, width);
		y[i] = random(-height, height);
		z[i] = random(-width, width);
	}

	curveX = new Curve(x);
	curveY = new Curve(y);
	curveZ = new Curve(z);

	curveX.setInterpolation(new CircularInterpolation());
	curveY.setInterpolation(new CircularInterpolation());
	curveZ.setInterpolation(new CircularInterpolation());

	// int res = 10;
	// float[] values = new float[res];
	// for(int i=0; i<values.length; i++) values[i] = random(height);
	// curve = new Curve(values);
}

void draw(){
	background(255);
	curveX.interpolate(int(map(mouseX, 0, width, 0, 1) * 100));
	curveY.interpolate(int(map(mouseX, 0, width, 0, 1) * 100));
	curveZ.interpolate(int(map(mouseX, 0, width, 0, 1) * 100));

	for(int i=0; i<curveX.getOriginalValues().length-1; i++){
		Vec3D a = new Vec3D(
					curveX.getOriginalValues()[i],
					curveY.getOriginalValues()[i],
					curveZ.getOriginalValues()[i]);
		Vec3D b = new Vec3D(
					curveX.getOriginalValues()[i+1],
					curveY.getOriginalValues()[i+1],
					curveZ.getOriginalValues()[i+1]);

		stroke(200, 0, 100, 100);
		strokeWeight(1);
		line(a.x, a.y, a.z, b.x, b.y, b.z);
		strokeWeight(5);
		point(a.x, a.y, a.z);
	}

	for(int i=0; i<curveX.getValues().length-1; i++){
		Vec3D a = new Vec3D(
					curveX.getValues()[i],
					curveY.getValues()[i],
					curveZ.getValues()[i]);
		Vec3D b = new Vec3D(
					curveX.getValues()[i+1],
					curveY.getValues()[i+1],
					curveZ.getValues()[i+1]);

		stroke(0);
		strokeWeight(1);
		line(a.x, a.y, a.z, b.x, b.y, b.z);
		strokeWeight(5);
		point(a.x, a.y, a.z);
	}

	noFill(); stroke(100); strokeWeight(1);
	box(width*2, height*2, width*2);

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