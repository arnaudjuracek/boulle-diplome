public class Organism{
	public Dna DNA;
	public Organism[] PARENTS;
	public float FITNESS = 30;
	public float DEATH_RATE = .05;


	public boolean HOVER;
	public float LAST_REPRODUCTION;


	// -------------------------------------------------------------------------
	// CONSTRUCTOR :
	// initialize fitness to 1
	// set parents to null
	// translate genotype onto phenotype
	public Organism(PVector position, Dna dna){
		this.DNA = dna;

		this.PARENTS = new Organism[2];
		this.PARENTS[0] = null;
		this.PARENTS[1] = null;

		// map GENES to phenotype
		this.P_define(position);
	}

	// CONSTRUCTOR :
	// initialize fitness to 1
	// define parents
	// translate genotype onto phenotype
	public Organism(PVector position, Dna dna, Organism mom, Organism dad){
		this.DNA = dna;

		this.PARENTS = new Organism[2];
		this.PARENTS[0] = mom;
		this.PARENTS[1] = dad;

		// map GENES to phenotype
		this.P_define(position);

	}

	// -------------------------------------------------------------------------
	// PHENOTYPE :
	// Define options for this organism specific instance
	private color P_color;
	private int P_size = 20;
	public PVector P_position, P_velocity;
	private float P_speed, P_speedmax;


	private void P_define(PVector position){
		this.P_color = color(
				(int) this.DNA.next_gene(0,255),
				(int) this.DNA.next_gene(0,255),
				(int) this.DNA.next_gene(0,255)
			);

		this.FITNESS = random(this.FITNESS, this.FITNESS*1.5);
		this.LAST_REPRODUCTION = random(100);

		this.P_position = position;
		this.P_velocity = new PVector(sin(this.P_position.x), cos(this.P_position.y));
		this.P_speed = 1; //random(.5, 1.5);
		this.P_speedmax = 2;

	}



	// -------------------------------------------------------------------------
	// MOVEMENT handling
	private void move(){
		PVector[] rules = {
			avoid_neighbors(this, this.P_size*.75),
			bound_position(this, new Rectangle(this.P_size/2, this.P_size/2, width-this.P_size, height-this.P_size))
		};

		// APPLY RULES
		for(PVector r : rules)
			this.P_velocity.add(r);

		// LIMIT P_velocity TO P_speedmax
		if(this.P_velocity.mag() > P_speedmax)
			this.P_velocity.div(this.P_velocity.mag()).mult(P_speedmax);

		// APPLY BOID P_speed TO ITS P_velocity
		this.P_velocity.mult(this.P_speed);

		// APPLY VELOCTIY TO P_position
		this.P_position.add(this.P_velocity);
	}

	// -------------------------------------------------------------------------
	// UI handling
	public void update(){
		this.move();

		// slow death...
		this.FITNESS -= DEATH_RATE;

		// P_size related to fitness
		this.P_size = int( sqrt(map(this.FITNESS, 0, 100, 1, sq(100))) );

		// hover test
		this.HOVER = this.is_hover();

		// increment counter
		this.LAST_REPRODUCTION += .5;
	}


	public void display(float x, float y){
		// stroke(255);
		// strokeWeight(3);
		noStroke();

		fill(this.P_color, 255*.9);
		ellipse(x, y, this.P_size, this.P_size);
	}

	public boolean is_hover(){
		return (this.P_position.dist(new PVector(mouseX, mouseY)) < this.P_size);
	}

}