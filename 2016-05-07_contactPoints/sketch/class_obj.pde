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
	private ObjLoader OBJLOADER;

	private String PATH, FILENAME;
	private File MESH_FILE, CPOINTS_FILE;
	private ArrayList<CPoint> CPOINTS;

	private HE_Mesh HEMESH;
	private TriangleMesh TOXIMESH;
	private PShape PSHAPE;

	private ArrayList<Mtl> MATERIALS = new ArrayList<Mtl>();


	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// load dir/filename.obj as hemesh and wblut mesh
	// load dir/filename_c.obj as contact points
	public Obj(ObjLoader parent, File mesh, File cpoints){
		this.OBJLOADER = parent;

		this.PATH = mesh.getAbsolutePath();
		this.FILENAME = mesh.getName();

		// Find the material
		this.MATERIALS = this.extractMaterials(mesh);
		// println(this.getMaterial().getName());

		// Handle the *.obj file
		this.MESH_FILE = mesh;
		this.HEMESH = new HE_Mesh(new HEC_FromOBJFile(mesh.getAbsolutePath()));
		this.TOXIMESH = this.hemeshToToxi(this.HEMESH);
		this.PSHAPE = this.toxiToPShape(this.TOXIMESH);

		// Parse the matching *.cpoints file
		this.CPOINTS_FILE = cpoints;
		this.CPOINTS = this.parseCPointsFile(this.CPOINTS_FILE);
	}



	// -------------------------------------------------------------------------
	// OBJ parser
	// quickly parse the *.obj file and get the material
	private ArrayList<Mtl> extractMaterials(File f){
		ArrayList<Mtl> materials = new ArrayList<Mtl>();
		if(f!=null && f.isFile()){
			BufferedReader reader = createReader(f.getAbsolutePath());
			String line = "";
			while(line != null){
				try{
					line = reader.readLine();
					if(line != null && line.length() > 0){
						if(line.startsWith("usemtl")){
							String[] parts = split(line, ' ');
							materials.add( this.getObjLoader().getMaterial(parts[1]) );
						}
					}
				}catch(IOException e){
					e.printStackTrace();
					line = null;
				}
			}
		}

		return materials;
	}

	// -------------------------------------------------------------------------
	// CPOINTS parser
	// create a BufferedReader with the given file, and read each line
	// if the line is beginning with a 'v', that means it describes a vertex
	// if the line is beginning with a 'g', that means it describes a group
	private ArrayList<CPoint> parseCPointsFile(File f){
		ArrayList<CPoint> cpoints = new ArrayList<CPoint>();
		if(f!=null && f.isFile()){
			ArrayList<Vec3D> surface_points = null;

			BufferedReader reader = createReader(f.getAbsolutePath());

			String line = "";
			while(line != null){
				try{
					line = reader.readLine();
					if(line != null && line.length() > 0){

						if(line.charAt(0) == 'g' || line.charAt(0) == 'o'){
							if(surface_points != null) cpoints.add(new CPoint(surface_points));
							surface_points = new ArrayList<Vec3D>();
						}

						if(line.charAt(0) == 'v' && line.charAt(1) == ' '){
							String[] parts = split(line, ' ');
							Vec3D v = new Vec3D( parseFloat(parts[1]), parseFloat(parts[2]), parseFloat(parts[3]) );
							if(surface_points != null)
								surface_points.add(v);
							else
								cpoints.add( new CPoint(v) );
						}

					}
				}catch(IOException e){
					e.printStackTrace();
					line = null;
				}
			}

			if(surface_points != null) cpoints.add(new CPoint(surface_points));
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

	private PShape toxiToPShape(TriangleMesh m){
		Vec3D cAmp = new Vec3D(300, 255, 300);
		WETriangleMesh mesh = m.toWEMesh();

		int num = mesh.getNumFaces();
		mesh.computeVertexNormals();
		mesh.computeFaceNormals();

		PShape s = createShape();
			s.beginShape(TRIANGLE);
			s.stroke(255, 10);
			for(int i=0; i<num; i++){
				Face f = mesh.faces.get(i);
				Vec3D c = f.a.add(cAmp);
					s.fill(c.x,c.y,c.z);
					s.normal(f.a.normal.x, f.a.normal.y, f.a.normal.z);
					s.vertex(f.a.x, f.a.y, f.a.z);

				c = f.b.add(cAmp);
					s.fill(c.x,c.y,c.z);
					s.normal(f.b.normal.x, f.b.normal.y, f.b.normal.z);
					s.vertex(f.b.x, f.b.y, f.b.z);

				c = f.c.add(cAmp);
					s.fill(c.x,c.y,c.z);
					s.normal(f.c.normal.x, f.c.normal.y, f.c.normal.z);
					s.vertex(f.c.x, f.c.y, f.c.z);
			}
			s.endShape();
		return s;
	}



	// -------------------------------------------------------------------------
	// GETTERS
	public ObjLoader getObjLoader(){ return this.OBJLOADER; }

	public File getMeshFile(){ return this.MESH_FILE; }
	public File getCPointsFile(){ return this.CPOINTS_FILE; }

	public String getPath(){ return this.PATH; }
	public String getFilename(){ return this.FILENAME; }

	public TriangleMesh getToxiMesh(){ return this.TOXIMESH; }
	public HE_Mesh getHemesh(){ return this.HEMESH; }
	public PShape getPShape(){ return this.PSHAPE; }

	public ArrayList<Mtl> getMaterials(){ return this.MATERIALS; }
	public Mtl getMaterial(int index){ return this.MATERIALS.get(index); }
	public Mtl getFirstMaterial(){ return this.MATERIALS.get(0); }
	public Mtl getLastMaterial(){ return this.MATERIALS.get(this.MATERIALS.size()-1); }
	public Mtl getRandomMaterial(){ return this.MATERIALS.size()>0 ? this.MATERIALS.get(int(random(this.MATERIALS.size()))) : null; }

	public ArrayList<CPoint> getContactPoints(){ return this.CPOINTS; }
	public CPoint getContactPoint(int index){ return this.CPOINTS.get(index); }
	public CPoint getFirstContactPoint(){ return this.CPOINTS.get(0); }
	public CPoint getLastContactPoint(){ return this.CPOINTS.get(this.CPOINTS.size()-1); }
	public CPoint getRandomContactPoint(){ return this.CPOINTS.get(int(random(this.CPOINTS.size()))); }

	public AABB getAABB(){ return this.getToxiMesh().getBoundingBox(); }

}