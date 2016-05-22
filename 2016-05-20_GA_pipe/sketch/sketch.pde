import peasy.*;
import toxi.processing.*;
import java.util.Random;

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
	// cam = new PeasyCam(this, 2500);
	gfx = new ToxiclibsSupport(this);

	tex = loadImage("data/tex.jpg");
	textureWrap(REPEAT);
	textureMode(NORMAL);

	// float[] radiuses = new float[int(random(1, 100))];
	// for(int i=0; i<radiuses.length; i++) radiuses[i] = random(100, 300);

	// float[] sides = new float[10];
	// for(int i=0; i<sides.length; i++)
	// 	sides[i] = random(3, 20);

	// pipe = new Pipe(
	// 	new Path(
	// 		new Vec3D[]{
	// 			new Vec3D(0, height, 0),
	// 			new Vec3D(0, -height, 0),
	// 			new Vec3D(0, -height, -width)
	// 			// new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 			// new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 			// new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 			// new Vec3D(random(-width, width), random(-height, height), random(-width, width)),
	// 			// new Vec3D(random(-width, width), random(-height, height), random(-width, width))
	// 		}, .9
	// 	),
	// 	new Curve(radiuses, .9),
	// 	new Curve(sides, .6),
	// 	20
	// );
}

void draw(){
	background(255);

	Wave wave = new Wave(Wave.FMSAWTOOTHWAVE, 0, 0.1, 0, height, 100);
	Curve debug_curve = new Curve(wave.getValues());
	debug_curve.smooth(.9);
	debug_curve.debug_draw();

	// cam.beginHUD();
	// 	rotateX(PI*1.5);
	// 	ambientLight(100, 100, 100);
	// 	directionalLight(200, 200, 200, 0, 0, -1);
	// 	lightFalloff(1, 0, 0);
	// 	lightSpecular(1, 0, 0);
	// cam.endHUD();

	// noFill(); stroke(100); strokeWeight(1); box(width*2, height*2, width*2);

	// if(D_PATH){
	// 	stroke(0);
	// 	for(int i=0; i<pipe.getPath().getPoints().length-1; i++){
	// 		Vec3D a = pipe.getPath().getPoint(i);
	// 		Vec3D b = pipe.getPath().getPoint(i+1);
	// 		strokeWeight(1);
	// 		line(a.x, a.y, a.z, b.x, b.y, b.z);
	// 		strokeWeight(11);
	// 		point(a.x, a.y, a.z);
	// 	}
	// 	point(pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).x, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).y, pipe.getPath().getPoint(pipe.getPath().getPoints().length-1).z);

	// 	stroke(200, 0, 100);
	// 	for(int i=0; i<pipe.getPath().getOriginalPoints().length-1; i++){
	// 		Vec3D a = pipe.getPath().getOriginalPoint(i);
	// 		Vec3D b = pipe.getPath().getOriginalPoint(i+1);
	// 		strokeWeight(1);
	// 		line(a.x, a.y, a.z, b.x, b.y, b.z);
	// 		strokeWeight(10);
	// 		point(a.x, a.y, a.z);
	// 	}
	// 	point(pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).x, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).y, pipe.getPath().getOriginalPoint(pipe.getPath().getOriginalPoints().length-1).z);

	// }else if(D_WIREFRAME && !D_NORMAL){
	// 	strokeWeight(1);
	// 	stroke(0, 50);
	// 	gfx.mesh(pipe.getMesh(), false);
	// }else if(D_NORMAL){
	// 	gfx.meshNormalMapped(pipe.getMesh(), true, 100);
	// }else if(D_TEX){
	// 	noStroke();
	// 	fill(255);
	// 	gfx.texturedMesh(pipe.getMesh(), tex, true);
	// }else{
	// 	noStroke();
	// 	fill(255);
	// 	gfx.mesh(pipe.getMesh(), true);
	// }
}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
}