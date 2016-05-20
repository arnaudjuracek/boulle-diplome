import peasy.*;
import toxi.geom.*;
import java.util.Random;

public static float EPSILON = 0.00001f;

Vec3D a, b;

void setup(){
	size(800, 800, P3D);
		smooth();

	PeasyCam c = new PeasyCam(this, height*3);

	// a = new Vec3D(random(-width, width), random(-height, height), random(-width, width));
	// b = new Vec3D(random(-width, width), random(-height, height), random(-width, width));
	a = new Vec3D(-width, 0, width);
	b = new Vec3D(width, 0, -width);
}

int mode = 0, _a = 0, _b = 0, _c = 1;

void draw(){
	background(255);

	stroke(0); strokeWeight(2);
	line(a.x, a.y, a.z, b.x, b.y, b.z);

	Vec3D point = a.interpolateTo(b, 0);

	noFill(); stroke(100); strokeWeight(1);
	box(width*2, height*2, width*2);

	pushMatrix();
		translate(point.x, point.y, point.z);
		fill(0, 200, 100, 100); noStroke();
		sphereDetail(10); sphere(50);
	popMatrix();

	float n_slices = 100;
	int n_sides = 4,
		radius = 200;

	ArrayList<Vec3D[]> slices = new ArrayList<Vec3D[]>();

	for(float t=0; t<1+(1/(n_slices-1)); t+=1/(n_slices-1)){
		Vec3D p = a.interpolateTo(b, t);


		Matrix4x4 matrix = new Matrix4x4();

		// @see http://stackoverflow.com/questions/23692077/rotate-object-to-face-point
		Vec3D distance = a.sub(b);
		if(distance.magnitude() > EPSILON){
			Vec3D directionA = new Vec3D(0, 0, 1).normalize();
			Vec3D directionB = distance.copy().normalize();

			float rotationAngle = (float) Math.acos(directionA.dot(directionB));

			if(Math.abs(rotationAngle) > EPSILON){
				Vec3D rotationAxis = directionA.copy().cross(directionB).normalize();
				matrix = Quaternion.createFromAxisAngle(rotationAxis, rotationAngle).toMatrix4x4();
			}

		}

		Vec3D[] slice = new Vec3D[n_sides];

		for(float theta=0, i=0; theta<TWO_PI; theta+=TWO_PI/n_sides){
			float
				x = cos(theta)*radius,
				y = sin(theta)*radius;

			Vec3D v = new Vec3D(x, y, 0);

			slice[(int) i++] = matrix.applyTo(v).addSelf(p);
		}
		slices.add(slice);
	}


	// give the same number of side to each slice
	// for(Circle c : slices){
	// 	c.setNumberOfFacesTo(100);
	// }

	// beginShape(TRIANGLE_FAN);
	// imagine unwrapping the tube to a planar mesh
	noFill();
	// lights(); fill(255);
	stroke(200, 0, 100);
	for(int x=0; x<n_sides; x++){
		beginShape(TRIANGLE_STRIP);
		for(int y=0; y<slices.size(); y++){
			// Vec3D a = slices.get(y)[0];
			Vec3D b = slices.get(y)[x];
			Vec3D c = slices.get(y)[(x+1)%n_sides];

			// vertex(a.x, a.y, a.z);
			vertex(b.x, b.y, b.z);
			vertex(c.x, c.y, c.z);
		}

		endShape();
	}


}

void keyPressed(){
	if(key == 'r') setup();

	if(key == 'b'){
		switch(mode++){
			case 0 : _a = 1; _b = 0; _c = 0; break;
			case 1 : _a = 0; _b = 1; _c = 0; break;
			case 2 : _a = 0; _b = 0; _c = 1; mode = 0; break;
		}

		println(int(_a) + "," + int(_b) + "," + int(_c));
	}

	if(key == ' '){
		a = new Vec3D(random(-width, width), random(-height, height), random(-width, width));
		b = new Vec3D(random(-width, width), random(-height, height), random(-width, width));
	}

	if(key == 'a'){
		Random r = new Random();
		a.x = (1 - int(r.nextBoolean())*2)*width;
		a.y = (1 - int(r.nextBoolean())*2)*height;
		a.z = (1 - int(r.nextBoolean())*2)*width;

		b.x = (1 - int(r.nextBoolean())*2)*width;
		b.y = (1 - int(r.nextBoolean())*2)*height;
		b.z = (1 - int(r.nextBoolean())*2)*width;
	}

	if(key == 'i'){
		Vec3D pa = a, pb = b;
		a = pb; b = pa;
	}
}