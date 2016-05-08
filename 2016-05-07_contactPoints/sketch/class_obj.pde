/*
 * class Obj
 * https://gist.github.com/arnaudjuracek/22a4c98af2b5e4c9d11803650c275dc7
 * 2016-05-07
 *
 * This class allows the definition of custom "contact points" for a
 * given *.obj file.
 * It takes an *.obj file and its matching *.cpoints file, which is
 * basically an *.obj file containing floating 3D vertices defining
 * the possible contact points of the *.obj.
 *
 * The *.obj file is read as both a HE_Mesh mesh and a
 * TriangleMesh (ToxicLibs) mesh.
 *
 * The contact points are stored as ToxicLibs Vec3D.
 *
 * nb : if using Rhino to create the *.cpoints file, make sure
 * you export the contact points as a NURBS .obj, otherwise Rhino
 * will throw an error.
 */


import java.io.File;
import java.io.FilenameFilter;

import toxi.geom.*;
import toxi.geom.mesh.*;
import wblut.hemesh.*;

import java.util.Iterator;
import java.util.List;

public class Obj{

	private String PATH, FILENAME;
	private File MESH_FILE, CPOINTS_FILE;
	private ArrayList<Vec3D> CPOINTS;
	private HE_Mesh HEMESH;
	private TriangleMesh TOXIMESH;



	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// load dir/filename.obj as hemesh and wblut mesh
	// load dir/filename_c.obj as contact points
	public Obj(File mesh){
		this.PATH = mesh.getAbsolutePath();
		this.FILENAME = mesh.getName();

		// Handle the *.obj file
		this.MESH_FILE = mesh;
		this.HEMESH = new HE_Mesh(new HEC_FromOBJFile(mesh.getAbsolutePath()));
		this.TOXIMESH = this.hemeshToToxi(this.HEMESH);

		// Find the matchin *.cpoints file and parse it
		this.CPOINTS_FILE = new File(mesh.getAbsolutePath().replaceFirst("[.][^.]+$", ".cpoints"));
		this.CPOINTS = this.parseCPointsFile(this.CPOINTS_FILE);
	}



	// -------------------------------------------------------------------------
	// CPOINTS parser
	// create a BufferedReader with the given file, and read each line
	// if the line is beginning with a 'v', that means it describes a vertex
	private ArrayList<Vec3D> parseCPointsFile(File f){
		ArrayList<Vec3D> cpoints = new ArrayList<Vec3D>();
		BufferedReader reader = createReader(f.getAbsolutePath());

		String line = "";
		while(line != null){
			try{
				line = reader.readLine();
				if(line != null && line.length() > 0 && line.charAt(0) == 'v'){
					String[] parts = split(line, ' ');
					cpoints.add( new Vec3D(parseFloat(parts[1]), parseFloat(parts[2]), parseFloat(parts[3])) );
				}
			}catch (IOException e){
				e.printStackTrace();
				line = null;
			}
		}

		return cpoints;
	}



	// -------------------------------------------------------------------------
	// TOXICLIBS / HEMESH CONVERTERS
	// see https://gist.github.com/arnaudjuracek/8766cde42b0a4e3f7c88fd3dce1e64f3
	private TriangleMesh hemeshToToxi(HE_Mesh m){
		m.triangulate();

		TriangleMesh tmesh = new TriangleMesh();

		Iterator<HE_Face> fItr = m.fItr();
		HE_Face f;
		while(fItr.hasNext()){
			f = fItr.next();
			List<HE_Vertex> v = f.getFaceVertices();
			tmesh.addFace(
				new Vec3D(v.get(0).xf(), v.get(0).yf(), v.get(0).zf()),
				new Vec3D(v.get(1).xf(), v.get(1).yf(), v.get(1).zf()),
				new Vec3D(v.get(2).xf(), v.get(2).yf(), v.get(2).zf()));
		}
		return tmesh;
	}

	private HE_Mesh toxiToHemesh(TriangleMesh m){
		String path = "/tmp/processing_toxiToHemesh";
		m.saveAsOBJ(path);
		return new HE_Mesh(new HEC_FromOBJFile(path));
	}



	// -------------------------------------------------------------------------
	// GETTERS
	public File getMeshFile(){ return this.MESH_FILE; }
	public File getCPointsFile(){ return this.CPOINTS_FILE; }

	public String getPath(){ return this.PATH; }
	public String getFilename(){ return this.FILENAME; }

	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public HE_Mesh getHemesh(){ return this.HEMESH; }

	public ArrayList<Vec3D> getContactPoints(){ return this.CPOINTS; }
	public Vec3D getContactPoint(int index){ return this.CPOINTS.get(index); }
	public Vec3D getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }

}