/**
 * GA_gario
 * by Arnaud Juracek
 * 2016-05-03
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */

import java.awt.Rectangle;

Population population;

void setup(){
	size(1000, 800, P2D);
	population = new Population(30, 0.1, .1);
	println("---------------------------------");
}

void draw(){
	background(50);

	// USER FITNESS ATTRIBUTION
	if(mousePressed){
		for(Organism o : population.ORGANISMS) if(o.HOVER && o.FITNESS < 100) o.FITNESS++;
	}

	population.update_breed_and_display();

	// DISPLAY INFOS
	surface.setTitle(population.ORGANISMS.size() + " — " + int(frameRate) + "fps");

	// if(frameCount%10==0) saveFrame("/Users/RNO/Desktop/frame/####.tiff");
	if(frameCount%10==0) println(population.ORGANISMS.size());
}

void keyPressed(){
	if(key == 'r') setup();
}
