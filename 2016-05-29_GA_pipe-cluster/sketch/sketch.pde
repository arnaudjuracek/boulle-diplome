import toxi.processing.*;
import peasy.*;

public final float EPSILON = 0.00001f;
public PApplet PAPPLET = this;
public ToxiclibsSupport gfx;
public PeasyCam cam;

public final float
	MUTATION_RATE = 0.5f,
	MUTATION_AMP = 10.0f;

public int TBN_WIDTH, TBN_HEIGHT;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true,
	D_BGWHITE = true;

public PImage TEX;
public Clusters clusters;

void setup(){
	// size(1200, 800, OPENGL);
	fullScreen(OPENGL);
	gfx = new ToxiclibsSupport(this);
	cam = new PeasyCam(this, 2000);

	TEX = loadImage("data/grid.jpg");
	textureMode(NORMAL);

	int cols = 5;
	int rows = 5;
	TBN_WIDTH = int(width/cols);
	TBN_HEIGHT = int(height/rows);

	Organism[] organisms = new Organism[cols*rows];
	for(int i=0; i<organisms.length; i++){
		Organism o = new Organism();
		organisms[i] = o.cross(new Organism(), MUTATION_RATE, MUTATION_AMP);
	}

	clusters = new Clusters(organisms);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(int(D_BGWHITE)*255);

	// int cols = 10;
	// int rows = 10;
	// TBN_WIDTH = int(width/cols);
	// TBN_HEIGHT = int(height/rows);

	// Organism[] organisms = new Organism[cols*rows];
	// for(int i=0; i<organisms.length; i++){
	// 	Organism o = new Organism();
	// 	organisms[i] = o.cross(new Organism(), MUTATION_RATE, MUTATION_AMP);
	// }

	// clusters = new Clusters(organisms);


	if(clusters.getCurrent()!=null){
		cam.beginHUD();
			clusters.displayClusters();
			ambientLight(127, 127, 127);
			directionalLight(127, 127, 127, 0, 1, 1);

			textSize(50); textAlign(RIGHT, BOTTOM); fill(0);
			text(clusters.current_index + "/" + clusters.getOrganisms().length, width-20, height-20);
		cam.endHUD();

		clusters.displayCurrent();
	}else{
		cam.beginHUD();
			clusters.displayAll(TBN_WIDTH, TBN_HEIGHT);
		cam.endHUD();
	}

	// loop();
}

void keyPressed(){
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
	if(key == 'c') D_BGWHITE = !D_BGWHITE;
	if(key == ' ') clusters.createNewCluster(clusters.getCurrent());
}

void mousePressed(){
	for(Cluster c : clusters.getClusters()) if(c.HOVER) clusters.addTo(clusters.getCurrent(), c);
}