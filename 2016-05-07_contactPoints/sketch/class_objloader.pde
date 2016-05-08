public class ObjLoader{

	private ArrayList<Obj> LIST;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// Recursively check a specified directory and create new Obj with their
	// matching *.cpoints file
	public ObjLoader(String directory){
		this.LIST = new ArrayList<Obj>();

		FilenameFilter filter = new FilenameFilter() { @Override public boolean accept(File dir, String name) { return name.endsWith(".obj"); } };
		File[] files = new File(sketchPath(directory)).listFiles(filter);
		for(File f : files) this.load(f);
	}



	// -------------------------------------------------------------------------
	// LOADER
	public Obj load(File f){
		if(f.isFile()){
			Obj o = new Obj(f);
			this.LIST.add(o);
			return o;
		}else return null;
	}



	// -------------------------------------------------------------------------
	// GETTER
	public ArrayList<Obj> list(){ return this.LIST;	}
	public Obj get(int index){ return this.LIST.get(index); }
	public Obj get(String filename){
		Obj match = null;
		for(Obj o : this.LIST){
			if(o.getFilename().equals(filename)){
				match = o;
				break;
	  		}
	  	}
		return match;
	}
	public Obj getRandom(){ return this.LIST.get(int(random(this.LIST.size()))); }

}