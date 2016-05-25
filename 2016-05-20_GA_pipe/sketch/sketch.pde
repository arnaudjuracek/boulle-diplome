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


public Population population;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1000, 800, OPENGL);
		smooth();
	cam = new PeasyCam(this, 2500);
	gfx = new ToxiclibsSupport(this);

	population = new Population(5, .01, 1);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(255);

	cam.beginHUD();
		rotateX(PI*1.5);
		ambientLight(100, 100, 100);
		directionalLight(200, 200, 200, 0, -1, -1);
	cam.endHUD();

	noFill(); stroke(100); strokeWeight(1); box(width*2, height*2, width*2);

	population.display(new Vec3D(-width, 0, 0), new Vec3D(width, 0, 0));

}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
}