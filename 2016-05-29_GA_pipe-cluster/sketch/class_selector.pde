public class Selector{
	private int
		P_SELECTION,
		SELECTION,
		LENGTH,
		COUNTER,
		COUNTER_MAX = 20;

	public float[] TRANSITION, T_TRANSITION;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Selector(int l) {
		this.LENGTH = l;
		this.SELECTION = 0;
		this.P_SELECTION = 0;
		this.COUNTER = 0;

		this.TRANSITION = new float[l+1];
		this.T_TRANSITION = new float[l+1];
	}

	boolean pKeyPressed;
	void update() {
		this.COUNTER = (keyPressed) ? this.COUNTER+1 : 0;

		if((keyPressed && !pKeyPressed) || (keyPressed && this.COUNTER > this.COUNTER_MAX)){
			switch(keyCode){
				case RIGHT :
					this.SELECTION = ++this.SELECTION%(this.LENGTH+1);
					break;

				case LEFT :
					this.SELECTION = (this.SELECTION>0) ? this.SELECTION-1 : this.LENGTH;
					break;
			}

			for(int i=0; i<this.T_TRANSITION.length; i++) this.T_TRANSITION[i] = 0;

			this.P_SELECTION = SELECTION;
			this.COUNTER = 0;
		}
		pKeyPressed = keyPressed;

		this.T_TRANSITION[this.SELECTION] = 1;
		for(int i=0; i<this.TRANSITION.length; i++) this.TRANSITION[i] += (this.T_TRANSITION[i] - this.TRANSITION[i])*.09;
	}
}