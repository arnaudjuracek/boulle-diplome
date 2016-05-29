import toxi.processing.*;

public final float EPSILON = 0.00001f;
public PApplet PAPPLET = this;
public ToxiclibsSupport gfx;

public final float
	MUTATION_RATE = 0.5f,
	MUTATION_AMP = 10.0f;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true,
	D_BGWHITE = true;

public Clusters clusters;
public PImage TEX;

void setup(){
	size(1200, 800, OPENGL);
	gfx = new ToxiclibsSupport(this);

	TEX = loadImage("data/grid.jpg");
	textureMode(NORMAL);

	clusters = new Clusters(new Population(100, MUTATION_RATE, MUTATION_AMP));
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(int(D_BGWHITE)*255);

	ambientLight(127, 127, 127);
	directionalLight(127, 127, 127, 0, 1, 1);

	pushMatrix();
		translate(scene_offset.x, scene_offset.y);
		pushMatrix();
			translate(0, height/2, -zoom_out*2);
			clusters.displayCurrent();
		popMatrix();
	popMatrix();

	clusters.displayClusters();
}

void keyPressed(){
	if(key == 'r') setup();
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

float zoom_out = 1500;
Vec2D scene_offset = new Vec2D();
void mouseWheel(MouseEvent event){ zoom_out += event.getCount(); }
void mouseDragged(){
	scene_offset.x += mouseX - pmouseX;
	scene_offset.y += mouseY - pmouseY;
}