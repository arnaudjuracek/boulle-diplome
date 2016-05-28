import java.awt.*;

public class Frame extends PApplet{

	private Tree tree;
	private int width, height, x, y;
	private PImage g;

	// -------------------------------------------------------------------------
	public Frame(Tree tree, int w, int h){
		super();
		this.tree = tree;
		this.width = w;
		this.height = h;
		this.x = 50;
		this.y = 50;
		PApplet.runSketch(new String[]{this.getClass().getName()}, this);
	}

	public Frame(Tree tree, int monitorIndex){
		super();
		this.tree = tree;

		Rectangle monitor = GraphicsEnvironment
								.getLocalGraphicsEnvironment()
								.getScreenDevices()[monitorIndex]
								.getConfigurations()[0]
								.getBounds();

		this.width = monitor.width;
		this.height = monitor.height;
		this.x = monitor.x;
		this.y = monitor.y;
		PApplet.runSketch(new String[]{this.getClass().getName()}, this);
	}



	// -------------------------------------------------------------------------
	public void settings(){
		// size(this.width, this.height);
		fullScreen();
	}

	public void setup(){
		surface.setLocation(this.x, this.y);
		background(0);
	}

	public void draw(){
		surface.setTitle(int(frameRate) + "fps");
		if(g!=null) image(g, 0, 0);
		else background(0);

		noLoop();
	}



	// -------------------------------------------------------------------------
	// PGRAPHICS
	public Frame setG(PImage g){
		loop();
		this.g = g;
		return this;
	}
	public PImage getG(){ return this.g; }



	// -------------------------------------------------------------------------
	// GETTER
	public int getWidth(){ return this.width; }
	public int getHeight(){ return this.height; }

}