public class Material{

	private final String[]
		COLORS = {
			"black",
			"blue",
			"golden",
			"gray",
			"green",
			"orange",
			"pink",
			"purple",
			"red",
			"white",
			"yellow"
		},
		MATERIALS = {
			"aluminium",
			"bronze",
			"cardboard",
			"ceramic",
			"chocolate",
			"concrete",
			"cork",
			"crystal",
			"fabric",
			"fur",
			"glass",
			"gold",
			"hairs",
			"iron",
			"leather",
			"marble",
			"paper",
			"plastic",
			"rubber",
			"silicon",
			"silver",
			"wood",
			"wool"
		},
		PARTS = {
			"top",
			"bottom",
			"middle",
			"top half",
			"bottom half",
			"left half",
			"right half"
		},
		ACTIONS = {
			"3D printed",
			"casted",
			"CNC milled",
			"hand sculpted",
			"laser cut",
			"organically grown",
			"turned",
			"vacuum formed"
		},
		TECHNICS = {
			"[actions] [colors] [materials]",
			"[actions] [materials], with some touch of painted [colors]",
			"[actions] [materials], with [colors] stripes",
			"[actions] [materials], with a [colors] gradient"
		},
		SENTENCES = {
			"My [parts] is made of [technics].",

			"I'm made of [materials], except my [parts] which is made of [materials2].",
			"I'm made of [materials], except my [parts] which is made of [colors] [materials2].",
			"I'm made of [colors] [materials], except my [parts] which is made of [materials2].",
			"I'm made of [colors] [materials], except my [parts] which is made of [colors2] [materials2].",
			"I'm made of [actions] [materials], except my [parts] which is made of [actions2] [materials2].",
			"I'm made of [technics], except my [parts] which is made of [actions2] [materials2].",

			"I'm made of [materials] and [materials2].",
			"I'm made of [materials] and [colors] [materials2].",
			"I'm made of [colors] [materials] and [materials2].",
			"I'm made of [colors] [materials] and [colors2] [materials2].",
			"I'm made of [actions] [materials] and [actions2] [materials2].",
			"I'm made of [technics] and [actions2] [materials2].",

			"I'm half [materials], half [materials2], but 100% [actions].",
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

		this.str = this.str.replace("[colors2]", m(this.COLORS, indexes[6]));
		this.str = this.str.replace("[materials2]", m(this.MATERIALS, indexes[7]));
		this.str = this.str.replace("[actions2]", m(this.ACTIONS, indexes[8]));
	}


	// -------------------------------------------------------------------------
	// String manipulation
	private String r(String[] arr){ return arr[int(random(arr.length))];}
	private String m(String[] arr, float a){ return arr[min(max(0, int(a*arr.length)), arr.length-1)];}

	// -------------------------------------------------------------------------
	// GETTER
	public float[] getIndexes(){ return this.indexes; }
	public String getStr(){ return this.str; }

}