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
	if(mousePressed){
		for(Organism o : population.ORGANISMS) if(o.hover) o.fitness++;
	}

	// // RANDOM FITNESS
	// for(Organism o : population.ORGANISMS) o.fitness *= random(10);

	// // TEND TO TARGET COLOR
	// color TARGET_COLOR = color(255, 255, 255);
	// for(Organism o : population.ORGANISMS){
	// 	// float d_hue = dist(0, hue(o.COLOR), 0, hue(TARGET_COLOR));
	// 	float d_brightness = dist(0, brightness(o.COLOR), 0, brightness(TARGET_COLOR));
	// 	// float d_saturation = dist(0, saturation(o.COLOR), 0, saturation(TARGET_COLOR));

	// 	// float n_d_hue = map(d_hue, 0, 255, 0, 1);
	// 	float n_d_brightness = map(d_brightness, 0, 255, 0, 1);
	// 	// float n_d_saturation = map(d_saturation, 0, 255, 0, 1);

	// 	// o.fitness = n_d_hue - n_d_brightness - n_d_saturation;
	// 	o.fitness = 1 - n_d_brightness;
	// }

	population.display();
	population.displayHistory();
	// population.evolve();

	// if(population.GENERATION > 35){
	// 	save("/Users/RNO/Dropbox/Emergence/mutation-rate-" + int(population.MUTATION_RATE*100) + "-percent" + ".png");
	// 	exit();
	// }
}

void keyPressed(){
	if(key == ' ') population.evolve();
}
