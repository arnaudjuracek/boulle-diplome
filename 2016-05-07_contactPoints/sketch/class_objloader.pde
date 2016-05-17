public class ObjLoader{

	private ArrayList<Obj> LIST, WEIGHTED_LIST;
	private ArrayList<Mtl> MATERIALS;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// Recursively check a specified directory and create new Obj with their
	// matching *.cpoints file
	public ObjLoader(String directory){
		this.LIST = new ArrayList<Obj>();
		this.MATERIALS = new ArrayList<Mtl>();

		// .mtl parsing
		for(File f : this.listFiles(directory, ".mtl", false)) this.parseMTLFile(f);

		// .obj loading
		for(File f : this.listFiles(directory, ".obj", true)) this.load(f);

		this.WEIGHTED_LIST = (ArrayList<Obj>) this.LIST.clone();

		// handle empty directory error
		if(this.list().size() == 0){
			println("No objects found.");
			System.exit(1);
		}
	}



	// -------------------------------------------------------------------------
	// FILES
	private ArrayList<File> listFiles(String directory, String extension, boolean listRecursive){
		ArrayList<File> files = new ArrayList<File>();
		for(File f : new File(sketchPath(directory)).listFiles()){
			if(f.isFile()){
				if(f.getName().endsWith(extension)) files.add(f);
			}else if(listRecursive && f.isDirectory()){
				files.addAll(this.listFiles(f.getAbsolutePath(), extension, true));
			}
		}
		return files;
	}


	// -------------------------------------------------------------------------
	// MTL parser
	private ArrayList<Mtl> parseMTLFile(File f){
		BufferedReader reader = createReader(f.getAbsolutePath());
		String line = "";
		while(line != null){
			try{
				line = reader.readLine();
				if(line != null && line.length()>0){

					if(line.startsWith("newmtl")){
						String[] parts = split(line, ' ');
						this.getMaterials().add(new Mtl(parts[1]));
					}

					else if(line.charAt(0) == 'K'){
						if(line.charAt(1) == 'a'){
							String[] parts = split(line, ' ');
							this.getLastMaterial().setAmbientColor(parseInt(parts[1])*255, parseInt(parts[2])*255, parseInt(parts[3])*255 );
						}
						else if(line.charAt(1) == 'd'){
							String[] parts = split(line, ' ');
							this.getLastMaterial().setDiffuseColor(parseInt(parts[1])*255, parseInt(parts[2])*255, parseInt(parts[3])*255 );
						}
						else if(line.charAt(1) == 's'){
							String[] parts = split(line, ' ');
							this.getLastMaterial().setSpecularColor(parseInt(parts[1])*255, parseInt(parts[2])*255, parseInt(parts[3])*255 );
						}
					}

				}
			}catch(IOException e){
				e.printStackTrace();
				line = null;
			}
		}

		return this.getMaterials();
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
			File cpoint_file = new File(f.getAbsolutePath().replaceFirst("[.][^.]+$", ".cpoints"));
			if(cpoint_file!=null && cpoint_file.isFile()){
				Obj o = new Obj(this, f, cpoint_file);
				this.LIST.add(o);
				return o;
			}else return null;
		}else return null;
	}

	// load a new .obj file and weight it
	public Obj load(File f, int weight){
		if(f!=null && f.isFile()){
			File cpoint_file = new File(f.getAbsolutePath().replaceFirst("[.][^.]+$", ".cpoints"));
			if(cpoint_file!=null && cpoint_file.isFile()){
				Obj o = new Obj(this, f, cpoint_file);
				for(int i=0; i<weight; i++) this.LIST.add(o);
				return o;
			}else return null;
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
	public Obj getRandom(){ return this.WEIGHTED_LIST.size()>0 ? this.WEIGHTED_LIST.get(int(random(this.WEIGHTED_LIST.size()))) : null; }


	public ArrayList<Mtl> getMaterials(){ return this.MATERIALS; }
	public Mtl getMaterial(int index){ return this.MATERIALS.get(index); }
	public Mtl getFirstMaterial(){ return this.MATERIALS.get(0); }
	public Mtl getLastMaterial(){ return this.MATERIALS.get(this.MATERIALS.size()-1); }
	public Mtl getRandomMaterial(){ return this.MATERIALS.get(int(random(this.MATERIALS.size()))); }
}