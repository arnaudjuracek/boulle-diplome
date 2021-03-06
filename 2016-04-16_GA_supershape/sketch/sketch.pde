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
	population = new Population((int) sq(5), .01, .1);
}

void draw(){
	background(50);

	// USER FITNESS ATTRIBUTION
	if(mousePressed){
		for(Organism o : population.ORGANISMS) if(o.HOVER && o.FITNESS < 100) o.FITNESS++;
	}

	// // AUTO EVOLVE
	// if(frameCount%20==0){
	// 	population.evolve();
	// 	for(Organism o : population.ORGANISMS) if(random(1)>.7) o.FITNESS = int(random(100));
	// }

	population.display();

	// DISPLAY INFOS
	textAlign(LEFT, BOTTOM);
	fill(255, 200);
	text(
		int(frameRate) + "fps" +
		"\n" + "generation #" + population.GENERATION
		, 10, height - 10);
}

void keyPressed(){
	if(key == ' ') population.evolve();
	if(key == 'r') setup();
}
