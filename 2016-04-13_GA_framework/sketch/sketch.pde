/**
 * GA_framework
 * by Arnaud Juracek
 * 2016-04-13
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */


Population population;

void setup(){
	size(800, 800, P2D);
	population = new Population(35, 0.01);
}

void draw(){
	background(50);

	// USER FITNESS ATTRIBUTION
	// if(mousePressed){
	// 	for(Organism o : population.ORGANISMS) if(o.hover) o.FITNESS++;
	// }

	// RANDOM FITNESS
	for(Organism o : population.ORGANISMS) o.FITNESS *= random(10);

	// // TEND TO TARGET COLOR
	// color TARGET_COLOR = color(255, 255, 255);
	// for(Organism o : population.ORGANISMS){
	// 	float rmean =(red(o.COLOR) + red(TARGET_COLOR)) / 2;
	// 	float r = red(o.COLOR) - red(TARGET_COLOR);
	// 	float g = green(o.COLOR) - green(TARGET_COLOR);
	// 	float b = blue(o.COLOR) - blue(TARGET_COLOR);
	// 	float d = sqrt((int(((512+rmean)*r*r))>>8)+(4*g*g)+(int(((767-rmean)*b*b))>>8));

	// 	o.FITNESS = 765 - d;
	// }

	population.display();
	population.displayHistory();
	population.evolve();

	// if(population.GENERATION > 35){
	// 	save("/Users/RNO/Dropbox/Emergence/mutation-rate-" + int(population.MUTATION_RATE*100) + "-percent" + ".png");
	// 	exit();
	// }
}

void mouseReleased(){
	population.evolve();
}

void keyPressed(){
	if(key == ' ') population.evolve();
	if(key == 'r') setup();
}
