public class Mtl{

	private String NAME;
	private color AMBIANT, DIFFUSE, SPECULAR;
	private PImage TEXTURE;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	public Mtl(String name){ this.NAME = name; }

	public Mtl(){
		this.NAME = "nullTex";
		this.setAmbientColor(color(255));
		this.setDiffuseColor(color(255));
		this.setSpecularColor(color(255));
	}


	// -------------------------------------------------------------------------
	// SETTER
	public Mtl setAmbientColor(color c){ this.AMBIANT = c; return this; }
	public Mtl setDiffuseColor(color c){ this.DIFFUSE = c; return this; }
	public Mtl setSpecularColor(color c){ this.SPECULAR = c; return this; }

	public Mtl setAmbientColor(float r, float g, float b){ this.AMBIANT = color(r,g,b); return this; }
	public Mtl setDiffuseColor(float r, float g, float b){ this.DIFFUSE = color(r,g,b); return this; }
	public Mtl setSpecularColor(float r, float g, float b){ this.SPECULAR = color(r,g,b); return this; }

	public Mtl setTexture(PImage tex){ this.TEXTURE = tex; return this;}

	// -------------------------------------------------------------------------
	// GETTER
	public String getName(){ return this.NAME; }

	public color getAmbientColor(){ return this.AMBIANT; }
	public color getDiffuseColor(){ return this.DIFFUSE; }
	public color getSpecularColor(){ return this.SPECULAR; }

	public PImage getTexture(){ return this.TEXTURE; }
}