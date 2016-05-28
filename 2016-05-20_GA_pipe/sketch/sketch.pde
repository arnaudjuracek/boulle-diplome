import toxi.processing.*;
import java.util.Random;
import java.util.Iterator;

public final float EPSILON = 0.00001f;
public PApplet PAPPLET = this;
public ToxiclibsSupport gfx;
public PGraphics render;

public Tree tree;

public final float
	MUTATION_RATE = 0.5f,
	MUTATION_AMP = 10.0f;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true,
	D_BGWHITE = true;


public Population population;
public PImage TEX;

void settings(){
	size(1200, 600, OPENGL);
	// fullScreen(OPENGL);
}

void setup(){
	gfx = new ToxiclibsSupport(this);

	TEX = loadImage("data/grid.jpg");
	textureMode(NORMAL);

	population = new Population(5, MUTATION_RATE, MUTATION_AMP);
	tree = new Tree(this, population, 600, 400);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(int(D_BGWHITE)*255);

	ambientLight(127, 127, 127);
	directionalLight(127, 127, 127, 0, 1, 1);

	translate(scene_offset.x, scene_offset.y);
	pushMatrix();
		translate(0, height/2, -zoom_out*2);
		population.display(-width, width*2);
	popMatrix();
}

void keyPressed(){
	if(key == 'r'){
		population = new Population(population.getOrganisms().length, population.getMutationRate(), population.getMutationAmp());
		tree.reset();
	}
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
	if(key == 'c') D_BGWHITE = !D_BGWHITE;
	if(key == 'e') population.getSelected().getPipe().export(30);
	if(key == ' '){
		Organism s = population.getSelected();
		population.reproduce(s);
		tree.add(s);
	}
}

float zoom_out = 1500;
Vec2D scene_offset = new Vec2D();
void mouseWheel(MouseEvent event){ zoom_out += event.getCount(); }
void mouseDragged(){
	scene_offset.x += mouseX - pmouseX;
	scene_offset.y += mouseY - pmouseY;
}