public class Selector {
  public int SELECTION;
  public Boolean VALIDATED;
  public Boolean PkeyPressed;
  public int COUNTER;
  public int DURATIONSELECTION;
  public int selectionLength;

  //Constructor
  public Selector(int l) {
	this.selectionLength = l;
	this.SELECTION = 0;
	this.VALIDATED = false;
	this.PkeyPressed = false;
	this.COUNTER = 0;
	this.DURATIONSELECTION = 20;
  }


  void update() {
	VALIDATED=false;
	if (keyPressed) {
	  COUNTER++;
	  //DURATIONSELECTION=DURATIONSELECTION-1;


	  if (PkeyPressed == false || COUNTER >= DURATIONSELECTION) {
		if (keyCode==LEFT) {
		  SELECTION=SELECTION-1;
		  if (SELECTION<0) {
			SELECTION=selectionLength;
		  }
		} else if (keyCode==RIGHT) {
		  SELECTION=SELECTION+1;
		  if (SELECTION>selectionLength) {
			SELECTION=0;
		  }
		} else if (key == ' ') {
		  VALIDATED=true;
		}
		COUNTER=0;

	  }
	}

	PkeyPressed = keyPressed;
  }


  void printSelector() {
	println("SELECTION = "+this.SELECTION+","+" VALIDATION"+this.VALIDATED);
  }
}