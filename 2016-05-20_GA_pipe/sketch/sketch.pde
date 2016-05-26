import toxi.processing.*;
import java.util.Random;
import java.util.Iterator;

public static final float EPSILON = 0.00001f;
public ToxiclibsSupport gfx;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true,
	D_BGWHITE = true;


public Population population;
public PImage TEX;

// void settings(){ fullScreen(OPENGL); }

void setup(){
	size(1200, 600, OPENGL);
		smooth();
	gfx = new ToxiclibsSupport(this);

	TEX = loadImage("data/tex.jpg");
	textureMode(NORMAL);

	population = new Population(5, .5, 1);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(int(D_BGWHITE)*255);

	ambientLight(100, 100, 100);
	directionalLight(127, 127, 127, 0, 1, 1);

	pushMatrix();
		translate(0, height/2, -zoom_out*2);
		population.display(-width, width*2);
	popMatrix();

}

void keyPressed(){
	if(key == 'r') setup();
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
	if(key == 'c') D_BGWHITE = !D_BGWHITE;
	if(key == ' ') population.reproduce(population.getSelected());
	if(key == 'e') population.getSelected().getPipe().export(30);
}

float zoom_out;
void mouseWheel(MouseEvent event){ zoom_out += event.getCount(); }