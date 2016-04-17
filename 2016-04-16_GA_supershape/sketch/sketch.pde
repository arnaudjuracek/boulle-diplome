/**
 * GA_supershape
 * by Arnaud Juracek
 * 2016-04-16
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */


Population population;

void setup(){
	size(800, 800, P2D);
	smooth();
	population = new Population((int) sq(5), 0.1);
}

void draw(){
	background(50);

	// USER FITNESS ATTRIBUTION
	if(mousePressed){
		for(Organism o : population.ORGANISMS) if(o.HOVER && o.FITNESS < 100) o.FITNESS++;
	}

	population.display();
	// population.displayHistory();
}

void keyPressed(){
	if(key == ' ') population.evolve();
	if(key == 'r') setup();
}
