module parts.igear;

import std.string;

import parts.part;
import parts.gear;

public class IGear : Gear{
	private Rotation states[];
	private uint actual_state;

	this(string line){
		this.type = "igear";

		// Check format
		if (line.indexOf(':') <= 0)
			throw new PartDefinitionException("No definition!");

		// Parse name and parameters
		string[] tmp = line.split(":");

		// Check type
		if (tmp[0].strip().tolower() != this.type)
			throw new PartDefinitionException("Unknown part '" ~ tmp[0].strip() ~ "'!");

		// Parse name
		tmp = tmp[1].strip().tolower().split(" ");
		this.name = tmp[0];

		// Parse parameters
		if (tmp.length > 1){
			foreach(p; tmp[1 .. $]){
				switch(p.strip()){
					case "l":
						states ~= Rotation.Left;
						break;
					case "r":
						states ~= Rotation.Right;
						break;
					case "n":
						states ~= Rotation.None;
						break;
					default:
						throw new UnknownPartParameterException("Unknown " ~ this.type ~ " '" ~ this.name ~ "' parameter '" ~ p ~ "'!");
				}
			}
		}

		// Set rotation
		if (states.length > 0){
			this.r = states[actual_state];
			this.rotating = (this.r != Rotation.None);
		}
	}

	public void nextState(){
		if (actual_state + 1 < states.length){
			actual_state++;
			this.r = states[actual_state];
			this.rotating = (this.r != Rotation.None);
		}
	}

	public PartContainer[] begin(){
		PartContainer[] output;
		
		PartContainer p;
		foreach(n; this.neighbours){
			p.part = n;
			p.rotation = this.r;
			p.from = this;

			output ~= p;
		}

		return output;
	}

	public bool hasNext(){
		return (actual_state + 1 < states.length);
	}

	public override string toString(){
		return  super.toString() ~
				"hasNext:  " ~ std.conv.to!(string)(this.hasNext) ~ "\n";
	}
}