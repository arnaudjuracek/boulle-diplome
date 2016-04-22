/**
 * GA_wavedsphere
 * by Arnaud Juracek
 * 2016-04-23
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 * and AdditiveWaves demo in Toxiclibs
 */

import processing.opengl.*;
import toxi.math.waves.*;

Population population;

void setup(){
	size(800, 800, OPENGL);
	smooth();
	ortho();
	population = new Population((int) sq(3), 0.01);
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

	lights();
	population.display();

	// DISPLAY INFOS
	hint(DISABLE_DEPTH_TEST);
		textAlign(LEFT, BOTTOM);
		fill(255, 200);
		text(
			int(frameRate) + "fps" +
			"\n" + "generation #" + population.GENERATION
			, 10, height - 10);
	hint(ENABLE_DEPTH_TEST);
}

void keyPressed(){
	if(key == ' ') population.evolve();
	if(key == 'r') setup();
	if(key == 's') population.VIEW_MODE_SOLO = !population.VIEW_MODE_SOLO;
}
