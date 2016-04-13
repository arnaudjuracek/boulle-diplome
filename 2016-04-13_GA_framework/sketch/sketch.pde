/**
 * GA_framework
 * by Arnaud Juracek
 * 2016-04-13
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */


Population population;

void setup(){
	size(800, 200, P2D);

	population = new Population(0.02, 7);
}

void draw(){
	background(50);
	population.display();

	fill(255);
	textAlign(LEFT, TOP);
	text("#" + population.generations, 10, 10);
}

void mousePressed(){
	for(Square square : population.population) if(square.is_hover()) square.fitness++;
}

void keyPressed(){
	if(key == ' '){
		population.selection();
		population.reproduction();
	}
}
