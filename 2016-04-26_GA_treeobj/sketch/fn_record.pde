boolean RECORDING = false;
int RECORDING_ID = 0;

void start_recording(){
	RECORDING = true;
	RECORDING_ID = millis();
	frameCount = 0;
	println("Starting to record frames...");
}

void record(){
	if(frameCount%10==0){
		saveFrame("/tmp/####_frame_"+ RECORDING_ID +".tiff");
		if(frameCount>TWO_PI*100){ // one full rotation
			RECORDING = false;
			new Thread(){
				public void run(){
					println("Saving "+ RECORDING_ID);
					String output = "/Users/RNO/Desktop/"+ year()+"-"+month()+"-"+day()+"_output-"+RECORDING_ID+".gif";
					exec("convert", "/tmp/*_frame_"+ RECORDING_ID +".tiff", "GIF:-", "|", "gifsicle", "--delay=10", "--loop", "--multifile", ">", output);
					println("Saved as '"+output+"' !");
				}
			}.start();
		}
	}
}