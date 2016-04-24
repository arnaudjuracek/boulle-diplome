/**
 * GA_isosurface
 * by Arnaud Juracek
 * 2016-04-23
 *
 * based on The Nature of Code by Daniel Shiffman : http://natureofcode.com
 */

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.waves.*;
import toxi.processing.*;
import toxi.volume.*;

import processing.opengl.*;

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
	// if(frameCount%100==0){
	// 	population.evolve();
	// 	for(Organism o : population.ORGANISMS) if(random(1)>.7) o.FITNESS = int(random(100));
	// }

	// rotateY(map(mouseX, 0, width, 0, 1) * PI);
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
	if(key == 'i') population.SHOW_INFO = !population.SHOW_INFO;
	if(key == 'e'){
		String filename = "disco_" + year() + month() + day() + hour() + minute();
		population.VIEW_MODE_SOLO = true;
		for(Organism o : population.ORGANISMS){
			if(o.HOVER) o.export("/Users/RNO/Desktop/" + filename);
		}
		population.VIEW_MODE_SOLO = false;
	}
}