import peasy.*;
import toxi.processing.*;
import java.util.Random;

public static final float EPSILON = 0.00001f;
public ToxiclibsSupport gfx;
public PeasyCam cam;

Pipe pipe;
PImage tex;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();
	cam = new PeasyCam(this, 2500);
	gfx = new ToxiclibsSupport(this);

	tex = loadImage("data/tex.jpg");
	textureMode(NORMAL);

	float[] radiuses = new float[int(random(1, 100))];
	for(int i=0; i<radiuses.length; i++) radiuses[i] = random(0, 300);

	pipe = new Pipe(
		new Path(
			new Vec3D[]{
				new Vec3D(0, height, 0), // start at the bottom
				new Vec3D(0, 0, 0), // go up
				new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
				new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
				new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
				new Vec3D(random(-width, width), random(-height, height), random(-width, width))
			},
			0.9
		),
		new Curve(radiuses, new CircularInterpolation(), .9),
		100
	);
}

void draw(){
	background(255);
	cam.beginHUD();
		rotateX(PI*1.5);
		ambientLight(100, 100, 100);
		directionalLight(200, 200, 200, 0, 0, -1);
		lightFalloff(1, 0, 0);
		lightSpecular(1, 0, 0);
	cam.endHUD();

	noFill(); stroke(100); strokeWeight(1); box(width*2, height*2, width*2);

	for(int i=0; i<pipe.getPath().getPoints().length-1; i++){
		Vec3D a = pipe.getPath().getPoint(i);
		Vec3D b = pipe.getPath().getPoint(i+1);
		strokeWeight(1);
		line(a.x, a.y, a.z, b.x, b.y, b.z);
		strokeWeight(10);
		point(a.x, a.y, a.z);
	}

	stroke(200, 0, 100);
	for(int i=0; i<pipe.getPath().getOriginalPoints().length-1; i++){
		Vec3D a = pipe.getPath().getOriginalPoint(i);
		Vec3D b = pipe.getPath().getOriginalPoint(i+1);
		strokeWeight(1);
		line(a.x, a.y, a.z, b.x, b.y, b.z);
		strokeWeight(10);
		point(a.x, a.y, a.z);
	}

	fill(255); noStroke();
	// strokeWeight(1); stroke(0, 50); gfx.mesh(pipe.getMesh(), false);
	// gfx.meshNormalMapped(pipe.getMesh(), true, 100);
	if(mousePressed) gfx.texturedMesh(pipe.getMesh(), tex, true);
}

void keyPressed(){
	if(key == 'r') setup();
}