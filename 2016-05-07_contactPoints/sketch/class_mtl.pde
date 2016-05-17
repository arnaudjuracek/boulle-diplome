public class Mtl{

	private String NAME;
	private color AMBIANT, DIFFUSE, SPECULAR;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Mtl(String name){ this.NAME = name; }



	// -------------------------------------------------------------------------
	// SETTER
	public Mtl setAmbientColor(color c){ this.AMBIANT = c; return this; }
	public Mtl setDiffuseColor(color c){ this.DIFFUSE = c; return this; }
	public Mtl setSpecularColor(color c){ this.SPECULAR = c; return this; }

	public Mtl setAmbientColor(int r, int g, int b){ this.AMBIANT = color(r,g,b); return this; }
	public Mtl setDiffuseColor(int r, int g, int b){ this.DIFFUSE = color(r,g,b); return this; }
	public Mtl setSpecularColor(int r, int g, int b){ this.SPECULAR = color(r,g,b); return this; }



	// -------------------------------------------------------------------------
	// GETTER
	public String getName(){ return this.NAME; }

	public color getAmbientColor(){ return this.AMBIANT; }
	public color getDiffuseColor(){ return this.DIFFUSE; }
	public color getSpecularColor(){ return this.SPECULAR; }

}