PVector bound_position(Organism t, Rectangle zone){
	PVector v = new PVector(0,0,0);
	if(t.P_position.x < zone.x) v.x = 10;
	else if(t.P_position.x > zone.x + zone.width) v.x = -10;

	if(t.P_position.y < zone.y) v.y = 10;
	else if(t.P_position.y > zone.y + zone.height) v.y = -10;
	return v;
}

PVector avoid_neighbors(Organism t, float distance){
	PVector v = new PVector(0,0,0);
	for(Organism o : population.ORGANISMS)
		if(o!=t)
			if(PVector.dist(o.P_position, t.P_position) < distance)
				v = v.sub(PVector.sub(o.P_position, t.P_position));
	return v.div(5);
}

PVector wander(Organism o){
	// WORK IN PROGRESS
	return
		new PVector(
			map( noise(o.P_position.x + frameCount), 0, 1, -1, 1 ),
			map( noise(o.P_position.y + frameCount), 0, 1, -1, 1 )
		);
}

PVector match_neighbors_velocity(Organism t){
	PVector v = new PVector(0,0,0);
	for(Organism o : population.ORGANISMS)
		if(o!=t) v.add(o.P_velocity);
	v.div(population.ORGANISMS.size()-1);
	return PVector.sub(v, t.P_velocity).div(2);
}