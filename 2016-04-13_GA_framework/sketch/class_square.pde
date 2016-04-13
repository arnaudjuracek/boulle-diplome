class Square{
	Dna dna;
	float fitness;
	PVector position;

	Square(Dna dna, float x, float y){
		this.dna = dna;
		this.position = new PVector(x,y);
		this.fitness = 1;
	}

	void display(){
		float
			r = this.dna.genes[0]*255,
			g = this.dna.genes[1]*255,
			b = this.dna.genes[2]*255;

		if(this.is_hover()) stroke(255, 0, 0);
		else stroke(255);

		fill(r,g,b);
		rect(this.position.x, this.position.y, 100, 100);

		fill(255);
		textAlign(CENTER, TOP);
		text(int(this.fitness), this.position.x + 50, this.position.y + 110);
	}

	boolean is_hover(){
		return (mouseX > this.position.x && mouseX < this.position.x + 100 && mouseY > this.position.y && mouseY < this.position.y + 100);
	}

	Dna getDNA(){ return this.dna; }
}