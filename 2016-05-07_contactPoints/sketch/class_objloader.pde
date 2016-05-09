public class ObjLoader{

	private ArrayList<Obj> LIST, WEIGHTED_LIST;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// Recursively check a specified directory and create new Obj with their
	// matching *.cpoints file
	public ObjLoader(String directory){
		this.LIST = new ArrayList<Obj>();

		FilenameFilter filter = new FilenameFilter() { @Override public boolean accept(File dir, String name) { return name.endsWith(".obj"); } };
		File[] files = new File(sketchPath(directory)).listFiles(filter);
		for(File f : files) this.load(f);

		this.WEIGHTED_LIST = (ArrayList<Obj>) this.LIST.clone();
	}



	// -------------------------------------------------------------------------
	// SETTERS

	// add multiple occurence of an object in the LIST, so that a random getter
	// will draw more often this object
	public ObjLoader weightObj(Obj o, int weight){
		if(o!=null){
			if(weight>0) for(int i=0; i<weight; i++) this.WEIGHTED_LIST.add(o);
			else this.WEIGHTED_LIST.remove(o);
		}
		return this;
	}

	// load a new .obj file
	public Obj load(File f){
		if(f!=null && f.isFile()){
			Obj o = new Obj(f);
			this.LIST.add(o);
			return o;
		}else return null;
	}

	// load a new .obj file and weight it
	public Obj load(File f, int weight){
		if(f!=null && f.isFile()){
			Obj o = new Obj(f);
			for(int i=0; i<weight; i++) this.LIST.add(o);
			return o;
		}else return null;
	}



	// -------------------------------------------------------------------------
	// GETTERS
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
	public Obj getRandom(){ return this.WEIGHTED_LIST.get(int(random(this.WEIGHTED_LIST.size()))); }

}