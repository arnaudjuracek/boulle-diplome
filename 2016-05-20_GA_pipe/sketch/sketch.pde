import peasy.*;
import toxi.processing.*;
import java.util.Random;
import java.util.Iterator;

public static final float EPSILON = 0.00001f;
public ToxiclibsSupport gfx;
public PeasyCam cam;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true;

Pipe pipe;
PImage tex;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();
	cam = new PeasyCam(this, 2500);
	gfx = new ToxiclibsSupport(this);

	// tex = loadImage("data/tex.jpg");
	tex = loadImage("data/code.png");
	textureWrap(REPEAT);
	textureMode(NORMAL);

	// float[] radiuses = new float[int(random(1, 100))];
	// for(int i=0; i<radiuses.length; i++) radiuses[i] = random(100, 300);

	float[] sides = new float[10];
	for(int i=0; i<sides.length; i++) sides[i] = 30;

	pipe = new Pipe(
		new Path(
			new Vec3D[]{
				new Vec3D(0, height, 0),
				new Vec3D(0, -height, 0),
				new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
				new Vec3D(random(-width, width), random(-height, height), random(-width, width))
			}, .9
		),
		// new Curve(new Wave(Wave.FMSQUAREWAVE, 0, .2f, 0, 300, 50).getValues(), .9),
		new Curve(
			new Wave(
				new Wave().create(Wave.FMSINEWAVE, 0, .1f, new Wave().create(Wave.FMSAWTOOTHWAVE, 0, .5f, null)),
				0, 600, 50
			).getValues(), .9),
		new Curve(10),
		// new Curve(new Wave(Wave.FMSINEWAVE, 0, .1f, 3, 5, 50).getValues(), .6),
		50
	);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(255);

	// WHOLE POPULATION FOLLOWS MOUSE ? :^D
	// pipe = new Pipe(
	// 	new Path(
	// 		new Vec3D[]{
	// 			new Vec3D(0, height, 0),
	// 			new Vec3D(0, height-20, 0),
	// 			new Vec3D(-sin(frameCount*0.03)*width/10, 0, -cos(frameCount*0.03)*width/10),
	// 			new Vec3D(sin(frameCount*0.03)*width, sin(frameCount*.1)*50, cos(frameCount*0.03)*width),
	// 			new Vec3D(sin(frameCount*0.03)*width/20, -height + sin(10+frameCount*.1)*100, cos(frameCount*0.03)*width/20)
	// 		}, .9
	// 	),
	// 	new Curve(new Wave(Wave.FMSQUAREWAVE, 0, .3f, 10, 150, 50).getValues(), norm(sin(frameCount*.01), -1, 1)),
	// 	new Curve(new Wave(Wave.FMSINEWAVE, -frameCount*.01, .1f, 3, 10, 10).getValues(), norm(sin(frameCount*.01), -1, 1)),
	// 	50
	// );

	cam.beginHUD();
		rotateX(PI*1.5);
		ambientLight(100, 100, 100);
		directionalLight(200, 200, 200, 0, -1, -1);
	cam.endHUD();

	noFill(); stroke(100); strokeWeight(1); box(width*2, height*2, width*2);

	if(D_PATH){
		stroke(0);
		for(int i=0; i<pipe.getPath().getPoints().length-1; i++){
			Vec3D a = pipe.getPath().getPoint(i);
			Vec3D b = pipe.getPath().getPoint(i+1);
			strokeWeight(1);
			line(a.x, a.y, a.z, b.x, b.y, b.z);
			strokeWeight(11);
			point(a.x, a.y, a.z);
		}
		point(pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).x, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).y, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).z);

		stroke(200, 0, 100);
		for(int i=0; i<pipe.getPath().getOriginalPoints().length-1; i++){
			Vec3D a = pipe.getPath().getOriginalPoint(i);
			Vec3D b = pipe.getPath().getOriginalPoint(i+1);
			strokeWeight(1);
			line(a.x, a.y, a.z, b.x, b.y, b.z);
			strokeWeight(10);
			point(a.x, a.y, a.z);
		}
		point(pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).x, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).y, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).z);

	}else if(D_WIREFRAME && !D_NORMAL){
		strokeWeight(1);
		stroke(0, 50);
		gfx.mesh(pipe.getMesh(), false);
	}else if(D_NORMAL){
		gfx.meshNormalMapped(pipe.getMesh(), true, 100);
	}else if(D_TEX){
		noStroke();
		fill(255);
		gfx.texturedMesh(pipe.getMesh(), tex, true);
	}else{
		noStroke();
		fill(255);
		gfx.mesh(pipe.getMesh(), true);
	}

	tex = get();
}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
}