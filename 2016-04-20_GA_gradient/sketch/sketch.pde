/**
 * GA_surfaces
 * by Arnaud Juracek
 * 2016-04-19
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 * and AdditiveWaves demo in Toxiclibs
 */

import toxi.math.waves.*;

Population population;

void setup(){
	size(800, 800, P2D);
	smooth();
	population = new Population((int) sq(4), 0.1);
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
	if(key == 's') population.VIEW_MODE_SOLO = !population.VIEW_MODE_SOLO;
	if(key == 'e'){
		String filename = "disco_" + year() + month() + day() + hour() + minute();
		population.VIEW_MODE_SOLO = true;
		for(Organism o : population.ORGANISMS){
			if(o.HOVER) o.export("/Users/RNO/Desktop/" + filename + ".png");
		}
		population.VIEW_MODE_SOLO = false;
	}
}
