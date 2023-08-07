class Version {
	public static final CURRENT = new Version();

	private final name:String;
	private final level:Int;

	private function new() {
		this.name = "0.1.0";
		this.level = 1;
	}

	public function getName():String {
		return name;
	}

	public function getLevel():Int {
		return level;
	}
}
