/**
 * GA_framework
 * by Arnaud Juracek
 * 2016-04-16
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */


Population population;

void setup(){
	size(800, 600, P2D);
	population = new Population(38, 0.01);
}

void draw(){
	background(50);

	// USER FITNESS ATTRIBUTION
	if(mousePressed){
		for(Organism o : population.ORGANISMS) if(o.hover && o.FITNESS < 100) o.FITNESS++;
	}

	population.display();
	population.displayHistory();
}

void keyPressed(){
	if(key == ' ') population.evolve();
	if(key == 'r') setup();
}
