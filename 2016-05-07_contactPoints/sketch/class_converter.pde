public class Converter{
	public PShape toxiToPShape(TriangleMesh m){
		Vec3D cAmp = new Vec3D(255, 200, 255);
		WETriangleMesh mesh = m.toWEMesh();

		int num = mesh.getNumFaces();
		mesh.computeVertexNormals();
		mesh.computeFaceNormals();

		PShape s = createShape();
			s.beginShape(TRIANGLE);
			s.noStroke();
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
	// TOXICLIBS / HEMESH CONVERTERS
	// see https://gist.github.com/arnaudjuracek/8766cde42b0a4e3f7c88fd3dce1e64f3
	public	TriangleMesh hemeshToToxi(HE_Mesh m){
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

	public	 HE_Mesh toxiToHemesh(TriangleMesh m){
		String path = "/tmp/processing_toxiToHemesh";
		m.saveAsOBJ(path);
		return new HE_Mesh(new HEC_FromOBJFile(path));
	}

}