public class Material{

	private final String[]
		COLORS = {
			"blue", "red", "pink", "yellow", "orange", "purple", "brown", "green", "black", "gray", "white", "golden"},
		MATERIALS = {
			"iron", "bronze", "silver", "gold", "wood", "plastic", "silicon", "wool", "fabric", "ceramic", "aluminium", "chocolate", "glass", "cork", "rubber", "marble", "concrete"},
		PARTS = {
			"top", "bottom", "middle", "top half", "bottom half", "left half", "right half"},
		TECHNICS = {
			"[actions] [colors] [materials]",
			"[actions] [materials], with some touch of painted [colors]",
			"[actions] [materials], with a [colors] gradient"},
		ACTIONS = {
			"turned", "casted", "hand sculpted", "organically grown"},
		SENTENCES = {
			// "Hello my name is [name] !",
			// "My [parts] is made of [colors] [materials]",
			"My [parts] is made of [technics].",
			"I'm mostly made of [materials], but my [parts] is [colors]."
		};

	private float[] indexes;
	private String str;

	// -------------------------------------------------------------------------
	public Material(float[] indexes){
		this.indexes = indexes;

		this.str = m(this.SENTENCES, indexes[0]);
		this.str = this.str.replace("[name]", "RNO");
		this.str = this.str.replace("[technics]", m(this.TECHNICS, indexes[1]));
		this.str = this.str.replace("[actions]", m(this.ACTIONS, indexes[2]));
		this.str = this.str.replace("[parts]", m(this.PARTS, indexes[3]));
		this.str = this.str.replace("[colors]", m(this.COLORS, indexes[4]));
		this.str = this.str.replace("[materials]", m(this.MATERIALS, indexes[5]));
	}


	// -------------------------------------------------------------------------
	// String manipulation
	private String m(String[] arr, float a){ return arr[min(max(0, int(a*arr.length)), arr.length-1)];}

	// -------------------------------------------------------------------------
	// GETTER
	public float[] getIndexes(){ return this.indexes; }
	public String getStr(){ return this.str; }

}